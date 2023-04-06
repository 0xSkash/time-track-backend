import Fluent
import Vapor

struct MemberMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let workspaceId: UUID = request.parameters.get("workspaceId") else {
            throw Abort(.badRequest)
        }

        let member = try await Member.query(on: request.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspaceId)
            .first()

        if member == nil {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
