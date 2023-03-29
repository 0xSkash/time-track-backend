import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Project.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("title", .string, .required)
            .field("color", .string, .required)
            .field("workspace_id", .uuid, .references(Workspace.schema, "id"), .required)
            .field("client_id", .uuid, .references(Client.schema, "id"), .required)
            .field("creator_id", .uuid, .references(Member.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Project.schema).delete()
    }
}
