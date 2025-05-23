import Testing

@testable import WebUI

@Suite("New Responsive Style Tests") struct NewResponsiveTests {
    // MARK: - Basic Responsive Tests

    @Test("Basic responsive font styling with result builder syntax")
    func testBasicResponsiveFontStylingNewSyntax() async throws {
        let element = Element(tag: "div")
            .font(size: .sm)
            .responsive {
                md {
                    font(size: .lg)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("class=\"text-sm md:text-lg\""))
    }

    @Test("Multiple breakpoints with result builder syntax")
    func testMultipleBreakpointsNewSyntax() async throws {
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
        #expect(
            rendered.contains(
                "class=\"bg-gray-100 text-sm sm:text-base md:text-lg md:bg-gray-200 lg:text-xl lg:bg-gray-300\""
            )
        )
    }

    // MARK: - Multiple Style Types Tests

    @Test("Multiple style types with result builder syntax")
    func testMultipleStyleTypesNewSyntax() async throws {
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
        #expect(rendered.contains("class=\"p-2 text-sm md:p-4 md:text-lg md:m-2\""))
    }

    // MARK: - Complex Component Tests

    @Test("Complex component with result builder syntax")
    func testComplexComponentNewSyntax() async throws {
        let button = Button(type: .submit) { "Submit" }
            .background(color: .blue(._500))
            .font(color: .blue(._50))
            .padding(of: 2)
            .rounded(.md)
            .on {
                sm {
                    padding(of: 3)
                }
                md {
                    padding(of: 4)
                    font(size: .lg)
                }
                lg {
                    padding(of: 6)
                    background(color: .blue(._600))
                }
            }

        let rendered = button.render()
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("bg-blue-500"))
        #expect(rendered.contains("text-blue-50"))
        #expect(rendered.contains("p-2"))
        #expect(rendered.contains("rounded-md"))
        #expect(rendered.contains("sm:p-3"))
        #expect(rendered.contains("md:p-4"))
        #expect(rendered.contains("md:text-lg"))
        #expect(rendered.contains("lg:p-6"))
        #expect(rendered.contains("lg:bg-blue-600"))
    }

    // MARK: - Layout Tests

    @Test("Responsive flex layout with result builder syntax")
    func testResponsiveFlexLayoutNewSyntax() async throws {
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
        #expect(rendered.contains("md:flex-row"))
        #expect(rendered.contains("md:justify-between"))
    }

    @Test("Responsive grid layout with result builder syntax")
    func testResponsiveGridLayoutNewSyntax() async throws {
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
        print("RENDERED:", rendered)
        #expect(rendered.contains("grid"))
        #expect(rendered.contains("grid-cols-1"))
        #expect(rendered.contains("md:grid-cols-2"))
        #expect(rendered.contains("lg:grid-cols-3"))
    }

    // MARK: - Visibility Tests

    @Test("Responsive visibility with result builder syntax")
    func testResponsiveVisibilityNewSyntax() async throws {
        let element = Element(tag: "div")
            .hidden()
            .on {
                md {
                    hidden(false)
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("class=\"hidden\""))
        #expect(!rendered.contains("md:hidden"))
    }

    // MARK: - Backward Compatibility Test

    @Test("Test all breakpoint modifiers")
    func testAllBreakpointModifiers() async throws {
        let element = Element(tag: "div")
            .font(size: .sm)
            .on {
                xs {
                    padding(of: 1)
                }
                sm {
                    padding(of: 2)
                }
                md {
                    font(size: .lg)
                }
                lg {
                    margins(of: 3)
                }
                xl {
                    border(of: 1, color: .blue(._500))
                }
                xl2 {
                    background(color: .gray(._200))
                }
            }

        let rendered = element.render()
        #expect(rendered.contains("text-sm"))
        #expect(rendered.contains("xs:p-1"))
        #expect(rendered.contains("sm:p-2"))
        #expect(rendered.contains("md:text-lg"))
        #expect(rendered.contains("lg:m-3"))
        #expect(rendered.contains("xl:border-1"))
        #expect(rendered.contains("xl:border-blue-500"))
        #expect(rendered.contains("2xl:bg-gray-200"))
    }
}
