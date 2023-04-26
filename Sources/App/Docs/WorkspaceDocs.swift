import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendWorkspaceDocs() -> OpenAPIBuilder {
        return add([
            WorkspaceResponse.modelDocs()
        ])
        .add(WorkspaceController.modelDocs())
    }
}

private extension WorkspaceResponse {
    static func modelDocs() -> APIObject<WorkspaceResponse> {
        let model = WorkspaceResponse(workspace: Workspace(
            id: UUID.generateRandom(),
            title: "Android",
            organizationId: UUID.generateRandom(),
            creatorId: UUID.generateRandom(),
            isBillable: true
        ))

        return APIObject(object: model)
    }
}

extension WorkspaceController {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "Workspace",
            description: "Fetching and creating of Workspaces per organization",
            actions: [
                indexForOrganizationDocs()
            ]
        )
    }

    private static func indexForOrganizationDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/organizations/{\(Organization.parameterName())}/workspaces",
            summary: "Returns all Workspaces who belong to the specified organizations for the authenticated user",
            description: "Endpoint for workspace fetching",
            parameters: [
                APIParameter.bearerHeader(),
                Organization.parameterDocs()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "List of Workspaces of the specified organzation",
                    type: .object(WorkspaceResponse.self, asCollection: true)
                ),
                APIResponse(code: "404", description: "organzation not found"),
                APIResponse.unauthorized()
            ]
        )
    }
}
