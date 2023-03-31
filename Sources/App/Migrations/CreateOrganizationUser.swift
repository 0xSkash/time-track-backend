import Fluent

struct CreateOrganizationUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(OrganizationUser.schema)
            .id()
            .field("user_id", .uuid, .references(User.schema, "id"), .required)
            .field("organization_id", .uuid, .references(Organization.schema, "id"), .required)
            .unique(on: "user_id", "organization_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(OrganizationUser.schema).delete()
    }
}
