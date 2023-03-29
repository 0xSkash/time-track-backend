import Fluent
import Vapor

final class Workspace: Model {
    static let schema = "workspaces"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "title")
    var title: String

    @Parent(key: "organization_id")
    var organization: Organization

    @Parent(key: "creator_id")
    var creator: User

    @Children(for: \.$workspace)
    var members: [Member]

    @Field(key: "is_billable")
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
