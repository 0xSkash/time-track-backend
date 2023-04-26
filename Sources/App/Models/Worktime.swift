import Fluent
import Vapor

final class Worktime: Model {
    static let schema = "worktimes"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "duration")
    var duration: Int

    @Field(key: "started_at")
    var startedAt: Date

    @Field(key: "ended_at")
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
