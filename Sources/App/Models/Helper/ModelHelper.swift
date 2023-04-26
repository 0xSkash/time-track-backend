import FluentKit
import Swiftgger
import Vapor

protocol PathParameter {
    associatedtype ModelType: Model & PathParameter where ModelType.IDValue: LosslessStringConvertible

    static func parameterName() -> String
}

extension PathParameter {
    static func parameterDefinition() -> PathComponent {
        return ":\(parameterName())"
    }

    static func find(req: Request, abort: Abort = Abort(.notFound)) async throws -> ModelType {
        guard let model = try await ModelType.find(
            req.parameters.get(ModelType.parameterName()),
            on: req.db
        ) else {
            throw abort
        }

        return model
    }

    static func parameterDocs(required: Bool = true) -> APIParameter {
        APIParameter(
            name: ModelType.parameterName(),
            parameterLocation: .path,
            required: required,
            allowEmptyValue: false,
            dataType: .uuid
        )
    }
}
