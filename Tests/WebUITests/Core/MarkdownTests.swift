import Foundation
import Markdown
import Testing

@testable import WebUI

@Suite("MarkdownParser Tests") struct MarkdownParserTests {
    // MARK: - ParsedMarkdown Tests

    @Test("ParsedMarkdown initialization")
    func testParsedMarkdownInitialization() throws {
        let frontMatter: [String: Any] = ["title": "Test Title", "description": "Test Description"]
        let htmlContent = "<p>Test content</p>"

        let parsed = MarkdownParser.ParsedMarkdown(frontMatter: frontMatter, htmlContent: htmlContent)

        #expect(parsed.frontMatter as? [String: String] == frontMatter as? [String: String])
        #expect(parsed.htmlContent == htmlContent)
    }

    // MARK: - Front Matter Parsing Tests

    @Test("Parse front matter lines with strings and dates")
    func testParseFrontMatterLines() throws {
        let lines = [
            "title: Introduction to Swift",
            "description: A guide to Swift programming",
            "published: April 15, 2025",
            "author: John Doe",
        ]

        let frontMatter = MarkdownParser.parseFrontMatterLines(lines)

        #expect(frontMatter["title"] as? String == "Introduction to Swift")
        #expect(frontMatter["description"] as? String == "A guide to Swift programming")
        #expect(frontMatter["author"] as? String == "John Doe")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let expectedDate = dateFormatter.date(from: "April 15, 2025")
        #expect(frontMatter["published"] as? Date == expectedDate)
    }

    @Test("Parse empty front matter lines")
    func testParseEmptyFrontMatterLines() throws {
        let lines: [String] = []
        let frontMatter = MarkdownParser.parseFrontMatterLines(lines)
        #expect(frontMatter.isEmpty)
    }

    @Test("Parse malformed front matter lines")
    func testParseMalformedFrontMatterLines() throws {
        let lines = [
            "title: Valid Title",
            "invalid line without colon",
            ": no key",
            "description: : invalid value",
        ]

        let frontMatter = MarkdownParser.parseFrontMatterLines(lines)
        #expect(frontMatter["title"] as? String == "Valid Title")
        #expect(frontMatter["description"] as? String == ": invalid value")
        #expect(frontMatter.count == 2)
    }

    @Test("Extract front matter and content")
    func testExtractFrontMatter() throws {
        let content = """
            ---
            title: Test Markdown
            description: A test markdown document
            published: April 15, 2025
            ---
            # Heading
            This is the content.
            """

        let (frontMatter, markdownContent) = MarkdownParser.extractFrontMatter(from: content)

        #expect(frontMatter["title"] as? String == "Test Markdown")
        #expect(frontMatter["description"] as? String == "A test markdown document")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let expectedDate = dateFormatter.date(from: "April 15, 2025")
        #expect(frontMatter["published"] as? Date == expectedDate)

        #expect(markdownContent == "# Heading\nThis is the content.")
    }

    @Test("Extract content without front matter")
    func testExtractNoFrontMatter() throws {
        let content = """
            # Heading
            This is the content.
            """

        let (frontMatter, markdownContent) = MarkdownParser.extractFrontMatter(from: content)

        #expect(frontMatter.isEmpty)
        #expect(markdownContent == content)
    }

    @Test("Extract empty front matter")
    func testExtractEmptyFrontMatter() throws {
        let content = """
            ---
            ---
            # Heading
            Content
            """

        let (frontMatter, markdownContent) = MarkdownParser.extractFrontMatter(from: content)

        #expect(frontMatter.isEmpty)
        #expect(markdownContent == "# Heading\nContent")
    }

    // MARK: - Markdown Parsing Tests

