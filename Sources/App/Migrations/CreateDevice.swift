import Fluent

struct CreateDevice: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Device.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("last_seen", .datetime)
            .field("manufacturer", .string, .required, .sql(.unique))
            .field("model", .string, .required)
            .field("os_version", .string, .required)
            .field("push_token", .string, .required, .sql(.unique))
            .field("user_id", .uuid, .references(User.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Device.schema).delete()
    }
}
