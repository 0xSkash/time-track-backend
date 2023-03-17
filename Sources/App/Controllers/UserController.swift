import Fluent
import Vapor

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)
    }

    func create(req: Request) async throws -> UserResponse {
        try CreateUserInput.validate(content: req)

        let userData = try req.content.decode(CreateUserInput.self)

        guard let user = try? userData.toUser() else {
            throw Abort(.notAcceptable)
        }

        try await user.save(on: req.db)

        return try UserResponse(user: user)
    }
}
