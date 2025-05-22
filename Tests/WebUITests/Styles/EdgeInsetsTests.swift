import Testing

@testable import WebUI

@Suite("EdgeInsets Tests") struct EdgeInsetsTests {

    // MARK: - EdgeInsets Initialization Tests

    @Test("EdgeInsets with specific values for each edge")
    func testEdgeInsetsWithSpecificValues() async throws {
        let insets = EdgeInsets(top: 4, leading: 6, bottom: 8, trailing: 6)
        #expect(insets.top == 4)
        #expect(insets.leading == 6)
        #expect(insets.bottom == 8)
        #expect(insets.trailing == 6)
    }

    @Test("EdgeInsets with same value for all edges")
    func testEdgeInsetsWithSameValue() async throws {
        let insets = EdgeInsets(all: 5)
        #expect(insets.top == 5)
        #expect(insets.leading == 5)
        #expect(insets.bottom == 5)
        #expect(insets.trailing == 5)
    }

    @Test("EdgeInsets with vertical and horizontal values")
    func testEdgeInsetsWithVerticalHorizontal() async throws {
        let insets = EdgeInsets(vertical: 3, horizontal: 8)
        #expect(insets.top == 3)
        #expect(insets.leading == 8)
        #expect(insets.bottom == 3)
        #expect(insets.trailing == 8)
    }

    // MARK: - Padding Tests

    @Test("Padding with EdgeInsets")
    func testPaddingWithEdgeInsets() async throws {
        let element = Element(tag: "div").padding(EdgeInsets(top: 4, leading: 6, bottom: 8, trailing: 6))
        let rendered = element.render()
        #expect(rendered.contains("pt-4"))
        #expect(rendered.contains("pl-6"))
        #expect(rendered.contains("pb-8"))
        #expect(rendered.contains("pr-6"))
    }

    @Test("Padding with uniform EdgeInsets")
    func testPaddingWithUniformEdgeInsets() async throws {
        let element = Element(tag: "div").padding(EdgeInsets(all: 5))
        let rendered = element.render()
        #expect(rendered.contains("pt-5"))
        #expect(rendered.contains("pl-5"))
        #expect(rendered.contains("pb-5"))
        #expect(rendered.contains("pr-5"))
    }

    @Test("Padding with EdgeInsets and modifiers")
    func testPaddingWithEdgeInsetsAndModifiers() async throws {
        let element = Element(tag: "div").padding(EdgeInsets(vertical: 3, horizontal: 8), on: .hover, .md)
        let rendered = element.render()
        #expect(rendered.contains("hover:md:pt-3"))
        #expect(rendered.contains("hover:md:pl-8"))
        #expect(rendered.contains("hover:md:pb-3"))
        #expect(rendered.contains("hover:md:pr-8"))
    }

    // MARK: - Margins Tests

    @Test("Margins with EdgeInsets")
    func testMarginsWithEdgeInsets() async throws {
        let element = Element(tag: "div").margins(EdgeInsets(top: 2, leading: 4, bottom: 6, trailing: 8))
        let rendered = element.render()
        #expect(rendered.contains("mt-2"))
        #expect(rendered.contains("ml-4"))
        #expect(rendered.contains("mb-6"))
        #expect(rendered.contains("mr-8"))
    }

    @Test("Margins with uniform EdgeInsets")
    func testMarginsWithUniformEdgeInsets() async throws {
        let element = Element(tag: "div").margins(EdgeInsets(all: 4))
        let rendered = element.render()
        #expect(rendered.contains("mt-4"))
        #expect(rendered.contains("ml-4"))
        #expect(rendered.contains("mb-4"))
        #expect(rendered.contains("mr-4"))
    }

    @Test("Auto margins with EdgeInsets")
    func testAutoMarginsWithEdgeInsets() async throws {
        let element = Element(tag: "div").margins(EdgeInsets(vertical: 0, horizontal: 0), auto: true)
        let rendered = element.render()
        #expect(rendered.contains("mt-auto"))
        #expect(rendered.contains("ml-auto"))
        #expect(rendered.contains("mb-auto"))
        #expect(rendered.contains("mr-auto"))
    }

