import Fluent
import Vapor

final class Workspace: Model {
    static let schema = "workspaces"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Field(key: Columns.title.key)
    var title: String

    @Parent(key: Columns.organization.key)
    var organization: Organization

    @Parent(key: Columns.creator.key)
    var creator: User

    @Children(for: \.$workspace)
    var members: [Member]

    @Field(key: Columns.isBillable.key)
    var isBillable: Bool

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        title: String,
        organizationId: Organization.IDValue,
        creatorId: User.IDValue,
        isBillable: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        $organization.id = organizationId
        $creator.id = creatorId
        self.isBillable = isBillable
    }

    init() {}
}

extension Workspace: PathParameter {
    typealias ModelType = Workspace

    static func parameterName() -> String {
        "workspaceId"
    }
}

extension Workspace {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title = "title"
        case organization = "organization_id"
        case creator = "creator_id"
        case isBillable = "is_billable"

        var key: FieldKey {
            rawValue
        }
    }
}
