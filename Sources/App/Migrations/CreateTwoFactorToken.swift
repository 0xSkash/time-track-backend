import Fluent

struct CreateTwoFactorToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(TwoFactorToken.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .field("key", .string, .required)
            .unique(on: "user_id", "key")
            .field("backup_tokens", .array(of: .string), .required)
            .create()

        try await database.schema(User.schema)
            .field("two_factor_enabled", .bool, .sql(.default(false)))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(TwoFactorToken.schema)
            .delete()
        
        try await database.schema(User.schema)
            .deleteField("two_factor_enabled")
            .update()
    }
}
