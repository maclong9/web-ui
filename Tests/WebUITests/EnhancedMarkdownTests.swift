import Testing
import Foundation

@testable import WebUIMarkdown

@Suite("Enhanced Markdown Rendering Tests") struct EnhancedMarkdownTests {
    
    // MARK: - Rendering Options Tests
    
    @Test("Markdown rendering options initialization")
    func testMarkdownRenderingOptionsInitialization() {
        let options = MarkdownRenderingOptions()
        
        #expect(!options.syntaxHighlighting.isEnabled)
        #expect(!options.tableOfContents.isEnabled)
        #expect(!options.codeBlocks.copyButton)
        #expect(!options.mathSupport.isEnabled)
        #expect(options.enhancedAccessibility)
        #expect(options.performanceOptimizations)
    }
    
    @Test("Enhanced rendering options preset")
    func testEnhancedRenderingOptionsPreset() {
        let options = MarkdownRenderingOptions.enhanced
        
        #expect(options.syntaxHighlighting.isEnabled)
        #expect(options.tableOfContents.isEnabled)
        #expect(options.codeBlocks.copyButton)
        #expect(options.codeBlocks.lineNumbers)
        #expect(options.codeBlocks.showFileName)
        #expect(options.mathSupport.isEnabled)
        #expect(options.hasEnhancedFeatures)
    }
    
    @Test("Documentation rendering options preset")
    func testDocumentationRenderingOptionsPreset() {
        let options = MarkdownRenderingOptions.documentation
        
        #expect(options.syntaxHighlighting.isEnabled)
        #expect(options.tableOfContents.isEnabled)
        #expect(options.tableOfContents.maxDepth == 3)
        #expect(options.codeBlocks.copyButton)
        #expect(options.codeBlocks.wrapLines)
        #expect(!options.codeBlocks.runButton)
    }
    
    @Test("Supported language detection")
    func testSupportedLanguageDetection() {
        let swift = MarkdownRenderingOptions.SupportedLanguage.swift
        let javascript = MarkdownRenderingOptions.SupportedLanguage.javascript
        
        #expect(swift.displayName == "Swift")
        #expect(swift.cssClassName == "language-swift")
        #expect(javascript.displayName == "JavaScript")
        #expect(javascript.cssClassName == "language-javascript")
    }
    
    @Test("Syntax highlighting configuration")
    func testSyntaxHighlightingConfiguration() {
        let disabledHighlighting = MarkdownRenderingOptions.SyntaxHighlighting.disabled
        let enabledHighlighting = MarkdownRenderingOptions.SyntaxHighlighting.enabled(languages: [.swift, .javascript])
        let allLanguages = MarkdownRenderingOptions.SyntaxHighlighting.enabledForAll
        
        #expect(!disabledHighlighting.isEnabled)
        #expect(disabledHighlighting.supportedLanguages.isEmpty)
        
        #expect(enabledHighlighting.isEnabled)
        #expect(enabledHighlighting.supportedLanguages.count == 2)
        #expect(enabledHighlighting.supportedLanguages.contains(.swift))
        #expect(enabledHighlighting.supportedLanguages.contains(.javascript))
        
        #expect(allLanguages.isEnabled)
        #expect(allLanguages.supportedLanguages.count == MarkdownRenderingOptions.SupportedLanguage.allCases.count)
    }
    
    @Test("Table of contents configuration")
    func testTableOfContentsConfiguration() {
        let disabled = MarkdownRenderingOptions.TableOfContents.disabled
        let enabled = MarkdownRenderingOptions.TableOfContents.enabled(maxDepth: 3, includeIds: true)
        
        #expect(!disabled.isEnabled)
        #expect(disabled.maxDepth == 0)
        #expect(!disabled.includeIds)
        
        #expect(enabled.isEnabled)
        #expect(enabled.maxDepth == 3)
        #expect(enabled.includeIds)
    }
    
