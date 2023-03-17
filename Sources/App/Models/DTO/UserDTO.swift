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
            firstName: self.firstName, 
            lastName: self.lastName, 
            email: self.email, 
            passwordHash: try Bcrypt.hash(self.password)
        )
    }
}

struct UserResponse: Content {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String

    init(user: User) throws {
        self.id = try user.requireID()
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.email = user.email
    }
}