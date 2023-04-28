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
            passwordHash: try Bcrypt.hash(password),
            selectedWorkspaceId: nil,
            avatar: nil
        )
    }
}

struct AvatarInput: Content {
    let file: File
}

struct SelectedWorkspaceInput: Content {
    let workspaceId: UUID
}

struct AvatarResponse: Content {
    let avatarName: String
}

struct UserResponse: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let selectedWorkspace: WorkspaceResponse?
    let avatarPath: String?
    let twoFactorEnabled: Bool

    init(user: User, workspace: Workspace?) {
        id = user.id
        firstName = user.firstName
        lastName = user.lastName
        email = user.email
        if let workspace {
            selectedWorkspace = WorkspaceResponse(workspace: workspace)
        } else {
            selectedWorkspace = nil
        }
        twoFactorEnabled = user.twoFactorEnabled
        avatarPath = user.avatar
    }
}
