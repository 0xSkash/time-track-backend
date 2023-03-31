import FluentKit
import Vapor

protocol UsableParameter {
    associatedtype ModelType: Model & UsableParameter where ModelType.IDValue: LosslessStringConvertible

    static func parameterName() -> String
}

extension UsableParameter {
    static func parameterDefinition() -> PathComponent {
        return ":\(parameterName())"
    }

    static func find(req: Request, abort: Abort = Abort(.badRequest)) async throws -> ModelType {
        guard let model = try await ModelType.find(
            req.parameters.get(ModelType.parameterName()),
            on: req.db
        ) else {
            throw abort
        }

        return model
    }
}
