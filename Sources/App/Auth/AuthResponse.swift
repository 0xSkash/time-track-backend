import Foundation
import Vapor

struct ClientTokenResponse: Content {
    var token: String
    var userId: UUID
    
    init(token: String, userId: UUID) {
        self.token = token
        self.userId = userId
    }
}
