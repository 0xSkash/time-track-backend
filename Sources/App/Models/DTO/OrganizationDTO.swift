import Vapor

struct CreateOrganizationInput: Content, Validatable {
    let name: String

    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
    }

    func toOrganization(owner: User) throws -> Organization {
        return Organization(name: name, ownerId: try owner.requireID())
    }
}

struct OrganizationResponse: Content {
    let id: UUID?
    let name: String

    init(organization: Organization) {
        id = organization.id
        name = organization.name
    }
}
