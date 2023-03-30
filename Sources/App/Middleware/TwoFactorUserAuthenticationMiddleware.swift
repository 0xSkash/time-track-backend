import Fluent
import Vapor

struct TwoFactorUserAuthenticationMiddleware: AsyncMiddleware {
    let allowBackupCode: Bool

    init(allowBackupCode: Bool = true) {
        self.allowBackupCode = allowBackupCode
    }

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Vapor.Response {
        guard let user = request.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }

        if !user.twoFactorEnabled {
            return try await next.respond(to: request)
        }

        guard let token = request.headers.first(name: "X-Auth-2FA") else {
            throw Abort(.badRequest)
        }

        let userToken = try await UserAuth.find(for: user, on: request.db)

        guard userToken.validate(token, allowBackupCode: allowBackupCode) else {
            throw Abort(.unauthorized)
        }

        return try await next.respond(to: request)
    }
}
