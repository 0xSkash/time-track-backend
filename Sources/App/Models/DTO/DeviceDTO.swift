
import Vapor

struct CreateDeviceInput: Content, Validatable {
    let manufacturer: String
    let model: String
    let osVersion: String
    let pushToken: String

    static func validations(_ validations: inout Validations) {
        validations.add("manufacturer", as: String.self, is: !.empty)
        validations.add("model", as: String.self, is: !.empty)
        validations.add("osVersion", as: String.self, is: !.empty)
        validations.add("pushToken", as: String.self, is: !.empty)
    }

    func toDevice(userId: User.IDValue) -> Device {
        return Device(
            manufacturer: manufacturer,
            model: model,
            osVersion: osVersion,
            pushToken: pushToken,
            userId: userId
        )
    }
}
