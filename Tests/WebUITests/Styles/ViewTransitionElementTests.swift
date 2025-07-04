import Testing

@testable import WebUI

@Suite("View Transition Element Integration Tests")
struct ViewTransitionElementTests {

    // MARK: - Basic Element Integration

    @Test("Element with view transition")
    func testElementWithViewTransition() async throws {
        let element = Stack().viewTransition(.fade, duration: 300)
        let rendered = element.render()

        #expect(rendered.contains("view-transition-fade"))
        #expect(rendered.contains("view-transition-duration-300"))
    }

    @Test("Element with view transition name")
    func testElementWithViewTransitionName() async throws {
        let element = Text("Hello").viewTransitionName("text-transition")
        let rendered = element.render()

        #expect(rendered.contains("view-transition-name-text-transition"))
    }

    @Test("Element with fade transition convenience method")
    func testElementWithFadeTransition() async throws {
        let element = Text("Hello").fadeTransition(duration: 500, timing: .easeInOut)
        let rendered = element.render()

        #expect(rendered.contains("view-transition-fade"))
        #expect(rendered.contains("view-transition-duration-500"))
        #expect(rendered.contains("view-transition-timing-ease-in-out"))
    }

    @Test("Element with slide transition convenience method")
    func testElementWithSlideTransition() async throws {
        let element = Stack().slideTransition(.left, duration: 400, timing: .easeOut)
        let rendered = element.render()

        #expect(rendered.contains("view-transition-slide"))
        #expect(rendered.contains("view-transition-slide-left"))
        #expect(rendered.contains("view-transition-duration-400"))
        #expect(rendered.contains("view-transition-timing-ease-out"))
    }

    @Test("Element with scale transition convenience method")
    func testElementWithScaleTransition() async throws {
        let element = Stack().scaleTransition(.scaleUp, origin: .center, duration: 250)
        let rendered = element.render()

        #expect(rendered.contains("view-transition-scale-up"))
        #expect(rendered.contains("view-transition-origin-center"))
        #expect(rendered.contains("view-transition-duration-250"))
    }

    // MARK: - Complex Element Configurations

    @Test("Element with multiple view transition parameters")
    func testElementWithMultipleParameters() async throws {
        let element = Stack()
            .viewTransition(
                .slide,
                name: "slide-card",
                duration: 500,
                timing: .backOut,
                delay: 100,
                slideDirection: .right,
                behavior: .smooth
            )
        let rendered = element.render()

        #expect(rendered.contains("view-transition-name-slide-card"))
        #expect(rendered.contains("view-transition-slide"))
        #expect(rendered.contains("view-transition-slide-right"))
        #expect(rendered.contains("view-transition-duration-500"))
        #expect(rendered.contains("view-transition-timing-cubic-bezier(0.34, 1.56, 0.64, 1)"))
        #expect(rendered.contains("view-transition-delay-100"))
        #expect(rendered.contains("view-transition-behavior-smooth"))
    }

    @Test("Element with view transition and other styles")
    func testElementWithViewTransitionAndOtherStyles() async throws {
        let element = Stack()
            .background(color: .blue(._500))
            .padding(of: 16)
            .viewTransition(.fade, duration: 300)
        let rendered = element.render()

        #expect(rendered.contains("bg-blue-500"))
        #expect(rendered.contains("p-16"))
        #expect(rendered.contains("view-transition-fade"))
        #expect(rendered.contains("view-transition-duration-300"))
    }

    // MARK: - Modifier Integration Tests

    @Test("View transition with hover modifier")
    func testViewTransitionWithHoverModifier() async throws {
        let element = Stack().viewTransition(.scale, duration: 200, on: .hover)
        let rendered = element.render()

        #expect(rendered.contains("hover:view-transition-scale"))
        #expect(rendered.contains("hover:view-transition-duration-200"))
    }

    @Test("View transition with focus modifier")
    func testViewTransitionWithFocusModifier() async throws {
        let element = Stack().viewTransition(.fade, timing: .easeInOut, on: .focus)
        let rendered = element.render()

        #expect(rendered.contains("focus:view-transition-fade"))
        #expect(rendered.contains("focus:view-transition-timing-ease-in-out"))
    }

    @Test("View transition with multiple modifiers")
    func testViewTransitionWithMultipleModifiers() async throws {
        let element = Stack().viewTransition(.slide, slideDirection: .up, on: .hover, .focus)
        let rendered = element.render()

        #expect(rendered.contains("hover:view-transition-slide"))
        #expect(rendered.contains("hover:view-transition-slide-up"))
        #expect(rendered.contains("focus:view-transition-slide"))
        #expect(rendered.contains("focus:view-transition-slide-up"))
    }

    @Test("View transition with responsive modifier")
    func testViewTransitionWithResponsiveModifier() async throws {
        let element = Stack().viewTransition(.fade, duration: 300, on: .md)
        let rendered = element.render()

        #expect(rendered.contains("md:view-transition-fade"))
        #expect(rendered.contains("md:view-transition-duration-300"))
    }

    // MARK: - Responsive Builder Integration

    @Test("Responsive builder with view transitions")
    func testResponsiveBuilderWithViewTransitions() async throws {
        let element = Stack()
            .on {
                sm { fadeTransition(duration: 200) }
                md { slideTransition(.left, duration: 300) }
                lg { scaleTransition(.scaleUp, origin: .center, duration: 400) }
            }
        let rendered = element.render()

        #expect(rendered.contains("sm:view-transition-fade"))
        #expect(rendered.contains("sm:view-transition-duration-200"))
        #expect(rendered.contains("md:view-transition-slide"))
        #expect(rendered.contains("md:view-transition-slide-left"))
        #expect(rendered.contains("md:view-transition-duration-300"))
        #expect(rendered.contains("lg:view-transition-scale-up"))
        #expect(rendered.contains("lg:view-transition-origin-center"))
        #expect(rendered.contains("lg:view-transition-duration-400"))
    }

