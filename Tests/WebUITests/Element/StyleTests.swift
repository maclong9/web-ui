import Testing

@testable import WebUI

// MARK: - Display Tests
@Suite("Display Tests")
struct DisplayTests {
  @Test("Flex Styles Render Correctly")
  func flexStylesShouldRenderCorrectly() async throws {
    let element = Text { "Flex Container" }
      .flex(
        .column,
        justify: .between,
        align: .center
      )
      .render()

    let rowReverseElement = Text { "Flex Container" }
      .flex(.rowReverse)
      .render()

    let colReverseElement = Text { "Flex Container" }
      .flex(.colReverse)
      .render()

    #expect(element.contains("flex flex-col justify-between items-center"))
    #expect(colReverseElement.contains("flex flex-col-reverse"))
    #expect(rowReverseElement.contains("flex flex-row-reverse"))
  }

  @Test("Grid Styles Render Correctly")
  func gridStylesShouldRenderCorrectly() async throws {
    let element = Text { "Grid Container" }
      .grid(
        justify: .center,
        align: .stretch,
        columns: 3
      )
      .render()

    #expect(element.contains("grid justify-center items-stretch grid-cols-3"))
  }

  @Test("Hidden Style Renders Correctly When True")
  func hiddenStyleShouldRenderCorrectlyWhenTrue() async throws {
    let element = Text { "Hidden Element" }
      .hidden(true)
      .render()

    #expect(element.contains("hidden"))
  }

  @Test("Hidden Style Does Not Render When False")
  func hiddenStyleShouldNotRenderWhenFalse() async throws {
    let element = Text { "Visible Element" }
      .hidden(false)
      .render()

    #expect(!element.contains("hidden"))
  }
}

// MARK: - Spacing Tests
@Suite("Spacing Tests")
struct SpacingTests {
  // MARK: Margin Tests

  @Test("Margins with .all edge and default length creates correct class")
  func testMarginsAllEdgeDefault() throws {
    let element = Element(tag: "div") {
      "Content"
    }.margins()

    let html = element.render()
    #expect(html.contains("<div class=\"m-4\">Content</div>"))
  }

  @Test("Margins with .all edge and specific length creates correct class")
  func testMarginsAllEdgeSpecificLength() throws {
    let element = Element(tag: "div") {
      "Content"
    }.margins(.all, length: 8)

    let html = element.render()
    #expect(html.contains("<div class=\"m-8\">Content</div>"))
  }

  @Test("Margins with .all edge and breakpoint creates correct class")
  func testMarginsAllEdgeWithBreakpoint() throws {
    let element = Element(tag: "div") {
      "Content"
    }.margins(.all, length: 6, on: .md)

    let html = element.render()
    #expect(html.contains("<div class=\"md:m-6\">Content</div>"))
  }

  // MARK: Padding Edge Tests

  @Test("Padding with .all edge and default length creates correct class")
  func testPaddingAllEdgeDefault() throws {
    let element = Element(tag: "div") {
      "Content"
    }.padding()

    let html = element.render()
    #expect(html.contains("<div class=\"p-4\">Content</div>"))
  }

  @Test("Padding with .all edge and specific length creates correct class")
  func testPaddingAllEdgeSpecificLength() throws {
    let element = Element(tag: "div") {
      "Content"
    }.padding(.all, length: 10)

    let html = element.render()
    #expect(html.contains("<div class=\"p-10\">Content</div>"))
  }

  @Test("Padding with .all edge and breakpoint creates correct class")
  func testPaddingAllEdgeWithBreakpoint() throws {
    let element = Element(tag: "div") {
      "Content"
    }.padding(.all, length: 7, on: .lg)

    let html = element.render()
    #expect(html.contains("<div class=\"lg:p-7\">Content</div>"))
  }

  // MARK: - Mixed Margin Tests

  @Test("Margins with nil edge and default length creates no classes")
  func testMarginsNilEdge() throws {
    let element = Element(tag: "div") {
      "Content"
    }.margins(nil, length: nil)

    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  @Test("Margins with nil length creates no classes")
  func testMarginsNilLength() throws {
    let element = Element(tag: "div") {
      "Content"
    }.margins(.top, length: nil)

    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  // MARK: - Mixed Padding Tests

  @Test("Padding with nil edge and default length creates no classes")
  func testPaddingNilEdge() throws {
    let element = Element(tag: "div") {
      "Content"
    }.padding(nil, length: nil)

    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  @Test("Padding with nil length creates no classes")
  func testPaddingNilLength() throws {
    let element = Element(tag: "div") {
      "Content"
    }.padding(.bottom, length: nil)

    let html = element.render()
    #expect(html == "<div>Content</div>")
  }
}

// MARK: - Typography Tests
@Suite("Typography Tests")
struct TypographyTests {
  @Test("Breakpoints Render Correctly")
  func breakpointsShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(weight: .bold)
      .font(weight: .extrabold, on: .xl)
      .render()

    #expect(element.contains("font-bold xl:font-extrabold"))
  }

  @Test("Font Styles Render Correctly")
  func fontStylesShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(
        weight: .extrabold,
        size: .xl5,
        alignment: .right,
        tracking: .wider,
        leading: .relaxed,
        decoration: .double
      )
      .render()

    #expect(element.contains("font-extrabold text-5xl text-right tracking-wider leading-relaxed decoration-double"))
  }

  @Test("Chained Styles Render Correctly")
  func chainedStylesShouldRenderCorrectly() async throws {
    let element = Text { "Chained Styles" }
      .flex(.row, justify: .around)
      .font(weight: .bold, size: .lg)
      .hidden(false)
      .render()

    #expect(element.contains("flex flex-row justify-around font-bold text-lg"))
    #expect(!element.contains("hidden"))
  }
}
