import Vapor

extension Request {
    func validateAndDecode<T: Decodable>(_ content: T.Type) throws -> T where T: Validatable {
        try T.validate(content: self)
        return try self.content.decode(T.self)
    }
}
