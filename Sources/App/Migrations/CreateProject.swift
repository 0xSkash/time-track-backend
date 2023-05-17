import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Project.schema)
            .id()
            .field(Project.Columns.createdAt.key, .datetime, .required)
            .field(Project.Columns.updatedAt.key, .datetime)
            .field(Project.Columns.title.key, .string, .required)
            .field(Project.Columns.color.key, .string, .required)
            .field(Project.Columns.workspace.key, .uuid, .references(Workspace.schema, "id"), .required)
            .field(Project.Columns.client.key, .uuid, .references(Client.schema, "id"), .required)
            .field(Project.Columns.creator.key, .uuid, .references(Member.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Project.schema).delete()
    }
}