    @Test("Parse markdown with front matter and content")
    func testParseMarkdownWithFrontMatter() throws {
        let content = """
            ---
            title: Test Markdown
            description: A test markdown document
            published: April 15, 2025
            ---
            # Heading
            This is a **bold** paragraph with [a link](https://example.com).
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.frontMatter["title"] as? String == "Test Markdown")
        #expect(parsed.frontMatter["description"] as? String == "A test markdown document")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let expectedDate = dateFormatter.date(from: "April 15, 2025")
        #expect(parsed.frontMatter["published"] as? Date == expectedDate)
        #expect(parsed.htmlContent.contains("<h1>Heading</h1>"))
        #expect(
            parsed.htmlContent.contains(
                #"p>This is a <strong>bold</strong> paragraph with <a href="https://example.com" target="_blank" rel="noopener noreferrer">a link</a>"#
            )
        )
    }

    @Test("Parse markdown without front matter")
    func testParseMarkdownNoFrontMatter() throws {
        let content = """
            # Heading
            This is a paragraph.
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.frontMatter.isEmpty)
        #expect(parsed.htmlContent.contains("<h1>Heading</h1>"))
        #expect(parsed.htmlContent.contains("<p>This is a paragraph.</p>"))
    }

    @Test("Parse empty markdown string")
    func testParseEmptyMarkdown() throws {
        let content = ""
        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.frontMatter.isEmpty)
        #expect(parsed.htmlContent.isEmpty)
    }

    // MARK: - HTML Renderer Tests

    @Test("Render basic markdown elements")
    func testHtmlRendererBasicElements() throws {
        let content = """
            # Heading
            This is a **bold** and *italic* paragraph.
            [Link](https://example.com)
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<h1>Heading</h1>"))
        #expect(
            parsed.htmlContent.contains(
                "<p>This is a <strong>bold</strong> and <em>italic</em> paragraph."
            )
        )
        #expect(
            parsed.htmlContent.contains(
                #"<a href="https://example.com" target="_blank" rel="noopener noreferrer">Link</a>"#
            )
        )
        #expect(parsed.htmlContent.contains("</p>"))
    }

    @Test("Render code block")
    func testHtmlRendererCodeBlock() throws {
        let content = """
            ```swift
            let x = 5
            ```
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<pre><code class=\"language-swift\">let x = 5"))
        #expect(parsed.htmlContent.contains("</code></pre>"))
    }

    @Test("Render lists")
    func testHtmlRendererLists() throws {
        let content = """
            - Item 1
            - Item 2

            1. Ordered Item 1
            2. Ordered Item 2
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<ul><li><p>Item 1</p></li><li><p>Item 2</p></li></ul>"))
        #expect(
            parsed.htmlContent.contains(
                "<ol><li><p>Ordered Item 1</p></li><li><p>Ordered Item 2</p></li></ol>"
            )
        )
    }

    @Test("Render table")
    func testHtmlRendererTable() throws {
        let content = """
            | Header 1 | Header 2 |
            |----------|----------|
            | Cell 1   | Cell 2   |
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<table>"))
        #expect(
            parsed.htmlContent.contains("<thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>")
        )
        #expect(parsed.htmlContent.contains("<tbody><tr><td>Cell 1</td><td>Cell 2</td></tr></tbody>"))
        #expect(parsed.htmlContent.contains("</table>"))
    }

    @Test("Render block quote and thematic break")
    func testHtmlRendererBlockQuoteAndThematicBreak() throws {
        let content = """
            > This is a block quote.
            ---
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<blockquote><p>This is a block quote.</p></blockquote>"))
        #expect(parsed.htmlContent.contains("<hr />"))
    }

    @Test("Render image")
    func testHtmlRendererImage() throws {
        let content = """
            ![Alt text](image.jpg)
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.htmlContent.contains("<img src=\"image.jpg\" alt=\"Alt text\" />"))
    }

    // MARK: - Edge Cases Tests

    @Test("Parse markdown with special characters in front matter")
    func testParseSpecialCharactersInFrontMatter() throws {
        let content = """
            ---
            title: Special & Characters <Test>
            description: Quotes " and ' included
            ---
            # Heading
            Content
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.frontMatter["title"] as? String == "Special & Characters <Test>")
        #expect(parsed.frontMatter["description"] as? String == "Quotes \" and ' included")
        #expect(parsed.htmlContent.contains("<h1>Heading</h1>"))
        #expect(parsed.htmlContent.contains("<p>Content</p>"))
    }

    @Test("Parse markdown with special characters in content")
    func testParseSpecialCharactersInContent() throws {
        let content = """
            # Heading
            Special & characters < > " ' in content.
            """
        let parsed = MarkdownParser.parseMarkdown(content)
        #expect(parsed.frontMatter.isEmpty)
        #expect(
            parsed.htmlContent.contains(
                #"<h1>Heading</h1><p>Special &amp; characters &lt; &gt; “ ’ in content.</p>"#
            )
        )
    }

    @Test("Parse markdown with malformed Markdown syntax")
    func testParseMalformedMarkdown() throws {
        let content = """
            # Heading
            This is *unclosed italic text
            """

        let parsed = MarkdownParser.parseMarkdown(content)

        #expect(parsed.frontMatter.isEmpty)
        #expect(parsed.htmlContent.contains("<h1>Heading</h1>"))
        #expect(parsed.htmlContent.contains("<p>This is *unclosed italic text</p>"))
    }
}
