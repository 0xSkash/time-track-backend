import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendClientDocs() -> OpenAPIBuilder {
        return add([
            ClientResponse.modelDocs()
        ])
        .add(ClientController.modelDocs())
    }
}

extension ClientResponse {
    static func modelDocs() -> APIObject<ClientResponse> {
        let model = ClientResponse(client: Client(
            title: "Example Title", workspaceId: UUID(uuidString: "d0a1d3c1-48bf-4c23-93d8-f6b6496f7c96")!, isBillable: true
        ))

        return APIObject(object: model)
    }
}

extension ClientController {
    static func modelDocs() -> APIController {
        return APIController(
            name: "Client",
            description: "Fetching and creating of clients per workspace",
            actions: [
                indexDocs(),
                createDocs()
            ]
        )
    }

    private static func indexDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/organizations/{organizationId}/workspaces/{workspaceId}/clients",
            summary: "Returns all Clients who belong to the specified workspace",
            description: "Endpoint for Client fetching",
            parameters: [
                APIParameter.bearerHeader(),
                APIParameter.organizationId(),
                APIParameter.workspaceId()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "List of Clients of the specified workspace",
                    type: .object(ClientResponse.self, asCollection: true)
                ),
                APIResponse(code: "400", description: "Workspace does not exist"),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func createDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/organizations/{organizationId}/workspaces/{workspaceId}/clients",
            summary: "Creates a client for the specified workspace",
            description: "Endpoint for Client Creation",
            parameters: [
                APIParameter.bearerHeader(),
                APIParameter.organizationId(),
                APIParameter.workspaceId()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created client",
                    type: .object(ClientResponse.self)
                ),
                APIResponse(code: "400", description: "Workspace does not exist"),
                APIResponse.unauthorized()
            ]
        )
    }
}
