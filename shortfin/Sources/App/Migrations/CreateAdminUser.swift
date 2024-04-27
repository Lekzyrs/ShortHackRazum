import Fluent
import Vapor
// 1
struct CreateAdminUser: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    let passwordHash: String
    do {
      passwordHash = try Bcrypt.hash("password")
    } catch {
      return database.eventLoop.future(error: error)
    }
// 4
    let user = User(
      name: "Admin",
      username: "admin",
      password: passwordHash)
// 5
    return user.save(on: database)
  }
// 6
  func revert(on database: Database) -> EventLoopFuture<Void> {
    // 7
    User.query(on: database)
      .filter(\.$username == "admin")
      .delete()
} }
