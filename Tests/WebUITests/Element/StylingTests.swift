import Testing

@testable import WebUI

@Suite("Styling Tests")
struct StylingTests {
  // From BorderModifierTests
  @Test("Border applies default width correctly")
  func testDefaultWidth() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 2)
    let html = element.render()
    #expect(html.contains("<div class=\"border-2\">Test Content</div>"))
  }

  @Test("Border applies radius to all sides correctly")
  func testRadiusAll() throws {
    let element = Element(tag: "div") { "Test Content" }.border(radius: (.all, .md))
    let html = element.render()
    #expect(html.contains("<div class=\"rounded-md\">Test Content</div>"))
  }

  @Test("Border applies specific corner radius correctly")
  func testSpecificCornerRadius() throws {
    let element = Element(tag: "div") { "Test Content" }.border(radius: (.topLeft, .lg))
    let html = element.render()
    #expect(html.contains("<div class=\"rounded-tl-lg\">Test Content</div>"))
  }

  @Test("Border applies none radius correctly")
  func testNoneRadius() throws {
    let element = Element(tag: "div") { "Test Content" }.border(radius: (.all, .none))
    let html = element.render()
    #expect(html.contains("<div class=\"rounded-none\">Test Content</div>"))
  }

  @Test("Border applies style correctly")
  func testStyle() throws {
    let element = Element(tag: "div") { "Test Content" }.border(style: .dashed)
    let html = element.render()
    #expect(html.contains("<div class=\"border-dashed\">Test Content</div>"))
  }

  @Test("Border applies divide style with width correctly")
  func testDivideStyle() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 4, style: .divide)
    let html = element.render()
    #expect(html.contains("<div class=\"divide-x-4\">Test Content</div>"))
  }

  @Test("Border applies with breakpoint correctly")
  func testBreakpoint() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 1, radius: (.bottom, .xl), breakpoint: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:border-1 md:rounded-b-xl\">Test Content</div>"))
  }

  @Test("Border combines all properties correctly")
  func testAllProperties() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 2, radius: (.topRight, .xl2), style: .dotted)
    let html = element.render()
    #expect(html.contains("<div class=\"border-2 rounded-tr-2xl border-dotted\">Test Content</div>"))
  }

  @Test("Border combines with existing classes")
  func testWithExistingClasses() throws {
    let element = Element(tag: "div", classes: ["flex"]) { "Test Content" }.border(width: 3, style: .solid)
    let html = element.render()
    #expect(html.contains("<div class=\"flex border-3 border-solid\">Test Content</div>"))
  }

  @Test("Border with full radius and breakpoint")
  func testFullRadiusWithBreakpoint() throws {
    let element = Element(tag: "div") { "Test Content" }.border(radius: (.all, .full), breakpoint: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:rounded-full\">Test Content</div>"))
  }

  @Test("Border with hidden style does not apply width")
  func testHiddenStyle() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 2, style: .hidden)
    let html = element.render()
    #expect(html.contains("<div class=\"border-2 border-hidden\">Test Content</div>"))
    #expect(!html.contains("divide"))
  }

  @Test("Border with multiple chained calls")
  func testChainedBorders() throws {
    let element = Element(tag: "div") { "Test Content" }
      .border(width: 1)
      .border(radius: (.bottomLeft, .xs), breakpoint: .small)
      .border(style: .double)
    let html = element.render()
    #expect(html.contains("<div class=\"border-1 sm:rounded-bl-xs border-double\">Test Content</div>"))
  }

  // New Border Color Tests
  @Test("Border applies color correctly")
  func testBorderColor() throws {
    let element = Element(tag: "div") { "Test Content" }.border(color: .red(._600))
    let html = element.render()
    #expect(html.contains("<div class=\"border-red-600\">Test Content</div>"))
  }

  @Test("Border applies custom color correctly")
  func testBorderCustomColor() throws {
    let element = Element(tag: "div") { "Test Content" }.border(color: .custom("#ffcc00"))
    let html = element.render()
    #expect(html.contains("<div class=\"border-[#ffcc00]\">Test Content</div>"))
  }

  @Test("Border applies color with breakpoint correctly")
  func testBorderColorWithBreakpoint() throws {
    let element = Element(tag: "div") { "Test Content" }.border(color: .purple(._400), breakpoint: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:border-purple-400\">Test Content</div>"))
  }

  @Test("Border combines color with other properties correctly")
  func testBorderColorWithOtherProperties() throws {
    let element = Element(tag: "div") { "Test Content" }.border(width: 2, style: .solid, color: .teal(._700))
    let html = element.render()
    #expect(html.contains("<div class=\"border-2 border-solid border-teal-700\">Test Content</div>"))
  }

  // New Outline Color Tests
  @Test("Outline applies color correctly")
  func testOutlineColor() throws {
    let element = Element(tag: "div") { "Test Content" }.outline(color: .indigo(._500))
    let html = element.render()
    #expect(html.contains("<div class=\"outline-indigo-500\">Test Content</div>"))
  }

  @Test("Outline applies custom color with width correctly")
  func testOutlineCustomColorWithWidth() throws {
    let element = Element(tag: "div") { "Test Content" }.outline(width: 2, color: .custom("#00ff99"))
    let html = element.render()
    #expect(html.contains("<div class=\"outline-2 outline-[#00ff99]\">Test Content</div>"))
  }

  // New Box Shadow Color Tests
  @Test("Box shadow applies color correctly")
  func testBoxShadowColor() throws {
    let element = Element(tag: "div") { "Test Content" }.boxShadow(size: .medium, color: .gray(._300))
    let html = element.render()
    #expect(html.contains("<div class=\"shadow-md shadow-gray-300\">Test Content</div>"))
  }

  @Test("Box shadow applies custom color with breakpoint correctly")
  func testBoxShadowCustomColorWithBreakpoint() throws {
    let element = Element(tag: "div") { "Test Content" }.boxShadow(
      size: .large, color: .custom("#123456"), breakpoint: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:shadow-lg md:shadow-[#123456]\">Test Content</div>"))
  }

  // New Ring Color Tests
  @Test("Ring applies color correctly")
  func testRingColor() throws {
    let element = Element(tag: "div") { "Test Content" }.ring(size: 3, color: .pink(._400))
    let html = element.render()
    #expect(html.contains("<div class=\"ring-3 ring-pink-400\">Test Content</div>"))
  }

  @Test("Ring applies custom color with default size correctly")
  func testRingCustomColor() throws {
    let element = Element(tag: "div") { "Test Content" }.ring(color: .custom("#abcdef"))
    let html = element.render()
    #expect(html.contains("<div class=\"ring-1 ring-[#abcdef]\">Test Content</div>"))
  }

  // New Typography Color Tests
  @Test("Font applies color correctly")
  func testFontColor() throws {
    let element = Element(tag: "p") { "Text" }.font(color: .emerald(._600))
    let html = element.render()
    #expect(html.contains("<p class=\"text-emerald-600\">Text</p>"))
  }

  @Test("Font applies custom color with breakpoint correctly")
  func testFontCustomColorWithBreakpoint() throws {
    let element = Element(tag: "p") { "Text" }.font(color: .custom("#ff00ff"), on: .small)
    let html = element.render()
    #expect(html.contains("<p class=\"sm:text-[#ff00ff]\">Text</p>"))
  }

  @Test("Font combines color with other properties correctly")
  func testFontColorWithOtherProperties() throws {
    let element = Element(tag: "p") { "Text" }.font(size: .lg, weight: .bold, color: .cyan(._700))
    let html = element.render()
    #expect(html.contains("<p class=\"text-lg font-bold text-cyan-700\">Text</p>"))
  }

  // From TransformTests
  @Test("Transform with rotate renders correctly")
  func testTransformRotate() throws {
    let element = Element(tag: "div") { "Content" }.transform(rotate: "45")
    let html = element.render()
    #expect(html.contains("<div class=\"transform rotate-45\">Content</div>"))
  }

  @Test("Transform with negative translate renders correctly")
  func testTransformNegativeTranslate() throws {
    let element = Element(tag: "div") { "Content" }.transform(translateX: "-4")
    let html = element.render()
    #expect(html.contains("<div class=\"transform -translate-x-4\">Content</div>"))
  }

  @Test("Transform with custom value and breakpoint renders correctly")
  func testTransformCustomWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.transform(scale: "[1.5]", on: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:transform md:scale-[1.5]\">Content</div>"))
  }

  @Test("Transform with multiple properties renders correctly")
  func testTransformMultiple() throws {
    let element = Element(tag: "div") { "Content" }.transform(scaleX: "110", skewY: "10")
    let html = element.render()
    #expect(html.contains("<div class=\"transform scale-x-110 skew-y-10\">Content</div>"))
  }

  // From OpacityTests
  @Test("Opacity with value renders correctly")
  func testOpacityValue() throws {
    let element = Element(tag: "div") { "Content" }.opacity("50")
    let html = element.render()
    #expect(html.contains("<div class=\"opacity-50\">Content</div>"))
  }

  @Test("Opacity with custom value and breakpoint renders correctly")
  func testOpacityCustomWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.opacity("[0.75]", on: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:opacity-[0.75]\">Content</div>"))
  }

  // From TransitionTests
  @Test("Transition with default renders correctly")
  func testTransitionDefault() throws {
    let element = Element(tag: "div") { "Content" }.transition()
    let html = element.render()
    #expect(html.contains("<div class=\"transition\">Content</div>"))
  }

  @Test("Transition with properties renders correctly")
  func testTransitionProperties() throws {
    let element = Element(tag: "div") { "Content" }.transition(property: .opacity, duration: 300, easing: .inOut)
    let html = element.render()
    #expect(html.contains("<div class=\"transition-opacity duration-300 ease-in-out\">Content</div>"))
  }

  @Test("Transition with delay and breakpoint renders correctly")
  func testTransitionWithDelayAndBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.transition(property: .colors, delay: 150, on: .medium)
    let html = element.render()
    #expect(html.contains("<div class=\"md:transition-colors md:delay-150\">Content</div>"))
  }

  // From CursorTests
  @Test("Cursor with type renders correctly")
  func testCursorType() throws {
    let element = Element(tag: "div") { "Content" }.cursor(.pointer)
    let html = element.render()
    #expect(html.contains("<div class=\"cursor-pointer\">Content</div>"))
  }

  @Test("Cursor with breakpoint renders correctly")
  func testCursorWithBreakpoint() throws {
    let element = Element(tag: "div") { "Content" }.cursor(.notAllowed, on: .large)
    let html = element.render()
    #expect(html.contains("<div class=\"lg:cursor-not-allowed\">Content</div>"))
  }

  // Background Tests
  @Test("Background color renders correctly")
  func testBackgroundColor() throws {
    let element = Element(tag: "div") { "Content" }.background(color: .blue(._500))
    let html = element.render()
    #expect(html.contains("bg-blue-500"))
  }

  @Test("Background color renders with breakpoints")
  func testBackgroundColorWithBreakpoints() throws {
    let element = Element(tag: "div") { "Content" }
      .background(color: .green(._300))
      .background(color: .blue(._500), on: .medium)
    let html = element.render()
    #expect(html.contains("bg-green-300 md:bg-blue-500"))
  }

  @Test("Background color renders with custom value")
  func testBackgroundColorWithCustomValue() throws {
    let element = Element(tag: "div") { "Content" }.background(color: .custom("#0099ff"))
    let html = element.render()
    #expect(html.contains("bg-[#0099ff]"))
  }
}
