import Fluent

struct CreateOrganization: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Organization.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("title", .string, .required)
            .field("owner_id", .uuid, .references(User.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Organization.schema).delete()
    }
}
