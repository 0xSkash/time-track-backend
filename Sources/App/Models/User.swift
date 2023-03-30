import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "first_name")
    var firstName: String

    @Field(key: "last_name")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "two_factor_enabled")
    var twoFactorEnabled: Bool

    @Children(for: \TwoFactorToken.$user)
    var twoFactorToken: [TwoFactorToken]

    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        email: String,
        passwordHash: String,
        twoFactorEnabled: Bool = false
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.twoFactorEnabled = twoFactorEnabled
    }

    init() {}
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    // Password verification used via AppUser.authenticator() / Basic Auth
    func verify(password: String) throws -> Bool {
        print("verify User")
        return try Bcrypt.verify(password, created: passwordHash)
    }
}
