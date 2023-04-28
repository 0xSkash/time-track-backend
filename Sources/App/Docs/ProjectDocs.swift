
import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendProjectDocs() -> OpenAPIBuilder {
        return add([
            ProjectResponse.modelDocs(),
            CreateProjectInput.modelDocs(),
        ])
        .add(ProjectController.modelDocs())
    }
}

private extension ProjectResponse {
    static func modelDocs() -> APIObject<ProjectResponse> {
        let model = ProjectResponse(project: Project(
            id: UUID.generateRandom(),
            title: "TimeTrack",
            color: "#FFFFFF",
            workspaceId: UUID.generateRandom(),
            clientId: UUID.generateRandom(),
            creatorId: UUID.generateRandom()
        ), client: Client(
            id: UUID.generateRandom(),
            title: "Skash",
            workspaceId: UUID.generateRandom(),
            isBillable: true
        ))

        return APIObject(object: model, customName: "ProjectResponse")
    }
}

private extension CreateProjectInput {
    static func modelDocs() -> APIObject<CreateProjectInput> {
        let model = CreateProjectInput(
            title: "TimeTrack",
            color: "#FFFFF",
            clientId: UUID.generateRandom()
        )

        return APIObject(object: model, customName: "CreateProjectInput")
    }
}

extension ProjectController {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "Project",
            description: "Fetching and creating of projects",
            actions: [
                indexDocs(),
                createDocs()
            ]
        )
    }

    private static func indexDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/projects",
            summary: "Returns all Projects who belong to the selected workspace of the authenticated user",
            description: "Endpoint for Project fetching",
            parameters: [
                APIParameter.bearerHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "List of Projects of the specified workspace",
                    type: .object(ProjectResponse.self, asCollection: true)
                ),
                APIResponse(code: "400", description: "Workspace does not exist"),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func createDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/projects",
            summary: "Creates a project for the specified workspace",
            description: "Endpoint for project Creation",
            parameters: [
                APIParameter.bearerHeader()
            ],
            request: APIRequest(type: .object(CreateProjectInput.self)),
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created project",
                    type: .object(ProjectResponse.self)
                ),
                APIResponse(code: "400", description: "Workspace does not exist"),
                APIResponse.unauthorized()
            ]
        )
    }
}
