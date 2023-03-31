import FluentKit
import Vapor

extension Member {
    static func find(for user: User, in workspace: Workspace, on db: Database) async throws -> Member {
        guard let member = try await Member.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$workspace.$id == workspace.requireID())
            .first()
        else {
            throw Abort(.unauthorized)
        }

        return member
    }
}
