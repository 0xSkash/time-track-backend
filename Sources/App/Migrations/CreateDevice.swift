import Fluent

struct CreateDevice: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Device.schema)
            .id()
            .field(Device.Columns.createdAt.key, .datetime, .required)
            .field(Device.Columns.updatedAt.key, .datetime)
            .field(Device.Columns.lastSeen.key, .datetime)
            .field(Device.Columns.manufacturer.key, .string, .required)
            .field(Device.Columns.model.key, .string, .required)
            .field(Device.Columns.osVersion.key, .string, .required)
            .field(Device.Columns.pushToken.key, .string, .required, .sql(.unique))
            .field(Device.Columns.userId.key, .uuid, .references(User.schema, "id"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Device.schema).delete()
    }
}
