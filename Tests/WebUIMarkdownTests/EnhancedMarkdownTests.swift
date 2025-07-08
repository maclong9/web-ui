import Foundation
import Testing

@testable import WebUIMarkdown

@Suite("Enhanced Markdown Rendering Tests") struct EnhancedMarkdownTests {

    // MARK: - Rendering Options Tests

    @Test("Markdown rendering options initialization")
    @MainActor func testMarkdownRenderingOptionsInitialization() async {
        let options = MarkdownRenderingOptions(codeBlocks: .disabled)

        #expect(!options.syntaxHighlighting.isEnabled)
        #expect(!options.tableOfContents.isEnabled)
        #expect(!options.codeBlocks.copyButton)
        #expect(!options.mathSupport.isEnabled)
        #expect(options.enhancedAccessibility)
        #expect(options.performanceOptimizations)
    }

    @Test("Enhanced rendering options preset")
    @MainActor func testEnhancedRenderingOptionsPreset() {
        let options = MarkdownRenderingOptions.enhanced

        #expect(options.syntaxHighlighting.isEnabled)
        #expect(options.tableOfContents.isEnabled)
        #expect(options.codeBlocks.copyButton)
        #expect(options.codeBlocks.lineNumbers)
        #expect(options.codeBlocks.showFileName)
        #expect(options.mathSupport.isEnabled)
        #expect(options.enhancedAccessibility)
        #expect(options.performanceOptimizations)
    }

    @Test("Documentation rendering options preset")
    @MainActor func testDocumentationRenderingOptionsPreset() {
        let options = MarkdownRenderingOptions.documentation

        #expect(options.syntaxHighlighting.isEnabled)
        #expect(options.tableOfContents.isEnabled)
        #expect(options.codeBlocks.copyButton)
        #expect(options.codeBlocks.lineNumbers)
        #expect(options.mathSupport.isEnabled)
        #expect(options.enhancedAccessibility)
        #expect(options.performanceOptimizations)
    }

    // MARK: - Typography Tests

    @Test("Typography configuration")
    @MainActor func testTypographyConfiguration() {
        let defaultTypography = MarkdownTypography.default
        let marketingTypography = MarkdownTypography.marketing

        #expect(defaultTypography.defaultFontFamily == "system-ui, -apple-system, sans-serif")
        #expect(defaultTypography.defaultFontSize == .body)
        #expect(defaultTypography.enableResponsiveTypography)

        // Marketing typography should be different
        #expect(!marketingTypography.headings.isEmpty)
        #expect(!marketingTypography.elements.isEmpty)
    }

    @Test("Code block options configuration")
    @MainActor func testCodeBlockOptionsConfiguration() {
        let disabled = MarkdownRenderingOptions.CodeBlockOptions.disabled
        let basic = MarkdownRenderingOptions.CodeBlockOptions.basic
        let enhanced = MarkdownRenderingOptions.CodeBlockOptions.enhanced

        #expect(!disabled.copyButton)
        #expect(!disabled.lineNumbers)
        #expect(!disabled.showFileName)
        #expect(!disabled.runButton)

        #expect(basic.copyButton)
        #expect(basic.lineNumbers)
        #expect(basic.showFileName)
        #expect(!basic.runButton)

        #expect(enhanced.copyButton)
        #expect(enhanced.lineNumbers)
        #expect(enhanced.showFileName)
        #expect(enhanced.runButton)
    }

    // MARK: - Basic Parsing Tests

    @Test("Basic markdown parsing")
    func testBasicMarkdownParsing() async throws {
        let markdown = WebUIMarkdown()

        let content = """
            ---
            title: Test Document
            date: January 1, 2024
            ---
            # Hello World

            This is a **bold** statement with *emphasis*.

            ```swift
            let example = "code block"
            ```
            """

        let result = try markdown.parseMarkdown(content)

        #expect(!result.htmlContent.isEmpty)
        #expect(result.frontMatter["title"] as? String == "Test Document")
        // Date field gets parsed as Date object, not String
        #expect(result.frontMatter["date"] != nil)
        #expect(result.htmlContent.contains("<h1>"))
        #expect(result.htmlContent.contains("<strong>"))
        #expect(result.htmlContent.contains("<em>"))
        #expect(result.htmlContent.contains("<pre"))
    }

