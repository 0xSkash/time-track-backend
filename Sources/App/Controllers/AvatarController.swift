import Vapor

struct AvatarController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(":avatarId", use: show)
    }

    func show(req: Request) async throws -> Response {
        guard let avatarId = req.parameters.get("avatarId") else {
            throw Abort(.badRequest)
        }

        let path = req.application.directory.workingDirectory + Constants.Directory.avatarDirectory + avatarId

        if !FileManager.default.fileExists(atPath: path) {
            throw Abort(.notFound)
        }

        return req.fileio.streamFile(at: path)
    }
}
