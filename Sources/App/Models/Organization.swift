import Fluent
import Vapor

final class Organization: Model {
    static let schema = "organizations"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "title")
    var name: String

    @Parent(key: "owner_id")
    var owner: User

    @Children(for: \.$organization)
    var workspaces: [Workspace]

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
