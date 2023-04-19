import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)

        routes.group(TokenAuthenticator()) { protected in
            protected.get("me", "organizations", use: indexOrganizations)
        }
    }

    func create(req: Request) async throws -> UserResponse {
        let userData = try req.validateAndDecode(CreateUserInput.self)
        
        guard let user = try? userData.toUser() else {
            throw Abort(.notAcceptable)
        }

        try await user.save(on: req.db)

        return UserResponse(user: user)
    }

    func indexOrganizations(req: Request) async throws -> [OrganizationResponse] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        try await user.$organizations.load(on: req.db)

        return try user.organizations.map { org in
            try OrganizationResponse(organization: org)
        }
    }
}
