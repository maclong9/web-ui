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
    }.margins(.all, length: 6, on: .medium)

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
    }.padding(.all, length: 7, on: .large)

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
      .font(weight: .extrabold, on: .extraLarge)
      .render()

    #expect(element.contains("font-bold xl:font-extrabold"))
  }

  @Test("Font Styles Render Correctly")
  func fontStylesShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(
        weight: .extrabold,
        size: .extraLarge5,
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
      .flex(.row, justify: .around, grow: .one)
      .font(weight: .bold, size: .lg)
      .hidden(false)
      .render()

    #expect(element.contains("flex flex-row justify-around flex-1 font-bold text-lg"))
    #expect(!element.contains("hidden"))
  }
}

// MARK: - Border Tests
@Suite("Border Modifier Tests")
struct BorderModifierTests {
    @Test("Border applies default width correctly")
    func testDefaultWidth() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(width: 2)
        
        let html = element.render()
        #expect(html.contains("<div class=\"border-2\">Test Content</div>"))
    }
    
    @Test("Border applies radius to all sides correctly")
    func testRadiusAll() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(radius: (.all, .md))
        
        let html = element.render()
        #expect(html.contains("<div class=\"rounded-md\">Test Content</div>"))
    }
    
    @Test("Border applies specific corner radius correctly")
    func testSpecificCornerRadius() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(radius: (.topLeft, .lg))
        
        let html = element.render()
        #expect(html.contains("<div class=\"rounded-tl-lg\">Test Content</div>"))
    }
    
    @Test("Border applies none radius correctly")
    func testNoneRadius() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(radius: (.all, .none))
        
        let html = element.render()
        #expect(html.contains("<div class=\"rounded-none\">Test Content</div>"))
    }
    
    @Test("Border applies style correctly")
    func testStyle() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(style: .dashed)
        
        let html = element.render()
        #expect(html.contains("<div class=\"border-dashed\">Test Content</div>"))
    }
    
    @Test("Border applies divide style with width correctly")
    func testDivideStyle() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(width: 4, style: .divide)
        
        let html = element.render()
        #expect(html.contains("<div class=\"divide-x-4\">Test Content</div>"))
    }
    
    @Test("Border applies with breakpoint correctly")
    func testBreakpoint() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(width: 1, radius: (.bottom, .xl), breakpoint: .medium)
        
        let html = element.render()
        #expect(html.contains("<div class=\"md:border-1 md:rounded-b-xl\">Test Content</div>"))
    }
    
    @Test("Border combines all properties correctly")
    func testAllProperties() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(width: 2, radius: (.topRight, .xl2), style: .dotted)
        
        let html = element.render()
        #expect(html.contains("<div class=\"border-2 rounded-tr-2xl border-dotted\">Test Content</div>"))
    }
    
    @Test("Border combines with existing classes")
    func testWithExistingClasses() throws {
        let element = Element(tag: "div", classes: ["flex"]) {
            "Test Content"
        }.border(width: 3, style: .solid)
        
        let html = element.render()
        #expect(html.contains("<div class=\"flex border-3 border-solid\">Test Content</div>"))
    }
    
    @Test("Border with full radius and breakpoint")
    func testFullRadiusWithBreakpoint() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(radius: (.all, .full), breakpoint: .large)
        
        let html = element.render()
        #expect(html.contains("<div class=\"lg:rounded-full\">Test Content</div>"))
    }
    
    @Test("Border with hidden style does not apply width")
    func testHiddenStyle() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }.border(width: 2, style: .hidden)
        
        let html = element.render()
        #expect(html.contains("<div class=\"border-2 border-hidden\">Test Content</div>"))
        #expect(!html.contains("divide"))
    }
    
    @Test("Border with multiple chained calls")
    func testChainedBorders() throws {
        let element = Element(tag: "div") {
            "Test Content"
        }
        .border(width: 1)
        .border(radius: (.bottomLeft, .xs), breakpoint: .small)
        .border(style: .double)
        
        let html = element.render()
        #expect(html.contains("<div class=\"border-1 sm:rounded-bl-xs border-double\">Test Content</div>"))
    }
}
