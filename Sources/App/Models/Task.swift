import Fluent
import Vapor

final class Task: Model {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Parent(key: Columns.member.key)
    var member: Member

    @Parent(key: Columns.project.key)
    var project: Project

    @Field(key: Columns.duration.key)
    var duration: Int

    @Field(key: Columns.description.key)
    var description: String

    @Field(key: Columns.startedAt.key)
    var startedAt: Date

    @Field(key: Columns.endedAt.key)
    var endedAt: Date

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        memberId: Member.IDValue,
        projectId: Project.IDValue,
        duration: Int,
        description: String,
        startedAt: Date,
        endedAt: Date
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        $member.id = memberId
        $project.id = projectId
        self.duration = duration
        self.description = description
        self.startedAt = startedAt
        self.endedAt = endedAt
    }

    init() {}
}

extension Task {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case member = "member_id"
        case project = "project_id"
        case duration = "duration"
        case description = "description"
        case startedAt = "started_at"
        case endedAt = "ended_at"

        var key: FieldKey {
            rawValue
        }
    }
}
