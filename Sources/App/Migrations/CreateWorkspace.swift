import Fluent

struct CreateWorkspace: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Workspace.schema)
            .id()
            .field(Workspace.Columns.createdAt.key, .datetime, .required)
            .field(Workspace.Columns.updatedAt.key, .datetime)
            .field(Workspace.Columns.title.key, .string, .required, .sql(.unique))
            .field(Workspace.Columns.organization.key, .uuid, .references(Organization.schema, "id"), .required)
            .field(Workspace.Columns.creator.key, .uuid, .references(User.schema, "id"), .required)
            .field(Workspace.Columns.isBillable.key, .bool, .required, .sql(.default(true)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Workspace.schema).delete()
    }
}
