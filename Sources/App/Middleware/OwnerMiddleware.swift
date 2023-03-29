
import Fluent
import Vapor

struct OwnerMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try await Organization.find(request.parameters.get("organizationId"), on: request.db) else {
            throw Abort(.badRequest)
        }
        
        try await organization.$owner.load(on: request.db)

        if organization.owner.id != user.id {
            throw Abort(.unauthorized)
        }

        return try await next.respond(to: request)
    }
}
