import Foundation
import Testing

@testable import WebUI

@Suite("Base Style Tests for Element Styling") struct BaseStyleTests {
  @Test("Element should render with frame dimensions")
  func shouldRenderWithFrameDimensions() {
    let element = Element(tag: "div")
      .frame(width: .fixed(300), height: .full)
      .render()
    #expect(element == "<div class=\"w-300 h-full\"></div>")
  }

  @Test("Element should render with fractional dimensions")
  func shouldRenderWithFractionalDimensions() {
    let element = Element(tag: "div")
      .frame(width: .fraction(1, 2), height: .fraction(2, 3))
      .render()
    #expect(element == "<div class=\"w-1/2 h-2/3\"></div>")
  }

  @Test("Element should render with font styling")
  func shouldRenderWithFontStyling() {
    let element = Element(tag: "p")
      .font(
        size: .lg,
        weight: .bold,
        alignment: .center,
        tracking: .wide,
        leading: .relaxed,
        decoration: .underline
      )
      .render()
    #expect(
      element == "<p class=\"text-lg font-bold text-center tracking-wide leading-relaxed decoration-underline\"></p>")
  }

  @Test("Element should render with cursor styling")
  func shouldRenderWithCursorStyling() {
    let element = Element(tag: "button")
      .cursor(.pointer)
      .render()
    #expect(element == "<button class=\"cursor-pointer\"></button>")
  }

  @Test("Element should render with margins")
  func shouldRenderWithMargins() {
    let element = Element(tag: "div")
      .margins(.horizontal, length: 6)
      .render()
    #expect(element == "<div class=\"mx-6\"></div>")
  }

  @Test("Element should render with padding")
  func shouldRenderWithPadding() {
    let element = Element(tag: "div")
      .padding(.vertical, length: 8)
      .render()
    #expect(element == "<div class=\"py-8\"></div>")
  }

  @Test("Element should render with combined styling")
  func shouldRenderWithCombinedStyling() {
    let element = Element(tag: "div")
      .frame(width: .screen, height: .auto)
      .font(size: .base, weight: .medium, alignment: .left)
      .cursor(.move)
      .margins(.top, length: 4)
      .padding(.all, length: 2)
      .render()
    #expect(element == "<div class=\"w-screen h-auto text-base font-medium text-left cursor-move mt-4 p-2\"></div>")
  }

  @Test("Element should render with breakpoint-specific styling")
  func shouldRenderWithBreakpointStyling() {
    let element = Element(tag: "div")
      .frame(width: .full, on: .medium)
      .font(size: .lg, on: .large)
      .cursor(.notAllowed, on: .small)
      .margins(.leading, length: 3, on: .extraLarge)
      .padding(.trailing, length: 5, on: .medium)
      .render()
    #expect(element == "<div class=\"md:w-full lg:text-lg sm:cursor-not-allowed xl:ml-3 md:pr-5\"></div>")
  }

  @Test("Element should render without styling")
  func shouldRenderWithoutStyling() {
    let element = Element(tag: "span").render()
    #expect(element == "<span></span>")
  }

  @Test("Nested elements should render with inherited styling")
  func shouldRenderNestedStyledContent() {
    let stack = Stack {
      Stack() { "Inner content" }
        .frame(width: .maxContent)
        .font(size: .sm, weight: .light)
        .padding(.all, length: 3)
    }
    .frame(width: .full)
    .margins(.all, length: 2)
    .render()
    #expect(
      stack == "<div class=\"w-full m-2\"><div class=\"w-max text-sm font-light p-3\">Inner content</div></div>"
    )
  }
}
