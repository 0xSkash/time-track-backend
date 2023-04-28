import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(TokenAuthenticator()) { protected in
            protected.get("", use: index)
            protected.post("", use: create)
        }
    }

    func index(req: Request) async throws -> [ProjectResponse] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let workspace = try await user.$selectedWorkspace.get(on: req.db) else {
            throw Abort(.badRequest)
        }

        return try await Project.query(on: req.db)
            .filter(\.$workspace.$id == workspace.requireID())
            .with(\.$client)
            .all()
            .map { project in
                ProjectResponse(
                    project: project,
                    client: project.client
                )
            }
    }

    func create(req: Request) async throws -> ProjectResponse {
        let projectData = try req.validateAndDecode(CreateProjectInput.self)

        let workspace = try await Workspace.find(req: req)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let member = try await Member.find(for: user, in: workspace.requireID(), on: req.db) else {
            throw Abort(.badRequest)
        }

        let project = projectData.toProject(
            workspaceId: try workspace.requireID(),
            creator: try member.requireID()
        )

        try await project.save(on: req.db)
        try await project.$client.load(on: req.db)

        return ProjectResponse(
            project: project, client: project.client
        )
    }
}
