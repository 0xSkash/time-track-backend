import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendWorktimeDocs() -> OpenAPIBuilder {
        return add([
            WorktimeResponse.modelDocs(),
            CreateWorktimeInput.modelDocs()
        ])
        .add(WorktimeController.modelDocs())
    }
}

private extension WorktimeResponse {
    static func modelDocs() -> APIObject<WorktimeResponse> {
        let model = WorktimeResponse(worktime: Worktime(
            id: UUID.generateRandom(),
            userId: UUID.generateRandom(),
            duration: 100,
            startedAt: Date(),
            endedAt: Date()
        ))

        return APIObject(object: model)
    }
}

private extension CreateWorktimeInput {
    static func modelDocs() -> APIObject<CreateWorktimeInput> {
        let model = CreateWorktimeInput(
            startedAt: Date(),
            endedAt: Date(),
            duration: 100
        )

        return APIObject(object: model)
    }
}

extension WorktimeController {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "Worktime",
            description: "Fetching and creating of worktime per user",
            actions: [
                createDocs()
            ]
        )
    }

    private static func createDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/worktime/",
            summary: "Creates a worktime entry for the specified workspace",
            description: "Endpoint for worktime Creation",
            parameters: [
                APIParameter.bearerHeader()
            ],
            request: APIRequest(type: .object(CreateWorktimeInput.self)),
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created worktime",
                    type: .object(WorktimeResponse.self)
                ),
                APIResponse.unauthorized()
            ]
        )
    }
}
