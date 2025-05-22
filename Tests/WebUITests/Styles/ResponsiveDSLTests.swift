import Testing

@testable import WebUI

@Suite("Responsive DSL Tests") struct ResponsiveDSLTests {
    // MARK: - Basic Tests
    
    @Test("Basic font styling with DSL syntax")
    func testBasicFontStylingWithDSL() async throws {
        let element = Element(tag: "div")
            .font(size: .sm)
            .responsive {
                md {
                    font(size: .lg)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("md:text-lg"))
    }
    
    @Test("Multiple breakpoints with DSL syntax")
    func testMultipleBreakpointsWithDSL() async throws {
        let element = Element(tag: "div")
            .background(color: .gray(._100))
            .font(size: .sm)
            .responsive {
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
    
    @Test("Multiple style types with DSL syntax")
    func testMultipleStyleTypesWithDSL() async throws {
        let element = Element(tag: "div")
            .padding(of: 2)
            .font(size: .sm)
            .responsive {
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
    
    @Test("Flex layout with DSL syntax")
    func testFlexLayoutWithDSL() async throws {
        let element = Element(tag: "div")
            .flex(direction: .column)
            .responsive {
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
    
    @Test("Grid layout with DSL syntax")
    func testGridLayoutWithDSL() async throws {
        let element = Element(tag: "div")
            .grid(columns: 1)
            .responsive {
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
    
    @Test("Legacy syntax with builder parameter")
    func testLegacySyntaxWithBuilderParameter() async throws {
        let element = Element(tag: "div")
            .font(size: .sm)
            .responsive { builder in
                builder.md { innerBuilder in
                    innerBuilder.font(size: .lg)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("md:text-lg"))
    }
}