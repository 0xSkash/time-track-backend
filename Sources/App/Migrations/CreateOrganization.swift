import Fluent

struct CreateOrganization: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Organization.schema)
            .id()
            .field(Organization.Columns.createdAt.key, .datetime, .required)
            .field(Organization.Columns.updatedAt.key, .datetime)
            .field(Organization.Columns.title.key, .string, .required)
            .field(Organization.Columns.owner.key, .uuid, .references(User.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Organization.schema).delete()
    }
}
