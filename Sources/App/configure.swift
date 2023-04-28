import FCM
import Fluent
import FluentPostgresDriver
import JWT
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.jwt.signers.use(.hs256(key: "secret"))

    app.routes.defaultMaxBodySize = "10mb"
    

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateTwoFactorToken())
    app.migrations.add(CreateOrganization())
    app.migrations.add(CreateWorkspace())
    app.migrations.add(CreateClient())
    app.migrations.add(CreateMember())
    app.migrations.add(CreateProject())
    app.migrations.add(CreateWorktime())
    app.migrations.add(CreateTask())
    app.migrations.add(CreateOrganizationUser())
    app.migrations.add(CreateDevice())
    app.migrations.add(AddAvatarToUser())
    app.migrations.add(AddSelectedWorkspaceToUser())

    app.commands.use(OpenAPIGenerator(), as: "api-gen")

    app.http.server.configuration.address = BindAddress.hostname("0.0.0.0", port: 8080)

    // FCM
    app.fcm.configuration = .envServiceAccountKey

    // register routes
    try routes(app)
}
