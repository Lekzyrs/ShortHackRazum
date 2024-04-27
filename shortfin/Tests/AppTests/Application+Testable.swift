

@testable import App
@testable import XCTVapor

extension Application {
  static func testable() throws -> Application {
    let app = Application(.testing)
    try configure(app)
    
    try app.autoRevert().wait()
    try app.autoMigrate().wait()
    
    return app
  }
}
// 1
extension XCTApplicationTester {
  // 2
  public func login(
    user: User
  ) throws -> Token {
    // 3
    var request = XCTHTTPRequest(
      method: .POST,
      url: .init(path: "/api/users/login"),
      headers: [:],
      body: ByteBufferAllocator().buffer(capacity: 0)
)
// 4
    request.headers.basicAuthorization =
      .init(username: user.username, password: "password")
// 5
    let response = try performTest(request: request)
    // 6
    return try response.content.decode(Token.self)
}
    @discardableResult
    public func test(
      _ method: HTTPMethod,
      _ path: String,
      headers: HTTPHeaders = [:],
      body: ByteBuffer? = nil,
      loggedInRequest: Bool = false,
      loggedInUser: User? = nil,
      file: StaticString = #file,
      line: UInt = #line,
      beforeRequest: (inout XCTHTTPRequest) throws -> () = { _ in },
      afterResponse: (XCTHTTPResponse) throws -> () = { _ in }
    ) throws -> XCTApplicationTester {
      // 2
      var request = XCTHTTPRequest(
        method: method,
        url: .init(path: path),
        headers: headers,
        body: body ?? ByteBufferAllocator().buffer(capacity: 0)
      )
    // 3
      if (loggedInRequest || loggedInUser != nil) {
        let userToLogin: User
        // 4
        if let user = loggedInUser {
          userToLogin = user
        } else {
            userToLogin = User(
                   name: "Admin",
                   username: "admin",
                   password: "password")
           }
           // 5
               let token = try login(user: userToLogin)
               // 6
               request.headers.bearerAuthorization =
                 .init(token: token.value)
             }
           // 7
             try beforeRequest(&request)
           // 8
             do {
               let response = try performTest(request: request)
               try afterResponse(response)
             } catch {
               XCTFail("\(error)", file: (file), line: line)
           throw error }
           return self
           }
        }
