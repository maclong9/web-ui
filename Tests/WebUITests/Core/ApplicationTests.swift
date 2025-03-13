import Foundation
import Testing

@testable import WebUI

@Suite("Application Tests") struct ApplicationTests {
  @Test("Application Builds Successfully")
  func applicationBuildSuccessfully() async throws {
    let app = Application(routes: [
      Document(path: "home", title: "Home Page", description: "Some generic description") {
        Heading(level: .level1) { "Home Page!" }
      },
      Document(path: "about", title: "About Page", description: "Some generic description") {
        Heading(level: .level1) { "About Page!" }
      },
    ])
    try app.build()
    let fileManager = FileManager.default
    #expect(fileManager.fileExists(atPath: ".build"))
    #expect(fileManager.fileExists(atPath: "./.build/home.html"))
    #expect(try! String(contentsOfFile: "./.build/home.html", encoding: .utf8).contains("<h1>Home Page!</h1>"))
    #expect(fileManager.fileExists(atPath: "./.build/about.html"))
    #expect(try! String(contentsOfFile: "./.build/about.html", encoding: .utf8).contains("<h1>About Page!</h1>"))
  }
}
