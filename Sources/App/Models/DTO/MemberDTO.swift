import Vapor

struct CreateMemberInput: Content, Validatable {
    let userId: UUID
    let role: Role
    let isBillable: Bool

    static func validations(_ validations: inout Validations) {
        validations.add("isBillable", as: Bool.self)
        validations.add("userId", as: UUID.self)
    }

    func toMember(workspaceId: Workspace.IDValue, owner: User) -> Member {
        return Member(workspaceId: workspaceId, userId: userId, role: role, isBillable: isBillable)
    }
}

struct MemberUpdateInput: Content {
    let role: Role?
    let isBillable: Bool?
}

struct MemberResponse: Content {
    let id: UUID
    let role: Role
    let isBillable: Bool
    let user: UserResponse?

    init(member: Member, user: User? = nil) throws {
        id = try member.requireID()
        role = member.role
        isBillable = member.isBillable
        if let user {
            self.user = UserResponse(user: user, workspace: nil)
        } else {
            self.user = nil
        }
    }
}

struct MemberListResponse: Content {
    let id: UUID
    let role: Role

    init(member: Member) throws {
        id = try member.requireID()
        role = member.role
    }
}
