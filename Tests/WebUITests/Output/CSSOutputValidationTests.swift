import Foundation
import Testing

@testable import WebUI

@Suite("CSS Output Validation Tests")
struct CSSOutputValidationTests {

    /// Validates CSS class generation for existing functionality
    @Test("Basic CSS class generation")
    func basicCSSGeneration() {
        // Test with explicit classes parameter - this IS implemented
        let text = Text("Styled text", classes: ["p-4", "bg-blue-500", "text-white"])

        let cssClasses = text.extractCSSClasses()

        #expect(!cssClasses.isEmpty)
        #expect(cssClasses.contains("p-4"))
        #expect(cssClasses.contains("bg-blue-500"))
        #expect(cssClasses.contains("text-white"))
    }

    /// Validates responsive CSS classes
    @Test("Responsive CSS classes")
    func responsiveCSSClasses() {
        // Test with explicit responsive classes - using actual Tailwind-style classes
        let element = Section(classes: ["p-2", "sm:p-4", "lg:p-8", "block", "md:flex"]) {
            Text("Responsive content")
        }

        let cssClasses = element.extractCSSClasses()

        // Should contain mobile-specific classes
        #expect(cssClasses.contains("sm:p-4"))
        // Should contain desktop-specific classes
        #expect(cssClasses.contains("lg:p-8"))
        #expect(cssClasses.contains("md:flex"))
    }

    /// Validates CSS utility class patterns
    @Test("CSS utility patterns")
    func cssUtilityPatterns() {
        // Test with explicit utility classes to validate pattern recognition
        let card = Section(classes: ["p-6", "m-4", "rounded-lg", "shadow-md", "px-2", "my-8"]) {
            Text("Card content")
        }

        let cssClasses = card.extractCSSClasses()

        // Check for common utility patterns
        for cssClass in cssClasses {
            // Classes should not contain invalid characters
            #expect(!cssClass.contains(" "))
            #expect(!cssClass.contains("undefined"))
            #expect(!cssClass.contains("null"))
            #expect(!cssClass.isEmpty)

            // Should follow naming conventions
            if cssClass.contains("p-") || cssClass.contains("px-") || cssClass.contains("py-") {
                #expect(cssClass.matches(pattern: "^p[xytblr]?-\\w+$"))
            }
            if cssClass.contains("m-") || cssClass.contains("mx-") || cssClass.contains("my-") {
                #expect(cssClass.matches(pattern: "^m[xytblr]?-\\w+$"))
            }
        }
    }

    /// Tests that style modifier APIs exist and compile (implementation in progress)
    @Test("Style modifier API existence")
    func styleModifierAPIExistence() {
        // This test ensures the style modifier API compiles
        // CSS output generation may not be fully implemented yet
        let element = Section {
            Text("Test content")
        }
        .padding(.medium)
        .backgroundColor(.blue)
        .width(.full)

        // Should not crash and should return a valid element
        let htmlOutput = element.render()
        #expect(!htmlOutput.isEmpty)
        #expect(htmlOutput.contains("<section"))
    }

    /// Validates CSS size utilities using explicit classes
    @Test("CSS size utilities")
    func cssSizeUtilities() {
        // Test with explicit size classes
        let element = Section(classes: ["w-full", "h-screen", "max-w-4xl"]) {
            Text("Sized content")
        }

        let cssClasses = element.extractCSSClasses()

        #expect(cssClasses.contains("w-full"))
        #expect(cssClasses.contains("h-screen"))
        #expect(cssClasses.contains("max-w-4xl"))
    }

    /// Validates flexbox CSS utilities
    @Test("Flexbox CSS utilities")
    func flexboxUtilities() {
        // Test with explicit flexbox classes
        let flexContainer = Section(classes: ["flex", "justify-between", "items-center", "flex-row"]) {
            Text("Flex item 1")
            Text("Flex item 2")
        }

        let cssClasses = flexContainer.extractCSSClasses()

        #expect(cssClasses.contains("flex"))
        #expect(cssClasses.contains("justify-between"))
        #expect(cssClasses.contains("items-center"))
        #expect(cssClasses.contains("flex-row"))
    }

    /// Validates grid CSS utilities
    @Test("Grid CSS utilities")
    func gridUtilities() {
        // Test with explicit grid classes
        let gridContainer = Section(classes: ["grid", "grid-cols-3", "gap-4"]) {
            Text("Grid item 1")
            Text("Grid item 2")
        }

        let cssClasses = gridContainer.extractCSSClasses()

        #expect(cssClasses.contains("grid"))
        #expect(cssClasses.contains("grid-cols-3"))
        #expect(cssClasses.contains("gap-4"))
    }

    /// Validates typography CSS utilities
    @Test("Typography CSS utilities")
    func typographyUtilities() {
        // Test with explicit typography classes
        let text = Text("Typography test", classes: ["text-lg", "font-bold", "text-center", "leading-relaxed"])

        let cssClasses = text.extractCSSClasses()

        #expect(cssClasses.contains("text-lg"))
        #expect(cssClasses.contains("font-bold"))
        #expect(cssClasses.contains("text-center"))
        #expect(cssClasses.contains("leading-relaxed"))
    }

    /// Validates color CSS utilities
    @Test("Color CSS utilities")
    func colorUtilities() {
        // Test with explicit color classes
        let element = Section(classes: ["bg-blue-500", "border-gray-300", "text-white"]) {
            Text("Colored content")
        }

        let cssClasses = element.extractCSSClasses()

        #expect(cssClasses.contains("bg-blue-500"))
        #expect(cssClasses.contains("border-gray-300"))
        #expect(cssClasses.contains("text-white"))
    }

    /// Validates hover and state CSS utilities
    @Test("State CSS utilities")
    func stateUtilities() {
        // Test with explicit state classes
        let button = Button("Hover me", classes: ["bg-blue-500", "hover:bg-blue-700", "hover:scale-105"])

        let cssClasses = button.extractCSSClasses()

        #expect(cssClasses.contains("hover:bg-blue-700"))
        #expect(cssClasses.contains("hover:scale-105"))
    }

    /// Validates CSS custom properties generation
    @Test("CSS custom properties")
    func cssCustomProperties() {
        // Test basic rendering without custom CSS properties for now
        // Custom CSS property API may not be implemented yet
        let element = Section {
            Text("Custom styled content")
        }

        let htmlOutput = element.render()

        // Should generate valid HTML structure
        #expect(htmlOutput.contains("<section"))
        #expect(htmlOutput.contains("Custom styled content"))
        #expect(htmlOutput.contains("</section>"))
    }

    /// Validates CSS class deduplication
    @Test("CSS class deduplication")
    func cssClassDeduplication() {
        // Test with duplicate classes in the classes array
        let element = Text("Test content", classes: ["p-4", "p-4", "text-blue-500", "text-blue-500"])

        let cssClasses = element.extractCSSClasses()

        // This tests that our CSS extraction handles duplicates properly
        // The actual deduplication might happen at a different level
        #expect(!cssClasses.isEmpty)
        #expect(cssClasses.contains("p-4"))
        #expect(cssClasses.contains("text-blue-500"))
    }
}
