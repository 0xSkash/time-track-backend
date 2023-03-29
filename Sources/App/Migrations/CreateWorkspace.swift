import Fluent

struct CreateWorkspace: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Workspace.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("title", .string, .required, .sql(.unique))
            .field("organization_id", .uuid, .references(Organization.schema, "id"), .required)
            .field("creator_id", .uuid, .references(User.schema, "id"), .required)
            .field("is_billable", .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Workspace.schema).delete()
    }
}
