import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.jwt.signers.use(.hs256(key: "secret"))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateOrganization())
    app.migrations.add(CreateRole())
    app.migrations.add(CreateWorkspace())
    app.migrations.add(CreateClient())
    app.migrations.add(CreateMember())
    app.migrations.add(CreateProject())
    app.migrations.add(CreateWorktime())
    app.migrations.add(CreateTask())
    
    // register routes
    try routes(app)
}
