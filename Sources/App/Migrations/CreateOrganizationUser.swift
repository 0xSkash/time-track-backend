import Fluent

struct CreateOrganizationUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(OrganizationUser.schema)
            .id()
            .field(OrganizationUser.Columns.user.key, .uuid, .references(User.schema, "id"), .required)
            .field(OrganizationUser.Columns.organization.key, .uuid, .references(Organization.schema, "id"), .required)
            .unique(on: OrganizationUser.Columns.user.key, OrganizationUser.Columns.organization.key)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(OrganizationUser.schema).delete()
    }
}
