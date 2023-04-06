import Fluent
import Vapor

struct WorktimeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)
        routes.get(Member.parameterDefinition(), use: index)
    }

    func index(req: Request) async throws -> [WorktimeResponse] {
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

        return try await Worktime.query(on: req.db)
            .filter(\.$member.$id == member.requireID())
            .all()
            .map { worktime in
                WorktimeResponse(worktime: worktime)
            }
    }

    func create(req: Request) async throws -> WorktimeResponse {
        let worktimeData = try req.validateAndDecode(CreateWorktimeInput.self)

        let workspace = try await Workspace.find(req: req)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let member = try await Member.find(for: user, in: workspace.requireID(), on: req.db) else {
            throw Abort(.badRequest)
        }

        let worktime = worktimeData.toWorktime(memberId: try member.requireID())

        try await worktime.save(on: req.db)

        return WorktimeResponse(worktime: worktime)
    }
}