    @Test("Responsive builder with state and view transitions")
    func testResponsiveBuilderWithStateAndViewTransitions() async throws {
        let element = Stack()
            .on {
                hover { fadeTransition(duration: 150) }
                modifiers(.hover, .md) { scaleTransition(.scale, origin: .center, duration: 200) }
                focus { slideTransition(.up, duration: 250) }
            }
        let rendered = element.render()

        #expect(rendered.contains("hover:view-transition-fade"))
        #expect(rendered.contains("hover:view-transition-duration-150"))
        #expect(rendered.contains("hover:md:view-transition-scale"))
        #expect(rendered.contains("hover:md:view-transition-origin-center"))
        #expect(rendered.contains("hover:md:view-transition-duration-200"))
        #expect(rendered.contains("focus:view-transition-slide"))
        #expect(rendered.contains("focus:view-transition-slide-up"))
        #expect(rendered.contains("focus:view-transition-duration-250"))
    }

    // MARK: - Global DSL Function Tests

    @Test("Global view transition function")
    func testGlobalViewTransitionFunction() async throws {
        let element = Stack()
            .on {
                sm { viewTransition(.fade, duration: 300) }
                md { viewTransitionName("card-transition") }
            }
        let rendered = element.render()

        #expect(rendered.contains("sm:view-transition-fade"))
        #expect(rendered.contains("sm:view-transition-duration-300"))
        #expect(rendered.contains("md:view-transition-name-card-transition"))
    }

    @Test("Global fade transition function")
    func testGlobalFadeTransitionFunction() async throws {
        let element = Stack()
            .on {
                hover { fadeTransition(duration: 200, timing: .easeInOut) }
            }
        let rendered = element.render()

        #expect(rendered.contains("hover:view-transition-fade"))
        #expect(rendered.contains("hover:view-transition-duration-200"))
        #expect(rendered.contains("hover:view-transition-timing-ease-in-out"))
    }

    @Test("Global slide transition function")
    func testGlobalSlideTransitionFunction() async throws {
        let element = Stack()
            .on {
                lg { slideTransition(.right, duration: 350, timing: .circOut) }
            }
        let rendered = element.render()

        #expect(rendered.contains("lg:view-transition-slide"))
        #expect(rendered.contains("lg:view-transition-slide-right"))
        #expect(rendered.contains("lg:view-transition-duration-350"))
        #expect(rendered.contains("lg:view-transition-timing-cubic-bezier(0, 0.55, 0.45, 1)"))
    }

    @Test("Global scale transition function")
    func testGlobalScaleTransitionFunction() async throws {
        let element = Stack()
            .on {
                focus { scaleTransition(.scaleDown, origin: .topLeft, duration: 180) }
            }
        let rendered = element.render()

        #expect(rendered.contains("focus:view-transition-scale-down"))
        #expect(rendered.contains("focus:view-transition-origin-top-left"))
        #expect(rendered.contains("focus:view-transition-duration-180"))
    }

    // MARK: - Edge Cases and Error Conditions

    @Test("Element with empty view transition name")
    func testElementWithEmptyViewTransitionName() async throws {
        let element = Stack().viewTransitionName("")
        let rendered = element.render()

        #expect(rendered.contains("view-transition-name-"))
    }

    @Test("Element with view transition and no parameters")
    func testElementWithViewTransitionNoParameters() async throws {
        let element = Stack().viewTransition()
        let rendered = element.render()

        // Should not contain any view transition classes when no parameters
        #expect(!rendered.contains("view-transition-"))
    }

    @Test("Element with conflicting transition configurations")
    func testElementWithConflictingConfigurations() async throws {
        let element = Stack()
            .viewTransition(.fade, slideDirection: .left, scaleOrigin: .center)
        let rendered = element.render()

        // Should only apply fade transition, not slide or scale specific properties
        #expect(rendered.contains("view-transition-fade"))
        #expect(!rendered.contains("view-transition-slide-left"))
        #expect(!rendered.contains("view-transition-origin-center"))
    }

    // MARK: - Complex Nesting Tests

    @Test("Nested elements with different view transitions")
    func testNestedElementsWithDifferentViewTransitions() async throws {
        let element = Stack {
            Text("Title")
                .fadeTransition(duration: 200)

            Stack {
                Text("Subtitle")
                    .slideTransition(.up, duration: 300)
            }
            .scaleTransition(.scale, origin: .center, duration: 400)
        }
        .viewTransition(.slide, duration: 500, slideDirection: .left)

        let rendered = element.render()

        // Outer stack should have slide left transition
        #expect(rendered.contains("view-transition-slide"))
        #expect(rendered.contains("view-transition-slide-left"))
        #expect(rendered.contains("view-transition-duration-500"))

        // Inner elements should have their own transitions
        #expect(rendered.contains("view-transition-fade"))
        #expect(rendered.contains("view-transition-duration-200"))
        #expect(rendered.contains("view-transition-slide-up"))
        #expect(rendered.contains("view-transition-duration-300"))
        #expect(rendered.contains("view-transition-scale"))
        #expect(rendered.contains("view-transition-origin-center"))
        #expect(rendered.contains("view-transition-duration-400"))
    }
}
