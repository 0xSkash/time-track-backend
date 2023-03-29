import Fluent
import Vapor

struct RoleMiddleware: AsyncMiddleware {
    let allowedRoles: [Role]

    init(_ allowedRoles: [Role]) {
        self.allowedRoles = allowedRoles
    }

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let workspaceId: UUID = request.parameters.get("workspaceId") else {
            throw Abort(.badRequest)
        }

        guard let member = try await Member.query(on: request.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspaceId)
            .first()
        else {
            throw Abort(.badRequest)
        }

        if !allowedRoles.contains(where: { role in
            role == member.role
        }) {
            throw Abort(.unauthorized)
        }

        return try await next.respond(to: request)
    }
}
