import Fluent
import Vapor

final class Client: Model {
    static let schema = "clients"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Field(key: Columns.title.key)
    var title: String

    @Parent(key: Columns.workspace.key)
    var workspace: Workspace

    @Field(key: Columns.isBillable.key)
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

extension Client {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title = "title"
        case workspace = "workspace_id"
        case isBillable = "isBillable"

        var key: FieldKey {
            rawValue
        }
    }
}
