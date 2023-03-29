import Fluent

struct CreateMember: AsyncMigration {
    func prepare(on database: Database) async throws {
        let role = try await database.enum("roles")
            .case("admin")
            .case("member")
            .create()

        try await database.schema(Member.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("workspace_id", .uuid, .references(Workspace.schema, "id"), .required)
            .field("user_id", .uuid, .references(User.schema, "id"), .required)
            .field("role", role, .required)
            .field("is_billable", .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Member.schema).delete()
    }
}
