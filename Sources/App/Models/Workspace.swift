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

    @Children(for: \.$workspace)
    var members: [Member]

    @Field(key: "is_billable")
    var isBillable: Bool

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        title: String,
        organizationId: UUID,
        isBillable: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        $organization.id = organizationId
        self.isBillable = isBillable
    }

    init() {}
}
