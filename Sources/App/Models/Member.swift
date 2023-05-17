import Fluent
import Vapor

final class Member: Model {
    static let schema = "members"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Parent(key: Columns.workspace.key)
    var workspace: Workspace

    @Parent(key: Columns.user.key)
    var user: User

    @Enum(key: Columns.role.key)
    var role: Role

    @Field(key: Columns.isBillable.key)
    var isBillable: Bool

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        workspaceId: UUID,
        userId: User.IDValue,
        role: Role,
        isBillable: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        $workspace.id = workspaceId
        $user.id = userId
        self.role = role
        self.isBillable = isBillable
    }

    init() {}
}

extension Member: PathParameter {
    typealias ModelType = Member

    static func parameterName() -> String {
        return "memberId"
    }
}

extension Member {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case workspace = "workspace_id"
        case user = "user_id"
        case role = "role"
        case isBillable = "isBillable"

        var key: FieldKey {
            rawValue
        }
    }
}
