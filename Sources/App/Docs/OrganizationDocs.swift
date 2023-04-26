import Foundation
import Swiftgger

extension OpenAPIBuilder {
    func appendOrganizationDocs() -> OpenAPIBuilder {
        return add([
            OrganizationResponse.modelDocs()
        ])
    }
}

private extension OrganizationResponse {
    static func modelDocs() -> APIObject<OrganizationResponse> {
        let model = OrganizationResponse(organization: Organization(
            id: UUID.generateRandom(),
            name: "Google",
            ownerId: UUID.generateRandom()
        ))

        return APIObject(object: model, customName: "OrganizationResponse")
    }
}
