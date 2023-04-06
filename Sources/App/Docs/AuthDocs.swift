import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendAuthDocs() -> OpenAPIBuilder {
        return add([
            ClientTokenResponse.modelDocs(),
            UserResponse.modelDocs()
        ])
        .add(UserAuth.modelDocs())
    }
}

private extension ClientTokenResponse {
    static func modelDocs() -> APIObject<ClientTokenResponse> {
        let model = ClientTokenResponse(
            token: "EGHEWGJWHKGWHJGHJWEG",
            userId: UUID.generateRandom()
        )

        return APIObject(object: model)
    }
}

private extension UserResponse {
    static func modelDocs() -> APIObject<UserResponse> {
        let model = UserResponse(user: User(
            id: UUID.generateRandom(),
            firstName: "Skash",
            lastName: "Mash",
            email: "skash@skash.de",
            passwordHash: "ENMGWNEGEioejge"
        ))

        return APIObject(object: model)
    }
}

extension UserAuth {
    fileprivate static func modelDocs() -> APIController {
        return APIController(
            name: "Auth",
            description: "User Authentication",
            actions: [
                loginDocs(),
                meDocs(),
                enableTwoFactorDocs(),
                disableTwoFactorDocs()
            ]
        )
    }

    private static func loginDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/auth/login",
            summary: "Login in User",
            description: "Endpoint for User authentication",
            parameters: [
                APIParameter.basicAuthHeader(),
                APIParameter.twoFactorHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "Auth Data for the authenticated user",
                    type: .object(ClientTokenResponse.self)
                ),
                APIResponse(code: "449", description: "Retry with X-Auth-2FA Header Field"),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func meDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/auth/me",
            summary: "Returns the SelfUser",
            description: "Endpoint for getting SelfUser",
            parameters: [
                APIParameter.bearerHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "The created client",
                    type: .object(UserResponse.self)
                ),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func getTwoFactorTokenDocs() -> APIAction {
        return APIAction(
            method: .get,
            route: "/auth/me/two-factor-token",
            summary: "Returns the 2FA Token",
            description: "Endpoint for getting 2FA Token",
            parameters: [
                APIParameter.bearerHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "The 2FA Token",
                    type: .object(TwoFactorTokenResponse.self)
                ),
                APIResponse.unauthorized()
            ]
        )
    }

    private static func enableTwoFactorDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/auth/me/enable-two-factor",
            summary: "Enables 2FA for selfuser",
            description: "Endpoint for enabling 2FA for selfuser",
            parameters: [
                APIParameter.bearerHeader(),
                APIParameter.twoFactorHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "2FA enabled"
                ),
                APIResponse.unauthorized(),
                APIResponse(code: "400", description: "X-Auth-2FA Missing")
            ]
        )
    }

    private static func disableTwoFactorDocs() -> APIAction {
        return APIAction(
            method: .post,
            route: "/auth/me/disable-two-factor",
            summary: "Disables 2FA for SelfUser",
            description: "Endpoint for disabling 2FA for SelfUser",
            parameters: [
                APIParameter.bearerHeader(),
                APIParameter.twoFactorHeader()
            ],
            responses: [
                APIResponse(
                    code: "200",
                    description: "2FA Disabled",
                    type: .object(UserResponse.self)
                ),
                APIResponse.unauthorized()
            ]
        )
    }
}
