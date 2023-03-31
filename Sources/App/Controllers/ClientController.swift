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
        guard let workspace = try await Workspace.find(req.parameters.get("workspaceId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        return try await Client.query(on: req.db)
            .filter(\.$workspace.$id == workspace.requireID())
            .all()
            .map { client in
                ClientResponse(client: client)
            }
    }

    func create(req: Request) async throws -> ClientResponse {
        try CreateClientInput.validate(content: req)

        let clientData = try req.content.decode(CreateClientInput.self)

        guard let workspace = try await Workspace.find(req.parameters.get("workspaceId"), on: req.db) else {
            throw Abort(.badRequest)
        }

        let client = try clientData.toClient(workspaceId: workspace.requireID())
        
        try await client.save(on: req.db)
        
        return ClientResponse(client: client)
    }
}
