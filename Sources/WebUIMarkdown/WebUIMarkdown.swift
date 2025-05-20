import Foundation
import Markdown

/// A module for parsing and rendering Markdown content with front matter support.
///
/// This module provides functionality to transform Markdown text into HTML and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
public struct WebUIMarkdown {
    /// A structure representing a parsed Markdown document, containing front matter and HTML content.
    ///
    /// Encapsulates the results of parsing a Markdown document, providing access to both
    /// the extracted metadata (front matter) and the rendered HTML content.
    public struct ParsedMarkdown {
        /// The metadata extracted from the front matter section of the document.
        public let frontMatter: [String: Any]

        /// The HTML content generated from the Markdown body.
        public let htmlContent: String

        /// Initializes a `ParsedMarkdown` instance with front matter and HTML content.
        ///
        /// - Parameters:
        ///   - frontMatter: The parsed front matter as a dictionary mapping string keys to values.
        ///   - htmlContent: The HTML content generated from the Markdown body.
        public init(frontMatter: [String: Any], htmlContent: String) {
            self.frontMatter = frontMatter
            self.htmlContent = htmlContent
        }
    }

    /// Parses a Markdown string into front matter and HTML content.
    ///
    /// This method processes a Markdown string, separating the front matter (if present) and converting
    /// the Markdown content into HTML. It handles the complete workflow from extracting front matter
    /// to rendering the final HTML.
    ///
    /// - Parameter content: The raw Markdown string to parse.
    /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and HTML content.
    public static func parseMarkdown(_ content: String) -> ParsedMarkdown {
        let (frontMatter, markdownContent) = extractFrontMatter(from: content)

        // Parse the markdown content to HTML
        let document = Markdown.Document(parsing: markdownContent)
        var renderer = HtmlRenderer()
        let html = renderer.render(document)

        return ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
    }

    /// Extracts front matter and Markdown content from a raw Markdown string.
    ///
    /// The front matter is expected to be enclosed in `---` delimiters at the start of the string.
    /// If no front matter is present, an empty dictionary is returned, and the entire string is treated
    /// as Markdown content.
    ///
    /// - Parameter content: The raw Markdown string.
    /// - Returns: A tuple containing the parsed front matter as a dictionary and the remaining Markdown content.
    public static func extractFrontMatter(from content: String) -> ([String: Any], String) {
        let lines = content.components(separatedBy: .newlines)
        var frontMatter: [String: Any] = [:]
        var contentStartIndex = 0

        // Check if the string starts with front matter (---)
        if lines.first?.trimmingCharacters(in: .whitespaces) == "---" {
            var frontMatterLines: [String] = []
            var foundEndDelimiter = false

            // Collect lines until the closing ---
            for (index, line) in lines.dropFirst().enumerated() {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                if trimmedLine == "---" {
                    foundEndDelimiter = true
                    contentStartIndex = index + 2  // Skip the --- line
                    break
                }
                frontMatterLines.append(line)
            }

            if foundEndDelimiter {
                // Parse front matter lines into a dictionary
                frontMatter = parseFrontMatterLines(frontMatterLines)
            }
        }

        // Join the remaining lines for the markdown content
        let markdownContent = lines[contentStartIndex...].joined(separator: "\n")
        return (frontMatter, markdownContent)
    }

    /// Parses front matter lines into a key-value dictionary.
    ///
    /// This method processes lines of front matter, splitting each line on the first colon to create
    /// key-value pairs. It also attempts to parse date values for keys containing "date" or "published".
    ///
    /// - Parameter lines: An array of strings representing front matter lines.
    /// - Returns: A dictionary containing the parsed key-value pairs.
    public static func parseFrontMatterLines(_ lines: [String]) -> [String: Any] {
        var frontMatter: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }

            // Split on the first colon to separate key and value
            let components = trimmed.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
            guard components.count == 2 else { continue }

            let key = components[0].trimmingCharacters(in: .whitespaces).lowercased()
            let valueString = components[1].trimmingCharacters(in: .whitespaces)

            // Attempt to parse the value as a date if the key suggests it
            if key.contains("date") || key == "published",
                let date = dateFormatter.date(from: valueString)
            {
                frontMatter[key] = date
            } else {
                // Store as string by default
                frontMatter[key] = valueString
            }
        }

        return frontMatter
    }
}

/// A renderer that converts a Markdown Abstract Syntax Tree (AST) into HTML.
///
/// `HtmlRenderer` walks through the Markdown document structure and generates appropriate
/// HTML tags for each Markdown element, with special handling for links, code blocks,
/// and other formatting constructs.
public struct HtmlRenderer: MarkupWalker {
    public var html = ""

    /// Renders a Markdown document into HTML.
    ///
    /// Traverses the entire document tree and converts each node into its corresponding HTML representation.
    ///
    /// - Parameter document: The Markdown document to render.
    /// - Returns: The generated HTML string.
    public mutating func render(_ document: Markdown.Document) -> String {
        html = ""
        visit(document)
        return html
    }

