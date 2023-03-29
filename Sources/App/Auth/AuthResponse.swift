import Foundation
import Vapor

struct ClientTokenResponse: Content {
    var token: String
}

extension ClientTokenResponse: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "Bearer " + token)
        headers.add(name: .accessControlExpose, value: "authorization")
        headers.add(name: .contentType, value: "text/plain")
        return .init(status: .ok, headers: headers, body: .init(string: token))
    }
}