    @Test("Margins with EdgeInsets and modifiers")
    func testMarginsWithEdgeInsetsAndModifiers() async throws {
        let element = Element(tag: "div").margins(EdgeInsets(all: 3), on: .lg)
        let rendered = element.render()
        #expect(rendered.contains("lg:mt-3"))
        #expect(rendered.contains("lg:ml-3"))
        #expect(rendered.contains("lg:mb-3"))
        #expect(rendered.contains("lg:mr-3"))
    }

    // MARK: - Border Tests

    @Test("Border with EdgeInsets")
    func testBorderWithEdgeInsets() async throws {
        let element = Element(tag: "div").border(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
        let rendered = element.render()
        #expect(rendered.contains("border-t-1"))
        #expect(rendered.contains("border-l-2"))
        #expect(rendered.contains("border-b-3"))
        #expect(rendered.contains("border-r-4"))
    }

    @Test("Border with EdgeInsets and style")
    func testBorderWithEdgeInsetsAndStyle() async throws {
        let element = Element(tag: "div").border(EdgeInsets(all: 2), style: .dashed)
        let rendered = element.render()
        #expect(rendered.contains("border-t-2"))
        #expect(rendered.contains("border-l-2"))
        #expect(rendered.contains("border-b-2"))
        #expect(rendered.contains("border-r-2"))
        #expect(rendered.contains("border-dashed"))
    }

    @Test("Border with EdgeInsets, style, and color")
    func testBorderWithEdgeInsetsStyleAndColor() async throws {
        let element = Element(tag: "div").border(
            EdgeInsets(vertical: 1, horizontal: 2),
            style: .solid,
            color: .blue(._500)
        )
        let rendered = element.render()
        #expect(rendered.contains("border-t-1"))
        #expect(rendered.contains("border-l-2"))
        #expect(rendered.contains("border-b-1"))
        #expect(rendered.contains("border-r-2"))
        #expect(rendered.contains("border-solid"))
        #expect(rendered.contains("border-blue-500"))
    }

    @Test("Border with EdgeInsets and modifiers")
    func testBorderWithEdgeInsetsAndModifiers() async throws {
        let element = Element(tag: "div").border(EdgeInsets(all: 1), on: .hover)
        let rendered = element.render()
        #expect(rendered.contains("hover:border-t-1"))
        #expect(rendered.contains("hover:border-l-1"))
        #expect(rendered.contains("hover:border-b-1"))
        #expect(rendered.contains("hover:border-r-1"))
    }

    // MARK: - Position Tests

    @Test("Position with EdgeInsets")
    func testPositionWithEdgeInsets() async throws {
        let element = Element(tag: "div").position(insets: EdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 12))
        let rendered = element.render()
        #expect(rendered.contains("top-0"))
        #expect(rendered.contains("left-4"))
        #expect(rendered.contains("bottom-8"))
        #expect(rendered.contains("right-12"))
    }

    @Test("Position with type and EdgeInsets")
    func testPositionWithTypeAndEdgeInsets() async throws {
        let element = Element(tag: "div").position(.absolute, insets: EdgeInsets(all: 0))
        let rendered = element.render()
        #expect(rendered.contains("absolute"))
        #expect(rendered.contains("top-0"))
        #expect(rendered.contains("left-0"))
        #expect(rendered.contains("bottom-0"))
        #expect(rendered.contains("right-0"))
    }

    @Test("Position with EdgeInsets and modifiers")
    func testPositionWithEdgeInsetsAndModifiers() async throws {
        let element = Element(tag: "div").position(.sticky, insets: EdgeInsets(vertical: 0, horizontal: 4), on: .lg)
        let rendered = element.render()
        #expect(rendered.contains("lg:sticky"))
        #expect(rendered.contains("lg:top-0"))
        #expect(rendered.contains("lg:left-4"))
        #expect(rendered.contains("lg:bottom-0"))
        #expect(rendered.contains("lg:right-4"))
    }

    // MARK: - Responsive Tests

