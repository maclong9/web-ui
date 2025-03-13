import Foundation
import Testing

@testable import WebUI

@Suite("Application Tests") struct ApplicationTests {
  let fileManager = FileManager.default

  @Test("Application Builds Successfully")
  func applicationBuildSuccessfully() async throws {
    let app = Application(routes: [
      Document(path: "home", title: "Home Page", description: "Some generic description") {
        Heading(level: .level1) { "Home Page!" }
          .font(size: .extraLarge3, color: .amber(._500))
      },
      Document(path: "about", title: "About Page", description: "Some generic description") {
        Heading(level: .level1) { "About Page!" }
          .script(style: .color, add: true, value: "green", on: .click)
      },
    ])
    try app.build()
    #expect(fileManager.fileExists(atPath: ".build"))
    #expect(fileManager.fileExists(atPath: "./.build/home.html"))
    #expect(
      try! String(contentsOfFile: "./.build/home.html", encoding: .utf8).contains(
        "<h1 class=\"text-3xl text-amber-500\">Home Page!</h1>"))
    #expect(fileManager.fileExists(atPath: "./.build/about.html"))
    #expect(try! String(contentsOfFile: "./.build/about.html", encoding: .utf8).contains("<h1 id=\"gen"))
    print(
      "AboutHTML:", try! String(contentsOfFile: "./.build/about.html", encoding: .utf8)
    )
    #expect(
      try! String(contentsOfFile: "./.build/about.html", encoding: .utf8).contains(
        "el.addEventListener('click', () => {"))
  }
}
