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
        titleSeperator: " | ",
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
        titleSeperator: " - ",
        description: "A complete metadata test",
        date: Date(),
        image: "https://example.com/image.png",
        author: "Test Author",
        keywords: ["test", "swift", "html"],
        twitter: "testhandle",
        locale: .ru,
        type: .article,
        themeColor: .init("#0099ff", dark: "#1c1c1c"),
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

  /// Tests that favicons are correctly added to the document head.
  @Test func testFaviconRendering() throws {
    let rendered = Document(
      path: "favicons",
      metadata: Metadata(
        title: "Favicon Test",
        description: "Testing favicon rendering",
        favicons: [
          Favicon("/favicon.png", size: "32x32"),
          Favicon("/favicon-light.ico", dark: "/favicon-dark.ico", type: "image/x-icon"),
        ]
      )
    ) {
      "Favicon Test"
    }.render()

    // Check standard favicon rendering
    #expect(
      rendered.contains("<link rel=\"icon\" type=\"image/png\" href=\"/favicon.png\" sizes=\"32x32\">"))

    // Check Apple touch icon for PNG favicons
    #expect(
      rendered.contains("<link rel=\"apple-touch-icon\" sizes=\"32x32\" href=\"/favicon.png\">"))

    // Check dark mode favicon rendering
    #expect(
      rendered.contains("<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon-light.ico\" media=\"(prefers-color-scheme: light)\">"))
    #expect(
      rendered.contains("<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon-dark.ico\" media=\"(prefers-color-scheme: dark)\">"))
  }

  /// Tests that structured data is correctly added to the document head.
  @Test func testStructuredDataRendering() throws {
    let rendered = Document(
      path: "structured-data",
      metadata: Metadata(
        title: "Structured Data Test",
        description: "Testing structured data rendering",
        structuredData: StructuredData.article(
          headline: "Test Article",
          image: "https://example.com/image.jpg",
          author: "Test Author",
          publisher: "Test Publisher",
          datePublished: Date(),
          description: "A test article"
        )
      )
    ) {
      "Structured Data Test"
    }.render()

    // Check for JSON-LD script tag
    #expect(rendered.contains("<script type=\"application/ld+json\">"))
    #expect(rendered.contains("\"@context\" : \"https://schema.org\""))
    #expect(rendered.contains("\"@type\" : \"Article\""))
    #expect(rendered.contains("\"headline\" : \"Test Article\""))
    #expect(rendered.contains("\"image\" : \"https://example.com/image.jpg\""))
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
        "https://cdn.example.com/script1.js": .async,
        "/public/script2.js": .defer,
      ]
    ) {
      "Script Test"
    }.render()

    #expect(
      rendered.contains(
        "<script async src=\"https://cdn.example.com/script1.js\"></script>"))
    #expect(rendered.contains("<script defer src=\"/public/script2.js\"></script>"))
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
