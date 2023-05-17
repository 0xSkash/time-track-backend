import Fluent
import Vapor

final class OrganizationUser: Model {
    static let schema = "organization+user"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: Columns.organization.key)
    var organization: Organization

    @Parent(key: Columns.user.key)
    var user: User

    init(
        id: UUID? = nil,
        organization: Organization,
        user: User
    ) throws {
        self.id = id
        self.$organization.id = try organization.requireID()
        self.$user.id = try user.requireID()
    }

    init() {}
}

extension OrganizationUser {
    enum Columns: FieldKey {
        case organization = "organization_id"
        case user = "user_id"

        var key: FieldKey {
            rawValue
        }
    }
}
