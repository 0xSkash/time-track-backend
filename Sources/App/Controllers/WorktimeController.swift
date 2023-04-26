import Fluent
import Vapor

struct WorktimeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(TokenAuthenticator()) { protected in
            protected.post("", use: create)
        }
    }

    func create(req: Request) async throws -> WorktimeResponse {
        let worktimeData = try req.validateAndDecode(CreateWorktimeInput.self)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        let worktime = worktimeData.toWorktime(userId: try user.requireID())

        try await worktime.save(on: req.db)

        return WorktimeResponse(worktime: worktime)
    }
}
