import Vapor

struct CreateUserInput: Content, Validatable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String

    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }

    func toUser() throws -> User {
        return User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            passwordHash: try Bcrypt.hash(password)
        )
    }
}

struct UserResponse: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let twoFactorEnabled: Bool

    init(user: User) {
        id = user.id
        firstName = user.firstName
        lastName = user.lastName
        email = user.email
        twoFactorEnabled = user.twoFactorEnabled
    }
}
