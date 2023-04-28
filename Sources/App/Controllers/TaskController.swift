import Fluent
import Vapor

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(TokenAuthenticator()) { protected in
            protected.post("", use: create)
        }
    }

    func create(req: Request) async throws -> TaskResponse {
        let taskData = try req.validateAndDecode(CreateTaskInput.self)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let workspace = try await user.$selectedWorkspace.get(on: req.db) else {
            throw Abort(.badRequest)
        }

        guard let member = try await Member.find(for: user, in: workspace.requireID(), on: req.db) else {
            throw Abort(.badRequest)
        }

        let task = taskData.toTask(memberId: try member.requireID())

        try await task.save(on: req.db)
        try await task.$project.load(on: req.db)
        try await task.project.$client.load(on: req.db)

        return TaskResponse(task: task, project: task.project, client: task.project.client)
    }
}