    /// Visits a heading node and generates corresponding HTML.
    public mutating func visitHeading(_ heading: Markdown.Heading) {
        let level = heading.level
        html += "<h\(level)>"
        descendInto(heading)
        html += "</h\(level)>"
    }

    /// Visits a paragraph node and generates corresponding HTML.
    public mutating func visitParagraph(_ paragraph: Paragraph) {
        html += "<p>"
        descendInto(paragraph)
        html += "</p>"
    }

    /// Visits a text node and generates escaped HTML content.
    public mutating func visitText(_ text: Markdown.Text) {
        html += escapeHTML(text.string)
    }

    /// Visits a link node and generates corresponding HTML.
    public mutating func visitLink(_ link: Markdown.Link) {
        let destination = link.destination ?? ""
        let isExternal = destination.hasPrefix("http://") || destination.hasPrefix("https://")
        let targetAttr = isExternal ? " target=\"_blank\" rel=\"noopener noreferrer\"" : ""
        html += "<a href=\"\(destination)\"\(targetAttr)>"
        descendInto(link)
        html += "</a>"
    }

    /// Visits an emphasis node and generates corresponding HTML.
    public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) {
        html += "<em>"
        descendInto(emphasis)
        html += "</em>"
    }

    /// Visits a strong node and generates corresponding HTML.
    public mutating func visitStrong(_ strong: Markdown.Strong) {
        html += "<strong>"
        descendInto(strong)
        html += "</strong>"
    }

    /// Visits a code block node and generates corresponding HTML.
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
        let language = codeBlock.language ?? ""
        html += "<pre><code class=\"language-\(language)\">"
        html += escapeHTML(codeBlock.code)
        html += "</code></pre>"
    }

    /// Visits an inline code node and generates corresponding HTML.
    public mutating func visitInlineCode(_ inlineCode: InlineCode) {
        html += "<code>"
        html += escapeHTML(inlineCode.code)
        html += "</code>"
    }

    /// Visits a list item node and generates corresponding HTML.
    public mutating func visitListItem(_ listItem: ListItem) {
        html += "<li>"
        descendInto(listItem)
        html += "</li>"
    }

    /// Visits an unordered list node and generates corresponding HTML.
    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
        html += "<ul>"
        descendInto(unorderedList)
        html += "</ul>"
    }

    /// Visits an ordered list node and generates corresponding HTML.
    public mutating func visitOrderedList(_ orderedList: OrderedList) {
        html += "<ol>"
        descendInto(orderedList)
        html += "</ol>"
    }

    /// Visits a block quote node and generates corresponding HTML.
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
        html += "<blockquote>"
        descendInto(blockQuote)
        html += "</blockquote>"
    }

    /// Visits a thematic break node and generates corresponding HTML.
    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
        html += "<hr />"
    }

    /// Visits an image node and generates corresponding HTML.
    public mutating func visitImage(_ image: Markdown.Image) {
        let altText = image.plainText
        html += "<img src=\"\(image.source ?? "")\" alt=\"\(altText)\" />"
    }

    /// Visits a table node and generates corresponding HTML.
    public mutating func visitTable(_ table: Table) {
        html += "<table>"
        descendInto(table)
        html += "</table>"
    }

    /// Visits a table head node and generates corresponding HTML.
    public mutating func visitTableHead(_ tableHead: Table.Head) {
        html += "<thead><tr>"
        insideTableHead = true
        for child in tableHead.children {
            if let cell = child as? Table.Cell {
                visitTableCell(cell)
            } else {
                descendInto(child)
            }
        }
        insideTableHead = false
        html += "</tr></thead>"
    }

    /// Visits a table row node and generates corresponding HTML.
    public mutating func visitTableRow(_ tableRow: Table.Row) {
        html += "<tr>"
        for child in tableRow.children {
            if let cell = child as? Table.Cell {
                visitTableCell(cell)
            } else {
                descendInto(child)
            }
        }
        html += "</tr>"
    }

    /// Visits a table body node and generates corresponding HTML.
    public mutating func visitTableBody(_ tableBody: Table.Body) {
        html += "<tbody>"
        descendInto(tableBody)
        html += "</tbody>"
    }

    /// A flag indicating whether the renderer is currently processing a table head.
    public var insideTableHead = false

    /// Visits a table cell node and generates corresponding HTML.
    public mutating func visitTableCell(_ tableCell: Table.Cell) {
        let tag = insideTableHead ? "th" : "td"
        html += "<\(tag)>"
        descendInto(tableCell)
        html += "</\(tag)>"
    }

    /// A fallback method for visiting any unhandled markup nodes.
    public mutating func defaultVisit(_ markup: Markup) {
        descendInto(markup)
    }

    /// Escapes special HTML characters in a string to prevent injection.
    public func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
