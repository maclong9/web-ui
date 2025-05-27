import Testing

@testable import WebUI
import struct WebUI.EdgeInsets

@Suite("Base Style Tests") struct BaseStyleTests {
    // MARK: - Sizing Tests

    @Test("Frame with fixed width and height")
    func testFrameWithFixedDimensions() async throws {
        let element = Stack().frame(width: .spacing(100), height: .spacing(200))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-100 h-200\""))
    }

    // MARK: - EdgeInsets Margin/Padding Tests

    @Test("Padding with EdgeInsets uniform")
    func testPaddingWithEdgeInsetsUniform() async throws {
        let element = Stack().padding(EdgeInsets(3))
        let rendered = element.render()
        #expect(rendered.contains("class=\"p-3\""))
    }

    @Test("Padding with EdgeInsets vertical/horizontal")
    func testPaddingWithEdgeInsetsVerticalHorizontal() async throws {
        let element = Stack().padding(EdgeInsets(vertical: 2, horizontal: 4))
        let rendered = element.render()
        #expect(rendered.contains("class=\"pt-2 pl-4 pb-2 pr-4\""))
    }

    @Test("Padding with EdgeInsets per-edge")
    func testPaddingWithEdgeInsetsPerEdge() async throws {
        let element = Stack().padding(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
        let rendered = element.render()
        #expect(rendered.contains("class=\"pt-1 pl-2 pb-3 pr-4\""))
    }

    @Test("Margins with EdgeInsets uniform")
    func testMarginsWithEdgeInsetsUniform() async throws {
        let element = Stack().margins(EdgeInsets(5))
        let rendered = element.render()
        #expect(rendered.contains("class=\"m-5\""))
    }

    @Test("Margins with EdgeInsets vertical/horizontal")
    func testMarginsWithEdgeInsetsVerticalHorizontal() async throws {
        let element = Stack().margins(EdgeInsets(vertical: 2, horizontal: 6))
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-2 ml-6 mb-2 mr-6\""))
    }

    @Test("Margins with EdgeInsets per-edge")
    func testMarginsWithEdgeInsetsPerEdge() async throws {
        let element = Stack().margins(EdgeInsets(top: 1, leading: 0, bottom: 2, trailing: 3))
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-1 mb-2 mr-3\""))
        #expect(!rendered.contains("ml-0"))
    }

    @Test("Frame with fractional width")
    func testFrameWithFractionalWidth() async throws {
        let element = Stack().frame(width: .fraction(1, 2))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-1/2\""))
    }

    @Test("Frame with Int fraction extension")
    func testFrameWithIntFractionExtension() async throws {
        let element = Stack().frame(width: 1.fraction(4), height: 3.fraction(4))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-1/4 h-3/4\""))
    }

    @Test("Frame with min and max dimensions")
    func testFrameWithMinMaxDimensions() async throws {
        let element = Stack().frame(minWidth: .min, maxHeight: .fit)
        let rendered = element.render()
        #expect(rendered.contains("class=\"min-w-min max-h-fit\""))
    }

    @Test("Frame with custom dimension")
    func testFrameWithCustomDimension() async throws {
        let element = Stack().frame(height: .custom("50vh"))
        let rendered = element.render()
        #expect(rendered.contains("class=\"h-[50vh]\""))
    }

    @Test("Frame with CGFloat values")
    func testFrameWithCGFloatValues() async throws {
        let element = Stack().frame(width: 120, height: 80)
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-120 h-80\""))
    }

    @Test("Frame with convenience extensions")
    func testFrameWithConvenienceExtensions() async throws {
        let element = Stack().frame(
            width: 4.spacing,
            height: 2.fraction(3),
            minWidth: 30.ch
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-4 h-2/3 min-w-[30ch]\""))
    }

    @Test("Frame with container size presets")
    func testFrameWithContainerSizePresets() async throws {
        let element = Stack().frame(
            width: .container(.medium),
            maxWidth: .xl2
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-md max-w-2xl\""))
    }

    @Test("Size method for square dimensions")
    func testSizeMethodForSquareDimensions() async throws {
        let element = Stack().size(.full)
        let rendered = element.render()
        #expect(rendered.contains("class=\"size-full\""))
    }

    @Test("Size method with different sizing values")
    func testSizeMethodWithDifferentValues() async throws {
        let element = Stack().size(.min)
        let rendered = element.render()
        #expect(rendered.contains("class=\"size-min\""))

        let element2 = Stack().size(.fraction(1, 3))
        let rendered2 = element2.render()
        #expect(rendered2.contains("class=\"size-1/3\""))
    }

    @Test("Aspect ratio with custom dimensions")
    func testAspectRatioWithCustomDimensions() async throws {
        let element = Stack().aspectRatio(16, 9)
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-[1.7777777777777777]\""))
    }

    @Test("Square aspect ratio")
    func testSquareAspectRatio() async throws {
        let element = Stack().aspectRatio()
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-square\""))
    }

    @Test("Video aspect ratio")
    func testVideoAspectRatio() async throws {
        let element = Stack().aspectRatioVideo()
        let rendered = element.render()
        #expect(rendered.contains("class=\"aspect-video\""))
    }

    @Test("Frame with viewport units")
    func testFrameWithViewportUnits() async throws {
        let element = Stack().frame(
            width: .dvw,
            height: .viewport(.dynamicViewHeight)
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-dvw h-dvh\""))
    }

    @Test("Frame with content sizing")
    func testFrameWithContentSizing() async throws {
        let element = Stack().frame(
            width: .content(.min),
            height: .content(.max),
            maxWidth: .content(.fit)
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-min h-max max-w-fit\""))
    }

    @Test("Frame with constants")
    func testFrameWithConstants() async throws {
        let element = Stack().frame(
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
        let element = Stack().font(size: .lg, weight: .bold)
        let rendered = element.render()
        #expect(rendered.contains("class=\"text-lg font-bold\""))
    }

    @Test("Font with alignment and color")
    func testFontWithAlignmentAndColor() async throws {
        let element = Stack().font(alignment: .center, color: .blue(._500))
        let rendered = element.render()
        #expect(rendered.contains("class=\"text-center text-blue-500\""))
    }

    @Test("Font with tracking and leading")
    func testFontWithTrackingAndLeading() async throws {
        let element = Stack().font(tracking: .wide, leading: .loose)
        let rendered = element.render()
        #expect(rendered.contains("class=\"tracking-wide leading-loose\""))
    }

    @Test("Font with decoration and wrapping")
    func testFontWithDecorationAndWrapping() async throws {
        let element = Stack().font(decoration: .underline, wrapping: .nowrap)
        let rendered = element.render()
        #expect(rendered.contains("class=\"underline text-nowrap\""))
    }

    @Test("Font with extra-large size")
    func testFontWithExtraLargeSize() async throws {
        let element = Stack().font(size: .xl5)
        let rendered = element.render()
        #expect(rendered.contains("class=\"text-5xl\""))
    }

    // MARK: - Cursor Tests

    @Test("Cursor with pointer type")
    func testCursorWithPointerType() async throws {
        let element = Stack().cursor(.pointer)
        let rendered = element.render()
        #expect(rendered.contains("class=\"cursor-pointer\""))
    }

    // MARK: - Margin Tests

    @Test("Margins with default length")
    func testMarginsWithDefaultLength() async throws {
        let element = Stack().margins()
        let rendered = element.render()
        #expect(rendered.contains("class=\"m-4\""))
    }

    @Test("Margins with specific edge and length")
    func testMarginsWithSpecificEdgeAndLength() async throws {
        let element = Stack().margins(of: 8, at: .top, .bottom)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-8 mb-8\""))
    }

    @Test("Margins with auto")
    func testMarginsWithAuto() async throws {
        let element = Stack().margins(at: .horizontal, auto: true)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mx-auto\""))
    }

    @Test("Margins with at parameter only")
    func testMarginsWithAtParameterOnly() async throws {
        let element = Stack().margins(at: .top)
        let rendered = element.render()
        #expect(rendered.contains("class=\"mt-4\""))
    }

    // MARK: - Padding Tests

    @Test("Padding with default length")
    func testPaddingWithDefaultLength() async throws {
        let element = Stack().padding()
        let rendered = element.render()
        #expect(rendered.contains("class=\"p-4\""))
    }

    @Test("Padding with specific edges")
    func testPaddingWithSpecificEdges() async throws {
        let element = Stack().padding(of: 5, at: .vertical)
        let rendered = element.render()
        #expect(rendered.contains("class=\"py-5\""))
    }

    @Test("Padding with at parameter only")
    func testPaddingWithAtParameterOnly() async throws {
        let element = Stack().padding(at: .horizontal)
        let rendered = element.render()
        #expect(rendered.contains("class=\"px-4\""))
    }

    // MARK: - Spacing Tests

    @Test("Spacing with default length")
    func testSpacingWithDefaultLength() async throws {
        let element = Stack().spacing()
        let rendered = element.render()
        #expect(rendered.contains("class=\"space-x-4 space-y-4\""))
    }

    @Test("Spacing with horizontal direction")
    func testSpacingWithHorizontalDirection() async throws {
        let element = Stack().spacing(of: 6, along: .horizontal)
        let rendered = element.render()
        #expect(rendered.contains("class=\"space-x-6\""))
    }

    @Test("Spacing with along parameter only")
    func testSpacingWithAlongParameterOnly() async throws {
        let element = Stack().spacing(along: .vertical)
        let rendered = element.render()
        #expect(rendered.contains("class=\"space-y-4\""))
    }

    // MARK: - Complex Style Tests

    @Test("Combined base styles")
    func testCombinedBaseStyles() async throws {
        let element = Stack()
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

    @Test("Frame with min and max CGFloat values")
    func testFrameWithMinMaxCGFloatValues() async throws {
        let element = Stack().frame(
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
        let element = Stack().frame()
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Frame with container size static constants")
    func testFrameWithContainerSizeStaticConstants() async throws {
        let element = Stack().frame(
            width: .xs,
            maxWidth: .xl3
        )
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-xs max-w-3xl\""))
    }

    @Test("Frame with character sizing")
    func testFrameWithCharacterSizing() async throws {
        let element = Stack().frame(width: .character(80))
        let rendered = element.render()
        #expect(rendered.contains("class=\"w-[80ch]\""))

        let element2 = Stack().frame(width: 40.ch)
        let rendered2 = element2.render()
        #expect(rendered2.contains("class=\"w-[40ch]\""))
    }

    @Test("Font with no properties")
    func testFontWithNoProperties() async throws {
        let element = Stack().font()
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Margins with nil length and no auto")
    func testMarginsWithNilLength() async throws {
        let element = Stack().margins(of: nil, at: .top)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Padding with nil length")
    func testPaddingWithNilLength() async throws {
        let element = Stack().padding(of: nil, at: .bottom)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }

    @Test("Spacing with nil length")
    func testSpacingWithNilLength() async throws {
        let element = Stack().spacing(of: nil, along: .vertical)
        let rendered = element.render()
        #expect(!rendered.contains("class="))
    }
}
