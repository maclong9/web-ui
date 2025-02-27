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
      description: "Test page",
      headerOverride: .logoCentered,
      footerOverride: .minimal
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

  @Test("Document includes Twitter handle from socials with twitter.com URL")
  func testTwitterHandleFromTwitterURL() throws {
    let config = Configuration(
      socials: [
        Social(label: "Twitter", url: "https://twitter.com/testuser"),
        Social(label: "Other", url: "https://example.com"),
      ]
    )
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    #expect(
      html.contains("<meta name=\"twitter:site\" content=\"@testuser\">")
        || html.contains("<meta name=\"twitter:creator\" content=\"@testuser\">"))
  }

  @Test("Document includes Twitter handle from x.com URL")
  func testTwitterHandleFromXURL() throws {
    let config = Configuration(
      socials: [
        Social(label: "X", url: "https://x.com/xuser"),
        Social(label: "Other", url: "https://example.com"),
      ]
    )
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    #expect(
      html.contains("<meta name=\"twitter:site\" content=\"@xuser\">")
        || html.contains("<meta name=\"twitter:creator\" content=\"@xuser\">"))
  }

  @Test("Document picks first matching Twitter social when multiple exist")
  func testMultipleTwitterSocials() throws {
    let config = Configuration(
      socials: [
        Social(label: "Twitter", url: "https://twitter.com/firstuser"),
        Social(label: "X", url: "https://x.com/seconduser"),
      ]
    )
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    #expect(
      html.contains("<meta name=\"twitter:site\" content=\"@firstuser\">")
        || html.contains("<meta name=\"twitter:creator\" content=\"@firstuser\">"))
    #expect(!html.contains("@seconduser"))
  }

  @Test("Document handles missing socials gracefully")
  func testNoTwitterSocial() throws {
    let config = Configuration(
      socials: nil  // No socials provided
    )
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    // Assuming metadata.render() handles empty Twitter gracefully, no crash or invalid content
    #expect(!html.contains("<meta name=\"twitter:site\" content=\"@\">"))
    #expect(!html.contains("<meta name=\"twitter:creator\" content=\"@\">"))
  }

  @Test("Document uses Twitter label even if URL doesn’t match domain")
  func testTwitterLabelOverride() throws {
    let config = Configuration(
      socials: [
        Social(label: "Twitter Profile", url: "https://customsite.com/twitter/testuser"),
        Social(label: "Other", url: "https://example.com"),
      ]
    )
    let document = Document(
      configuration: config,
      title: "Test",
      description: "Test page"
    ) {
      "<div>Content</div>"
    }

    let html = document.render()
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@testuser\">"))
  }
}
