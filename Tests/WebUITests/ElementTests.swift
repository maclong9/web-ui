import Testing

@testable import WebUI

@Suite("Element Tests")
struct ElementTests {
  let numbers = ["one", "two", "three"]
  let html = Article {
    Text(heading: .h1) { "Hello, world!" }
    Section(id: "main-content") {
      Text(heading: .h2, role: .heading) { "Introduction" }
      Stack(classes: ["container"]) {
        Text { "This container has one class" }
      }
      Stack(classes: ["container", "primary"]) {
        Text { "This container has multiple classes" }
      }
      Text(href: "https://example.com", target: .blank) { "Click me" }
      Text(bold: true) { "Bold text" }
      Text(emphasized: true) { "Emphasized text" }
      Text(heading: .h2) { "Heading 2" }
      Text { "Single sentence." }
      Text { "First sentence. Second sentence!" }
      Text(id: "text-id", classes: ["text-class"]) { "Styled text." }
      Text {
        "Here is some text"
        Text(bold: true) { "With some nested text as well" }
      }
    }
    Section(id: "featured", classes: ["article", "featured"]) {
      Text(heading: .h2) { "More Content" }
      Stack {
        Text { "Hello, world!" }
      }
    }
    Button {
      Text { "Click me" }
    }
  }.render()

  @Test("Render basic layout elements")
  func testBasicLayoutRendering() async throws {
    print(html)
    #expect(html.contains("<article>"))
    #expect(html.contains("</article>"))
    #expect(html.contains("<div>"))
    #expect(html.contains("</div>"))
    #expect(html.contains("<section"))
    #expect(html.contains("</section>"))
  }

  @Test("Render element with ID")
  func testIDRendering() async throws {
    #expect(html.contains("id=\"main-content\""))
  }

  @Test("Render element with classes")
  func testClassesRendering() async throws {
    #expect(html.contains("class=\"container\""))
    #expect(html.contains("class=\"container primary\""))
    #expect(html.contains("class=\"text-class\""))
  }

  @Test("Render element with both ID and classes")
  func testIDAndClassesRendering() async throws {
    #expect(html.contains("id=\"featured\""))
    #expect(html.contains("class=\"article featured\""))
  }

  @Test("Render text as link with href and target")
  func testLinkRendering() async throws {
    #expect(html.contains("<a href=\"https://example.com\" target=\"_blank\">Click me</a>"))
  }

  @Test("Render text as bold")
  func testBoldRendering() async throws {
    #expect(html.contains("<b>Bold text</b>"))
  }

  @Test("Render text as emphasized")
  func testEmphasizedRendering() async throws {
    #expect(html.contains("<em>Emphasized text</em>"))
  }

  @Test("Render text as heading")
  func testHeadingRendering() async throws {
    #expect(html.contains("<h2>Heading 2</h2>"))
  }

  @Test("Render single sentence text as span")
  func testSingleSentenceRendering() async throws {
    #expect(html.contains("<span>Single sentence.</span>"))
  }

  @Test("Render multiple sentences text as paragraph")
  func testMultipleSentencesRendering() async throws {
    #expect(html.contains("<p>First sentence. Second sentence!</p>"))
  }

  @Test("Render text with id and classes")
  func testTextWithAttributesRendering() async throws {
    #expect(html.contains("<span id=\"text-id\" class=\"text-class\">Styled text.</span>"))
  }

  @Test("Render article with default role")
  func testArticleRoleRendering() async throws {
    #expect(html.contains("<h2 role=\"heading\">"))
  }

  @Test("Render section with no default role")
  func testSectionNoRoleRendering() async throws {
    #expect(html.contains("<section id=\"main-content\">"))
    #expect(!html.contains("<section id=\"main-content\" role"))
  }

  @Test("Render stack with no default role")
  func testStackNoRoleRendering() async throws {
    #expect(html.contains("<div class=\"container\">"))
    #expect(!html.contains("<div class=\"container\" role"))
  }
}
