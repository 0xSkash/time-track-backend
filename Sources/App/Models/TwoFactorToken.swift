import Fluent
import Vapor

final class TwoFactorToken: Model {
    static let schema = "twofactor_tokens"

    @ID(key: "id")
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "key")
    var key: String

    @Field(key: "backup_tokens")
    var backupTokens: [String]

    init() {}

    init(
        _ userId: User.IDValue,
        _ key: String,
        _ backups: [String]
    ) {
        $user.id = userId
        self.key = key
        backupTokens = backups
    }
}

extension TwoFactorToken {
    var totpToken: TOTP {
        let key = SymmetricKey(data: Data(base32Encoded: self.key)!)
        return TOTP(key: key, digest: .sha1, digits: .six, interval: 30)
    }
    
    static func generate(for user: User) throws -> TwoFactorToken {
        let data = Data([UInt8].random(count: 16)).base32EncodedString()
        let key = SymmetricKey(data: Data(base32Encoded: data)!)
        let hotp = HOTP(key: key, digest: .sha1, digits: .six)
        let codes = (1...10).map { index in
            hotp.generate(counter: index)
        }
        
        return try TwoFactorToken(user.requireID(), data, codes)
    }

    func validate(_ input: String, allowBackupCode: Bool = true) -> Bool {
        totpToken.generate(time: Date(), range: 1).contains(input) ||
            (allowBackupCode && backupTokens.contains(input))
    }
}
