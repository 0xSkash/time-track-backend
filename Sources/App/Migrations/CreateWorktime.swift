import Fluent

struct CreateWorktime: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Worktime.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("member_id", .uuid, .references(Member.schema, "id"), .required)
            .field("duration", .int)
            .field("started_at", .datetime, .required)
            .field("ended_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Worktime.schema).delete()
    }
}
