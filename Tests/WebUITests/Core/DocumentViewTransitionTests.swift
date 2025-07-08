import Testing

@testable import WebUI

@Suite("Document View Transition Tests")
struct DocumentViewTransitionTests {

    // MARK: - Test Document Implementations

    struct BasicViewTransitionDocument: Document {
        var metadata: Metadata {
            Metadata(
                title: "Test Page",
                description: "Test page for view transitions"
            )
        }

        var body: some Markup {
            Stack {
                Text("Hello World")
            }
        }

        var viewTransitions: DocumentViewTransitionConfiguration? {
            DocumentViewTransitionConfiguration(
                defaultTransition: .fade,
                duration: 300,
                timing: .easeInOut,
                enableCrossDocument: true
            )
        }
    }

    struct SlideViewTransitionDocument: Document {
        var metadata: Metadata {
            Metadata(
                title: "Slide Page",
                description: "Test page for slide transitions"
            )
        }

        var body: some Markup {
            Text("Slide Content")
        }

        var viewTransitions: DocumentViewTransitionConfiguration? {
            DocumentViewTransitionConfiguration(
                defaultTransition: .slideLeft,
                duration: 500,
                timing: .backOut,
                delay: 100,
                enableCrossDocument: true,
                customCSS: """
                    .custom-transition {
                        animation-delay: 50ms;
                    }
                    """
            )
        }
    }

    struct NoViewTransitionDocument: Document {
        var metadata: Metadata {
            Metadata(
                title: "No Transition Page",
                description: "Test page without view transitions"
            )
        }

        var body: some Markup {
            Text("No Transition Content")
        }

        // viewTransitions returns nil by default
    }

    // MARK: - DocumentViewTransitionConfiguration Tests

    @Test("Document view transition configuration initialization")
    func testDocumentViewTransitionConfigurationInit() async throws {
        let config = DocumentViewTransitionConfiguration(
            defaultTransition: .fade,
            duration: 300,
            timing: .easeInOut,
            delay: 50,
            enableCrossDocument: true,
            customCSS: ".custom { color: red; }"
        )

        #expect(config.defaultTransition == .fade)
        #expect(config.duration == 300)
        #expect(config.timing == .easeInOut)
        #expect(config.delay == 50)
        #expect(config.enableCrossDocument == true)
        #expect(config.customCSS == ".custom { color: red; }")
    }

    @Test("Document view transition configuration with defaults")
    func testDocumentViewTransitionConfigurationDefaults() async throws {
        let config = DocumentViewTransitionConfiguration()

        #expect(config.defaultTransition == nil)
        #expect(config.duration == nil)
        #expect(config.timing == nil)
        #expect(config.delay == nil)
        #expect(config.enableCrossDocument == false)
        #expect(config.customCSS == nil)
    }

    // MARK: - CSS Generation Tests

    @Test("Document generates fade transition CSS")
    func testDocumentGeneratesFadeTransitionCSS() async throws {
        let document = BasicViewTransitionDocument()
        let css = document.generateViewTransitionCSS()

        #expect(css != nil)
        #expect(css!.contains("@view-transition"))
        #expect(css!.contains("navigation: auto"))
        #expect(css!.contains("animation-duration: 300ms"))
        #expect(css!.contains("animation-timing-function: ease-in-out"))
        #expect(css!.contains("::view-transition-old(root)"))
        #expect(css!.contains("::view-transition-new(root)"))
        #expect(css!.contains("animation-name: fade-out"))
        #expect(css!.contains("animation-name: fade-in"))
        #expect(css!.contains("@keyframes fade-out"))
        #expect(css!.contains("@keyframes fade-in"))
    }

