import Fluent

struct CreateClient: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Client.schema)
            .id()
            .field(Client.Columns.createdAt.key, .datetime, .required)
            .field(Client.Columns.updatedAt.key, .datetime)
            .field(Client.Columns.title.key, .string, .required, .sql(.unique))
            .field(Client.Columns.workspace.key, .uuid, .references(Workspace.schema, "id"), .required)
            .field(Client.Columns.isBillable.key, .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Client.schema).delete()
    }
}
