import Fluent
import Vapor

final class Device: Model {
    static let schema = "devices"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: Columns.createdAt.key, on: .create)
    var createdAt: Date?

    @Timestamp(key: Columns.updatedAt.key, on: .update)
    var updatedAt: Date?

    @Timestamp(key: Columns.lastSeen.key, on: .none)
    var lastSeen: Date?

    @Field(key: Columns.manufacturer.key)
    var manufacturer: String

    @Field(key: Columns.model.key)
    var model: String

    @Field(key: Columns.osVersion.key)
    var osVersion: String

    @Field(key: Columns.pushToken.key)
    var pushToken: String

    @Parent(key: Columns.userId.key)
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

extension Device {
    enum Columns: FieldKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastSeen = "last_seen"
        case manufacturer = "manufacturer"
        case model = "model"
        case osVersion = "os_version"
        case pushToken = "pushToken"
        case userId = "user_id"

        var key: FieldKey {
            rawValue
        }
    }
}
