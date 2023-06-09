import FluentKit
import Vapor

struct CreateWorkspaceInput: Content, Validatable {
    let title: String
    let isBillable: Bool

    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("isBillable", as: Bool.self)
    }

    func toWorkspace(organization: Organization, creator: User) throws -> Workspace {
        return Workspace(
            title: title,
            organizationId: try organization.requireID(),
            creatorId: try creator.requireID(),
            isBillable: isBillable
        )
    }
}

struct WorkspaceResponse: Content {
    let id: UUID?
    let title: String
    let isBillable: Bool
    let organiztionId: UUID

    init(workspace: Workspace) {
        id = try workspace.id
        title = workspace.title
        isBillable = workspace.isBillable
        organiztionId = workspace.$organization.id
    }
}
