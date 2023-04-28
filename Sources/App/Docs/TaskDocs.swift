
import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendTaskDocs() -> OpenAPIBuilder {
        return add([
            TaskResponse.modelDocs(),
            CreateTaskInput.modelDocs()
        ])
        .add(TaskController.modelDocs())
    }
}

private extension TaskResponse {
    static func modelDocs() -> APIObject<TaskResponse> {
        let model = TaskResponse(task: Task(
            id: UUID.generateRandom(),
            memberId: UUID.generateRandom(),
            projectId: UUID.generateRandom(),
            duration: 100,
            description: "Thats a Task description",
            startedAt: Date(),
            endedAt: Date()
        ), project: Project(
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

        return APIObject(object: model)
    }
}

private extension CreateTaskInput {
    static func modelDocs() -> APIObject<CreateTaskInput> {
        let model = CreateTaskInput(
            startedAt: Date(),
            endedAt: Date(),
            duration: 100,
            project: UUID.generateRandom(),
            description: "Thats a Task description"
        )

        return APIObject(object: model)
    }
}

extension TaskController {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "Task",
            description: "Fetching and creating of task per member",
            actions: [
                createDocs()
            ]
        )
    }

    private static func createDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/tasks/",
            summary: "Creates a task entry for the authenticated user",
            description: "Endpoint for worktime Creation",
            parameters: [
                APIParameter.bearerHeader()
            ],
            request: APIRequest(type: .object(CreateTaskInput.self)),
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created task",
                    type: .object(TaskResponse.self)
                ),
                APIResponse.unauthorized()
            ]
        )
    }
}
