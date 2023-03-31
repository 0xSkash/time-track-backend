import Vapor

struct OrganizationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)

        routes.group(TokenAuthenticator()) { protected in
            protected.post(":organizationId", "invite-user", ":userId", use: inviteUser)
        }
    }

    func create(req: Request) async throws -> OrganizationResponse {
        let organizaztionData = try req.validateAndDecode(CreateOrganizationInput.self)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try? organizaztionData.toOrganization(owner: user) else {
            throw Abort(.notAcceptable)
        }

        try await organization.save(on: req.db)

        try await organization.$users.attach(user, on: req.db)

        return try OrganizationResponse(organization: organization)
    }

    func inviteUser(req: Request) async throws -> HTTPStatus {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try await Organization.find(req.parameters.get("organizationId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        if organization.$owner.id != user.id {
            throw Abort(.unauthorized)
        }

        guard let userToInvite = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        try await organization.$users.attach(userToInvite, on: req.db)

        return .ok
    }
}
