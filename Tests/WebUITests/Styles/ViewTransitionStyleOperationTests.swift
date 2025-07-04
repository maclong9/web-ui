import Testing

@testable import WebUI

@Suite("View Transition Style Operation Tests")
struct ViewTransitionStyleOperationTests {

    // MARK: - Basic Functionality Tests

    @Test("View transition with default parameters")
    func testViewTransitionWithDefaultParameters() async throws {
        let params = ViewTransitionStyleOperation.Parameters()
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.isEmpty)
    }

    @Test("View transition with specific type")
    func testViewTransitionWithSpecificType() async throws {
        let params = ViewTransitionStyleOperation.Parameters(transitionType: .fade)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-fade"))
    }

    @Test("View transition with name")
    func testViewTransitionWithName() async throws {
        let params = ViewTransitionStyleOperation.Parameters(name: "card-transition")
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-name-card-transition"))
    }

    @Test("View transition with duration")
    func testViewTransitionWithDuration() async throws {
        let params = ViewTransitionStyleOperation.Parameters(duration: 500)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-duration-500"))
    }

    @Test("View transition with timing function")
    func testViewTransitionWithTiming() async throws {
        let params = ViewTransitionStyleOperation.Parameters(timing: .easeInOut)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-timing-ease-in-out"))
    }

    @Test("View transition with delay")
    func testViewTransitionWithDelay() async throws {
        let params = ViewTransitionStyleOperation.Parameters(delay: 100)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-delay-100"))
    }

    @Test("View transition with behavior")
    func testViewTransitionWithBehavior() async throws {
        let params = ViewTransitionStyleOperation.Parameters(behavior: .smooth)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-behavior-smooth"))
    }

    // MARK: - Slide Transition Tests

    @Test("Slide transition with direction")
    func testSlideTransitionWithDirection() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .slide,
            slideDirection: .left
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-slide"))
        #expect(classes.contains("view-transition-slide-left"))
    }

    @Test("Slide transition without direction")
    func testSlideTransitionWithoutDirection() async throws {
        let params = ViewTransitionStyleOperation.Parameters(transitionType: .slide)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-slide"))
        #expect(!classes.contains("view-transition-slide-left"))
    }

    @Test("Non-slide transition with direction ignored")
    func testNonSlideTransitionWithDirection() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .fade,
            slideDirection: .right
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-fade"))
        #expect(!classes.contains("view-transition-slide-right"))
    }

    // MARK: - Scale Transition Tests

    @Test("Scale transition with origin")
    func testScaleTransitionWithOrigin() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .scale,
            scaleOrigin: .center
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-scale"))
        #expect(classes.contains("view-transition-origin-center"))
    }

    @Test("Scale up transition with origin")
    func testScaleUpTransitionWithOrigin() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .scaleUp,
            scaleOrigin: .topLeft
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-scale-up"))
        #expect(classes.contains("view-transition-origin-top-left"))
    }

    @Test("Scale down transition with origin")
    func testScaleDownTransitionWithOrigin() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .scaleDown,
            scaleOrigin: .bottomRight
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-scale-down"))
        #expect(classes.contains("view-transition-origin-bottom-right"))
    }

    @Test("Non-scale transition with origin ignored")
    func testNonScaleTransitionWithOrigin() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .fade,
            scaleOrigin: .center
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-fade"))
        #expect(!classes.contains("view-transition-origin-center"))
    }

    // MARK: - Complex Parameter Combinations

    @Test("View transition with all parameters")
    func testViewTransitionWithAllParameters() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .slide,
            name: "page-transition",
            duration: 300,
            timing: .easeInOut,
            delay: 100,
            slideDirection: .right,
            scaleOrigin: .center,
            behavior: .smooth
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-name-page-transition"))
        #expect(classes.contains("view-transition-slide"))
        #expect(classes.contains("view-transition-slide-right"))
        #expect(classes.contains("view-transition-timing-ease-in-out"))
        #expect(classes.contains("view-transition-duration-300"))
        #expect(classes.contains("view-transition-delay-100"))
        #expect(classes.contains("view-transition-behavior-smooth"))
    }

    @Test("View transition with conflicting parameters")
    func testViewTransitionWithConflictingParameters() async throws {
        let params = ViewTransitionStyleOperation.Parameters(
            transitionType: .fade,
            slideDirection: .left,
            scaleOrigin: .center
        )
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-fade"))
        #expect(!classes.contains("view-transition-slide-left"))
        #expect(!classes.contains("view-transition-origin-center"))
    }

    // MARK: - Edge Cases

    @Test("View transition with empty name")
    func testViewTransitionWithEmptyName() async throws {
        let params = ViewTransitionStyleOperation.Parameters(name: "")
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-name-"))
    }

    @Test("View transition with zero duration")
    func testViewTransitionWithZeroDuration() async throws {
        let params = ViewTransitionStyleOperation.Parameters(duration: 0)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-duration-0"))
    }

    @Test("View transition with negative delay")
    func testViewTransitionWithNegativeDelay() async throws {
        let params = ViewTransitionStyleOperation.Parameters(delay: -50)
        let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("view-transition-delay--50"))
    }

    // MARK: - Enum Value Tests

    @Test("All transition types generate correct classes")
    func testAllTransitionTypes() async throws {
        let testCases: [(ViewTransitionType, String)] = [
            (.fade, "view-transition-fade"),
            (.slide, "view-transition-slide"),
            (.slideUp, "view-transition-slide-up"),
            (.slideDown, "view-transition-slide-down"),
            (.slideLeft, "view-transition-slide-left"),
            (.slideRight, "view-transition-slide-right"),
            (.scale, "view-transition-scale"),
            (.scaleUp, "view-transition-scale-up"),
            (.scaleDown, "view-transition-scale-down"),
            (.flip, "view-transition-flip"),
            (.flipHorizontal, "view-transition-flip-horizontal"),
            (.flipVertical, "view-transition-flip-vertical"),
            (.none, "view-transition-none"),
        ]

        for (transitionType, expectedClass) in testCases {
            let params = ViewTransitionStyleOperation.Parameters(transitionType: transitionType)
            let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

            #expect(
                classes.contains(expectedClass),
                "Expected class '\(expectedClass)' for transition type '\(transitionType)'")
        }
    }

    @Test("All slide directions generate correct classes")
    func testAllSlideDirections() async throws {
        let testCases: [(SlideDirection, String)] = [
            (.up, "view-transition-slide-up"),
            (.down, "view-transition-slide-down"),
            (.left, "view-transition-slide-left"),
            (.right, "view-transition-slide-right"),
        ]

        for (direction, expectedClass) in testCases {
            let params = ViewTransitionStyleOperation.Parameters(
                transitionType: .slide,
                slideDirection: direction
            )
            let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

            #expect(classes.contains(expectedClass), "Expected class '\(expectedClass)' for direction '\(direction)'")
        }
    }

    @Test("All scale origins generate correct classes")
    func testAllScaleOrigins() async throws {
        let testCases: [(ScaleOrigin, String)] = [
            (.center, "view-transition-origin-center"),
            (.top, "view-transition-origin-top"),
            (.bottom, "view-transition-origin-bottom"),
            (.left, "view-transition-origin-left"),
            (.right, "view-transition-origin-right"),
            (.topLeft, "view-transition-origin-top-left"),
            (.topRight, "view-transition-origin-top-right"),
            (.bottomLeft, "view-transition-origin-bottom-left"),
            (.bottomRight, "view-transition-origin-bottom-right"),
        ]

        for (origin, expectedClass) in testCases {
            let params = ViewTransitionStyleOperation.Parameters(
                transitionType: .scale,
                scaleOrigin: origin
            )
            let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

            #expect(classes.contains(expectedClass), "Expected class '\(expectedClass)' for origin '\(origin)'")
        }
    }

    @Test("All timing functions generate correct classes")
    func testAllTimingFunctions() async throws {
        let testCases: [(ViewTransitionTiming, String)] = [
            (.linear, "view-transition-timing-linear"),
            (.easeIn, "view-transition-timing-ease-in"),
            (.easeOut, "view-transition-timing-ease-out"),
            (.easeInOut, "view-transition-timing-ease-in-out"),
            (.circIn, "view-transition-timing-cubic-bezier(0.55, 0, 1, 0.45)"),
            (.circOut, "view-transition-timing-cubic-bezier(0, 0.55, 0.45, 1)"),
            (.circInOut, "view-transition-timing-cubic-bezier(0.85, 0, 0.15, 1)"),
            (.backIn, "view-transition-timing-cubic-bezier(0.36, 0, 0.66, -0.56)"),
            (.backOut, "view-transition-timing-cubic-bezier(0.34, 1.56, 0.64, 1)"),
            (.backInOut, "view-transition-timing-cubic-bezier(0.68, -0.6, 0.32, 1.6)"),
        ]

        for (timing, expectedClass) in testCases {
            let params = ViewTransitionStyleOperation.Parameters(timing: timing)
            let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

            #expect(classes.contains(expectedClass), "Expected class '\(expectedClass)' for timing '\(timing)'")
        }
    }

    @Test("All behaviors generate correct classes")
    func testAllBehaviors() async throws {
        let testCases: [(ViewTransitionBehavior, String)] = [
            (.auto, "view-transition-behavior-auto"),
            (.smooth, "view-transition-behavior-smooth"),
            (.instant, "view-transition-behavior-instant"),
        ]

        for (behavior, expectedClass) in testCases {
            let params = ViewTransitionStyleOperation.Parameters(behavior: behavior)
            let classes = ViewTransitionStyleOperation.shared.applyClasses(params: params)

            #expect(classes.contains(expectedClass), "Expected class '\(expectedClass)' for behavior '\(behavior)'")
        }
    }
}
