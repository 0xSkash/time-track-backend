import Fluent
import Vapor

final class Role: Model {
    static let schema = "roles"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "slug")
    var slug: Role.RoleIdentifier

    init(
        id: UUID? = nil,
        slug: RoleIdentifier
    ) {
        self.id = id
        self.slug = slug
    }

    init() {}
}

extension Role {
    enum RoleIdentifier: String, Codable {
        case admin
        case member
    }
}
