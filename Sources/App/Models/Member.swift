import Fluent
import Vapor

final class Member: Model {
    static let schema = "members"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Parent(key: "workspace_id")
    var workspace: Workspace

    @Parent(key: "user_id")
    var user: User

    @Enum(key: "role")
    var role: Role

    @Field(key: "is_billable")
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
