import Testing

@testable import WebUI

@Suite("Appearance Tests") struct AppearanceTests {
    // MARK: - Opacity Tests

    @Test("Opacity without modifiers")
    func testOpacityWithoutModifiers() async throws {
        let element = Element(tag: "div").opacity(50)
        let rendered = element.render()
        #expect(rendered.contains("class=\"opacity-50\""))
    }

    @Test("Opacity with hover modifier")
    func testOpacityWithHoverModifier() async throws {
        let element = Element(tag: "div").opacity(75, on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:opacity-75\""))
    }

    @Test("Opacity with multiple modifiers")
    func testOpacityWithMultipleModifiers() async throws {
        let element = Element(tag: "div").opacity(25, on: .hover, .md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:md:opacity-25\""))
    }

    // MARK: - Background Color Tests

    @Test("Background color without modifiers")
    func testBackgroundColorWithoutModifiers() async throws {
        let element = Element(tag: "div").background(color: .blue(._500))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-blue-500\""))
    }

    @Test("Background color with opacity")
    func testBackgroundColorWithOpacity() async throws {
        let element = Element(tag: "div").background(color: .red(._300, opacity: 0.5))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-red-300/50\""))
    }

    @Test("Background color with hover modifier")
    func testBackgroundColorWithHoverModifier() async throws {
        let element = Element(tag: "div").background(color: .green(._700), on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:bg-green-700\""))
    }

    @Test("Custom background color")
    func testCustomBackgroundColor() async throws {
        let element = Element(tag: "div").background(color: .custom("#ff0000", opacity: 0.8))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-[#ff0000]/80\""))
    }

    // MARK: - Border Tests

    @Test("Border with width and style")
    func testBorderWithWidthAndStyle() async throws {
        let element = Element(tag: "div").border(of: 2, style: .solid)
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-2 border-solid\""))
    }

    @Test("Border with radius")
    func testBorderWithRadius() async throws {
        let element = Element(tag: "div").rounded(.md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"rounded-md\""))
    }

    @Test("Border with radius on just one side")
    func testBorderWithOneSidedRadius() async throws {
        let element = Element(tag: "div").rounded(.full, .topLeft)
        let rendered = element.render()
        #expect(rendered.contains("class=\"rounded-tl-full\""))
    }

    @Test("Border with specific edge and color")
    func testBorderWithEdgeAndColor() async throws {
        let element = Element(tag: "div").border(at: .top, color: .blue(._500))
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-t border-blue-500\""))
    }

    @Test("Border with divide style")
    func testBorderWithDivideStyle() async throws {
        let element = Element(tag: "div").border(of: 1, at: .horizontal, style: .divide)
        let rendered = element.render()
        #expect(rendered.contains("class=\"divide-x-1\""))
    }

    @Test("Border with modifiers")
    func testBorderWithModifiers() async throws {
        let element = Element(tag: "div").border(of: 3, on: .hover, .md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:md:border-3\""))
    }

    // MARK: - Outline Tests

    @Test("Outline with width and color")
    func testOutlineWithWidthAndColor() async throws {
        let element = Element(tag: "div").outline(of: 2, color: .purple(._600))
        let rendered = element.render()
        #expect(rendered.contains("class=\"outline-2 outline-purple-600\""))
    }

    @Test("Outline with style and modifier")
    func testOutlineWithStyleAndModifier() async throws {
        let element = Element(tag: "div").outline(style: .dashed, on: .focus)
        let rendered = element.render()
        #expect(rendered.contains("class=\"focus:outline-dashed\""))
    }

<<<<<<< HEAD
=======
    // MARK: - Shadow Tests

    @Test("Shadow with size")
    func testShadowWithSize() async throws {
        let element = Element(tag: "div").shadow(radius: .lg)
        let rendered = element.render()
        #expect(rendered.contains("class=\"shadow-lg\""))
    }

    @Test("Shadow with color and modifier")
    func testShadowWithColorAndModifier() async throws {
        let element = Element(tag: "div").shadow(color: .gray(._500), radius: .md, on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:shadow-md hover:shadow-gray-500\""))
    }

    // MARK: - Ring Tests

    @Test("Ring with default size")
    func testRingWithDefaultSize() async throws {
        let element = Element(tag: "div").ring()
        let rendered = element.render()
        #expect(rendered.contains("class=\"ring-1\""))
    }

    @Test("Ring with color and modifier")
    func testRingWithColorAndModifier() async throws {
        let element = Element(tag: "div").ring(of: 2, color: .pink(._400), on: .focus)
        let rendered = element.render()
        #expect(rendered.contains("class=\"focus:ring-2 focus:ring-pink-400\""))
    }

