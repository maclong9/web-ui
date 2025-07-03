import Testing
import Foundation

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
        #expect(result.htmlContent.contains("<pre>"))
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
        #expect(!invalidResult.htmlContent.isEmpty) // Should contain error message
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
}