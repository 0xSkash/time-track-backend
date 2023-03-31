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
        let workspace = try await Workspace.find(req: req)

        return try await Client.query(on: req.db)
            .filter(\.$workspace.$id == workspace.requireID())
            .all()
            .map { client in
                ClientResponse(client: client)
            }
    }

    func create(req: Request) async throws -> ClientResponse {
        let clientData = try req.validateAndDecode(CreateClientInput.self)

        let workspace = try await Workspace.find(req: req)

        let client = try clientData.toClient(workspaceId: workspace.requireID())
        
        try await client.save(on: req.db)
        
        return ClientResponse(client: client)
    }
}
