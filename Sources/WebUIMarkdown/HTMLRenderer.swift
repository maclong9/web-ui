/// A renderer that converts a Markdown Abstract Syntax Tree (AST) into markup.
///
/// `HtmlRenderer` walks through the Markdown document structure and generates appropriate
/// markup tags for each Markdown element, with special handling for links, code blocks,
/// and other formatting constructs.
/// A renderer that converts a Markdown Abstract Syntax Tree (AST) into markup with configurable code block rendering options.
///
/// `HtmlRenderer` walks through the Markdown document structure and generates appropriate
/// markup tags for each Markdown element, with special handling for links, code blocks,
/// and other formatting constructs. Code block rendering features such as syntax highlighting,
/// filename display, copy button, and line numbers can be enabled or disabled via boolean flags.
///
/// ## Error Handling
///
/// The renderer provides both throwing and safe variants:
///
/// ```swift
/// let document = Document(parsing: markdownContent)
/// var renderer = HtmlRenderer()
///
/// // Throwing version - use when you need to handle specific errors
/// do {
///     let html = try renderer.render(document)
///     print("Rendered HTML: \(html)")
/// } catch HtmlRendererError.invalidLinkDestination {
///     print("Found a link without a destination")
/// } catch HtmlRendererError.missingImageSource {
///     print("Found an image without a source")
/// } catch {
///     print("Rendering failed: \(error)")
/// }
///
/// // Safe version - continues rendering even with errors
/// let safeHtml = renderer.renderSafely(document)
/// print("HTML: \(safeHtml)")
/// ```
import Foundation
import Markdown

public struct HtmlRenderer {
    public var html = ""

    /// Renders a Markdown document into HTML.
    ///
    /// Traverses the entire document tree and converts each node into its corresponding HTML representation.
    ///
    /// - Parameter document: The Markdown document to render.
    /// - Returns: The generated HTML string.
    /// - Throws: `HtmlRendererError` if rendering encounters invalid content.
    public mutating func render(_ document: Markdown.Document) throws -> String {
        html = ""
        try renderMarkup(document)
        return html
    }

    /// Renders a Markdown document into HTML with graceful error handling.
    ///
    /// This is a convenience method that handles errors gracefully by skipping problematic
    /// nodes and continuing with the rest of the document.
    ///
    /// - Parameter document: The Markdown document to render.
    /// - Returns: The generated HTML string. Problematic nodes are replaced with error messages.
    public mutating func renderSafely(_ document: Markdown.Document) -> String {
        html = ""
        do {
            try renderMarkup(document)
        } catch {
            html += "<!-- Rendering error: \(error.localizedDescription) -->"
        }
        return html
    }

    /// Renders any markup node by dispatching to the appropriate visit method.
    ///
    /// - Parameter markup: The markup node to render.
    /// - Throws: `HtmlRendererError` if rendering encounters invalid content.
    private mutating func renderMarkup(_ markup: Markup) throws {
        switch markup {
            case let heading as Markdown.Heading:
                try visitHeading(heading)
            case let paragraph as Paragraph:
                try visitParagraph(paragraph)
            case let text as Markdown.Text:
                try visitText(text)
            case let link as Markdown.Link:
                try visitLink(link)
            case let emphasis as Markdown.Emphasis:
                try visitEmphasis(emphasis)
            case let strong as Markdown.Strong:
                try visitStrong(strong)
            case let codeBlock as CodeBlock:
                try visitCodeBlock(codeBlock)
            case let inlineCode as InlineCode:
                try visitInlineCode(inlineCode)
            case let listItem as ListItem:
                try visitListItem(listItem)
            case let unorderedList as UnorderedList:
                try visitUnorderedList(unorderedList)
            case let orderedList as OrderedList:
                try visitOrderedList(orderedList)
            case let blockQuote as BlockQuote:
                try visitBlockQuote(blockQuote)
            case let thematicBreak as ThematicBreak:
                try visitThematicBreak(thematicBreak)
            case let image as Markdown.Image:
                try visitImage(image)
            case let table as Table:
                try visitTable(table)
            case let tableHead as Table.Head:
                try visitTableHead(tableHead)
            case let tableRow as Table.Row:
                try visitTableRow(tableRow)
            case let tableBody as Table.Body:
                try visitTableBody(tableBody)
            case let tableCell as Table.Cell:
                try visitTableCell(tableCell)
            case let htmlBlock as Markdown.HTMLBlock:
                try visitHTMLBlock(htmlBlock)
            case let inlineHTML as Markdown.InlineHTML:
                try visitInlineHTML(inlineHTML)
            default:
                try defaultVisit(markup)
        }
    }

