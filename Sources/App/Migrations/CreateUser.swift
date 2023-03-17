import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("updated_at", .datetime)
            .field("created_at", .datetime)
            .field("email", .string, .required, .sql(.unique))
            .field("password_hash", .string, .required)
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
