import Vapor

struct CreateClientInput: Content, Validatable {
    let title: String
    let isBillable: Bool
    
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("isBillable", as: Bool.self)
    }

    func toClient(workspaceId: Workspace.IDValue) -> Client {
        return Client(title: title, workspaceId: workspaceId, isBillable: isBillable)
    }
}

struct UpdateClientInput: Content {
    let title: String?
    let isBillable: Bool?
}

struct ClientResponse: Content {
    let id: UUID?
    let title: String
    let isBillable: Bool

    init(client: Client) {
        id = client.id
        title = client.title
        isBillable = client.isBillable
    }
}
