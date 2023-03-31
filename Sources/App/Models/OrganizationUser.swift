import Fluent
import Vapor

final class OrganizationUser: Model {
    static let schema = "organization+user"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "organization_id")
    var organization: Organization

    @Parent(key: "user_id")
    var user: User

    init(
        id: UUID? = nil, organization: Organization, user: User
    ) throws {
        self.id = id
        self.$organization.id = try organization.requireID()
        self.$user.id = try user.requireID()
    }

    init() {}
}