    @Test("Document generates slide transition CSS")
    func testDocumentGeneratesSlideTransitionCSS() async throws {
        let document = SlideViewTransitionDocument()
        let css = document.generateViewTransitionCSS()

        #expect(css != nil)
        #expect(css!.contains("@view-transition"))
        #expect(css!.contains("animation-duration: 500ms"))
        #expect(css!.contains("animation-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1)"))
        #expect(css!.contains("animation-name: slide-out-left"))
        #expect(css!.contains("animation-name: slide-in-right"))
        #expect(css!.contains("@keyframes slide-out-left"))
        #expect(css!.contains("@keyframes slide-in-right"))
        #expect(css!.contains("transform: translateX(-100%)"))
        #expect(css!.contains("transform: translateX(100%)"))
        #expect(css!.contains("transform: translateX(0)"))
    }

    @Test("Document generates custom CSS")
    func testDocumentGeneratesCustomCSS() async throws {
        let document = SlideViewTransitionDocument()
        let css = document.generateViewTransitionCSS()

        #expect(css != nil)
        #expect(css!.contains("/* Custom view transition styles */"))
        #expect(css!.contains(".custom-transition"))
        #expect(css!.contains("animation-delay: 50ms"))
    }

    @Test("Document with no view transitions generates no CSS")
    func testDocumentWithNoViewTransitionsGeneratesNoCSS() async throws {
        let document = NoViewTransitionDocument()
        let css = document.generateViewTransitionCSS()

        #expect(css == nil)
    }

    // MARK: - JavaScript Generation Tests

    @Test("Document generates cross-document JavaScript")
    func testDocumentGeneratesCrossDocumentJavaScript() async throws {
        let document = BasicViewTransitionDocument()
        let js = document.generateViewTransitionJS()

        #expect(js != nil)
        #expect(js!.contains("'use strict'"))
        #expect(js!.contains("document.startViewTransition"))
        #expect(js!.contains("DOMContentLoaded"))
        #expect(js!.contains("addEventListener('click'"))
        #expect(js!.contains("addEventListener('popstate'"))
        #expect(js!.contains("window.location.href"))
        #expect(js!.contains("window.location.reload"))
    }

    @Test("Document without cross-document transitions generates no JavaScript")
    func testDocumentWithoutCrossDocumentGeneratesNoJavaScript() async throws {
        struct NoCrossDocumentTransitionDocument: Document {
            var metadata: Metadata {
                Metadata(
                    title: "No Cross Document",
                    description: "Test page"
                )
            }

            var body: some Markup {
                Text("Content")
            }

            var viewTransitions: DocumentViewTransitionConfiguration? {
                DocumentViewTransitionConfiguration(
                    defaultTransition: .fade,
                    enableCrossDocument: false
                )
            }
        }

        let document = NoCrossDocumentTransitionDocument()
        let js = document.generateViewTransitionJS()

        #expect(js == nil)
    }

    // MARK: - Enhanced Head Content Tests

    @Test("Document enhanced head includes view transition CSS and JavaScript")
    func testDocumentEnhancedHeadIncludesViewTransitions() async throws {
        let document = BasicViewTransitionDocument()
        let enhancedHead = document.enhancedHead

        #expect(enhancedHead != nil)
        #expect(enhancedHead!.contains("<style>"))
        #expect(enhancedHead!.contains("@view-transition"))
        #expect(enhancedHead!.contains("</style>"))
        #expect(enhancedHead!.contains("<script>"))
        #expect(enhancedHead!.contains("document.startViewTransition"))
        #expect(enhancedHead!.contains("</script>"))
    }

    @Test("Document enhanced head with custom head content")
    func testDocumentEnhancedHeadWithCustomContent() async throws {
        struct CustomHeadDocument: Document {
            var metadata: Metadata {
                Metadata(
                    title: "Custom Head",
                    description: "Test page"
                )
            }

            var body: some Markup {
                Text("Content")
            }

            var head: String? {
                "<meta name=\"custom\" content=\"value\">"
            }

            var viewTransitions: DocumentViewTransitionConfiguration? {
                DocumentViewTransitionConfiguration(
                    defaultTransition: .fade,
                    enableCrossDocument: true
                )
            }
        }

        let document = CustomHeadDocument()
        let enhancedHead = document.enhancedHead

        #expect(enhancedHead != nil)
        #expect(enhancedHead!.contains("<meta name=\"custom\" content=\"value\">"))
        #expect(enhancedHead!.contains("<style>"))
        #expect(enhancedHead!.contains("@view-transition"))
        #expect(enhancedHead!.contains("<script>"))
        #expect(enhancedHead!.contains("document.startViewTransition"))
    }

