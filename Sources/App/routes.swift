import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.group("api") { app in

        try app.group("auth") { auth in
            try auth.register(collection: UserAuth())
        }

        try app.group("users") { users in
            try users.register(collection: UserController())
        }

        try app.group(TokenAuthenticator()) { protected in
            try protected.group("organizations") { organizations in
                try organizations.register(collection: OrganizationController())

                try organizations.group(":organizationId", "workspaces") { workspace in
                    try workspace.register(collection: WorkspaceController())

                    try workspace.group(MemberMiddleware()) { memberProtected in
                        try memberProtected.group(":workspaceId", "members") { members in
                            try members.register(collection: MemberController())
                        }

                        try memberProtected.group(":workspaceId", "projects") { projects in
                            try projects.register(collection: ProjectController())
                        }
                        
                        try memberProtected.group(":workspaceId", "worktimes") { worktimes in
                            try worktimes.register(collection: WorktimeController())
                        }
                        
                        try memberProtected.group(":workspaceId", "tasks") { tasks in
                            try tasks.register(collection: TaskController())
                        }
                        
                        try memberProtected.group(":workspaceId", "clients") { clients in
                            try clients.register(collection: ClientController())
                        }
                    }
                }

                
            }
        }
    }
}
