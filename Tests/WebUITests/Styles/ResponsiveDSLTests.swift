import Testing

@testable import WebUI

@Suite("Responsive DSL Tests") struct ResponsiveDSLTests {
    // MARK: - Basic Tests

    @Test("Basic font styling with result builder syntax")
    func testBasicFontStylingWithDSL() async throws {
        let element = Element(tag: "div")
            .font(size: .sm)
            .on {
                md {
                    font(size: .lg)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("md:text-lg"))
    }

    @Test("Multiple breakpoints with result builder syntax")
    func testMultipleBreakpointsWithDSL() async throws {
        let element = Element(tag: "div")
            .background(color: .gray(._100))
            .font(size: .sm)
            .on {
                sm {
                    font(size: .base)
                }
                md {
                    font(size: .lg)
                    background(color: .gray(._200))
                }
                lg {
                    font(size: .xl)
                    background(color: .gray(._300))
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("bg-gray-100"))
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("sm:text-base"))
        #expect(rendered.contains("md:text-lg"))
        #expect(rendered.contains("md:bg-gray-200"))
        #expect(rendered.contains("lg:text-xl"))
        #expect(rendered.contains("lg:bg-gray-300"))
    }

    @Test("Multiple style types with result builder syntax")
    func testMultipleStyleTypesWithDSL() async throws {
        let element = Element(tag: "div")
            .padding(of: 2)
            .font(size: .sm)
            .on {
                md {
                    padding(of: 4)
                    font(size: .lg)
                    margins(of: 2)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("p-2"))
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("md:p-4"))
        #expect(rendered.contains("md:text-lg"))
        #expect(rendered.contains("md:m-2"))
    }

    // MARK: - Layout Tests

    @Test("Flex layout with result builder syntax")
    func testFlexLayoutWithDSL() async throws {
        let element = Element(tag: "div")
            .flex(direction: .column)
            .on {
                md {
                    flex(direction: .row, justify: .between)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("flex"))
        #expect(rendered.contains("flex-col"))
        #expect(rendered.contains("md:flex"))
        #expect(rendered.contains("md:justify-between"))
    }

    @Test("Grid layout with result builder syntax")
    func testGridLayoutWithDSL() async throws {
        let element = Element(tag: "div")
            .grid(columns: 1)
            .on {
                md {
                    grid(columns: 2)
                }
                lg {
                    grid(columns: 3)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("grid"))
        #expect(rendered.contains("grid-cols-1"))
        #expect(rendered.contains("md:grid-cols-2"))
        #expect(rendered.contains("lg:grid-cols-3"))
    }

    // MARK: - Backward Compatibility

    @Test("Test all breakpoint modifiers")
    func testAllBreakpointModifiers() async throws {
        let element = Element(tag: "div")
            .on {
                xs {
                    padding(of: 1)
                }
                sm {
                    font(size: .sm)
                }
                md {
                    background(color: .blue(._300))
                }
                lg {
                    margins(of: 4)
                }
                xl {
                    border(of: 1, color: .gray(._200))
                }
                xl2 {
                    rounded(.lg)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("xs:p-1"))
        #expect(rendered.contains("sm:text-sm"))
        #expect(rendered.contains("md:bg-blue-300"))
        #expect(rendered.contains("lg:m-4"))
        #expect(rendered.contains("xl:border-1"))
        #expect(rendered.contains("xl:border-gray-200"))
        #expect(rendered.contains("2xl:rounded-lg"))
    }
}
