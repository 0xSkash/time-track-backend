import Fluent
import Vapor

final class Project: Model {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Field(key: Columns.title.key)
    var title: String

    @Field(key: Columns.color.key)
    var color: String

    @Parent(key: Columns.workspace.key)
    var workspace: Workspace

    @Parent(key: Columns.client.key)
    var client: Client

    @Parent(key: Columns.creator.key)
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

extension Project {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title = "title"
        case color = "color"
        case workspace = "workspace_id"
        case client = "client_id"
        case creator = "creator_id"

        var key: FieldKey {
            rawValue
        }
    }
}
