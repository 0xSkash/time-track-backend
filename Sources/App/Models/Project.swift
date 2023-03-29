import Fluent
import Vapor

final class Project: Model {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "title")
    var title: String

    @Field(key: "color")
    var color: String

    @Parent(key: "workspace_id")
    var workspace: Workspace

    @Parent(key: "client_id")
    var client: Client

    @Parent(key: "creator_id")
    var creator: Member

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        title: String,
        color: String,
        workspaceId: Workspace.IDValue,
        clientId: Client.IDValue,
        creatorId: Member.IDValue
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        self.color = color
        $workspace.id = workspaceId
        $client.id = clientId
        $creator.id = creatorId
    }

    init() {}
}
