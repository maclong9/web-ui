import Testing

@testable import WebUI

@Suite("Border Style Operation Tests") struct BorderStyleOperationTests {
    // MARK: - Basic Style Operations Tests

    @Test("Border with default parameters")
    func testBorderWithDefaultParameters() async throws {
        let params = BorderStyleOperation.Parameters()
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-1") || classes.contains("border"))
    }

    @Test("Border with specific width")
    func testBorderWithSpecificWidth() async throws {
        let params = BorderStyleOperation.Parameters(width: 2)
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-2"))
    }

    @Test("Border with specific edge")
    func testBorderWithSpecificEdge() async throws {
        let params = BorderStyleOperation.Parameters(edges: [.top])
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-t-1") || classes.contains("border-t"))
    }

    @Test("Border with style")
    func testBorderWithStyle() async throws {
        let params = BorderStyleOperation.Parameters(style: .dashed)
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-dashed"))
    }

    @Test("Border with color")
    func testBorderWithColor() async throws {
        let params = BorderStyleOperation.Parameters(color: .blue(._500))
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-blue-500"))
    }

    @Test("Border with divide style")
    func testBorderWithDivideStyle() async throws {
        let params = BorderStyleOperation.Parameters(
            width: 2,
            edges: [.horizontal],
            style: .divide
        )
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("divide-x-2"))
    }

    // MARK: - Element Tests

    @Test("Element extension with default parameters")
    func testElementExtensionWithDefaultParameters() async throws {
        let element = Element(tag: "div").border()
        let rendered = element.render()

        #expect(rendered.contains("class=\"border-1\"") || rendered.contains("class=\"border\""))
    }

    @Test("Element extension with specific width")
    func testElementExtensionWithSpecificWidth() async throws {
        let element = Element(tag: "div").border(of: 3)
        let rendered = element.render()

        #expect(rendered.contains("class=\"border-3\""))
    }

    @Test("Element extension with specific edges")
    func testElementExtensionWithSpecificEdges() async throws {
        let element = Element(tag: "div").border(at: .top, .bottom)
        let rendered = element.render()

        #expect(rendered.contains("border-t") && rendered.contains("border-b"))
    }

    @Test("Element extension with color and style")
    func testElementExtensionWithColorAndStyle() async throws {
        let element = Element(tag: "div").border(style: .dotted, color: .red(._300))
        let rendered = element.render()

        #expect(rendered.contains("border-dotted") && rendered.contains("border-red-300"))
    }

    @Test("Element extension with modifiers")
    func testElementExtensionWithModifiers() async throws {
        let element = Element(tag: "div").border(of: 2, color: .blue(._500), on: .hover, .md)
        let rendered = element.render()

        #expect(rendered.contains("hover:md:border-2") && rendered.contains("hover:md:border-blue-500"))
    }

    // MARK: - Responsive Modification Tests

    @Test("Responsive modification with result builder syntax")
    func testResponsiveModificationWithResultBuilderSyntax() async throws {
        let element = Element(tag: "div").responsive {
            sm {
                border(of: 1, color: .gray(._200))
            }
            md {
                border(of: 2, style: .dashed, color: .blue(._500))
            }
        }

        let rendered = element.render()

        #expect(rendered.contains("sm:border-1") && rendered.contains("sm:border-gray-200"))
        #expect(
            rendered.contains("md:border-2") && rendered.contains("md:border-dashed")
                && rendered.contains("md:border-blue-500")
        )
    }

    @Test("Responsive modification with all breakpoints")
    func testResponsiveModificationWithAllBreakpoints() async throws {
        let element = Element(tag: "div").responsive {
            xs {
                border(of: 1)
            }
            sm {
                border(at: .top)
            }
            md {
                border(style: .dashed)
            }
            lg {
                border(color: .gray(._300))
            }
            xl {
                border(of: 2, at: .bottom)
            }
            xl2 {
                border(of: 3, style: .dotted, color: .blue(._500))
            }
        }

        let rendered = element.render()

        #expect(rendered.contains("xs:border-1"))
        #expect(rendered.contains("sm:border-t"))
        #expect(rendered.contains("md:border-dashed"))
        #expect(rendered.contains("lg:border-gray-300"))
        #expect(rendered.contains("xl:border-b-2"))
        #expect(
            rendered.contains("2xl:border-3") && rendered.contains("2xl:border-dotted")
                && rendered.contains("2xl:border-blue-500")
        )
    }

    // MARK: - Complex Scenarios

    @Test("Complex element with multiple border styles")
    func testComplexElementWithMultipleBorderStyles() async throws {
        let element = Element(tag: "div")
            .border(of: 1, at: .horizontal)
            .border(of: 2, at: .vertical, color: .gray(._300))
            .responsive {
                md {
                    border(of: 0, at: .top)
                    border(style: .dashed)
                }
                lg {
                    border(of: 3, color: .blue(._500))
                }
            }

        let rendered = element.render()

        #expect(rendered.contains("border-x-1"))
        #expect(rendered.contains("border-y-2") && rendered.contains("border-gray-300"))
        #expect(rendered.contains("md:border-t-0") && rendered.contains("md:border-dashed"))
        #expect(rendered.contains("lg:border-3") && rendered.contains("lg:border-blue-500"))
    }

    @Test("Element with divide style")
    func testElementWithDivideStyle() async throws {
        let element = Element(tag: "div")
            .border(of: 2, at: .horizontal, style: .divide)
            .responsive {
                md {
                    border(of: 4, at: .vertical, style: .divide)
                }
            }

        let rendered = element.render()

        #expect(rendered.contains("divide-x-2"))
        #expect(rendered.contains("md:divide-y-4"))
    }

    // MARK: - Edge Cases

    @Test("Border with nil width")
    func testBorderWithNilWidth() async throws {
        let params = BorderStyleOperation.Parameters(width: nil, color: .blue(._500))
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border") || classes.contains("border-blue-500"))
    }

    @Test("Border with empty edges")
    func testBorderWithEmptyEdges() async throws {
        let params = BorderStyleOperation.Parameters(edges: [])
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border") || classes.contains("border-1"))
    }
}
