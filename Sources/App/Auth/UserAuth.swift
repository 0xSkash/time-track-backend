import Vapor

import Fluent
import Foundation
import Vapor

struct UserAuth: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // password protected
        routes.group(User.authenticator(), User.guardMiddleware()) { password in
            password.post("login", use: getToken)
        }

        // jwt protected
        routes.group(TokenAuthenticator()) { protected in
            protected.get("me", use: getCurrentUser)
            protected.get("refresh", use: getToken)
        }
    }

    func getToken(req: Request) async throws -> ClientTokenResponse {
        let user = try req.auth.require(User.self)
        let payload = try SessionToken(user: user)
        let token = try req.jwt.sign(payload)

        return ClientTokenResponse(token: token)
    }

    func getCurrentUser(req: Request) async throws -> UserResponse {
        return try UserResponse(user: try req.auth.require(User.self))
    }
}
