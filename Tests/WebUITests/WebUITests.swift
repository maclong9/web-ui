import Testing

@testable import WebUI

// TODO: Implement a test which runs HTML validator

// MARK: - Configuration Tests
@Suite("Configuration Tests")
struct ConfigurationTests {
  @Test("Initialize with default values")
  func testDefaultInitialization() async throws {
    let config = Configuration()
    #expect(config.metadata.locale == "en")
  }

  @Test("Initialize with custom site")
  func testCustomSiteInitialization() async throws {
    let customSite = "Custom Site"
    let config = Configuration(metadata: Metadata(site: customSite))
    #expect(config.metadata.site == customSite)
  }
}

// MARK: - Document Tests
@Suite("Document Tests")
struct DocumentTests {
  @Test("Initialize with basic properties")
  func testBasicInitialization() async throws {
    let config = Configuration()
    let testTitle = "Test Title"
    let testDescription = "Hello, world!"
    let document = Document(title: testTitle, description: testDescription) { "Hello, world!" }

    #expect(document.title == testTitle)
    #expect(document.description == testDescription)

    let html = document.render()
    #expect(html.contains("<title>\(testTitle) | \(config.metadata.site)</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"\(testDescription)\">"))
  }

  @Test("Render with alternate header and footer")
  func testAlternateHeaderFooterRendering() async throws {
    let config = Configuration(layout: Layout(header: .logoCentered, footer: .minimal))
    let documentOne = Document(title: "Test Title", description: "Hello, world!") { "Hello, world!" }
    let documentTwo = Document(configuration: config, title: "Test Title", description: "Hello, world!") {
      "Hello, world!"
    }

    let htmlOne = documentOne.render()
    let htmlTwo = documentTwo.render()

    #expect(htmlOne != htmlTwo)
    #expect(htmlTwo.contains("header-centered"))
    #expect(htmlTwo.contains("footer-minimal"))
  }

  @Test("Render with overridden header and footer")
  func testHeaderFooterOverrideRendering() async throws {
    let config = Configuration(layout: Layout(header: .hidden, footer: .hidden))

    let documentOne = Document(
      configuration: config,
      title: "Test Title",
      description: "Hello, world!"
    ) { "Hello, world!" }

    let documentTwo = Document(
      configuration: config,
      title: "Test Title",
      description: "Hello, world!",
      headerOverride: .normal,
      footerOverride: .normal
    ) { "Hello, world!" }

    let htmlOne = documentOne.render()
    let htmlTwo = documentTwo.render()

    #expect(!htmlOne.contains("header-normal"))
    #expect(!htmlOne.contains("footer-normal"))
    #expect(htmlTwo.contains("header-normal"))
    #expect(htmlTwo.contains("footer-normal"))
  }
}

// MARK: - Full Page Tests
@Suite("Full Page Tests") struct FullPageTests {
  @Test func shouldRenderFullPage() async throws {
    let config = Configuration()
    let html = Document(configuration: config, title: "Hello, world!", description: "An introductory page") {
      Article {
        Section {
          Stack { "Hello, world!" }
          Stack { "Here is a fun description of the website!" }
        }
        Section {
          Stack { "This is another section of the site!" }
          Stack { "And another sentence!" }
        }
      }
    }.render()

    #expect(html.contains("<!DOCTYPE html>"))
    #expect(html.contains("<title>Hello, world! | Great Site</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"An introductory page\">"))
    #expect(
      html.contains(
        "<article><section><div>Hello, world!</div><div>Here is a fun description of the website!</div></section><section><div>This is another section of the site!</div><div>And another sentence!</div></section></article>"
      )
    )
  }
}
