import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field(User.Columns.updatedAt.key, .datetime)
            .field(User.Columns.createdAt.key, .datetime, .required)
            .field(User.Columns.email.key, .string, .required, .sql(.unique))
            .field(User.Columns.passwordHash.key, .string, .required)
            .field(User.Columns.firstName.key, .string, .required)
            .field(User.Columns.lastName.key, .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
