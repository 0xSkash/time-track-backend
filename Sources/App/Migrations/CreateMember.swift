import Fluent

struct CreateMember: AsyncMigration {
    func prepare(on database: Database) async throws {
        let role = try await database.enum("roles")
            .case("admin")
            .case("member")
            .create()

        try await database.schema(Member.schema)
            .id()
            .field(Member.Columns.createdAt.key, .datetime, .required)
            .field(Member.Columns.updatedAt.key, .datetime)
            .field(Member.Columns.workspace.key, .uuid, .references(Workspace.schema, "id"), .required)
            .field(Member.Columns.user.key, .uuid, .references(User.schema, "id"), .required)
            .field(Member.Columns.role.key, role, .required)
            .field(Member.Columns.isBillable.key, .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Member.schema).delete()
    }
}
