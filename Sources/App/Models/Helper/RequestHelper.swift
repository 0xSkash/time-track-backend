import Vapor

extension Request {
    func validateAndDecode<T: Decodable & Validatable>(_ content: T.Type) throws -> T {
        try T.validate(content: self)
        return try self.content.decode(T.self)
    }
}

