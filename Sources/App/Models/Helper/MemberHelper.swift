import FluentKit
import Vapor

extension Member {
    static func find(for user: User, in workspaceId: Workspace.IDValue, on db: Database) async throws -> Member? {
        return try await Member.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspaceId)
            .first()
    }
}
