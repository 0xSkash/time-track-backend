import Fluent

struct CreateTask: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Task.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("member_id", .uuid, .references(Member.schema, "id"), .required)
            .field("project_id", .uuid, .references(Project.schema, "id"), .required)
            .field("duration", .int)
            .field("description", .string, .required)
            .field("started_at", .datetime, .required)
            .field("ended_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Task.schema).delete()
    }
}
