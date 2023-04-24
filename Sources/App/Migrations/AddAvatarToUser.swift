import Fluent

struct AddAvatarToUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field("avatar", .string)
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).deleteField("avatar").update()
    }
}
