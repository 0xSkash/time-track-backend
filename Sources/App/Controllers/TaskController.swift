import Fluent
import Vapor

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)
        routes.get(Member.parameterDefinition(), use: index)
    }

    func index(req: Request) async throws -> [TaskResponse] {
        let member = try await Member.find(req: req)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        let workspace = try await Workspace.find(req: req)

        guard let selfMember = try await Member.find(for: user, in: workspace.requireID(), on: req.db) else {
            throw Abort(.badRequest)
        }

        if selfMember.id != member.id && selfMember.role != .admin {
            throw Abort(.unauthorized)
        }

        return try await Task.query(on: req.db)
            .filter(\.$member.$id == member.requireID())
            .with(\.$project) { project in
                project.with(\.$client)
            }
            .all()
            .map { task in
                TaskResponse(task: task)
            }
    }

    func create(req: Request) async throws -> TaskResponse {
        let taskData = try req.validateAndDecode(CreateTaskInput.self)

        let workspace = try await Workspace.find(req: req)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let member = try await Member.find(for: user, in: workspace.requireID(), on: req.db) else {
            throw Abort(.badRequest)
        }

        let task = taskData.toTask(memberId: try member.requireID())

        try await task.save(on: req.db)
        try await task.$project.load(on: req.db)
        try await task.project.$client.load(on: req.db)

        return TaskResponse(task: task)
    }
}
