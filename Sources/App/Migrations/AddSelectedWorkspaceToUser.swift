
import Fluent

struct AddSelectedWorkspaceToUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field(User.Columns.selectedWorkspace.key, .uuid, .references(Workspace.schema, "id"))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).deleteField(User.Columns.selectedWorkspace.key).update()
    }
}
