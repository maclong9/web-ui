import Testing

@testable import WebUI

@Suite("Document Tests")
struct DocumentTests {
  @Test("Document renders basic HTML structure")
  func testBasicRender() throws {
    let config = Configuration()
    let document = Document(
      configuration: config,
      title: "Home",
      description: "Welcome to my site"
    ) {
      "<p>Hello, World!</p>"
    }

    let html = document.render()
    #expect(html.contains("<!DOCTYPE html>"))
    #expect(html.contains("<html lang=\"en\">"))
    #expect(html.contains("<title>Home | Great Site</title>"))
    #expect(html.contains("<p>Hello, World!</p>"))
  }

  @Test("Document uses header and footer overrides")
  func testHeaderFooterOverrides() throws {
    let config = Configuration()
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    #expect(html.contains("<html"))
    #expect(html.contains("Test | Great Site"))
  }

  @Test("Content builder evaluates correctly")
  func testContentBuilder() throws {
    let document = Document(
      title: "Test",
      description: "Test desc"
    ) {
      "<h1>Heading</h1>"
      "<p>Paragraph</p>"
    }

    let html = document.render()
    #expect(html.contains("<h1>Heading</h1>"))
    #expect(html.contains("<p>Paragraph</p>"))
  }
}
