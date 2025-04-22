import Foundation
import Markdown

/// A service for parsing Markdown strings into front matter and HTML content.
///
/// This struct provides functionality to process Markdown content, extracting metadata (front matter)
/// and converting the Markdown body into HTML using the `Markdown` framework.
public struct MarkdownParser {
  /// A structure representing a parsed Markdown document, containing front matter and HTML content.
  public struct ParsedMarkdown {
    /// A dictionary containing the parsed front matter key-value pairs.
    ///
    /// The keys are typically strings, and the values can be strings, dates, or other types depending
    /// on the parsing logic.
    public let frontMatter: [String: Any]

    /// The HTML content generated from the Markdown body.
    public let htmlContent: String

    /// Initializes a `ParsedMarkdown` instance with front matter and HTML content.
    ///
    /// - Parameters:
    ///   - frontMatter: The parsed front matter as a dictionary.
    ///   - htmlContent: The HTML content generated from the Markdown.
    public init(frontMatter: [String: Any], htmlContent: String) {
      self.frontMatter = frontMatter
      self.htmlContent = htmlContent
    }
  }

  /// Parses a Markdown string into front matter and HTML content.
  ///
  /// This method processes a Markdown string, separating the front matter (if present) and converting
  /// the Markdown content into HTML.
  ///
  /// - Parameter content: The raw Markdown string to parse.
  /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and HTML content.
  public static func parseMarkdown(_ content: String) -> ParsedMarkdown {
    // Extract front matter and markdown content
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
      if key.contains("date") || key == "published", let date = dateFormatter.date(from: valueString) {
        frontMatter[key] = date
      } else {
        // Store as string by default
        frontMatter[key] = valueString
      }
    }

    return frontMatter
  }
}

/// A renderer that converts a Markdown AST into HTML.
public struct HtmlRenderer: MarkupWalker {
  /// The accumulated HTML output.
  public var html = ""

  /// Initializes an `HtmlRenderer` instance.
  public init() {}

  /// Renders a Markdown document into HTML.
  ///
  /// - Parameter document: The Markdown document to render.
  /// - Returns: The generated HTML string.
  public mutating func render(_ document: Markdown.Document) -> String {
    html = ""
    visit(document)
    return html
  }

  /// Visits a heading node and generates corresponding HTML.
  ///
  /// - Parameter heading: The heading node to process.
  public mutating func visitHeading(_ heading: Markdown.Heading) {
    let level = heading.level
    html += "<h\(level)>"
    descendInto(heading)
    html += "</h\(level)>"
  }

  /// Visits a paragraph node and generates corresponding HTML.
  ///
  /// - Parameter paragraph: The paragraph node to process.
  public mutating func visitParagraph(_ paragraph: Paragraph) {
    html += "<p>"
    descendInto(paragraph)
    html += "</p>"
  }

  /// Visits a text node and generates escaped HTML content.
  ///
  /// - Parameter text: The text node to process.
  public mutating func visitText(_ text: Markdown.Text) {
    html += escapeHTML(text.string)
  }

  /// Visits a link node and generates corresponding HTML.
  ///
  /// - Parameter link: The link node to process.
  public mutating func visitLink(_ link: Markdown.Link) {
    html += "<a href=\"\(link.destination ?? "")\">"
    descendInto(link)
    html += "</a>"
  }

