import JWT
import Vapor

struct TokenAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User

    // verifies the JWT token and authenticates the corresponding user
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        print("In authenticator")
        let sessionToken = try request.jwt.verify(as: SessionToken.self)

        if let user = try await User.find(sessionToken.userId, on: request.db) {
             request.auth.login(user)
        }
    }
}

// JWT payload.
struct SessionToken: Content, Authenticatable, JWTPayload {
    // Constants
    var expirationTime: TimeInterval = 60 * 60 * 24

    // Token Data
    var expiration: ExpirationClaim
    var userId: UUID

    init(userId: UUID) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    init(user: User) throws {
        self.userId = try user.requireID()
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}