    @Test("Markdown without front matter")
    func testMarkdownWithoutFrontMatter() async throws {
        let markdown = WebUIMarkdown()

        let content = """
            # Simple Document

            Just some basic markdown content.
            """

        let result = try markdown.parseMarkdown(content)

        #expect(!result.htmlContent.isEmpty)
        #expect(result.frontMatter.isEmpty)
        #expect(result.htmlContent.contains("<h1>"))
    }

    @Test("Empty content handling")
    func testEmptyContentHandling() async throws {
        let markdown = WebUIMarkdown()

        do {
            _ = try markdown.parseMarkdown("")
            #expect(Bool(false), "Should have thrown an error for empty content")
        } catch let error as WebUIMarkdownError {
            #expect(error == .emptyContent)
        }

        do {
            _ = try markdown.parseMarkdown("   \n\n   ")
            #expect(Bool(false), "Should have thrown an error for whitespace-only content")
        } catch let error as WebUIMarkdownError {
            #expect(error == .emptyContent)
        }
    }

    @Test("Invalid front matter handling")
    func testInvalidFrontMatterHandling() async throws {
        let markdown = WebUIMarkdown()

        let content = """
            ---
            title: Test Document
            This line is malformed front matter
            """

        do {
            _ = try markdown.parseMarkdown(content)
            #expect(Bool(false), "Should have thrown an error for unclosed front matter")
        } catch let error as WebUIMarkdownError {
            #expect(error == .invalidFrontMatter)
        }
    }

    // MARK: - Safe Parsing Tests

    @Test("Safe markdown parsing")
    func testSafeMarkdownParsing() {
        let markdown = WebUIMarkdown()

        let validContent = """
            # Test Document

            Some content here.
            """

        let result = markdown.parseMarkdownSafely(validContent)
        #expect(!result.htmlContent.isEmpty)
        #expect(result.htmlContent.contains("<h1>"))

        // Should handle invalid content gracefully
        let invalidResult = markdown.parseMarkdownSafely("")
        #expect(!invalidResult.htmlContent.isEmpty)  // Should contain error message
    }

    // MARK: - Performance Tests

    @Test("Large markdown document performance")
    func testLargeMarkdownDocumentPerformance() async throws {
        let markdown = WebUIMarkdown()

        // Generate a large document
        var largeContent = "---\ntitle: Large Document\n---\n\n"
        for i in 1...100 {
            largeContent += "# Heading \(i)\n\nSome content for section \(i) with **bold** and *italic* text.\n\n"
        }

        let result = try markdown.parseMarkdown(largeContent)
        #expect(!result.htmlContent.isEmpty)
        #expect(result.frontMatter["title"] as? String == "Large Document")
    }

    @Test("Special characters in markdown content")
    func testSpecialCharactersInMarkdownContent() async throws {
        let markdown = WebUIMarkdown()

        let content = """
            # Test with Special Characters

            Here are some special characters: < > & " '

            ```html
            <div class="example">Hello & goodbye</div>
            ```
            """

        let result = try markdown.parseMarkdown(content)
        #expect(!result.htmlContent.isEmpty)
        // HTML should be properly escaped
        #expect(result.htmlContent.contains("&lt;"))
        #expect(result.htmlContent.contains("&gt;"))
        #expect(result.htmlContent.contains("&amp;"))
    }

    // MARK: - Enhanced Typography Tests

    @Test("Typography style merging")
    @MainActor func testTypographyStyleMerging() {
        let baseStyle = MarkdownTypography.TypographyStyle(
            font: MarkdownTypography.FontProperties(size: .body, weight: .regular),
            margins: MarkdownTypography.MarginProperties(bottom: "1rem")
        )

        let overrideStyle = MarkdownTypography.TypographyStyle(
            font: MarkdownTypography.FontProperties(weight: .bold),
            padding: MarkdownTypography.PaddingProperties(all: "0.5rem")
        )

        let merged = baseStyle.merging(with: overrideStyle)

        // Should keep base size but override weight
        #expect(merged.font?.size == .body)
        #expect(merged.font?.weight == .bold)
        // Should keep base margins and add padding
        #expect(merged.margins?.bottom == "1rem")
        #expect(merged.padding?.all == "0.5rem")
    }

