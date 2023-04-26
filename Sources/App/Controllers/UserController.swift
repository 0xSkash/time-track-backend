import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)

        routes.group(User.authenticator(), User.guardMiddleware()) { password in
            password.get("me", "backupcodes", use: indexTwoFABackupCodes)
        }

        routes.group(TokenAuthenticator()) { protected in
            protected.get("me", "organizations", use: indexOrganizations)
            protected.post("me", "avatar", use: updateAvatar)
            protected.delete("me", "avatar", use: destroyAvatar)
            protected.get("me", "worktime", use: indexWorktime)
        }
    }

    func create(req: Request) async throws -> UserResponse {
        let userData = try req.validateAndDecode(CreateUserInput.self)

        guard let user = try? userData.toUser() else {
            throw Abort(.notAcceptable)
        }

        try await user.save(on: req.db)

        return UserResponse(user: user)
    }

    func indexOrganizations(req: Request) async throws -> [OrganizationResponse] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        try await user.$organizations.load(on: req.db)

        return user.organizations.map { org in
            OrganizationResponse(organization: org)
        }
    }
    
    func indexWorktime(req: Request) async throws -> [WorktimeResponse] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        return try await Worktime.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .all()
            .map { worktime in
                WorktimeResponse(worktime: worktime)
            }
    }

    func updateAvatar(req: Request) async throws -> AvatarResponse {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        let avatarInput = try req.content.decode(AvatarInput.self)

        guard avatarInput.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }

        guard let fileExtension = avatarInput.file.extension else {
            throw Abort(.badRequest)
        }

        let fileName = UUID.generateRandom().uuidString + "." + fileExtension

        let path = req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + fileName
        let isImage = ["png", "jpeg", "jpg"].contains(fileExtension.lowercased())

        if !isImage {
            throw Abort(.badRequest)
        }

        let handle = try await req.application.fileio.openFile(
            path: path,
            mode: .write,
            flags: .allowFileCreation(posixMode: 0x744),
            eventLoop: req.eventLoop
        ).get()

        try await req.application.fileio.write(
            fileHandle: handle,
            buffer: avatarInput.file.data,
            eventLoop: req.eventLoop
        ).get()

        try handle.close()

        if let oldAvatar = user.avatar {
            try await deleteOldAvatar(path: req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + oldAvatar, req: req)
        }

        user.avatar = fileName
        try await user.save(on: req.db)

        return AvatarResponse(avatarName: fileName)
    }

    func destroyAvatar(req: Request) async throws -> HTTPStatus {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if let avatar = user.avatar {
            try await deleteOldAvatar(path: req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + avatar, req: req)
            user.avatar = nil
            try await user.save(on: req.db)
        }

        return .noContent
    }

    func indexTwoFABackupCodes(req: Request) async throws -> [String] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if !user.twoFactorEnabled {
            throw Abort(.badRequest)
        }

        try await user.$twoFactorToken.load(on: req.db)

        guard let token = user.twoFactorToken.first else {
            throw Abort(.internalServerError)
        }

        return token.backupTokens
    }

    private func deleteOldAvatar(path: String, req: Request) async throws {
        if !FileManager.default.fileExists(atPath: path) {
            return
        }

        return try await req.application.fileio.remove(path: path, eventLoop: req.eventLoop).get()
    }
}