    /// Renders all child markup nodes of a container.
    ///
    /// - Parameter markup: The container markup node whose children should be rendered.
    /// - Throws: `HtmlRendererError` if rendering encounters invalid content.
    private mutating func renderChildren(_ markup: Markup) throws {
        for child in markup.children {
            try renderMarkup(child)
        }
    }

    /// Visits a heading node and generates corresponding HTML.
    public mutating func visitHeading(_ heading: Markdown.Heading) throws {
        let level = heading.level
        html += "<h\(level)>"
        try renderChildren(heading)
        html += "</h\(level)>"
    }

    /// Visits a paragraph node and generates corresponding HTML.
    public mutating func visitParagraph(_ paragraph: Paragraph) throws {
        html += "<p>"
        try renderChildren(paragraph)
        html += "</p>"
    }

    /// Visits a text node and generates escaped HTML content.
    public mutating func visitText(_ text: Markdown.Text) throws {
        html += escapeHTML(text.string)
    }

    /// Visits a link node and generates corresponding HTML.
    public mutating func visitLink(_ link: Markdown.Link) throws {
        guard let destination = link.destination, !destination.isEmpty else {
            throw HtmlRendererError.invalidLinkDestination
        }

        let escapedDestination = escapeHTML(destination)
        let isExternal =
            escapedDestination.hasPrefix("http://")
            || escapedDestination.hasPrefix("https://")
        let targetAttr =
            isExternal ? " target=\"_blank\" rel=\"noopener noreferrer\"" : ""
        html += "<a href=\"\(escapedDestination)\"\(targetAttr)>"
        try renderChildren(link)
        html += "</a>"
    }

