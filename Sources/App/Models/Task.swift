import Fluent
import Vapor

final class Task: Model {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Parent(key: "member_id")
    var member: Member

    @Parent(key: "project_id")
    var project: Project

    @Field(key: "duration")
    var duration: Int?

    @Field(key: "description")
    var description: String

    @Field(key: "started_at")
    var startedAt: Date

    @Field(key: "ended_at")
    var endedAt: Date?

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        memberId: Member.IDValue,
        projectId: Project.IDValue,
        duration: Int?,
        description: String,
        startedAt: Date,
        endedAt: Date?
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