>>>>>>> origin/development
    // MARK: - Flex Tests

    @Test("Flex with direction and justify")
    func testFlexWithDirectionAndJustify() async throws {
        let element = Element(tag: "div").flex(direction: .row, justify: .between)
        let rendered = element.render()
        #expect(rendered.contains("class=\"flex flex-row justify-between\""))
    }

    @Test("Flex with align and grow")
    func testFlexWithAlignAndGrow() async throws {
        let element = Element(tag: "div").flex(align: .center, grow: .one)
        let rendered = element.render()
        #expect(rendered.contains("class=\"flex items-center flex-1\""))
    }

    @Test("Flex with modifiers")
    func testFlexWithModifiers() async throws {
        let element = Element(tag: "div").flex(direction: .column, on: .md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"md:flex md:flex-col\""))
    }

    // MARK: - Hidden Tests

    @Test("Hidden element")
    func testHiddenElement() async throws {
        let element = Element(tag: "div").hidden()
        let rendered = element.render()
        #expect(rendered.contains("class=\"hidden\""))
    }

    @Test("Hidden with modifier")
    func testHiddenWithModifier() async throws {
        let element = Element(tag: "div").hidden(true, on: .sm)
        let rendered = element.render()
        #expect(rendered.contains("class=\"sm:hidden\""))
    }

    @Test("Not hidden")
    func testNotHidden() async throws {
        let element = Element(tag: "div").hidden(false)
        let rendered = element.render()
        #expect(!rendered.contains("class=\"hidden\""))
    }

    // MARK: - Display Tests

    @Test("Display element as block")
    func testDisplayAsBlock() async throws {
        let element = Element(tag: "span").display(.block)
        let rendered = element.render()
        #expect(rendered.contains("class=\"display-block\""))
    }

    @Test("Display element as inline-block with hover")
    func testDisplayAsInlineBlockWithHover() async throws {
        let element = Element(tag: "div").display(.inlineBlock, on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("class=\"hover:display-inline-block\""))
    }

    @Test("Display as table on medium screens")
    func testDisplayAsTableOnMedium() async throws {
        let element = Element(tag: "div").display(.table, on: .md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"md:display-table\""))
    }

    // MARK: - Complex Appearance Tests

    @Test("Combined appearance styles")
    func testCombinedAppearanceStyles() async throws {
        let element = Element(tag: "div")
            .background(color: .blue(._600))
            .border(of: 1, style: .solid, color: .blue(._800))
<<<<<<< HEAD
=======
            .shadow(radius: .md)
>>>>>>> origin/development
            .opacity(90, on: .hover)
            .flex(direction: .row, justify: .center)
        let rendered = element.render()
        #expect(
            rendered.contains(
                "class=\"bg-blue-600 border-1 border-solid border-blue-800 hover:opacity-90 flex flex-row justify-center\""
            )
        )
    }

    // MARK: - Edge Cases

    @Test("Empty modifiers")
    func testEmptyModifiers() async throws {
        let element = Element(tag: "div").border(of: 2)
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-2\""))
    }

    @Test("Border with No Width")
    func testBorderWithNoWidth() async throws {
        let element = Element(tag: "div").border(at: .bottom, color: .neutral(._800, opacity: 0.5))
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-b border-neutral-800/50\""))
    }

    @Test("Invalid opacity value")
    func testInvalidOpacityValue() async throws {
        let element = Element(tag: "div").opacity(150)
        let rendered = element.render()
        #expect(rendered.contains("class=\"opacity-150\""))
    }

    @Test("Custom color with no opacity")
    func testCustomColorNoOpacity() async throws {
        let element = Element(tag: "div").background(color: .custom("rgb(255, 0, 0)"))
        let rendered = element.render()
        #expect(rendered.contains(#"class="bg-[rgb(255, 0, 0)]""#))
    }
}
