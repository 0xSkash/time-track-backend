import Fluent
import Vapor

final class Device: Model {
    static let schema = "devices"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "last_seen", on: .none)
    var lastSeen: Date?

    @Field(key: "manufacturer")
    var manufacturer: String

    @Field(key: "model")
    var model: String

    @Field(key: "os_version")
    var osVersion: String

    @Field(key: "push_token")
    var pushToken: String

    @Parent(key: "user_id")
    var user: User

    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        lastSeen: Date? = nil,
        manufacturer: String,
        model: String,
        osVersion: String,
        pushToken: String,
        userId: User.IDValue
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSeen = lastSeen
        self.manufacturer = manufacturer
        self.model = model
        self.osVersion = osVersion
        self.pushToken = pushToken
        $user.id = userId
    }

    init() {}

    func createOrUpdate(req: Request) async throws {
        guard let existingDevice = try await Device.query(on: req.db)
            .filter(\.$pushToken == pushToken)
            .first()
        else {
            lastSeen = Date()
            return try await save(on: req.db)
        }

        existingDevice.lastSeen = Date()
        existingDevice.model = model
        existingDevice.osVersion = osVersion
        existingDevice.manufacturer = manufacturer
        try await existingDevice.save(on: req.db)
    }
}
