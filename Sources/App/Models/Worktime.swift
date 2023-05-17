import Fluent
import Vapor

final class Worktime: Model {
    static let schema = "worktimes"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Parent(key: Columns.user.key)
    var user: User

    @Field(key: Columns.duration.key)
    var duration: Int

    @Field(key: Columns.startedAt.key)
    var startedAt: Date

    @Field(key: Columns.endedAt.key)
    var endedAt: Date

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        userId: User.IDValue,
        duration: Int,
        startedAt: Date,
        endedAt: Date
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        $user.id = userId
        self.duration = duration
        self.startedAt = startedAt
        self.endedAt = endedAt
    }

    init() {}
}

extension Worktime {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user = "user_id"
        case duration = "duration"
        case startedAt = "started_at"
        case endedAt = "ended_at"

        var key: FieldKey {
            rawValue
        }
    }
}
