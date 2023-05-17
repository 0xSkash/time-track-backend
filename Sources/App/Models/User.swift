import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Field(key: Columns.firstName.key)
    var firstName: String

    @Field(key: Columns.lastName.key)
    var lastName: String

    @Field(key: Columns.email.key)
    var email: String

    @Field(key: Columns.passwordHash.key)
    var passwordHash: String

    @Field(key: Columns.twoFactorEnabled.key)
    var twoFactorEnabled: Bool

    @Field(key: Columns.avatar.key)
    var avatar: String?

    @OptionalParent(key: Columns.selectedWorkspace.key)
    var selectedWorkspace: Workspace?

    @Children(for: \TwoFactorToken.$user)
    var twoFactorToken: [TwoFactorToken]

    @Siblings(through: OrganizationUser.self, from: \.$user, to: \.$organization)
    public var organizations: [Organization]

    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        email: String,
        passwordHash: String,
        selectedWorkspaceId: Workspace.IDValue?,
        twoFactorEnabled: Bool = false,
        avatar: String?
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        $selectedWorkspace.id = selectedWorkspaceId
        self.twoFactorEnabled = twoFactorEnabled
        self.avatar = avatar
    }

    init() {}
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    // Password verification used via AppUser.authenticator() / Basic Auth
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: passwordHash)
    }
}

extension User: PathParameter {
    typealias ModelType = User

    static func parameterName() -> String {
        return "userId"
    }
}

extension User {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case passwordHash = "password_hash"
        case twoFactorEnabled = "two_factor_enabled"
        case avatar = "avatar"
        case selectedWorkspace = "selected_workspace_id"

        var key: FieldKey {
            rawValue
        }
    }
}
