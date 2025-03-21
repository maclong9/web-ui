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
        size: .sm,
        weight: .bold,
        alignment: .center,
        tracking: .wide,
        leading: .relaxed,
        decoration: .underline
      )
      .render()
    let extraLarge = Element(tag: "p").font(size: .xl3).render()
    #expect(
      element == "<p class=\"text-sm font-bold text-center tracking-wide leading-relaxed decoration-underline\"></p>")
    #expect(extraLarge == "<p class=\"text-3xl\"></p>")
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

  @Test("Element should render with multiple margin sides")
  func shouldRenderWithMultipleMargins() {
    let element = Element(tag: "div")
      .margins([.bottom, .leading], length: 6)
      .render()
    #expect(element == "<div class=\"mb-6 ml-6\"></div>")
  }

  @Test("Element should render with padding")
  func shouldRenderWithPadding() {
    let element = Element(tag: "div")
      .padding(.vertical, length: 8)
      .render()
    #expect(element == "<div class=\"py-8\"></div>")
  }

  @Test("Element should render with multiple padding sides")
  func shouldRenderWithMultiplePaddingSides() {
    let element = Element(tag: "div")
      .padding([.bottom, .leading], length: 6)
      .render()
    #expect(element == "<div class=\"pb-6 pl-6\"></div>")
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
      .frame(width: .full, on: .md)
      .font(size: .lg, on: .lg)
      .cursor(.notAllowed, on: .sm)
      .margins(.leading, length: 3, on: .xl)
      .padding(.trailing, length: 5, on: .md)
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

  @Test("Dimension rawValue should format fixed correctly")
  func shouldFormatFixedDimension() {
    let dimension = Dimension.fixed(42)
    #expect(dimension.rawValue == "42")
  }

  @Test("Dimension rawValue should format fraction correctly")
  func shouldFormatFractionDimension() {
    let dimension = Dimension.fraction(3, 4)
    #expect(dimension.rawValue == "3/4")
  }

  @Test("Dimension rawValue should format full correctly")
  func shouldFormatFullDimension() {
    let dimension = Dimension.full
    #expect(dimension.rawValue == "full")
  }

  @Test("Dimension rawValue should format screen correctly")
  func shouldFormatScreenDimension() {
    let dimension = Dimension.screen
    #expect(dimension.rawValue == "screen")
  }

  @Test("Dimension rawValue should format auto correctly")
  func shouldFormatAutoDimension() {
    let dimension = Dimension.auto
    #expect(dimension.rawValue == "auto")
  }

  @Test("Dimension rawValue should format minContent correctly")
  func shouldFormatMinContentDimension() {
    let dimension = Dimension.minContent
    #expect(dimension.rawValue == "min")
  }

  @Test("Dimension rawValue should format maxContent correctly")
  func shouldFormatMaxContentDimension() {
    let dimension = Dimension.maxContent
    #expect(dimension.rawValue == "max")
  }

  @Test("Dimension rawValue should format fitContent correctly")
  func shouldFormatFitContentDimension() {
    let dimension = Dimension.fitContent
    #expect(dimension.rawValue == "fit")
  }

  @Test("Dimension rawValue should format custom correctly")
  func shouldFormatCustomDimension() {
    let dimension = Dimension.custom("special-value")
    #expect(dimension.rawValue == "[special-value]")
  }

  // Test frame method with all Dimension variants
  @Test("Frame should handle all dimension types for width")
  func shouldHandleAllWidthDimensions() {
    let element = Element(tag: "div")
      .frame(width: .fixed(100))
      .frame(width: .fraction(1, 3))
      .frame(width: .full)
      .frame(width: .screen)
      .frame(width: .auto)
      .frame(width: .minContent)
      .frame(width: .maxContent)
      .frame(width: .fitContent)
      .frame(width: .custom("special"))
      .render()

    #expect(element == "<div class=\"w-100 w-1/3 w-full w-screen w-auto w-min w-max w-fit w-[special]\"></div>")
  }

  @Test("Frame should handle all dimension types for height")
  func shouldHandleAllHeightDimensions() {
    let element = Element(tag: "div")
      .frame(height: .fixed(200))
      .frame(height: .fraction(2, 5))
      .frame(height: .full)
      .frame(height: .screen)
      .frame(height: .auto)
      .frame(height: .minContent)
      .frame(height: .maxContent)
      .frame(height: .fitContent)
      .frame(height: .custom("75vh"))
      .render()

    #expect(element == "<div class=\"h-200 h-2/5 h-full h-screen h-auto h-min h-max h-fit h-[75vh]\"></div>")
  }

  @Test("Frame should handle nil parameters")
  func shouldHandleNilParameters() {
    let element = Element(tag: "div")
      .frame(width: nil, height: nil)
      .render()
    #expect(element == "<div></div>")
  }

  @Test("Frame should handle only width parameter")
  func shouldHandleOnlyWidth() {
    let element = Element(tag: "div")
      .frame(width: .full)
      .render()
    #expect(element == "<div class=\"w-full\"></div>")
  }

  @Test("Frame should handle only height parameter")
  func shouldHandleOnlyHeight() {
    let element = Element(tag: "div")
      .frame(height: .screen)
      .render()
    #expect(element == "<div class=\"h-screen\"></div>")
  }

  @Test("Frame should handle breakpoint prefix")
  func shouldHandleBreakpointPrefix() {
    let element = Element(tag: "div")
      .frame(width: .full, height: .auto, on: .md)
      .render()
    #expect(element == "<div class=\"md:w-full md:h-auto\"></div>")
  }
}
