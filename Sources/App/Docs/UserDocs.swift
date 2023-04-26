
import Foundation
import Swiftgger
import Vapor

extension OpenAPIBuilder {
    func appendUserDocs() -> OpenAPIBuilder {
        return add([
            CreateUserInput.modelDocs(),
            AvatarInput.modelDocs(),
            AvatarResponse.modelDocs()
        ])
        .add(UserController.modelDocs())
    }
}

private extension CreateUserInput {
    static func modelDocs() -> APIObject<CreateUserInput> {
        let model = CreateUserInput(
            firstName: "Skash",
            lastName: "mash",
            email: "skash@skash.de",
            password: "password"
        )

        return APIObject(object: model, customName: "userInput")
    }
}

private extension AvatarInput {
    static func modelDocs() -> APIObject<AvatarInput> {
        let model = AvatarInput(file: File(data: "", filename: "example-file"))

        return APIObject(object: model)
    }
}

private extension AvatarResponse {
    static func modelDocs() -> APIObject<AvatarResponse> {
        let model = AvatarResponse(avatarName: UUID.generateRandom().uuidString)

        return APIObject(object: model, customName: "AvatarResponse")
    }
}

extension UserController {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "User",
            description: "Fetching and creating of Users",
            actions: [
                registerDocs(),
                updateAvatarDocs(),
                destroyAvatarDocs(),
                indexOrganizationsDocs(),
                indexWorktimeDocs()
            ]
        )
    }

    private static func registerDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/users/register",
            summary: "Registers a new user",
            description: "Endpoint for registration of users",
            request: APIRequest(type: .object(CreateUserInput.self)),
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created user object",
                    type: .object(UserResponse.self)
                ),
                APIResponse(code: "406", description: "Input Data not acceptable")
            ]
        )
    }

    private static func updateAvatarDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/users/me/avatar",
            summary: "Updates avatar of authenticated user",
            description: "Endpoint for updating avatar of authenticated users",
            parameters: [
                APIParameter.bearerHeader()
            ],
            request: APIRequest(type: .formdata("avatar"), description: "Avatar of user"),
            responses: [
                APIResponse(
                    code: "200",
                    description: "Avatar got updated",
                    type: .object(AvatarResponse.self)
                ),
                APIResponse.unauthorized(),
                APIResponse(code: "400", description: "corrupted data")
            ]
        )
    }

    private static func destroyAvatarDocs() -> APIAction {
        return APIAction(
            method: .delete,
            route: "/users/me/avatar",
            summary: "Delets avatar of user",
            description: "Endpoint for destroying avatar of authenticated user",
            parameters: [
                APIParameter.bearerHeader()
            ],
            responses: [
                APIResponse(
                    code: "204",
                    description: "No Content"
                ),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func indexOrganizationsDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/users/me/organizations",
            summary: "Returns all Organizations of the authenticated user.",
            description: "Endpoint for fetching of users organizations",
            parameters: [
                APIParameter.bearerHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "List of Organizations",
                    type: .object(OrganizationResponse.self, asCollection: true)
                ),
                APIResponse.unauthorized()
            ]
        )
    }
    
    private static func indexWorktimeDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/users/me/worktime",
            summary: "Returns worktimes of the authenticated user in specified.",
            description: "Endpoint for fetching of users worktimes",
            parameters: [
                APIParameter.bearerHeader()            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "List of Worktimes",
                    type: .object(WorktimeResponse.self, asCollection: true)
                ),
                APIResponse.unauthorized()
            ]
        )
    }
}
