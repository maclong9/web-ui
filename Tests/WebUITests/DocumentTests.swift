import Testing

@testable import WebUI

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
    let config = Configuration(metadata: Metadata(author: "Mac"), layout: Layout(header: .logoCentered, footer: .minimal))
    let documentOne = Document(title: "Test Title", description: "Hello, world!") { "Hello, world!" }
    let documentTwo = Document(configuration: config, title: "Test Title", description: "Hello, world!") {
      "Hello, world!"
    }

    let htmlOne = documentOne.render()
    let htmlTwo = documentTwo.render()

    #expect(htmlOne != htmlTwo)
    #expect(htmlTwo.contains("header-centered"))
    #expect(htmlTwo.contains("footer-minimal"))
    #expect(htmlTwo.contains("<meta name=\"author\" content=\"Mac\">"))
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
