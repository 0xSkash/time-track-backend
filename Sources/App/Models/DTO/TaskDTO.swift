import Vapor

struct CreateTaskInput: Content, Validatable {
    let startedAt: Date
    let endedAt: Date
    let duration: Int
    let project: Project.IDValue
    let description: String

    static func validations(_ validations: inout Validations) {
        validations.add("startedAt", as: Date.self)
        validations.add("endedAt", as: Date.self)
        validations.add("duration", as: Int.self)
        validations.add("project", as: UUID.self)
        validations.add("description", as: String.self, is: !.empty)
    }

    func toTask(memberId: Member.IDValue) -> Task {
        return Task(
            memberId: memberId,
            projectId: project,
            duration: duration,
            description: description,
            startedAt: startedAt,
            endedAt: endedAt
        )
    }
}

struct UpdateTaskInput: Content {}

struct TaskResponse: Content {
    let id: UUID?
    let startedAt: Date
    let endedAt: Date
    let duration: Int
    let project: ProjectResponse
    let description: String

    init(task: Task, project: Project, client: Client) {
        id = task.id
        startedAt = task.startedAt
        endedAt = task.endedAt
        duration = task.duration
        self.project = ProjectResponse(project: project, client: client)
        description = task.description
    }
}