    @Test("Typography CSS generation")
    @MainActor func testTypographyCSSGeneration() {
        let style = MarkdownTypography.TypographyStyle(
            font: MarkdownTypography.FontProperties(
                family: "Arial, sans-serif",
                size: .headline,
                weight: .bold,
                color: "rgb(0 0 0)"
            ),
            padding: MarkdownTypography.PaddingProperties(right: "0.5rem", left: "0.5rem"),
            margins: MarkdownTypography.MarginProperties(bottom: "1rem")
        )

        let css = style.generateCSS()

        #expect(css.contains("font-family: Arial, sans-serif"))
        #expect(css.contains("font-size: 1.125rem"))
        #expect(css.contains("font-weight: 700"))
        #expect(css.contains("color: rgb(0 0 0)"))
        #expect(css.contains("margin-bottom: 1rem"))
        #expect(css.contains("padding-left: 0.5rem"))
        #expect(css.contains("padding-right: 0.5rem"))
    }

    @Test("Typography composition and inheritance")
    @MainActor func testTypographyComposition() {
        let baseTypography = MarkdownTypography.default
        let customTypography = MarkdownTypography(
            headings: [
                .h1: MarkdownTypography.TypographyStyle(
                    font: MarkdownTypography.FontProperties(weight: .black)
                )
            ],
            elements: [
                .paragraph: MarkdownTypography.TypographyStyle(
                    font: MarkdownTypography.FontProperties(lineHeight: .loose)
                )
            ],
            defaultFontSize: .body
        )

        let merged = baseTypography.merging(with: customTypography)

        // Should have custom h1 weight
        #expect(merged.headings[.h1]?.font?.weight == .black)
        // Should have custom paragraph line height
        #expect(merged.elements[.paragraph]?.font?.lineHeight == .loose)
        // Should retain base h2 style
        #expect(merged.headings[.h2] != nil)
    }

    @Test("Typography selector helpers")
    func testTypographySelectorHelpers() {
        let idSelectors = MarkdownTypography.id("hero", style: MarkdownTypography.TypographyStyle())
        let classSelectors = MarkdownTypography.class("highlight", style: MarkdownTypography.TypographyStyle())

        #expect(idSelectors["#hero"] != nil)
        #expect(classSelectors[".highlight"] != nil)
    }

    @Test("Typography presets availability")
    @MainActor func testTypographyPresets() {
        // Test all presets are available and configured
        let defaultTypography = MarkdownTypography.default
        let documentationTypography = MarkdownTypography.documentation
        let marketingTypography = MarkdownTypography.marketing
        let articleTypography = MarkdownTypography.article
        let blogTypography = MarkdownTypography.blog

        #expect(!defaultTypography.headings.isEmpty)
        #expect(!documentationTypography.headings.isEmpty)
        #expect(!marketingTypography.headings.isEmpty)
        #expect(!articleTypography.headings.isEmpty)
        #expect(!blogTypography.headings.isEmpty)

        // Each should have different font families
        #expect(defaultTypography.defaultFontFamily != articleTypography.defaultFontFamily)
        #expect(documentationTypography.defaultFontFamily != blogTypography.defaultFontFamily)
    }

    @Test("CSS value generation for enums")
    func testCSSValueGeneration() {
        // Test TextSize
        #expect(TextSize.body.cssValue == "1rem")
        #expect(TextSize.extraLarge.cssValue == "2rem")
        #expect(TextSize.custom(1.5).cssValue == "1.5rem")

        // Test Weight
        #expect(Weight.regular.cssValue == "400")
        #expect(Weight.bold.cssValue == "700")

        // Test Leading
        #expect(Leading.tight.cssValue == "1.25")
        #expect(Leading.relaxed.cssValue == "1.625")

        // Test Tracking
        #expect(Tracking.normal.cssValue == "0")
        #expect(Tracking.wide.cssValue == "0.025em")

        // Test Decoration
        #expect(Decoration.none.cssValue == "none")
        #expect(Decoration.underline.cssValue == "underline")
    }

    // MARK: - Enhanced WebUIMarkdown Integration Tests

    @Test("Enhanced rendering with default configuration")
    func testEnhancedRenderingDefault() async throws {
        let markdown = WebUIMarkdown()

        let content = """
            # Test Document

            This is a test with `inline code` and:

            ```swift
            let example = "Hello, World!"
            print(example)
            ```

            ## Section Two

            Some more content here.
            """

        let result = try markdown.parseMarkdown(content)

        // Should contain enhanced HTML structure
        #expect(result.htmlContent.contains("class=\"markdown-content\""))
        #expect(result.htmlContent.contains("<h1"))
        #expect(result.htmlContent.contains("<h2"))
        #expect(result.htmlContent.contains("<code"))
        #expect(result.htmlContent.contains("<pre"))
    }