  /// Visits an emphasis node and generates corresponding HTML.
  ///
  /// - Parameter emphasis: The emphasis node to process.
  public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) {
    html += "<em>"
    descendInto(emphasis)
    html += "</em>"
  }

  /// Visits a strong node and generates corresponding HTML.
  ///
  /// - Parameter strong: The strong node to process.
  public mutating func visitStrong(_ strong: Markdown.Strong) {
    html += "<strong>"
    descendInto(strong)
    html += "</strong>"
  }

  /// Visits a code block node and generates corresponding HTML.
  ///
  /// - Parameter codeBlock: The code block node to process.
  public mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
    let language = codeBlock.language ?? ""
    html += "<pre><code class=\"language-\(language)\">"
    html += escapeHTML(codeBlock.code)
    html += "</code></pre>"
  }

  /// Visits an inline code node and generates corresponding HTML.
  ///
  /// - Parameter inlineCode: The inline code node to process.
  public mutating func visitInlineCode(_ inlineCode: InlineCode) {
    html += "<code>"
    html += escapeHTML(inlineCode.code)
    html += "</code>"
  }

  /// Visits a list item node and generates corresponding HTML.
  ///
  /// - Parameter listItem: The list item node to process.
  public mutating func visitListItem(_ listItem: ListItem) {
    html += "<li>"
    descendInto(listItem)
    html += "</li>"
  }

  /// Visits an unordered list node and generates corresponding HTML.
  ///
  /// - Parameter unorderedList: The unordered list node to process.
  public mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
    html += "<ul>"
    descendInto(unorderedList)
    html += "</ul>"
  }

  /// Visits an ordered list node and generates corresponding HTML.
  ///
  /// - Parameter orderedList: The ordered list node to process.
  public mutating func visitOrderedList(_ orderedList: OrderedList) {
    html += "<ol>"
    descendInto(orderedList)
    html += "</ol>"
  }

  /// Visits a block quote node and generates corresponding HTML.
  ///
  /// - Parameter blockQuote: The block quote node to process.
  public mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
    html += "<blockquote>"
    descendInto(blockQuote)
    html += "</blockquote>"
  }

  /// Visits a thematic break node and generates corresponding HTML.
  ///
  /// - Parameter thematicBreak: The thematic break node to process.
  public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
    html += "<hr />"
  }

  /// Visits an image node and generates corresponding HTML.
  ///
  /// - Parameter image: The image node to process.
  public mutating func visitImage(_ image: Markdown.Image) {
    let altText = image.plainText
    html += "<img src=\"\(image.source ?? "")\" alt=\"\(altText)\" />"
  }

  /// Visits a table node and generates corresponding HTML.
  ///
  /// - Parameter table: The table node to process.
  public mutating func visitTable(_ table: Table) {
    html += "<table>"
    descendInto(table)
    html += "</table>"
  }

  /// Visits a table head node and generates corresponding HTML.
  ///
  /// - Parameter tableHead: The table head node to process.
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
  ///
  /// - Parameter tableRow: The table row node to process.
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
  ///
  /// - Parameter tableBody: The table body node to process.
  public mutating func visitTableBody(_ tableBody: Table.Body) {
    html += "<tbody>"
    descendInto(tableBody)
    html += "</tbody>"
  }

  /// A flag indicating whether the renderer is currently processing a table head.
  public var insideTableHead = false

  /// Visits a table cell node and generates corresponding HTML.
  ///
  /// - Parameter tableCell: The table cell node to process.
  public mutating func visitTableCell(_ tableCell: Table.Cell) {
    let tag = insideTableHead ? "th" : "td"
    html += "<\(tag)>"
    descendInto(tableCell)
    html += "</\(tag)>"
  }

  /// A fallback method for visiting any unhandled markup nodes.
  ///
  /// - Parameter markup: The markup node to process.
  public mutating func defaultVisit(_ markup: Markup) {
    descendInto(markup)
  }

  /// Escapes special HTML characters in a string to prevent injection.
  ///
  /// - Parameter string: The input string to escape.
  /// - Returns: The escaped string safe for HTML output.
  public func escapeHTML(_ string: String) -> String {
    string
      .replacingOccurrences(of: "&", with: "&amp;")
      .replacingOccurrences(of: "<", with: "&lt;")
      .replacingOccurrences(of: ">", with: "&gt;")
      .replacingOccurrences(of: "\"", with: "&quot;")
      .replacingOccurrences(of: "'", with: "&#39;")
  }
}
