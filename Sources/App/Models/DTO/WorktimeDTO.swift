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

    func toWorktime(memberId: Member.IDValue) -> Worktime {
        return Worktime(
            memberId: memberId,
            duration: duration,
            startedAt: startedAt,
            endedAt: endedAt
        )
    }
}

struct UpdateWorktimeInput: Content {}

struct WorktimeResponse: Content {
    let startedAt: Date
    let endedAt: Date
    let duration: Int

    init(worktime: Worktime) {
        self.startedAt = worktime.startedAt
        self.endedAt = worktime.endedAt
        self.duration = worktime.duration
    }
}
