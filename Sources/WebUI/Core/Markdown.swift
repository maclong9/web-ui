import Foundation
import Markdown

/// Service responsible for parsing Markdown strings into front matter and HTML content
public struct MarkdownParser {
  /// Represents a parsed Markdown document
  public struct ParsedMarkdown {
    public let frontMatter: [String: Any]
    public let htmlContent: String

    public init(frontMatter: [String: Any], htmlContent: String) {
      self.frontMatter = frontMatter
      self.htmlContent = htmlContent
    }
  }

  /// Parses a Markdown string into front matter and HTML content
  public static func parseMarkdown(_ content: String) -> ParsedMarkdown {
    // Extract front matter and markdown content
    let (frontMatter, markdownContent) = extractFrontMatter(from: content)

    // Parse the markdown content to HTML
    let document = Markdown.Document(parsing: markdownContent)
    var renderer = HtmlRenderer()
    let html = renderer.render(document)

    return ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
  }

  /// Extract front matter and content from the markdown string
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

  /// Parse front matter lines into a key-value dictionary
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

/// HTML Renderer for Markdown AST
public struct HtmlRenderer: MarkupWalker {
  public var html = ""

  public init() {}

  public mutating func render(_ document: Markdown.Document) -> String {
    html = ""
    visit(document)
    return html
  }

  public mutating func visitHeading(_ heading: Markdown.Heading) {
    let level = heading.level
    html += "<h\(level)>"
    descendInto(heading)
    html += "</h\(level)>"
  }

  public mutating func visitParagraph(_ paragraph: Paragraph) {
    html += "<p>"
    descendInto(paragraph)
    html += "</p>"
  }

  public mutating func visitText(_ text: Markdown.Text) {
    html += escapeHTML(text.string)
  }

  public mutating func visitLink(_ link: Markdown.Link) {
    html += "<a href=\"\(link.destination ?? "")\">"
    descendInto(link)
    html += "</a>"
  }

  public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) {
    html += "<em>"
    descendInto(emphasis)
    html += "</em>"
  }

  public mutating func visitStrong(_ strong: Markdown.Strong) {
    html += "<strong>"
    descendInto(strong)
    html += "</strong>"
  }

  public mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
    let language = codeBlock.language ?? ""
    html += "<pre><code class=\"language-\(language)\">"
    html += escapeHTML(codeBlock.code)
    html += "</code></pre>"
  }

  public mutating func visitInlineCode(_ inlineCode: InlineCode) {
    html += "<code>"
    html += escapeHTML(inlineCode.code)
    html += "</code>"
  }

  public mutating func visitListItem(_ listItem: ListItem) {
    html += "<li>"
    descendInto(listItem)
    html += "</li>"
  }

  public mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
    html += "<ul>"
    descendInto(unorderedList)
    html += "</ul>"
  }

  public mutating func visitOrderedList(_ orderedList: OrderedList) {
    html += "<ol>"
    descendInto(orderedList)
    html += "</ol>"
  }

  public mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
    html += "<blockquote>"
    descendInto(blockQuote)
    html += "</blockquote>"
  }

  public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
    html += "<hr />"
  }

  public mutating func visitImage(_ image: Markdown.Image) {
    let altText = image.plainText
    html += "<img src=\"\(image.source ?? "")\" alt=\"\(altText)\" />"
  }

  public mutating func visitTable(_ table: Table) {
    html += "<table>"
    descendInto(table)
    html += "</table>"
  }

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

  public mutating func visitTableBody(_ tableBody: Table.Body) {
    html += "<tbody>"
    descendInto(tableBody)
    html += "</tbody>"
  }

  public var insideTableHead = false

  public mutating func visitTableCell(_ tableCell: Table.Cell) {
    let tag = insideTableHead ? "th" : "td"
    html += "<\(tag)>"
    descendInto(tableCell)
    html += "</\(tag)>"
  }

  public mutating func defaultVisit(_ markup: Markup) {
    descendInto(markup)
  }

  public func escapeHTML(_ string: String) -> String {
    string
      .replacingOccurrences(of: "&", with: "&amp;")
      .replacingOccurrences(of: "<", with: "&lt;")
      .replacingOccurrences(of: ">", with: "&gt;")
      .replacingOccurrences(of: "\"", with: "&quot;")
      .replacingOccurrences(of: "'", with: "&#39;")
  }

}
