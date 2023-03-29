import Vapor

struct WorkspaceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)
    }

    func create(req: Request) async throws -> WorkspaceResponse {
        try CreateWorkspaceInput.validate(content: req)
        let workspaceData = try req.content.decode(CreateWorkspaceInput.self)

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
}
