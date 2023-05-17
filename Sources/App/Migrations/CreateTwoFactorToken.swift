import Fluent

struct CreateTwoFactorToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(TwoFactorToken.schema)
            .id()
            .field(TwoFactorToken.Columns.user.key, .uuid, .required, .references(User.schema, "id"))
            .field(TwoFactorToken.Columns.key.key, .string, .required)
            .unique(on: TwoFactorToken.Columns.user.key, TwoFactorToken.Columns.key.key)
            .field(TwoFactorToken.Columns.backupTokens.key, .array(of: .string), .required)
            .create()

        try await database.schema(User.schema)
            .field(User.Columns.twoFactorEnabled.key, .bool, .sql(.default(false)))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(TwoFactorToken.schema)
            .delete()
        
        try await database.schema(User.schema)
            .deleteField(User.Columns.twoFactorEnabled.key)
            .update()
    }
}
