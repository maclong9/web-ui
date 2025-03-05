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

    #expect(element.contains("flex flex-col justify-between items-center"))
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
  @Test("Margins apply default classes correctly")
  func testDefaultMargins() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.margins()

    let html = element.render()
    #expect(html.contains("<div class=\"m-4\">Test Content</div>"))
  }

  @Test("Margins apply specific edge and length correctly")
  func testSpecificEdgeMargins() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.margins(.top, length: 6)

    let html = element.render()
    #expect(html.contains("<div class=\"mt-6\">Test Content</div>"))
  }

  @Test("Margins apply with breakpoint correctly")
  func testMarginsWithBreakpoint() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.margins(.horizontal, length: 2, on: .md)

    let html = element.render()
    #expect(html.contains("<div class=\"md:mx-2\">Test Content</div>"))
  }

  @Test("Margins combine with existing classes")
  func testMarginsWithExistingClasses() throws {
    let element = Element(tag: "div", classes: ["flex"]) {
      "Test Content"
    }.margins(.vertical, length: 8)

    let html = element.render()
    #expect(html.contains("<div class=\"flex my-8\">Test Content</div>"))
  }

  @Test("Padding applies default classes correctly")
  func testDefaultPadding() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.padding()

    let html = element.render()
    #expect(html.contains("<div class=\"p-4\">Test Content</div>"))
  }

  @Test("Padding applies specific edge and length correctly")
  func testSpecificEdgePadding() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.padding(.leading, length: 3)

    let html = element.render()
    #expect(html.contains("<div class=\"pl-3\">Test Content</div>"))
  }

  @Test("Padding applies with breakpoint correctly")
  func testPaddingWithBreakpoint() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.padding(.bottom, length: 5, on: .lg)

    let html = element.render()
    #expect(html.contains("<div class=\"lg:pb-5\">Test Content</div>"))
  }

  @Test("Padding combines with existing classes")
  func testPaddingWithExistingClasses() throws {
    let element = Element(tag: "div", classes: ["text-center"]) {
      "Test Content"
    }.padding(.trailing, length: 2)

    let html = element.render()
    #expect(html.contains("<div class=\"text-center pr-2\">Test Content</div>"))
  }

  @Test("Multiple spacing modifiers chain correctly")
  func testChainedSpacingModifiers() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }
    .margins(.top, length: 2)
    .padding(.horizontal, length: 4)
    .margins(.bottom, length: 6, on: .sm)

    let html = element.render()
    #expect(html.contains("<div class=\"mt-2 px-4 sm:mb-6\">Test Content</div>"))
  }

  @Test("Spacing with all edges explicitly set")
  func testAllEdgesSpacing() throws {
    let element = Element(tag: "div") {
      "Test Content"
    }.margins(.all, length: 10)

    let html = element.render()
    #expect(html.contains("<div class=\"m-10\">Test Content</div>"))
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
