import Fluent

struct CreateRole: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Role.schema)
            .id()
            .field("slug", .string, .required)
            .create()

        let admin = Role(slug: .admin)
        let member = Role(slug: .member)

        try await admin.save(on: database)
        try await member.save(on: database)
    }

    func revert(on database: Database) async throws {
        try await database.schema(Role.schema).delete()
    }
}
