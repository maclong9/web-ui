import Foundation
import Testing

@testable import WebUI

@Suite("Document Tests") struct DocumentTests {
  @Test("Document renders basic metadata correctly")
  func testBasicDocumentRendering() throws {
    let rendered = Document(
      path: "index",
      metadata: Metadata(
        site: "Test Site",
        title: "Hello World",
        description: "A test description"
      )
    ) {
      "Hello, world!"
    }.render()

    #expect(
      rendered.contains("<title>Hello World | Test Site</title>"),
      "Title not set correctly")
    #expect(
      rendered.contains("<meta property=\"og:title\" content=\"Hello World | Test Site\">"),
      "OG title not set correctly")
    #expect(
      rendered.contains("<meta name=\"description\" content=\"A test description\">"),
      "Meta description not set correctly")
    #expect(
      rendered.contains("<meta property=\"og:description\" content=\"A test description\">"),
      "OG description not set correctly")
    #expect(rendered.contains("Hello, world!"), "Content not rendered correctly")
    #expect(rendered.contains("<html lang=\"en\">"), "Default locale not set correctly")
  }

  /// Tests that a document renders all optional metadata correctly.
  @Test func testFullMetadataRendering() throws {
    let rendered = Document(
      path: "full-test",
      metadata: Metadata(
        site: "Test Site",
        title: "Full Test",
        titleSeperator: "-",
        description: "A complete metadata test",
        date: Date(),
        image: "https://example.com/image.png",
        author: "Test Author",
        keywords: ["test", "swift", "html"],
        twitter: "testhandle",
        locale: .ru,
        type: .article,
        themeColor: .init(light: "#0099ff", dark: "#1c1c1c"),
      )
    ) {
      "Content"
    }.render()

    #expect(rendered.contains("<title>Full Test - Test Site</title>"))
    #expect(
      rendered.contains("<meta property=\"og:image\" content=\"https://example.com/image.png\">"))
    #expect(rendered.contains("<meta name=\"author\" content=\"Test Author\">"))
    #expect(rendered.contains("<meta property=\"og:type\" content=\"article\">"))
    #expect(rendered.contains("<meta name=\"twitter:creator\" content=\"@testhandle\">"))
    #expect(rendered.contains("<meta name=\"keywords\" content=\"test, swift, html\">"))
    #expect(
      rendered.contains(
        "<meta name=\"theme-color\" content=\"#0099ff\" media=\"(prefers-color-scheme: light)\">"))
    #expect(rendered.contains("<html lang=\"ru\">"))
  }

  /// Tests that custom scripts are correctly added to the document head.
  @Test func testCustomScripts() throws {
    let rendered = Document(
      path: "scripts",
      metadata: Metadata(
        title: "Script Test",
        description: "Testing script inclusion"
      ),
      scripts: [
        "https://cdn.example.com/script1.js",
        "/public/script2.js",
      ]
    ) {
      "Script Test"
    }.render()

    #expect(
      rendered.contains(
        "<script src=\"https://cdn.example.com/script1.js\"></script>"))
    #expect(rendered.contains("<script src=\"/public/script2.js\"></script>"))
  }

  /// Tests that custom stylesheets are correctly added to the document head.
  @Test func testCustomStylesheets() throws {
    let rendered = Document(
      path: "styles",
      metadata: Metadata(
        title: "Stylesheet Test",
        description: "Testing stylesheet inclusion"
      ),
      stylesheets: [
        "https://cdn.example.com/style1.css",
        "/public/style2.css",
      ]
    ) {
      "Stylesheet Test"
    }.render()

    #expect(
      rendered.contains("<link rel=\"stylesheet\" href=\"https://cdn.example.com/style1.css\">"))
    #expect(rendered.contains("<link rel=\"stylesheet\" href=\"/public/style2.css\">"))
  }

  /// Tests that raw HTML can be added to the document head.
  @Test func testCustomHeadHTML() throws {
    let document = Document(
      path: "custom-head",
      metadata: Metadata(
        title: "Custom Head",
        description: "Testing custom head HTML"
      ),
      head: """
        <script>
          console.log('Custom head script');
        </script>
        <style>
          body { color: red; }
        </style>
        """
    ) {
      "Custom Head Test"
    }

    let rendered = document.render()

    #expect(rendered.contains(document.head ?? ""))
  }

  /// Helper class to create HTML from strings for testing
  struct StringHTML: HTML {
    let content: String

    init(_ content: String) {
      self.content = content
    }

    func render() -> String {
      content
    }
  }
}
