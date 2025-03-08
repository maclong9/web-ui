// StylingTests.swift
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
}
