import Fluent

struct CreateMember: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Member.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("workspace_id", .uuid, .references(Workspace.schema, "id"), .required)
            .field("user_id", .uuid, .references(User.schema, "id"), .required)
            .field("role_id", .uuid, .references(Role.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Member.schema).delete()
    }
}
