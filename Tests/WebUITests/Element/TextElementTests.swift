import Testing

@testable import WebUI

@Suite("Text Elements Tests")
struct TextElementsTests {
  // From TextElementTests
  @Test("Text renders as p for multiple sentences")
  func testTextParagraph() throws {
    let text = Text { "Hello. World!" }
    let html = text.render()
    #expect(html == "<p>Hello. World!</p>")
  }

  @Test("Text renders as span for single sentence")
  func testTextSpan() throws {
    let text = Text { "Hello" }
    let html = text.render()
    #expect(html == "<span>Hello</span>")
  }

  @Test("Heading renders with correct level")
  func testHeadingRender() throws {
    let heading = Heading(level: .level2, id: "title") { "Section Title" }
    let html = heading.render()
    #expect(html == "<h2 id=\"title\">Section Title</h2>")
  }

  @Test("Emphasis renders as em tag")
  func testEmphasisRender() throws {
    let emphasis = Emphasis { "Important" }
    let html = emphasis.render()
    #expect(html == "<em>Important</em>")
  }

  @Test("Strong renders as strong tag")
  func testStrongRender() throws {
    let strong = Strong { "Critical" }
    let html = strong.render()
    #expect(html == "<strong>Critical</strong>")
  }

  // From TypographyTests
  @Test("Breakpoints Render Correctly")
  func breakpointsShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(weight: .bold)
      .font(weight: .extrabold, on: .extraLarge)
      .render()
    #expect(element.contains("font-bold xl:font-extrabold"))
  }

  @Test("Font Styles Render Correctly")
  func fontStylesShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(
        size: .extraLarge5, weight: .extrabold, alignment: .right, tracking: .wider, leading: .relaxed,
        decoration: .double
      )
      .render()
    #expect(element.contains("text-5xl font-extrabold text-right tracking-wider leading-relaxed decoration-double"))
  }

  @Test("Chained Styles Render Correctly")
  func chainedStylesShouldRenderCorrectly() async throws {
    let element = Text { "Chained Styles" }
      .flex(.row, justify: .around, grow: .one)
      .font(size: .lg, weight: .bold)
      .hidden(false)
      .render()
    #expect(element.contains("flex flex-row justify-around flex-1 text-lg font-bold"))
    #expect(!element.contains("hidden"))
  }
}
