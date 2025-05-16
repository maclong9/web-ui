import Testing

@testable import WebUI

@Suite("Base Style Tests") struct BaseStyleTests {
    // MARK: - Sizing Tests

    @Test("Frame with fixed width and height")
    func testFrameWithFixedDimensions() async throws {
        let element = Element(tag: "div").frame(width: .spacing(100), height: .spacing(200))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-100 h-200\""))
    }

    @Test("Frame with fractional width")
    func testFrameWithFractionalWidth() async throws {
        let element = Element(tag: "div").frame(width: .fraction(1, 2))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-1/2\""))
    }

    @Test("Frame with Int fraction extension")
    func testFrameWithIntFractionExtension() async throws {
        let element = Element(tag: "div").frame(width: 1.fraction(4), height: 3.fraction(4))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-1/4 h-3/4\""))
    }

    @Test("Frame with min and max dimensions")
    func testFrameWithMinMaxDimensions() async throws {
        let element = Element(tag: "div").frame(minWidth: .min, maxHeight: .fit)
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

    @Test("Frame with CGFloat values")
    func testFrameWithCGFloatValues() async throws {
        let element = Element(tag: "div").frame(width: 120, height: 80)
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-120 h-80\""))
    }

    @Test("Frame with convenience extensions")
    func testFrameWithConvenienceExtensions() async throws {
        let element = Element(tag: "div").frame(
            width: 4.spacing,
            height: 2.fraction(3),
            minWidth: 30.ch
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-4 h-2/3 min-w-[30ch]\""))
    }

    @Test("Frame with container size presets")
    func testFrameWithContainerSizePresets() async throws {
        let element = Element(tag: "div").frame(
            width: .container(.medium),
            maxWidth: .xl2
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-md max-w-2xl\""))
    }

    @Test("Size method for square dimensions")
    func testSizeMethodForSquareDimensions() async throws {
        let element = Element(tag: "div").size(.full)
        let rendered = element.render()
        #expect(rendered.contains("class=\"size-full\""))
    }

    @Test("Size method with modifiers")
    func testSizeMethodWithModifiers() async throws {
        let element = Element(tag: "div").size(16.spacing, on: .hover, .lg)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:lg:size-16\""))
    }

    @Test("Size method with different sizing values")
    func testSizeMethodWithDifferentValues() async throws {
        let element = Element(tag: "div").size(.min)
        let rendered = element.render()
        #expect(rendered.contains("class=\"size-min\""))

        let element2 = Element(tag: "div").size(.fraction(1, 3))
        let rendered2 = element2.render()
        #expect(rendered2.contains("class=\"size-1/3\""))
    }

    @Test("Aspect ratio with custom dimensions")
    func testAspectRatioWithCustomDimensions() async throws {
        let element = Element(tag: "div").aspectRatio(16, 9)
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-[1.7777777777777777]\""))
    }

    @Test("Square aspect ratio")
    func testSquareAspectRatio() async throws {
        let element = Element(tag: "div").aspectRatio()
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-square\""))
    }

    @Test("Video aspect ratio")
    func testVideoAspectRatio() async throws {
        let element = Element(tag: "div").aspectRatioVideo()
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-video\""))
    }

    @Test("Aspect ratio with modifiers")
    func testAspectRatioWithModifiers() async throws {
        let element = Element(tag: "div").aspectRatio(4, 3, on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:aspect-[1.3333333333333333]\""))
    }

    @Test("Frame with viewport units")
    func testFrameWithViewportUnits() async throws {
        let element = Element(tag: "div").frame(
            width: .dvw,
            height: .viewport(.dynamicViewHeight)
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-dvw h-dvh\""))
    }

    @Test("Frame with content sizing")
    func testFrameWithContentSizing() async throws {
        let element = Element(tag: "div").frame(
            width: .content(.min),
            height: .content(.max),
            maxWidth: .content(.fit)
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-min h-max max-w-fit\""))
    }

    @Test("Frame with constants")
    func testFrameWithConstants() async throws {
        let element = Element(tag: "div").frame(
            width: .constant(.auto),
            height: .constant(.full),
            minWidth: .constant(.px)
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-auto h-full min-w-px\""))
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
        let element = Element(tag: "div").margins(of: 8, at: .top, .bottom)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-8 mb-8\""))
    }

    @Test("Margins with auto")
    func testMarginsWithAuto() async throws {
        let element = Element(tag: "div").margins(at: .horizontal, auto: true)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mx-auto\""))
    }

    @Test("Margins with at parameter only")
    func testMarginsWithAtParameterOnly() async throws {
        let element = Element(tag: "div").margins(at: .top)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-4\""))
    }

    @Test("Margins with modifier")
    func testMarginsWithModifier() async throws {
        let element = Element(tag: "div").margins(of: 6, at: .leading, on: .md)
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
        let element = Element(tag: "div").padding(of: 5, at: .vertical)
        let rendered = element.render()
        #expect(rendered.contains("class=\"py-5\""))
    }

    @Test("Padding with at parameter only")
    func testPaddingWithAtParameterOnly() async throws {
        let element = Element(tag: "div").padding(at: .horizontal)
        let rendered = element.render()
        #expect(rendered.contains("class=\"px-4\""))
    }

    @Test("Padding with modifier")
    func testPaddingWithModifier() async throws {
        let element = Element(tag: "div").padding(of: 3, at: .trailing, on: .hover)
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
        let element = Element(tag: "div").spacing(of: 6, along: .x)
        let rendered = element.render()
        #expect(rendered.contains("class=\"space-x-6\""))
    }

    @Test("Spacing with along parameter only")
    func testSpacingWithAlongParameterOnly() async throws {
        let element = Element(tag: "div").spacing(along: .y)
        let rendered = element.render()
        #expect(rendered.contains("class=\"space-y-4\""))
    }

    @Test("Spacing with modifier")
    func testSpacingWithModifier() async throws {
        let element = Element(tag: "div").spacing(of: 2, along: .y, on: .lg)
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
            .margins(of: 0, at: .horizontal, auto: true)
            .padding(of: 6, at: .all)
            .spacing(of: 4, along: .both)
        let rendered = element.render()
        #expect(
            rendered.contains(
                "class=\"w-full h-screen text-xl font-semibold text-gray-700 cursor-pointer mx-auto p-6 space-x-4 space-y-4\""
            )
        )
    }

    @Test("Combined sizing styles")
    func testCombinedSizingStyles() async throws {
        let element = Element(tag: "div")
            .frame(width: .container(.extraLarge), minHeight: 50.spacing)
            .size(24.spacing, on: .sm)
            .aspectRatioVideo(on: .lg)
        let rendered = element.render()
        #expect(
            rendered.contains(
                "class=\"w-xl min-h-50 sm:size-24 lg:aspect-video\""
            )
        )
    }

    @Test("Frame with min and max CGFloat values")
    func testFrameWithMinMaxCGFloatValues() async throws {
        let element = Element(tag: "div").frame(
            width: 100,
            height: 80,
            minWidth: 50,
            maxWidth: 200,
            minHeight: 40,
            maxHeight: 160
        )
        let rendered = element.render()
        #expect(
            rendered.contains(
                "class=\"w-100 h-80 min-w-50 max-w-200 min-h-40 max-h-160\""
            )
        )
    }

    // MARK: - Edge Cases

    @Test("Frame with no dimensions")
    func testFrameWithNoDimensions() async throws {
        let element = Element(tag: "div").frame()
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Frame with modifiers on specific dimensions")
    func testFrameWithModifiersOnSpecificDimensions() async throws {
        let element = Element(tag: "div").frame(
            width: .auto,
            maxWidth: .container(.fourExtraLarge),
            on: .md,
            .dark
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"md:dark:w-auto md:dark:max-w-4xl\""))
    }

    @Test("Frame with container size static constants")
    func testFrameWithContainerSizeStaticConstants() async throws {
        let element = Element(tag: "div").frame(
            width: .xs,
            maxWidth: .xl3
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-xs max-w-3xl\""))
    }

    @Test("Frame with character sizing")
    func testFrameWithCharacterSizing() async throws {
        let element = Element(tag: "div").frame(width: .character(80))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-[80ch]\""))

        let element2 = Element(tag: "div").frame(width: 40.ch)
        let rendered2 = element2.render()
        #expect(rendered2.contains("class=\"w-[40ch]\""))
    }

    @Test("Font with no properties")
    func testFontWithNoProperties() async throws {
        let element = Element(tag: "div").font()
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Margins with nil length and no auto")
    func testMarginsWithNilLength() async throws {
        let element = Element(tag: "div").margins(of: nil, at: .top)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Padding with nil length")
    func testPaddingWithNilLength() async throws {
        let element = Element(tag: "div").padding(of: nil, at: .bottom)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Spacing with nil length")
    func testSpacingWithNilLength() async throws {
        let element = Element(tag: "div").spacing(of: nil, along: .x)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }
}
