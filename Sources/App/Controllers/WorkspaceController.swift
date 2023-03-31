import Fluent
import Vapor

struct WorkspaceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)
        routes.get(Workspace.parameterDefinition(), "team-members", use: indexTeamMembers)
        routes.get("", use: indexForOrganization)
    }

    func create(req: Request) async throws -> WorkspaceResponse {
        let workspaceData = try req.validateAndDecode(CreateWorkspaceInput.self)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try await Organization.find(req.parameters.get("organizationId"), on: req.db) else {
            throw Abort(.notAcceptable)
        }

        guard let workspace = try? workspaceData.toWorkspace(organization: organization, creator: user) else {
            throw Abort(.notAcceptable)
        }

        try await workspace.save(on: req.db)

        let member = Member(workspaceId: try workspace.requireID(), userId: try user.requireID(), role: .admin, isBillable: true)
        try await member.save(on: req.db)

        return try WorkspaceResponse(workspace: workspace)
    }

    func indexForOrganization(req: Request) async throws -> [WorkspaceResponse] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try await Organization.find(req.parameters.get("organizationId"), on: req.db) else {
            throw Abort(.notAcceptable)
        }

        let workspaces = try await Workspace.query(on: req.db)
            .filter(\.$organization.$id == organization.requireID())
            .join(Member.self, on: \Member.$workspace.$id == \Workspace.$id)
            .filter(Member.self, \.$user.$id == user.requireID())
            .all()

        return try workspaces.map { ws in
            try WorkspaceResponse(workspace: ws)
        }
    }

    func indexTeamMembers(req: Request) async throws -> [MemberListResponse] {
        let workspace = try await Workspace.find(req: req)

        try await workspace.$members.load(on: req.db)

        return try workspace.members.map { member in
            try MemberListResponse(member: member)
        }
    }
}
