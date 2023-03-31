import Fluent
import Vapor

struct MemberController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: index)
        routes.group(RoleMiddleware([.admin])) { adminProtected in
            adminProtected.post("", use: create)
            adminProtected.put(":memberId", use: update)
        }
    }

    func index(req: Request) async throws -> [MemberResponse] {
        let workspace = try await Workspace.find(req: req)

        return try await Member.query(on: req.db)
            .filter(\.$workspace.$id == workspace.requireID())
            .with(\.$user)
            .all()
            .map { member in
                try MemberResponse(member: member, user: member.user)
            }
    }

    func create(req: Request) async throws -> MemberResponse {
        let memberData = try req.validateAndDecode(CreateMemberInput.self)

        guard let user = try await User.find(memberData.userId, on: req.db) else {
            throw Abort(.badRequest)
        }

        let workspace = try await Workspace.find(req: req)

        let existingMember = try await Member.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspace.requireID())
            .first()

        if existingMember != nil {
            throw Abort(.badRequest)
        }

        let member = memberData.toMember(workspaceId: try workspace.requireID(), owner: user)

        try await member.save(on: req.db)

        return try MemberResponse(member: member, user: user)
    }

    func update(req: Request) async throws -> MemberResponse {
        let memberData = try req.content.decode(MemberUpdateInput.self)

        guard let member = try await Member.find(req.parameters.get("memberId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        if let role = memberData.role {
            member.role = role
        }

        if let isBillable = memberData.isBillable {
            member.isBillable = isBillable
        }

        try await member.save(on: req.db)

        return try MemberResponse(member: member)
    }
}