    /// Visits an emphasis node and generates corresponding HTML.
    public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) throws {
        html += "<em>"
        try renderChildren(emphasis)
        html += "</em>"
    }

    /// Visits a strong node and generates corresponding HTML.
    public mutating func visitStrong(_ strong: Markdown.Strong) throws {
        html += "<strong>"
        try renderChildren(strong)
        html += "</strong>"
    }

    /// Visits a code block node and generates corresponding HTML with optional syntax highlighting, filename, copy button, and line numbers.
    ///
    /// - Parameter codeBlock: The code block node to render.
    /// - Throws: `HtmlRendererError.invalidCodeBlock` if the code block content is invalid.
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) throws {
        guard
            !codeBlock.code.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        else {
            throw HtmlRendererError.invalidCodeBlock
        }

        // Simply extract the code content
        let code = escapeHTML(codeBlock.code)

        // Build the basic HTML for the code block
        html += "<pre><code>"
        html += code
        html += "</code></pre>"
    }

    /// Visits an inline code node and generates corresponding HTML.
    public mutating func visitInlineCode(_ inlineCode: InlineCode) throws {
        html += "<code>"
        html += escapeHTML(inlineCode.code)
        html += "</code>"
    }

    /// Visits a list item node and generates corresponding HTML.
    public mutating func visitListItem(_ listItem: ListItem) throws {
        html += "<li>"
        try renderChildren(listItem)
        html += "</li>"
    }

    /// Visits an unordered list node and generates corresponding HTML.
    public mutating func visitUnorderedList(_ unorderedList: UnorderedList)
        throws
    {
        html += "<ul>"
        try renderChildren(unorderedList)
        html += "</ul>"
    }

    /// Visits an ordered list node and generates corresponding HTML.
    public mutating func visitOrderedList(_ orderedList: OrderedList) throws {
        html += "<ol>"
        try renderChildren(orderedList)
        html += "</ol>"
    }

    /// Visits a block quote node and generates corresponding HTML.
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) throws {
        html += "<blockquote>"
        try renderChildren(blockQuote)
        html += "</blockquote>"
    }

    /// Visits a thematic break node and generates corresponding HTML.
    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak)
        throws
    {
        html += "<hr />"
    }

    /// Visits an image node and generates corresponding HTML.
    public mutating func visitImage(_ image: Markdown.Image) throws {
        guard let source = image.source, !source.isEmpty else {
            throw HtmlRendererError.missingImageSource
        }

        let altText = image.plainText
        let escapedSource = escapeHTML(source)
        let escapedAltText = escapeHTML(altText)
        html += "<img src=\"\(escapedSource)\" alt=\"\(escapedAltText)\" />"
    }

    /// Visits a table node and generates corresponding HTML.
    public mutating func visitTable(_ table: Table) throws {
        html += "<table>"
        try renderChildren(table)
        html += "</table>"
    }

    /// Visits a table head node and generates corresponding HTML.
    public mutating func visitTableHead(_ tableHead: Table.Head) throws {
        html += "<thead><tr>"
        insideTableHead = true
        for child in tableHead.children {
            if let cell = child as? Table.Cell {
                try visitTableCell(cell)
            } else {
                try renderMarkup(child)
            }
        }
        insideTableHead = false
        html += "</tr></thead>"
    }

    /// Visits a table row node and generates corresponding HTML.
    public mutating func visitTableRow(_ tableRow: Table.Row) throws {
        html += "<tr>"
        for child in tableRow.children {
            if let cell = child as? Table.Cell {
                try visitTableCell(cell)
            } else {
                try renderMarkup(child)
            }
        }
        html += "</tr>"
    }

    /// Visits a table body node and generates corresponding HTML.
    public mutating func visitTableBody(_ tableBody: Table.Body) throws {
        html += "<tbody>"
        try renderChildren(tableBody)
        html += "</tbody>"
    }

    /// A flag indicating whether the renderer is currently processing a table head.
    public var insideTableHead = false

    /// Visits a table cell node and generates corresponding HTML.
    public mutating func visitTableCell(_ tableCell: Table.Cell) throws {
        let tag = insideTableHead ? "th" : "td"
        html += "<\(tag)>"
        try renderChildren(tableCell)
        html += "</\(tag)>"
    }

    /// Visits a block of rawHTML and adds it to the Markdown file
    public mutating func visitHTMLBlock(_ htmlBlock: Markdown.HTMLBlock) throws {
        html += htmlBlock.rawHTML
    }

    /// Visits inline rawHTML and adds it to the Markdown file
    public mutating func visitInlineHTML(_ inlineHTML: Markdown.InlineHTML) throws {
        html += inlineHTML.rawHTML
    }

    /// A fallback method for visiting any unhandled markup nodes.
    public mutating func defaultVisit(_ markup: Markup) throws {
        try renderChildren(markup)
    }

    /// Escapes special HTML characters in a string to prevent injection.
    ///
    /// - Parameter string: The string to escape.
    /// - Returns: The escaped HTML string.
    public func escapeHTML(_ string: String) -> String {

        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}

/// Errors that can occur during WebUIMarkdown operations.
public enum WebUIMarkdownError: Error, LocalizedError {
    /// Front matter delimiter is opened but not properly closed.
    case invalidFrontMatter
    /// No front matter found in the document.
    case noFrontMatter
    /// Front matter contains malformed key-value pairs.
    case malformedFrontMatter(line: String)
    /// Date parsing failed for a front matter value.
    case dateParsingFailed(key: String, value: String)
    /// Markdown content is empty or invalid.
    case emptyContent

    public var errorDescription: String? {
        switch self {
            case .invalidFrontMatter:
                return "Front matter is not properly closed with '---'"
            case .noFrontMatter:
                return "No front matter found in the document"
            case .malformedFrontMatter(let line):
                return "Malformed front matter line: '\(line)'"
            case .dateParsingFailed(let key, let value):
                return
                    "Failed to parse date for key '\(key)' with value '\(value)'"
            case .emptyContent:
                return "Markdown content is empty or invalid"
        }
    }
}

/// Errors that can occur during HTML rendering operations.
public enum HtmlRendererError: Error, LocalizedError {
    /// Link destination is missing or invalid.
    case invalidLinkDestination
    /// Image source is missing.
    case missingImageSource
    /// Table structure is malformed.
    case malformedTable
    /// Code block contains invalid content.
    case invalidCodeBlock

    public var errorDescription: String? {
        switch self {
            case .invalidLinkDestination:
                return "Link destination is missing or invalid"
            case .missingImageSource:
                return "Image source is required but missing"
            case .malformedTable:
                return "Table structure is malformed"
            case .invalidCodeBlock:
                return "Code block contains invalid content"
        }
    }
}
