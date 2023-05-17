import Fluent
import Vapor

final class Organization: Model {
    static let schema = "organizations"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Field(key: Columns.title.key)
    var name: String

    @Parent(key: Columns.owner.key)
    var owner: User

    @Children(for: \.$organization)
    var workspaces: [Workspace]

    @Siblings(through: OrganizationUser.self, from: \.$organization, to: \.$user)
    public var users: [User]

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        name: String,
        ownerId: User.IDValue
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        $owner.id = ownerId
    }

    init() {}
}

extension Organization: PathParameter {
    typealias ModelType = Organization

    static func parameterName() -> String {
        return "organizationId"
    }
}

extension Organization {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title = "title"
        case owner = "owner_id"

        var key: FieldKey {
            rawValue
        }
    }
}
