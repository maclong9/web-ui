import Testing

@testable import WebUI

@Suite("Layout Tests")
struct LayoutTests {
  // From DisplayTests
  @Test("Flex Styles Render Correctly")
  func flexStylesShouldRenderCorrectly() async throws {
    let element = Text { "Flex Container" }
      .flex(.column, justify: .between, align: .center)
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
      .grid(justify: .center, align: .stretch, columns: 3)
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

  // From SpacingTests
  @Test("Margins with .all edge and default length creates correct class")
  func testMarginsAllEdgeDefault() throws {
    let element = Element(tag: "div") { "Content" }.margins()
    let html = element.render()
    #expect(html.contains("<div class=\"m-4\">Content</div>"))
  }

  @Test("Margins with .all edge and specific length creates correct class")
  func testMarginsAllEdgeSpecificLength() throws {
    let element = Element(tag: "div") { "Content" }.margins(.all, length: 8)
    let html = element.render()
    #expect(html.contains("<div class=\"m-8\">Content</div>"))
  }

  @Test("Margins with .all edge and breakpoint creates correct class")
  func testMarginsAllEdgeWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.margins(.all, length: 6, on: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:m-6\">Content</div>"))
  }

  @Test("Padding with .all edge and default length creates correct class")
  func testPaddingAllEdgeDefault() throws {
    let element = Element(tag: "div") { "Content" }.padding()
    let html = element.render()
    #expect(html.contains("<div class=\"p-4\">Content</div>"))
  }

  @Test("Padding with .all edge and specific length creates correct class")
  func testPaddingAllEdgeSpecificLength() throws {
    let element = Element(tag: "div") { "Content" }.padding(.all, length: 10)
    let html = element.render()
    #expect(html.contains("<div class=\"p-10\">Content</div>"))
  }

  @Test("Padding with .all edge and breakpoint creates correct class")
  func testPaddingAllEdgeWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.padding(.all, length: 7, on: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:p-7\">Content</div>"))
  }

  @Test("Margins with nil edge and default length creates no classes")
  func testMarginsNilEdge() throws {
    let element = Element(tag: "div") { "Content" }.margins(nil, length: nil)
    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  @Test("Margins with nil length creates no classes")
  func testMarginsNilLength() throws {
    let element = Element(tag: "div") { "Content" }.margins(.top, length: nil)
    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  @Test("Padding with nil edge and default length creates no classes")
  func testPaddingNilEdge() throws {
    let element = Element(tag: "div") { "Content" }.padding(nil, length: nil)
    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  @Test("Padding with nil length creates no classes")
  func testPaddingNilLength() throws {
    let element = Element(tag: "div") { "Content" }.padding(.bottom, length: nil)
    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  // From SizingTests
  @Test("Frame with width and height renders correctly")
  func testFrameWidthHeight() throws {
    let element = Element(tag: "div") { "Content" }.frame(width: .full, height: .fixed(4))
    let html = element.render()
    #expect(html.contains("<div class=\"w-full h-4\">Content</div>"))
  }

  @Test("Frame with custom value and breakpoint renders correctly")
  func testFrameCustomWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.frame(width: .custom("200px"), on: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:w-[200px]\">Content</div>"))
  }

  @Test("Frame with fraction renders correctly")
  func testFrameFraction() throws {
    let element = Element(tag: "div") { "Content" }.frame(width: .fraction(1, 2))
    let html = element.render()
    #expect(html.contains("<div class=\"w-1/2\">Content</div>"))
  }

  @Test("Frame with no parameters renders no classes")
  func testFrameNoParams() throws {
    let element = Element(tag: "div") { "Content" }.frame()
    let html = element.render()
    #expect(html == "<div>Content</div>")
  }

  // From OverflowTests
  @Test("Overflow with both axis renders correctly")
  func testOverflowBoth() throws {
    let element = Element(tag: "div") { "Content" }.overflow(.hidden)
    let html = element.render()
    #expect(html.contains("<div class=\"overflow-hidden\">Content</div>"))
  }

  @Test("Overflow with x-axis renders correctly")
  func testOverflowXAxis() throws {
    let element = Element(tag: "div") { "Content" }.overflow(.scroll, axis: .x)
    let html = element.render()
    #expect(html.contains("<div class=\"overflow-x-scroll\">Content</div>"))
  }

  @Test("Overflow with breakpoint renders correctly")
  func testOverflowWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.overflow(.auto, axis: .y, on: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:overflow-y-auto\">Content</div>"))
  }

  // From PositioningTests
  @Test("Position with type only renders correctly")
  func testPositionType() throws {
    let element = Element(tag: "div") { "Content" }.position(.absolute)
    let html = element.render()
    #expect(html.contains("<div class=\"absolute\">Content</div>"))
  }

  @Test("Position with inset renders correctly")
  func testPositionInset() throws {
    let element = Element(tag: "div") { "Content" }.position(.relative, inset: "0")
    let html = element.render()
    #expect(html.contains("<div class=\"relative inset-0\">Content</div>"))
  }

  @Test("Position with edges renders correctly")
  func testPositionEdges() throws {
    let element = Element(tag: "div") { "Content" }.position(.fixed, top: "0", left: "4")
    let html = element.render()
    #expect(html.contains("<div class=\"fixed top-0 left-4\">Content</div>"))
  }

  @Test("Position with inset and edges with breakpoint renders correctly")
  func testPositionInsetAndEdgesWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.position(.sticky, inset: "auto", bottom: "[10%]", on: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:sticky lg:inset-auto lg:bottom-[10%]\">Content</div>"))
  }

  // From ZIndexTests
  @Test("ZIndex with value renders correctly")
  func testZIndexValue() throws {
    let element = Element(tag: "div") { "Content" }.zIndex("10")
    let html = element.render()
    #expect(html.contains("<div class=\"z-10\">Content</div>"))
  }

  @Test("ZIndex with custom value and breakpoint renders correctly")
  func testZIndexCustomWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.zIndex("[100]", on: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:z-[100]\">Content</div>"))
  }
}
