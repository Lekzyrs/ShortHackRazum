

import Fluent
import Vapor

final class User: Model, Content {
  static let schema = "users"
  
  @ID
  var id: UUID?
  
  @Field(key: "name")
  var name: String
  
  @Field(key: "username")
  var username: String
    
  @Field(key: "password")
  var password: String

  @OptionalField(key: "profilePicture")
  var profilePicture: String?
  
  @Children(for: \.$user)
  var acronyms: [Acronym]
  
  init() {}
  
  init(id: UUID? = nil, name: String, username: String, password: String, profilePicture: String? = nil) {
    self.name = name
    self.username = username
    self.password = password
    self.profilePicture = profilePicture
  }
    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String
    init(id: UUID?, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
        }
    }
}
extension User {
  // 1
  func convertToPublic() -> User.Public {
    // 2
    return User.Public(id: id, name: name, username: username)
  }
}
// 1
extension EventLoopFuture where Value: User {
  // 2
  func convertToPublic() -> EventLoopFuture<User.Public> {
    // 3
    return self.map { user in
      // 4
      return user.convertToPublic()
    }
} }
// 5
extension Collection where Element: User {
  // 6
  func convertToPublic() -> [User.Public] {
    // 7
    return self.map { $0.convertToPublic() }
  }
}
// 8
extension EventLoopFuture where Value == Array<User> {
  // 9
  func convertToPublic() -> EventLoopFuture<[User.Public]> {
    // 10
    return self.map { $0.convertToPublic() }
  }
}
// 1
extension User: ModelAuthenticatable {
  // 2
  static let usernameKey = \User.$username
  // 3
  static let passwordHashKey = \User.$password
// 4
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}
// 1
extension User: ModelSessionAuthenticatable {}
// 2
extension User: ModelCredentialsAuthenticatable {}
