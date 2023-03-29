import Vapor

struct OrganizationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("", use: create)
    }

    func create(req: Request) async throws -> OrganizationResponse {
        try CreateOrganizationInput.validate(content: req)
        let organizaztionData = try req.content.decode(CreateOrganizationInput.self)

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let organization = try? organizaztionData.toOrganization(owner: user) else {
            throw Abort(.notAcceptable)
        }

        try await organization.save(on: req.db)

        return try OrganizationResponse(organization: organization)
    }
}
