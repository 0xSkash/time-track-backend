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
    fileprivate static func modelDocs() -> APIObject<ClientResponse> {
        let model = ClientResponse(client: Client(
            id: UUID.generateRandom(),
            title: "Example Title",
            workspaceId: UUID.generateRandom(),
            isBillable: true
        ))

        return APIObject(object: model)
    }
}

extension ClientController {
    fileprivate static func modelDocs() -> APIController {
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
            route: "/organizations/{\(Organization.parameterName())}/workspaces/{\(Workspace.parameterName())}/clients",
            summary: "Returns all Clients who belong to the specified workspace",
            description: "Endpoint for Client fetching",
            parameters: [
                APIParameter.bearerHeader(),
                Organization.parameterDocs(),
                Workspace.parameterDocs()
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
            route: "/organizations/{\(Organization.parameterName())}/workspaces/{\(Workspace.parameterName())}/clients",
            summary: "Creates a client for the specified workspace",
            description: "Endpoint for Client Creation",
            parameters: [
                APIParameter.bearerHeader(),
                Organization.parameterDocs(),
                Workspace.parameterDocs()
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