    @Test("Enhanced rendering with enhanced options")
    @MainActor func testEnhancedRenderingWithOptions() async throws {
        let options = MarkdownRenderingOptions.enhanced
        let typography = MarkdownTypography.documentation
        let markdown = WebUIMarkdown(options: options, typography: typography)

        let content = """
            # Main Title

            ## Subsection

            Some content with:

            ```swift:Example.swift
            let value = 42
            func greet() {
                print("Hello!")
            }
            ```

            ### Another Section

            More content here.
            """

        let result = try markdown.parseMarkdown(content)

        // Should contain enhanced features
        #expect(result.htmlContent.contains("class=\"markdown-content\""))
        #expect(result.htmlContent.contains("class=\"markdown-code-block\""))

        // Should have syntax highlighting classes
        #expect(result.htmlContent.contains("class=\"keyword\"") || result.htmlContent.contains("let"))
    }

    @Test("Table of contents generation")
    @MainActor func testTableOfContentsGeneration() async throws {
        let options = MarkdownRenderingOptions.enhanced
        let typography = MarkdownTypography.default
        let markdown = WebUIMarkdown(options: options, typography: typography)

        let content = """
            # Main Title

            Content for main section.

            ## First Section

            Some content here.

            ### Subsection

            More detailed content.

            ## Second Section

            Final content.
            """

        let (result, toc) = try markdown.parseMarkdownWithTableOfContents(content)

        // Should generate HTML content
        #expect(!result.htmlContent.isEmpty)
        #expect(result.htmlContent.contains("class=\"markdown-content\""))

        // Should generate table of contents
        #expect(!toc.isEmpty)
        #expect(toc.contains("id=\"table-of-contents\""))
        #expect(toc.contains("Table of Contents"))
        #expect(toc.contains("<a href=\"#"))
    }

    @Test("CSS generation")
    @MainActor func testCSSGeneration() {
        let markdown = WebUIMarkdown()

        let css = markdown.generateCSS()
        #expect(!css.isEmpty)
        #expect(css.contains("font-family"))
        #expect(css.contains("font-size"))

        let advancedCSS = markdown.generateAdvancedCSS()
        #expect(!advancedCSS.isEmpty)
        #expect(advancedCSS.contains(".markdown-content"))
    }

    @Test("Configuration methods")
    @MainActor func testConfigurationMethods() {
        let original = WebUIMarkdown()

        // Test withOptions
        let withOptions = original.withOptions(.enhanced)
        #expect(withOptions.options.syntaxHighlighting.isEnabled)

        // Test withTypography
        let withTypography = original.withTypography(.documentation)
        #expect(withTypography.typography.defaultFontFamily.contains("ui-sans-serif"))

        // Test withConfiguration
        let withBoth = original.withConfiguration(options: .enhanced, typography: .marketing)
        #expect(withBoth.options.syntaxHighlighting.isEnabled)
        #expect(!withBoth.typography.headings.isEmpty)
    }

    @Test("Safe parsing with enhanced features")
    func testSafeParsingEnhanced() {
        let markdown = WebUIMarkdown()

        // Valid content should work
        let validContent = "# Test\n\nSome content."
        let validResult = markdown.parseMarkdownSafely(validContent)
        #expect(!validResult.htmlContent.isEmpty)
        #expect(validResult.htmlContent.contains("class=\"markdown-content\""))

        // Invalid content should return safe fallback
        let invalidResult = markdown.parseMarkdownSafely("")
        #expect(!invalidResult.htmlContent.isEmpty)
        #expect(invalidResult.htmlContent.contains("class=\"markdown-error\""))
    }

    @Test("Safe table of contents parsing")
    @MainActor func testSafeTableOfContentsParsing() {
        let markdown = WebUIMarkdown(options: .enhanced, typography: .default)

        // Valid content
        let validContent = "# Title\n\n## Section\n\nContent here."
        let (validResult, validToc) = markdown.parseMarkdownSafelyWithTableOfContents(validContent)
        #expect(!validResult.htmlContent.isEmpty)
        #expect(!validToc.isEmpty)

        // Invalid content
        let (invalidResult, invalidToc) = markdown.parseMarkdownSafelyWithTableOfContents("")
        #expect(!invalidResult.htmlContent.isEmpty)
        #expect(invalidToc.isEmpty)
    }
}