    @Test("Element with responsive padding EdgeInsets")
    func testElementWithResponsivePaddingEdgeInsets() async throws {
        let element = Element(tag: "div").responsive {
            md {
                padding(EdgeInsets(top: 2, leading: 4, bottom: 6, trailing: 8))
            }
        }
        let rendered = element.render()
        #expect(rendered.contains("md:pt-2"))
        #expect(rendered.contains("md:pl-4"))
        #expect(rendered.contains("md:pb-6"))
        #expect(rendered.contains("md:pr-8"))
    }

    @Test("Element with responsive margins EdgeInsets")
    func testElementWithResponsiveMarginsEdgeInsets() async throws {
        let element = Element(tag: "div").responsive {
            sm {
                margins(EdgeInsets(all: 5))
            }
        }
        let rendered = element.render()
        #expect(rendered.contains("sm:mt-5"))
        #expect(rendered.contains("sm:ml-5"))
        #expect(rendered.contains("sm:mb-5"))
        #expect(rendered.contains("sm:mr-5"))
    }

    @Test("Element with responsive auto margins EdgeInsets")
    func testElementWithResponsiveAutoMarginsEdgeInsets() async throws {
        let element = Element(tag: "div").responsive {
            lg {
                margins(EdgeInsets(vertical: 0, horizontal: 0), auto: true)
            }
        }
        let rendered = element.render()
        #expect(rendered.contains("lg:mt-auto"))
        #expect(rendered.contains("lg:ml-auto"))
        #expect(rendered.contains("lg:mb-auto"))
        #expect(rendered.contains("lg:mr-auto"))
    }

    @Test("Element with responsive border EdgeInsets")
    func testElementWithResponsiveBorderEdgeInsets() async throws {
        let element = Element(tag: "div").responsive {
            xl {
                border(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4), style: .solid, color: .gray(._300))
            }
        }
        let rendered = element.render()
        #expect(rendered.contains("xl:border-t-1"))
        #expect(rendered.contains("xl:border-l-2"))
        #expect(rendered.contains("xl:border-b-3"))
        #expect(rendered.contains("xl:border-r-4"))
        #expect(rendered.contains("xl:border-solid"))
        #expect(rendered.contains("xl:border-gray-300"))
    }

    @Test("Element with responsive position EdgeInsets")
    func testElementWithResponsivePositionEdgeInsets() async throws {
        let element = Element(tag: "div").responsive {
            lg {
                position(.fixed, insets: EdgeInsets(all: 0))
            }
        }
        let rendered = element.render()
        #expect(rendered.contains("lg:fixed"))
        #expect(rendered.contains("lg:top-0"))
        #expect(rendered.contains("lg:left-0"))
        #expect(rendered.contains("lg:bottom-0"))
        #expect(rendered.contains("lg:right-0"))
    }

    // MARK: - Complex Usage Tests

    @Test("Complex element with multiple EdgeInsets usages")
    func testComplexElementWithMultipleEdgeInsetsUsages() async throws {
        let element = Element(tag: "div")
            .padding(EdgeInsets(vertical: 4, horizontal: 8))
            .margins(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
            .border(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0), style: .solid, color: .gray(._200))
            .position(.relative, insets: EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))

        let rendered = element.render()

        // Padding assertions
        #expect(rendered.contains("pt-4"))
        #expect(rendered.contains("pl-8"))
        #expect(rendered.contains("pb-4"))
        #expect(rendered.contains("pr-8"))

        // Margins assertions
        #expect(rendered.contains("mt-2"))
        #expect(rendered.contains("ml-0"))
        #expect(rendered.contains("mb-2"))
        #expect(rendered.contains("mr-0"))

        // Border assertions
        #expect(rendered.contains("border-t-1"))
        #expect(rendered.contains("border-l-0"))
        #expect(rendered.contains("border-b-1"))
        #expect(rendered.contains("border-r-0"))
        #expect(rendered.contains("border-solid"))
        #expect(rendered.contains("border-gray-200"))

        // Position assertions
        #expect(rendered.contains("relative"))
        #expect(rendered.contains("top-2"))
        #expect(rendered.contains("left-0"))
        #expect(rendered.contains("bottom-0"))
        #expect(rendered.contains("right-0"))
    }
}
