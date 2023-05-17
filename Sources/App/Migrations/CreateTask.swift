import Fluent

struct CreateTask: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Task.schema)
            .id()
            .field(Task.Columns.createdAt.key, .datetime, .required)
            .field(Task.Columns.updatedAt.key, .datetime)
            .field(Task.Columns.member.key, .uuid, .references(Member.schema, "id"), .required)
            .field(Task.Columns.project.key, .uuid, .references(Project.schema, "id"), .required)
            .field(Task.Columns.duration.key, .int)
            .field(Task.Columns.description.key, .string, .required)
            .field(Task.Columns.startedAt.key, .datetime, .required)
            .field(Task.Columns.endedAt.key, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Task.schema).delete()
    }
}