    @Test("Code block options configuration")
    func testCodeBlockOptionsConfiguration() {
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
    
    // MARK: - Typography Tests
    
    @Test("Typography style creation and merging")
    func testTypographyStyleCreationAndMerging() {
        let baseStyle = MarkdownTypography.TypographyStyle(
            font: MarkdownTypography.FontProperties(family: "system-ui", size: .medium),
            margins: MarkdownTypography.MarginProperties(bottom: "1rem")
        )
        
        let overrideStyle = MarkdownTypography.TypographyStyle(
            font: MarkdownTypography.FontProperties(size: .large, weight: .bold),
            padding: MarkdownTypography.PaddingProperties(all: "0.5rem")
        )
        
        let merged = baseStyle.merged(with: overrideStyle)
        
        #expect(merged.font?.family == "system-ui")
        #expect(merged.font?.size == .large)
        #expect(merged.font?.weight == .bold)
        #expect(merged.margins?.bottom == "1rem")
        #expect(merged.padding?.top == "0.5rem")
    }
    
    @Test("Typography default configuration")
    func testTypographyDefaultConfiguration() {
        let typography = MarkdownTypography.default
        
        #expect(typography.headings.count == 6)
        #expect(typography.headings[.h1] != nil)
        #expect(typography.headings[.h6] != nil)
        #expect(typography.elements[.paragraph] != nil)
        #expect(typography.elements[.code] != nil)
        #expect(typography.elements[.blockquote] != nil)
    }
    
    @Test("Typography documentation configuration")
    func testTypographyDocumentationConfiguration() {
        let typography = MarkdownTypography.documentation
        
        #expect(typography.defaultFontFamily.contains("ui-sans-serif"))
        #expect(typography.enableResponsiveTypography)
        #expect(typography.headings[.h1]?.border != nil)
        #expect(typography.elements[.code]?.border != nil)
    }
    
    @Test("Typography CSS generation")
    func testTypographyCSSGeneration() {
        let typography = MarkdownTypography.default
        let css = typography.generateCSS()
        
        #expect(!css.isEmpty)
        #expect(css.contains(".markdown-content h1"))
        #expect(css.contains(".markdown-content p"))
        #expect(css.contains(".markdown-content code"))
        #expect(css.contains("font-size:"))
        #expect(css.contains("margin-bottom:"))
    }
    
    @Test("Heading level properties")
    func testHeadingLevelProperties() {
        let h1 = MarkdownTypography.HeadingLevel.h1
        let h3 = MarkdownTypography.HeadingLevel.h3
        
        #expect(h1.tagName == "h1")
        #expect(h1.cssClassName == "markdown-heading-1")
        #expect(h3.tagName == "h3")
        #expect(h3.cssClassName == "markdown-heading-3")
    }
    
    @Test("Element type properties")
    func testElementTypeProperties() {
        let paragraph = MarkdownTypography.ElementType.paragraph
        let codeBlock = MarkdownTypography.ElementType.codeBlock
        
        #expect(paragraph.cssClassName == "markdown-p")
        #expect(codeBlock.cssClassName == "markdown-pre")
    }
    
    // MARK: - Enhanced HTML Renderer Tests
    
    @Test("Enhanced HTML renderer initialization")
    func testEnhancedHTMLRendererInitialization() {
        let options = MarkdownRenderingOptions.basic
        let typography = MarkdownTypography.default
        var renderer = EnhancedHTMLRenderer(options: options, typography: typography)
        
        #expect(renderer.options.syntaxHighlighting.isEnabled)
        #expect(renderer.typography.headings.count > 0)
        #expect(renderer.html.isEmpty)
        #expect(renderer.tableOfContentsEntries.isEmpty)
    }
    
    @Test("Table of contents entry creation")
    func testTableOfContentsEntryCreation() {
        let entry = EnhancedHTMLRenderer.TableOfContentsEntry(
            level: 1,
            text: "Introduction",
            id: "introduction"
        )
        
        #expect(entry.level == 1)
        #expect(entry.text == "Introduction")
        #expect(entry.id == "introduction")
        #expect(entry.children.isEmpty)
    }
    
    @Test("Syntax highlight info creation")
    func testSyntaxHighlightInfoCreation() {
        let info = EnhancedHTMLRenderer.SyntaxHighlightInfo(
            language: .swift,
            fileName: "Example.swift",
            code: "print(\"Hello\")",
            highlightedHTML: "<span class=\"keyword\">print</span>(\"Hello\")"
        )
        
        #expect(info.language == .swift)
        #expect(info.fileName == "Example.swift")
        #expect(info.code == "print(\"Hello\")")
        #expect(info.highlightedHTML.contains("keyword"))
    }
    
    // MARK: - Integration Tests
    
    @Test("Basic markdown parsing with enhanced features")
    func testBasicMarkdownParsingWithEnhancedFeatures() async throws {
        let options = MarkdownRenderingOptions.basic
        let typography = MarkdownTypography.default
        let markdown = WebUIMarkdown(renderingOptions: options, typography: typography)
        
        let content = """
        # Hello World
        
        This is a paragraph with **bold** text.
        
        ```swift
        print("Hello, World!")
        ```
        """
        
        let result = try markdown.parseMarkdown(content)
        
        #expect(!result.htmlContent.isEmpty)
        #expect(result.htmlContent.contains("<h1"))
        #expect(result.htmlContent.contains("<strong>"))
        #expect(result.htmlContent.contains("<pre"))
        #expect(result.htmlContent.contains("markdown-content"))
        #expect(result.renderingMetadata.hasSyntaxHighlighting)
    }
    
    @Test("Markdown parsing with table of contents")
    func testMarkdownParsingWithTableOfContents() async throws {
        let options = MarkdownRenderingOptions(
            tableOfContents: .enabled(maxDepth: 3, includeIds: true)
        )
        let markdown = WebUIMarkdown(renderingOptions: options)
        
        let content = """
        # Introduction
        
        This is the introduction.
        
        ## Getting Started
        
        Let's get started.
        
        ### Installation
        
        How to install.
        """
        
        let result = try markdown.parseMarkdown(content)
        
        #expect(!result.htmlContent.isEmpty)
        #expect(result.tableOfContents != nil)
        #expect(result.tableOfContents!.contains("table-of-contents"))
        #expect(result.tableOfContents!.contains("Introduction"))
        #expect(result.tableOfContents!.contains("Getting Started"))
        #expect(result.renderingMetadata.hasTableOfContents)
        #expect(result.renderingMetadata.headingCount >= 3)
    }
    
    @Test("Markdown parsing with front matter and enhanced features")
    func testMarkdownParsingWithFrontMatterAndEnhancedFeatures() async throws {
        let options = MarkdownRenderingOptions.documentation
        let typography = MarkdownTypography.documentation
        let markdown = WebUIMarkdown(renderingOptions: options, typography: typography)
        
        let content = """
        ---
        title: Documentation Example
        author: Test Author
        date: January 1, 2025
        ---
        
        # \(String("title"))
        
        This is a documentation example with `inline code` and:
        
        ```swift:Example.swift
        func greet(name: String) {
            print("Hello, \\(name)!")
        }
        ```
        
        ## Features
        
        - Syntax highlighting
        - Table of contents
        - Typography styling
        """
        
        let result = try markdown.parseMarkdown(content)
        
        #expect(!result.frontMatter.isEmpty)
        #expect(result.frontMatter["title"] as? String == "Documentation Example")
        #expect(result.frontMatter["author"] as? String == "Test Author")
        #expect(!result.htmlContent.isEmpty)
        #expect(result.tableOfContents != nil)
        #expect(result.stylesheetCSS != nil)
        #expect(result.stylesheetCSS!.contains(".markdown-content"))
        #expect(result.renderingMetadata.hasSyntaxHighlighting)
        #expect(result.renderingMetadata.hasTableOfContents)
    }
    
    @Test("Enhanced code block rendering")
    func testEnhancedCodeBlockRendering() async throws {
        let codeBlockOptions = MarkdownRenderingOptions.CodeBlockOptions(
            copyButton: true,
            lineNumbers: true,
            showFileName: true,
            runButton: true
        )
        let options = MarkdownRenderingOptions(
            syntaxHighlighting: .enabled(languages: [.swift]),
            codeBlocks: codeBlockOptions
        )
        let markdown = WebUIMarkdown(renderingOptions: options)
        
        let content = """
        Here's a Swift example:
        
        ```swift:Hello.swift
        func hello() {
            print("Hello, World!")
        }
        ```
        """
        
        let result = try markdown.parseMarkdown(content)
        
        #expect(result.htmlContent.contains("markdown-code-block"))
        #expect(result.htmlContent.contains("code-block-header"))
        #expect(result.htmlContent.contains("Hello.swift"))
        #expect(result.htmlContent.contains("copy-button"))
        #expect(result.htmlContent.contains("run-button"))
        #expect(result.htmlContent.contains("line-numbers"))
        #expect(result.stylesheetCSS!.contains(".copy-button"))
    }
    
    @Test("Mathematical notation support")
    func testMathematicalNotationSupport() async throws {
        let options = MarkdownRenderingOptions(
            mathSupport: .enabled()
        )
        let markdown = WebUIMarkdown(renderingOptions: options)
        
        let content = """
        Here's an inline equation: $x = 4$ and a block equation:
        
        ```math
        E = mc^2
        ```
        """
        
        let result = try markdown.parseMarkdown(content)
        
        #expect(result.htmlContent.contains("math-inline"))
        #expect(result.htmlContent.contains("math-block"))
        #expect(result.stylesheetCSS!.contains(".math-inline"))
        #expect(result.stylesheetCSS!.contains(".math-block"))
        #expect(result.renderingMetadata.hasMathematicalNotation)
    }
    
    @Test("Safe markdown parsing with enhanced features")
    func testSafeMarkdownParsingWithEnhancedFeatures() {
        let options = MarkdownRenderingOptions.enhanced
        let markdown = WebUIMarkdown(renderingOptions: options)
        
        let invalidContent = """
        ---
        title: Invalid Front Matter
        This line breaks the front matter
        """
        
        let result = markdown.parseMarkdownSafely(invalidContent)
        
        #expect(result.frontMatter.isEmpty)
        #expect(result.htmlContent.contains("<pre>"))
        #expect(result.tableOfContents == nil)
        #expect(result.stylesheetCSS == nil)
        #expect(!result.renderingMetadata.hasSyntaxHighlighting)
        #expect(!result.renderingMetadata.hasTableOfContents)
    }
    
    @Test("Performance comparison: basic vs enhanced rendering")
    func testPerformanceComparisonBasicVsEnhanced() async throws {
        let basicMarkdown = WebUIMarkdown()
        let enhancedMarkdown = WebUIMarkdown(renderingOptions: .enhanced, typography: .documentation)
        
        let content = """
        # Performance Test
        
        This is a test document with various elements:
        
        - List item 1
        - List item 2
        
        ```swift
        func test() { print("test") }
        ```
        
        **Bold text** and *italic text*.
        """
        
        // Both should work without errors
        let basicResult = try basicMarkdown.parseMarkdown(content)
        let enhancedResult = try enhancedMarkdown.parseMarkdown(content)
        
        #expect(!basicResult.htmlContent.isEmpty)
        #expect(!enhancedResult.htmlContent.isEmpty)
        
        // Enhanced should have additional features
        #expect(basicResult.tableOfContents == nil)
        #expect(enhancedResult.tableOfContents != nil)
        #expect(basicResult.stylesheetCSS == nil)
        #expect(enhancedResult.stylesheetCSS != nil)
        
        // Enhanced should have more detailed metadata
        #expect(!basicResult.renderingMetadata.hasSyntaxHighlighting)
        #expect(enhancedResult.renderingMetadata.hasSyntaxHighlighting)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Error handling for invalid markdown content")
    func testErrorHandlingForInvalidMarkdownContent() async throws {
        let markdown = WebUIMarkdown(renderingOptions: .enhanced)
        
        // Empty content should throw
        do {
            _ = try markdown.parseMarkdown("")
            #expect(Bool(false), "Should have thrown an error for empty content")
        } catch let error as WebUIMarkdownError {
            #expect(error == .emptyContent)
        }
        
        // Whitespace-only content should throw
        do {
            _ = try markdown.parseMarkdown("   \n  \t  ")
            #expect(Bool(false), "Should have thrown an error for whitespace-only content")
        } catch let error as WebUIMarkdownError {
            #expect(error == .emptyContent)
        }
    }
    
    @Test("Error handling for malformed front matter")
    func testErrorHandlingForMalformedFrontMatter() async throws {
        let markdown = WebUIMarkdown()
        
        let contentWithUnclosedFrontMatter = """
        ---
        title: Test
        author: Someone
        This should cause an error
        """
        
        do {
            _ = try markdown.parseMarkdown(contentWithUnclosedFrontMatter)
            #expect(Bool(false), "Should have thrown an error for unclosed front matter")
        } catch let error as WebUIMarkdownError {
            #expect(error == .invalidFrontMatter)
        }
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("Empty markdown elements rendering")
    func testEmptyMarkdownElementsRendering() async throws {
        let markdown = WebUIMarkdown(renderingOptions: .enhanced)
        
        let content = """
        # 
        
        
        
        ```
        ```
        
        **
        """
        
        // Should not crash and should produce some output
        let result = try markdown.parseMarkdown(content)
        #expect(!result.htmlContent.isEmpty)
        #expect(result.htmlContent.contains("markdown-content"))
    }
    
    @Test("Large markdown document performance")
    func testLargeMarkdownDocumentPerformance() async throws {
        let markdown = WebUIMarkdown(renderingOptions: .basic)
        
        // Generate a large document
        var content = "# Large Document Test\n\n"
        for i in 1...100 {
            content += """
            ## Section \(i)
            
            This is section \(i) with some content and a code block:
            
            ```swift
            func section\(i)() {
                print("Section \(i)")
            }
            ```
            
            """
        }
        
        // Should handle large documents without issues
        let result = try markdown.parseMarkdown(content)
        #expect(!result.htmlContent.isEmpty)
        #expect(result.renderingMetadata.headingCount >= 100)
    }
    
    @Test("Special characters in markdown content")
    func testSpecialCharactersInMarkdownContent() async throws {
        let markdown = WebUIMarkdown(renderingOptions: .enhanced)
        
        let content = """
        # Special Characters Test
        
        Content with special characters: <>&"'
        
        ```html
        <div class="test">Content with HTML</div>
        ```
        
        Math: $x < y > z$
        """
        
        let result = try markdown.parseMarkdown(content)
        
        // Special characters should be properly escaped
        #expect(result.htmlContent.contains("&lt;"))
        #expect(result.htmlContent.contains("&gt;"))
        #expect(result.htmlContent.contains("&amp;"))
        #expect(result.htmlContent.contains("&quot;"))
        #expect(result.htmlContent.contains("&#39;"))
    }
}