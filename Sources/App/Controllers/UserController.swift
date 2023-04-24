import Fluent
import Vapor

struct UserController: RouteCollection {
    let formatter = DateFormatter()

    init() {
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss-SSSS-"
    }

    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)

        routes.group(TokenAuthenticator()) { protected in
            protected.get("me", "organizations", use: indexOrganizations)
            protected.post("me", "avatar", use: updateAvatar)
            protected.get("me", "avatar", use: showMyAvatar)
            protected.get("me", use: showMe)
        }
    }
    
    func showMe(req: Request) async throws -> UserResponse {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }
        
        return UserResponse(user: user)
    }
    
    func showMyAvatar(req: Request) async throws -> Response {
        
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let avatar = user.avatar else {
            throw Abort(.notFound)
        }
        
        let path = req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + avatar

            
        return req.fileio.streamFile(at: path)
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

        return try user.organizations.map { org in
            try OrganizationResponse(organization: org)
        }
    }

    func updateAvatar(req: Request) async throws -> HTTPStatus {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        let avatarInput = try req.content.decode(AvatarInput.self)

        guard avatarInput.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }

        let prefix = formatter.string(from: .init())
        let fileName = prefix + avatarInput.file.filename
        let path = req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + fileName
        let isImage = ["png", "jpeg", "jpg"].contains(avatarInput.file.extension?.lowercased())

        if !isImage {
            throw Abort(.badRequest)
        }

        let handle = try await req.application.fileio.openFile(
            path: path,
            mode: .write,
            flags: .allowFileCreation(posixMode: 0x744),
            eventLoop: req.eventLoop
        ).get()

        try await req.application.fileio.write(fileHandle: handle, buffer: avatarInput.file.data, eventLoop: req.eventLoop).get()

        try handle.close()

        user.avatar = fileName

        try await user.save(on: req.db)

        return .accepted
    }
}
