import Fluent
import Vapor

struct ClientController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(OwnerMiddleware()) { ownerProtected in
            ownerProtected.get("", use: index)
            ownerProtected.post("", use: create)
        }
    }

    func index(req: Request) async throws -> [ClientResponse] {
        guard let organization = try await Organization.find(req.parameters.get("organizationId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        return try await Client.query(on: req.db)
            .filter(\.$organization.$id == organization.requireID())
            .all()
            .map { client in
                ClientResponse(client: client)
            }
    }

    func create(req: Request) async throws -> ClientResponse {
        try CreateClientInput.validate(content: req)

        let clientData = try req.content.decode(CreateClientInput.self)

        guard let organization = try await Organization.find(req.parameters.get("organizationId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        let client = try clientData.toClient(organization: organization.requireID())
        
        try await client.save(on: req.db)
        
        return ClientResponse(client: client)
    }
}
