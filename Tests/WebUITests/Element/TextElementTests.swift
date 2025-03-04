import Testing

@testable import WebUI

@Suite("Text Element Tests")
struct TextElementTests {
  @Test("Text renders as p for multiple sentences")
  func testTextParagraph() throws {
    let text = Text {
      "Hello. World!"
    }
    let html = text.render()
    #expect(html == "<p>Hello. World!</p>")
  }

  @Test("Text renders as span for single sentence")
  func testTextSpan() throws {
    let text = Text {
      "Hello"
    }
    let html = text.render()
    #expect(html == "<span>Hello</span>")
  }

  @Test("Heading renders with correct level")
  func testHeadingRender() throws {

    let heading =

      Heading(level: .h2, id: "title") {
        "Section Title"
      }

    let html = heading.render()
    #expect(html == "<h2 id=\"title\">Section Title</h2>")
  }

  @Test("Emphasis renders as em tag")
  func testEmphasisRender() throws {
    let emphasis = Emphasis {
      "Important"
    }
    let html = emphasis.render()
    #expect(html == "<em>Important</em>")
  }

  @Test("Strong renders as strong tag")
  func testStrongRender() throws {
    let strong = Strong {
      "Critical"
    }
    let html = strong.render()
    #expect(html == "<strong>Critical</strong>")
  }
}
