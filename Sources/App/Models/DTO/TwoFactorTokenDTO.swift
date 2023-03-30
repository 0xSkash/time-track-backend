import Vapor

struct TwoFactorTokenResponse: Content {
    let backupCodes: [String]
    let key: String
    let label: String
    let issuer: String
    let url: String

    init(
        backupCodes: [String],
        key: String,
        label: String,
        issuer: String,
        url: String
    ) {
        self.backupCodes = backupCodes
        self.key = key
        self.label = label
        self.issuer = issuer
        self.url = url
    }

    init(twoFactorCode: TwoFactorToken) {
        let issuer = "DiningIn"
        self.init(
            backupCodes: twoFactorCode.backupTokens,
            key: twoFactorCode.key,
            label: twoFactorCode.user.email,
            issuer: issuer,
            url: "otpauth://totp/\(twoFactorCode.user.email)?secret=\(twoFactorCode.key)&issuer=\(issuer)"
        )
    }
}
