import Vapor

struct CreateWorktimeInput: Content, Validatable {
    let startedAt: Date
    let endedAt: Date
    let duration: Int

    static func validations(_ validations: inout Validations) {
        validations.add("startedAt", as: Date.self)
        validations.add("endedAt", as: Date.self)
        validations.add("duration", as: Int.self)
    }

    func toWorktime(userId: User.IDValue) -> Worktime {
        return Worktime(
            userId: userId,
            duration: duration,
            startedAt: startedAt,
            endedAt: endedAt
        )
    }
}

struct UpdateWorktimeInput: Content {}

struct WorktimeResponse: Content {
    let id: UUID?
    let startedAt: Date
    let endedAt: Date
    let duration: Int

    init(worktime: Worktime) {
        id = worktime.id
        startedAt = worktime.startedAt
        endedAt = worktime.endedAt
        duration = worktime.duration
    }
}
