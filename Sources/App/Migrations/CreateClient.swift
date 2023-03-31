import Fluent

struct CreateClient: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Client.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("title", .string, .required, .sql(.unique))
            .field("workspace_id", .uuid, .references(Workspace.schema, "id"), .required)
            .field("is_billable", .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Client.schema).delete()
    }
}
