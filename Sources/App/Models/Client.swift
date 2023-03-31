import Fluent
import Vapor

final class Client: Model {
    static let schema = "clients"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "title")
    var title: String

    @Parent(key: "workspace_id")
    var workspace: Workspace

    @Field(key: "is_billable")
    var isBillable: Bool

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        title: String,
        workspaceId: Workspace.IDValue,
        isBillable: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        $workspace.id = workspaceId
        self.isBillable = isBillable
    }

    init() {}
}
