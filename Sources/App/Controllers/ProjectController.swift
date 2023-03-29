import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: index)
        routes.post("", use: create)
    }

    func index(req: Request) async throws -> [ProjectResponse] {
        guard let workspace = try await Workspace.find(req.parameters.get("workspaceId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        return try await Project.query(on: req.db)
            .filter(\.$workspace.$id == workspace.requireID())
            .with(\.$client)
            .with(\.$creator)
            .all()
            .map { project in
                ProjectResponse(
                    project: project
                )
            }
    }

    func create(req: Request) async throws -> ProjectResponse {
        try CreateProjectInput.validate(content: req)

        let projectData = try req.content.decode(CreateProjectInput.self)

        guard let workspace = try await Workspace.find(req.parameters.get("workspaceId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let member = try await Member.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspace.requireID())
            .first()
        else {
            throw Abort(.badRequest)
        }

        let project = projectData.toProject(workspaceId: try workspace.requireID(), creator: try member.requireID())

        try await project.save(on: req.db)

        try await project.$client.load(on: req.db)
        try await project.$creator.load(on: req.db)
        try await workspace.$organization.load(on: req.db)

        return ProjectResponse(
            project: project
        )
    }
}
