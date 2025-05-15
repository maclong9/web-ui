import Foundation
import Logging
import Testing

@testable import WebUI

@Suite("Application Tests") struct ApplicationTests {
  @Test("Creates the build directory and populates correctly")
  func createsAndPopulatesBuildDirectory() throws {
    // Set log level to critical to silence build output
    LoggingSystem.bootstrap { label in
      var handler = StreamLogHandler.standardOutput(label: label)
      handler.logLevel = .critical
      return handler
    }

    let app = Website(
      routes: [
        Document(
          path: "index",
          metadata: .init(title: "Hello", description: "Some cool description")
        ) {
          Header {
            Text { "Logo" }
            Navigation {
              Link(to: "home") { "Home" }
              Link(to: "about") { "About" }
              Link(to: "https://example.com", newTab: true) { "Other" }
            }
          }
          Main {
            Stack {
              Heading(.largeTitle) { "Tagline" }
              Text { "Lorem ipsum dolor sit amet." }
            }
          }
          Footer {
            Text { "Logo" }
          }
        },
        Document(
          path: "about",
          metadata: .init(title: "About", description: "Learn more here")
        ) {
          Article {
            Heading(.title) { "Article Heading" }
            Text { "Lorem ipsum dolor sit amet." }
          }
        },
      ]
    )

    try app.build(to: URL(fileURLWithPath: ".build"))
    #expect(FileManager.default.fileExists(atPath: ".build/index.html"))
    #expect(FileManager.default.fileExists(atPath: ".build/about.html"))
    #expect(
      try String(
        contentsOfFile: ".build/index.html",
        encoding: .utf8
      ).contains(
        """
        <header><span>Logo</span><nav><a href="home">Home</a><a href="about">About</a><a href="https://example.com" target="_blank" rel="noreferrer">Other</a></nav></header><main><div><h1>Tagline</h1><span>Lorem ipsum dolor sit amet.</span></div></main><footer><span>Logo</span></footer>
        """)
    )
    #expect(
      try String(
        contentsOfFile: ".build/about.html", encoding: .utf8
      ).contains(
        "<article><h2>Article Heading</h2><span>Lorem ipsum dolor sit amet.</span></article>"
      ))
  }
}