    @Test("Document enhanced head with no view transitions")
    func testDocumentEnhancedHeadWithNoViewTransitions() async throws {
        let document = NoViewTransitionDocument()
        let enhancedHead = document.enhancedHead

        #expect(enhancedHead == nil)
    }

    // MARK: - Document Rendering with View Transitions

    @Test("Document renders with view transitions")
    func testDocumentRendersWithViewTransitions() async throws {
        let document = BasicViewTransitionDocument()
        let rendered = try document.renderWithViewTransitions()

        #expect(rendered.contains("<!DOCTYPE html>"))
        #expect(rendered.contains("<title>Test Page</title>"))
        #expect(rendered.contains("Hello World"))
        #expect(rendered.contains("<style>"))
        #expect(rendered.contains("@view-transition"))
        #expect(rendered.contains("animation-name: fade-out"))
        #expect(rendered.contains("<script>"))
        #expect(rendered.contains("document.startViewTransition"))
    }

    @Test("Document renders without view transitions")
    func testDocumentRendersWithoutViewTransitions() async throws {
        let document = NoViewTransitionDocument()
        let rendered = try document.renderWithViewTransitions()

        #expect(rendered.contains("<!DOCTYPE html>"))
        #expect(rendered.contains("<title>No Transition Page</title>"))
        #expect(rendered.contains("No Transition Content"))
        #expect(!rendered.contains("<style>"))
        #expect(!rendered.contains("@view-transition"))
        #expect(!rendered.contains("<script>"))
    }

    // MARK: - All Transition Types CSS Generation

    @Test("Document generates CSS for all transition types")
    func testDocumentGeneratesCSSForAllTransitionTypes() async throws {
        let transitionTypes: [ViewTransitionType] = [
            .fade, .slide, .slideUp, .slideDown, .slideLeft, .slideRight,
            .scale, .scaleUp, .scaleDown, .flip, .flipHorizontal, .flipVertical, .none,
        ]

        for transitionType in transitionTypes {
            struct TestDocument: Document {
                let transitionType: ViewTransitionType

                var metadata: Metadata {
                    Metadata(
                        title: "Test",
                        description: "Test"
                    )
                }

                var body: some Markup {
                    Text("Test")
                }

                var viewTransitions: DocumentViewTransitionConfiguration? {
                    DocumentViewTransitionConfiguration(
                        defaultTransition: transitionType,
                        duration: 300
                    )
                }
            }

            let document = TestDocument(transitionType: transitionType)
            let css = document.generateViewTransitionCSS()

            #expect(css != nil, "CSS should be generated for transition type \(transitionType)")
            #expect(css!.contains("@view-transition"), "CSS should contain @view-transition for \(transitionType)")
            #expect(css!.contains("animation-duration: 300ms"), "CSS should contain duration for \(transitionType)")

            if transitionType != .none {
                #expect(css!.contains("@keyframes"), "CSS should contain keyframes for \(transitionType)")
            }
        }
    }

    // MARK: - Website Default View Transitions

    @Test("Website default view transitions property")
    func testWebsiteDefaultViewTransitions() async throws {
        struct TestWebsite: Website {
            var metadata: Metadata {
                Metadata(
                    site: "Test Site",
                    description: "Test website"
                )
            }

            @WebsiteRouteBuilder
            var routes: [any Document] {
                // Empty routes for test
            }

            var defaultViewTransitions: DocumentViewTransitionConfiguration? {
                DocumentViewTransitionConfiguration(
                    defaultTransition: .fade,
                    duration: 400,
                    enableCrossDocument: true
                )
            }
        }

        let website = TestWebsite()
        let config = website.defaultViewTransitions

        #expect(config != nil)
        #expect(config!.defaultTransition == .fade)
        #expect(config!.duration == 400)
        #expect(config!.enableCrossDocument == true)
    }
}
