
import Fluent

struct AddSelectedWorkspaceToUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field("selected_workspace_id", .uuid, .references(Workspace.schema, "id"))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).deleteField("selected_workspace_id").update()
    }
}
