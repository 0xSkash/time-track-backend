import Fluent

struct CreateWorktime: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Worktime.schema)
            .id()
            .field(Worktime.Columns.createdAt.key, .datetime, .required)
            .field(Worktime.Columns.updatedAt.key, .datetime)
            .field(Worktime.Columns.user.key, .uuid, .references(User.schema, "id"), .required)
            .field(Worktime.Columns.duration.key, .int)
            .field(Worktime.Columns.startedAt.key, .datetime, .required)
            .field(Worktime.Columns.endedAt.key, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Worktime.schema).delete()
    }
}
