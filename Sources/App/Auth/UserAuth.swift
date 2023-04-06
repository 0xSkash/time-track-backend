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

            protected.group(TwoFactorUserAuthenticationMiddleware()) { twoFactorProtected in
                twoFactorProtected.post("me", "disable-two-factor", use: disableTwoFactor)
            }
            protected.get("me", use: getCurrentUser)
            protected.get("me", "two-factor-token", use: getTwoFactorToken)
            protected.post("me", "enable-two-factor", use: enableTwoFactor)
            protected.get("refresh", use: getToken)
        }
    }

    func getToken(req: Request) async throws -> ClientTokenResponse {
        let user = try req.auth.require(User.self)
        let payload = try SessionToken(user: user)
        let token = try req.jwt.sign(payload)

        if !user.twoFactorEnabled {
            return ClientTokenResponse(token: token, userId: try user.requireID())
        }

        guard let code = req.headers.first(name: "X-Auth-2FA") else {
            throw Abort(HTTPStatus(statusCode: 449))
        }

        let twoFactorToken = try await UserAuth.find(for: user, on: req.db)

        guard twoFactorToken.validate(code) else {
            throw Abort(.unauthorized)
        }

        return ClientTokenResponse(token: token, userId: try user.requireID())
    }

    func getCurrentUser(req: Request) async throws -> UserResponse {
        return UserResponse(user: try req.auth.require(User.self))
    }

    func getTwoFactorToken(req: Request) async throws -> TwoFactorTokenResponse {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if user.twoFactorEnabled {
            let response = try await UserAuth.find(for: user, on: req.db)
            return TwoFactorTokenResponse(twoFactorCode: response)
        }

        let token = try await user.$twoFactorToken.get(on: req.db)

        if token.isEmpty {
            let newToken = try TwoFactorToken.generate(for: user)
            try await newToken.save(on: req.db)
        }

        let response = try await UserAuth.find(for: user, on: req.db)
        return TwoFactorTokenResponse(twoFactorCode: response)
    }

    func enableTwoFactor(req: Request) async throws -> HTTPStatus {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if user.twoFactorEnabled {
            return .ok
        }

        guard let token = req.headers.first(name: "X-Auth-2FA") else {
            throw Abort(.badRequest)
        }

        let userToken = try await UserAuth.find(for: user, on: req.db)

        guard userToken.validate(token, allowBackupCode: false) else {
            try await userToken.delete(on: req.db)
            throw Abort(.unauthorized)
        }

        user.twoFactorEnabled = true
        try await user.save(on: req.db)

        return .ok
    }

    func disableTwoFactor(req: Request) async throws -> HTTPStatus {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if !user.twoFactorEnabled {
            return .ok
        }

        let userToken = try await UserAuth.find(for: user, on: req.db)
        
        user.twoFactorEnabled = false
        try await userToken.delete(on: req.db)
        try await user.save(on: req.db)

        return .ok
    }

    static func find(
        for user: User,
        on db: Database
    ) async throws -> TwoFactorToken {
        guard let token = try await user.$twoFactorToken
            .query(on: db)
            .with(\.$user)
            .first()
        else {
            throw Abort(.internalServerError, reason: "No 2FA token found")
        }

        return token
    }
}
