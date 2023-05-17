import Fluent

struct AddAvatarToUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field(User.Columns.avatar.key, .string)
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).deleteField(User.Columns.avatar.key).update()
    }
}
