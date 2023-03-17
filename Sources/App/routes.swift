import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.group("api") { app in

        try app.group("auth") { auth in
            try auth.register(collection: UserAuth())
        }

        try app.group("users") {users in 
            try users.register(collection: UserController())
        }
    }
}
