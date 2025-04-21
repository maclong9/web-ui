import Testing

@testable import WebUI

@Suite("Base Style Tests") struct BaseStyleTests {
  // MARK: - Sizing Tests

  @Test("Frame with fixed width and height")
  func testFrameWithFixedDimensions() async throws {
    let element = Element(tag: "div").frame(width: .fixed(100), height: .fixed(200))
    let rendered = element.render()
    #expect(rendered.contains("class=\"w-100 h-200\""))
  }

  @Test("Frame with fractional width")
  func testFrameWithFractionalWidth() async throws {
    let element = Element(tag: "div").frame(width: .fraction(1, 2))
    let rendered = element.render()
    #expect(rendered.contains("class=\"w-1/2\""))
  }

  @Test("Frame with min and max dimensions")
  func testFrameWithMinMaxDimensions() async throws {
    let element = Element(tag: "div").frame(minWidth: .minContent, maxHeight: .fitContent)
    let rendered = element.render()
    #expect(rendered.contains("class=\"min-w-min max-h-fit\""))
  }

  @Test("Frame with character width and modifier")
  func testFrameWithCharacterWidthAndModifier() async throws {
    let element = Element(tag: "div").frame(width: .character(60), on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:w-[60ch]\""))
  }

  @Test("Frame with custom dimension")
  func testFrameWithCustomDimension() async throws {
    let element = Element(tag: "div").frame(height: .custom("50vh"))
    let rendered = element.render()
    #expect(rendered.contains("class=\"h-[50vh]\""))
  }

  // MARK: - Typography Tests

  @Test("Font with size and weight")
  func testFontWithSizeAndWeight() async throws {
    let element = Element(tag: "div").font(size: .lg, weight: .bold)
    let rendered = element.render()
    #expect(rendered.contains("class=\"text-lg font-bold\""))
  }

  @Test("Font with alignment and color")
  func testFontWithAlignmentAndColor() async throws {
    let element = Element(tag: "div").font(alignment: .center, color: .blue(._500))
    let rendered = element.render()
    #expect(rendered.contains("class=\"text-center text-blue-500\""))
  }

  @Test("Font with tracking and leading")
  func testFontWithTrackingAndLeading() async throws {
    let element = Element(tag: "div").font(tracking: .wide, leading: .loose)
    let rendered = element.render()
    #expect(rendered.contains("class=\"tracking-wide leading-loose\""))
  }

  @Test("Font with decoration and wrapping")
  func testFontWithDecorationAndWrapping() async throws {
    let element = Element(tag: "div").font(decoration: .underline, wrapping: .nowrap)
    let rendered = element.render()
    #expect(rendered.contains("class=\"decoration-underline text-nowrap\""))
  }

  @Test("Font with family and modifier")
  func testFontWithFamilyAndModifier() async throws {
    let element = Element(tag: "div").font(family: "sans", on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:font-[sans]\""))
  }

  @Test("Font with extra-large size")
  func testFontWithExtraLargeSize() async throws {
    let element = Element(tag: "div").font(size: .xl5)
    let rendered = element.render()
    #expect(rendered.contains("class=\"text-5xl\""))
  }

  // MARK: - Cursor Tests

  @Test("Cursor with pointer type")
  func testCursorWithPointerType() async throws {
    let element = Element(tag: "div").cursor(.pointer)
    let rendered = element.render()
    #expect(rendered.contains("class=\"cursor-pointer\""))
  }

  @Test("Cursor with not-allowed type and modifier")
  func testCursorWithNotAllowedAndModifier() async throws {
    let element = Element(tag: "div").cursor(.notAllowed, on: .focus)
    let rendered = element.render()
    #expect(rendered.contains("class=\"focus:cursor-not-allowed\""))
  }

  // MARK: - Margin Tests

  @Test("Margins with default length")
  func testMarginsWithDefaultLength() async throws {
    let element = Element(tag: "div").margins()
    let rendered = element.render()
    #expect(rendered.contains("class=\"m-4\""))
  }

  @Test("Margins with specific edge and length")
  func testMarginsWithSpecificEdgeAndLength() async throws {
    let element = Element(tag: "div").margins(.top, .bottom, length: 8)
    let rendered = element.render()
    #expect(rendered.contains("class=\"mt-8 mb-8\""))
  }

  @Test("Margins with auto")
  func testMarginsWithAuto() async throws {
    let element = Element(tag: "div").margins(.horizontal, auto: true)
    let rendered = element.render()
    #expect(rendered.contains("class=\"mx-auto\""))
  }

  @Test("Margins with modifier")
  func testMarginsWithModifier() async throws {
    let element = Element(tag: "div").margins(.leading, length: 6, on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:ml-6\""))
  }

  // MARK: - Padding Tests

  @Test("Padding with default length")
  func testPaddingWithDefaultLength() async throws {
    let element = Element(tag: "div").padding()
    let rendered = element.render()
    #expect(rendered.contains("class=\"p-4\""))
  }

  @Test("Padding with specific edges")
  func testPaddingWithSpecificEdges() async throws {
    let element = Element(tag: "div").padding(.vertical, length: 5)
    let rendered = element.render()
    #expect(rendered.contains("class=\"py-5\""))
  }

  @Test("Padding with modifier")
  func testPaddingWithModifier() async throws {
    let element = Element(tag: "div").padding(.trailing, length: 3, on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:pr-3\""))
  }

  // MARK: - Spacing Tests

  @Test("Spacing with default length")
  func testSpacingWithDefaultLength() async throws {
    let element = Element(tag: "div").spacing()
    let rendered = element.render()
    #expect(rendered.contains("class=\"space-x-4 space-y-4\""))
  }

  @Test("Spacing with horizontal direction")
  func testSpacingWithHorizontalDirection() async throws {
    let element = Element(tag: "div").spacing(.x, length: 6)
    let rendered = element.render()
    #expect(rendered.contains("class=\"space-x-6\""))
  }

  @Test("Spacing with modifier")
  func testSpacingWithModifier() async throws {
    let element = Element(tag: "div").spacing(.y, length: 2, on: .lg)
    let rendered = element.render()
    #expect(rendered.contains("class=\"lg:space-y-2\""))
  }

  // MARK: - Complex Style Tests

  @Test("Combined base styles")
  func testCombinedBaseStyles() async throws {
    let element = Element(tag: "div")
      .frame(width: .full, height: .screen)
      .font(size: .xl, weight: .semibold, color: .gray(._700))
      .cursor(.pointer)
      .margins(.horizontal, auto: true)
      .padding(.all, length: 6)
      .spacing(.both, length: 4)
    let rendered = element.render()
    #expect(
      rendered.contains("class=\"w-full h-screen text-xl font-semibold text-gray-700 cursor-pointer mx-auto p-6 space-x-4 space-y-4\""))
  }

  // MARK: - Edge Cases

  @Test("Frame with no dimensions")
  func testFrameWithNoDimensions() async throws {
    let element = Element(tag: "div").frame()
    let rendered = element.render()
    #expect(!rendered.contains("class="))
  }

  @Test("Font with no properties")
  func testFontWithNoProperties() async throws {
    let element = Element(tag: "div").font()
    let rendered = element.render()
    #expect(!rendered.contains("class="))
  }

  @Test("Margins with nil length and no auto")
  func testMarginsWithNilLength() async throws {
    let element = Element(tag: "div").margins(.top, length: nil)
    let rendered = element.render()
    #expect(!rendered.contains("class="))
  }

  @Test("Padding with nil length")
  func testPaddingWithNilLength() async throws {
    let element = Element(tag: "div").padding(.bottom, length: nil)
    let rendered = element.render()
    #expect(!rendered.contains("class="))
  }

  @Test("Spacing with nil length")
  func testSpacingWithNilLength() async throws {
    let element = Element(tag: "div").spacing(.x, length: nil)
    let rendered = element.render()
    #expect(!rendered.contains("class="))
  }
}
