import Testing

@testable import WebUI

@Suite("Appearance Tests") struct AppearanceTests {
    // MARK: - Opacity Tests

    @Test("Opacity without modifiers")
    func testOpacityWithoutModifiers() async throws {
        let element = Stack().opacity(50)
        let rendered = element.render()
        #expect(rendered.contains("class=\"opacity-50\""))
    }

    // MARK: - Background Color Tests

    @Test("Background color without modifiers")
    func testBackgroundColorWithoutModifiers() async throws {
        let element = Stack().background(color: .blue(._500))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-blue-500\""))
    }

    @Test("Background color with opacity")
    func testBackgroundColorWithOpacity() async throws {
        let element = Stack().background(color: .red(._300, opacity: 0.5))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-red-300/50\""))
    }

    @Test("Custom background color")
    func testCustomBackgroundColor() async throws {
        let element = Stack().background(
            color: .custom("#ff0000", opacity: 0.8))
        let rendered = element.render()
        #expect(rendered.contains("class=\"bg-[#ff0000]/80\""))
    }

    // MARK: - Border Tests

    @Test("Border with width and style")
    func testBorderWithWidthAndStyle() async throws {
        let element = Stack().border(of: 2, style: .solid)
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-2 border-solid\""))
    }

    @Test("Border with radius")
    func testBorderWithRadius() async throws {
        let element = Stack().rounded(.md)
        let rendered = element.render()
        #expect(rendered.contains("class=\"rounded-md\""))
    }

    @Test("Border with radius on just one side")
    func testBorderWithOneSidedRadius() async throws {
        let element = Stack().rounded(.full, .topLeft)
        let rendered = element.render()
        #expect(rendered.contains("class=\"rounded-tl-full\""))
    }

    @Test("Border with specific edge and color")
    func testBorderWithEdgeAndColor() async throws {
        let element = Stack().border(at: .top, color: .blue(._500))
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-t border-blue-500\""))
    }

    @Test("Border with divide style")
    func testBorderWithDivideStyle() async throws {
        let element = Stack().border(of: 1, at: .horizontal, style: .divide)
        let rendered = element.render()
        #expect(rendered.contains("class=\"divide-x-1\""))
    }

    // MARK: - Outline Tests

    @Test("Outline with width and color")
    func testOutlineWithWidthAndColor() async throws {
        let element = Stack().outline(of: 2, color: .purple(._600))
        let rendered = element.render()
        #expect(rendered.contains("class=\"outline-2 outline-purple-600\""))
    }

    // MARK: - Shadow Tests

    @Test("Shadow with size")
    func testShadowWithSize() async throws {
        let element = Stack().shadow(size: .lg)
        let rendered = element.render()
        #expect(rendered.contains("class=\"shadow-lg\""))
    }

    // MARK: - Ring Tests

    @Test("Ring with default size")
    func testRingWithDefaultSize() async throws {
        let element = Stack().ring()
        let rendered = element.render()
        #expect(rendered.contains("class=\"ring-1\""))
    }

    // MARK: - Flex Tests

    @Test("Flex with direction and justify")
    func testFlexWithDirectionAndJustify() async throws {
        let element = Stack().flex(direction: .row, justify: .between)
        let rendered = element.render()
        #expect(rendered.contains("class=\"flex flex-row justify-between\""))
    }

    @Test("Flex with align and grow")
    func testFlexWithAlignAndGrow() async throws {
        let element = Stack().flex(align: .center, grow: .one)
        let rendered = element.render()
        #expect(rendered.contains("class=\"flex items-center flex-1\""))
    }

    // MARK: - Hidden Tests

    @Test("Hidden element")
    func testHiddenElement() async throws {
        let element = Stack().hidden()
        let rendered = element.render()
        #expect(rendered.contains("class=\"hidden\""))
    }

    @Test("Not hidden")
    func testNotHidden() async throws {
        let element = Stack().hidden(false)
        let rendered = element.render()
        #expect(!rendered.contains("class=\"hidden\""))
    }

    // MARK: - Display Tests

    @Test("Display element as block")
    func testDisplayAsBlock() async throws {
        let element = Text("Test content").display(.block)
        let rendered = element.render()
        #expect(rendered.contains("class=\"display-block\""))
    }

    // MARK: - Complex Appearance Tests

    @Test("Combined appearance styles")
    func testCombinedAppearanceStyles() async throws {
        let element = Stack()
            .background(color: .blue(._600))
            .border(of: 1, style: .solid, color: .blue(._800))
            .flex(direction: .row, justify: .center)
        let rendered = element.render()
        #expect(
            rendered.contains(
                "class=\"bg-blue-600 border-1 border-solid border-blue-800 flex flex-row justify-center\""
            )
        )
    }

    // MARK: - Edge Cases

    @Test("Empty modifiers")
    func testEmptyModifiers() async throws {
        let element = Stack().border(of: 2)
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-2\""))
    }

    @Test("Border with No Width")
    func testBorderWithNoWidth() async throws {
        let element = Stack().border(
            at: .bottom, color: .neutral(._800, opacity: 0.5))
        let rendered = element.render()
        #expect(rendered.contains("class=\"border-b border-neutral-800/50\""))
    }

    @Test("Invalid opacity value")
    func testInvalidOpacityValue() async throws {
        let element = Stack().opacity(150)
        let rendered = element.render()
        #expect(rendered.contains("class=\"opacity-150\""))
    }

    @Test("Custom color with no opacity")
    func testCustomColorNoOpacity() async throws {
        let element = Stack().background(color: .custom("rgb(255, 0, 0)"))
        let rendered = element.render()
        #expect(rendered.contains(#"class="bg-[rgb(255, 0, 0)]""#))
    }
}
