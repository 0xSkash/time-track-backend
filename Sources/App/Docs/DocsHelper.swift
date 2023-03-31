import Swiftgger

extension APIParameter {
    static func bearerHeader() -> APIParameter {
        return APIParameter(
            name: "Authorization",
            parameterLocation: .header,
            description: "Bearer Token used to authenticate user",
            required: true,
            allowEmptyValue: false,
            dataType: .string
        )
    }

    static func twoFactorHeader() -> APIParameter {
        return APIParameter(
            name: "X-Auth-2FA",
            parameterLocation: .header,
            description: "6 digit 2FA Code",
            required: true,
            allowEmptyValue: false,
            dataType: .int32
        )
    }

    static func organizationId() -> APIParameter {
        APIParameter(
            name: "organizationId",
            parameterLocation: .path,
            required: true,
            allowEmptyValue: false,
            dataType: .uuid
        )
    }
    
    static func workspaceId() -> APIParameter {
        APIParameter(
            name: "workspaceId",
            parameterLocation: .path,
            required: true,
            allowEmptyValue: false,
            dataType: .uuid
        )
    }
}

extension APIResponse {
    static func unauthorized() -> APIResponse {
        return APIResponse(code: "401", description: "Unauthorized")
    }
}
