import Vapor

struct CreateProjectInput: Content, Validatable {
    let title: String
    let color: String
    let clientId: UUID

    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("color", as: String.self, is: !.empty)
        validations.add("clientId", as: UUID.self)
    }

    func toProject(
        workspaceId: Workspace.IDValue,
        creator: Member.IDValue
    ) -> Project {
        return Project(title: title, color: color, workspaceId: workspaceId, clientId: clientId, creatorId: creator)
    }
}

struct UpdateProjectInput: Content {
    let title: String?
    let color: String?
}

struct ProjectResponse: Content {
    let id: UUID?
    let title: String
    let color: String
    let client: ClientResponse

    init(
        project: Project,
        client: Client
    ) {
        id = project.id
        title = project.title
        color = project.color
        self.client = ClientResponse(client: client)
    }
}
