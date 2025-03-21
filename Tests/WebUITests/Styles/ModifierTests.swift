import Foundation
import Testing

@testable import WebUI

@Suite("Style Modifier Tests for Element Styling") struct StyleModifierTests {
  @Test("Element should render with xs breakpoint modifier")
  func shouldRenderWithXsModifier() {
    let element = Element(tag: "div")
      .opacity(50, on: .xs)
      .background(color: .blue(._500), on: .xs)
      .render()
    #expect(element == "<div class=\"xs:opacity-50 xs:bg-blue-500\"></div>")
  }

  @Test("Element should render with sm breakpoint modifier")
  func shouldRenderWithSmModifier() {
    let element = Element(tag: "div")
      .flex(direction: .row, on: .sm)
      .border(width: 1, style: .solid, on: .sm)
      .render()
    #expect(element == "<div class=\"sm:flex sm:flex-row sm:border-1 sm:border-solid\"></div>")
  }

  @Test("Element should render with md breakpoint modifier")
  func shouldRenderWithMdModifier() {
    let element = Element(tag: "div")
      .grid(columns: 3, on: .md)
      .shadow(size: .lg, on: .md)
      .render()
    #expect(element == "<div class=\"md:grid md:grid-cols-3 md:shadow-lg\"></div>")
  }

  @Test("Element should render with lg breakpoint modifier")
  func shouldRenderWithLgModifier() {
    let element = Element(tag: "div")
      .position(.absolute, length: 4, on: .lg)
      .ring(size: 2, on: .lg)
      .render()
    #expect(element == "<div class=\"lg:absolute lg:inset-4 lg:ring-2\"></div>")
  }

  @Test("Element should render with xl breakpoint modifier")
  func shouldRenderWithXlModifier() {
    let element = Element(tag: "div")
      .hidden(on: .xl)
      .frame(width: .full, on: .xl)
      .render()
    #expect(element == "<div class=\"xl:hidden xl:w-full\"></div>")
  }

  @Test("Element should render with xl2 breakpoint modifier")
  func shouldRenderWithXl2Modifier() {
    let element = Element(tag: "div")
      .transform(scale: (x: 110, y: 90), on: .xl2)
      .zIndex(10, on: .xl2)
      .render()
    #expect(element == "<div class=\"xl2:transform xl2:scale-x-110 xl2:scale-y-90 xl2:z-10\"></div>")
  }

  @Test("Element should render with hover state modifier")
  func shouldRenderWithHoverModifier() {
    let element = Element(tag: "div")
      .opacity(75, on: .hover)
      .background(color: .red(._300), on: .hover)
      .cursor(.pointer, on: .hover)
      .render()
    #expect(element == "<div class=\"hover:opacity-75 hover:bg-red-300 hover:cursor-pointer\"></div>")
  }

  @Test("Element should render with focus state modifier")
  func shouldRenderWithFocusModifier() {
    let element = Element(tag: "div")
      .ring(size: 3, color: .blue(._400), on: .focus)
      .outline(width: 2, style: .solid, on: .focus)
      .render()
    #expect(element == "<div class=\"focus:ring-3 focus:ring-blue-400 focus:outline-2 focus:outline-solid\"></div>")
  }

  @Test("Element should render with active state modifier")
  func shouldRenderWithActiveModifier() {
    let element = Element(tag: "div")
      .shadow(size: .xl, on: .active)
      .transform(rotate: 45, on: .active)
      .render()
    #expect(element == "<div class=\"active:shadow-xl active:transform active:rotate-45\"></div>")
  }

  @Test("Element should render with placeholder state modifier")
  func shouldRenderWithPlaceholderModifier() {
    let element = Element(tag: "input")
      .font(size: .sm, color: .gray(._400), on: .placeholder)
      .padding(.horizontal, length: 2, on: .placeholder)
      .render()
    #expect(element == "<input class=\"placeholder:text-sm placeholder:text-gray-400 placeholder:px-2\"></input>")
  }

  @Test("Element should render with multiple breakpoint modifiers")
  func shouldRenderWithMultipleBreakpointModifiers() {
    let element = Element(tag: "div")
      .flex(direction: .column, on: .sm, .lg)
      .background(color: .green(._500), on: .md, .xl)
      .render()
    #expect(element == "<div class=\"sm:lg:flex sm:lg:flex-col md:xl:bg-green-500\"></div>")
  }

  @Test("Element should render with mixed state and breakpoint modifiers")
  func shouldRenderWithMixedModifiers() {
    let element = Element(tag: "div")
      .opacity(80, on: .hover, .md)
      .border(width: 1, radius: (side: .all, size: .md), on: .focus, .lg)
      .render()
    #expect(
      element
        == "<div class=\"hover:md:opacity-80 focus:lg:border-1 focus:lg:rounded-md\"></div>"
    )
  }

  @Test("Element should render transform with modifier")
  func shouldRenderTransformWithModifier() {
    let element = Element(tag: "div")
      .transform(scale: (x: 150, y: nil), rotate: 90, on: .hover)
      .render()
    #expect(element == "<div class=\"hover:transform hover:scale-x-150 hover:rotate-90\"></div>")
  }

  @Test("Element should render position with modifier")
  func shouldRenderPositionWithModifier() {
    let element = Element(tag: "div")
      .position(.fixed, edges: .top, .leading, length: 0, on: .md)
      .render()
    #expect(element == "<div class=\"md:fixed md:top-0 md:left-0\"></div>")
  }

  @Test("Element should render transition with modifier")
  func shouldRenderTransitionWithModifier() {
    let element = Element(tag: "div")
      .transition(property: .opacity, duration: 300, easing: .inOut, on: .hover)
      .render()
    #expect(element == "<div class=\"hover:transition-opacity hover:duration-300 hover:ease-in-out\"></div>")
  }

  @Test("Element should render overflow with modifier")
  func shouldRenderOverflowWithModifier() {
    let element = Element(tag: "div")
      .overflow(.hidden, axis: .x, on: .lg)
      .render()
    #expect(element == "<div class=\"lg:overflow-x-hidden\"></div>")
  }

  @Test("Element should render margins with modifier")
  func shouldRenderMarginsWithModifier() {
    let element = Element(tag: "div")
      .margins(.vertical, length: 6, on: .sm)
      .render()
    #expect(element == "<div class=\"sm:my-6\"></div>")
  }

  @Test("Element should render padding with modifier")
  func shouldRenderPaddingWithModifier() {
    let element = Element(tag: "div")
      .padding(.all, length: 4, on: .md)
      .render()
    #expect(element == "<div class=\"md:p-4\"></div>")
  }

  @Test("Element should render font with modifier")
  func shouldRenderFontWithModifier() {
    let element = Element(tag: "div")
      .font(size: .lg, weight: .bold, color: .purple(._600), on: .hover)
      .render()
    #expect(element == "<div class=\"hover:text-lg hover:font-bold hover:text-purple-600\"></div>")
  }

  @Test("Element should render frame with modifier")
  func shouldRenderFrameWithModifier() {
    let element = Element(tag: "div")
      .frame(width: .fraction(1, 2), height: .fixed(200), on: .xl)
      .render()
    #expect(element == "<div class=\"xl:w-1/2 xl:h-200\"></div>")
  }
}
