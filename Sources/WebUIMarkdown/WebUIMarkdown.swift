import Foundation
import Markdown

/// A module for parsing and rendering Markdown content with front matter support and advanced rendering features.
///
/// This module provides functionality to transform Markdown text into markup and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
/// Advanced features include syntax highlighting, table of contents generation, interactive
/// code blocks, mathematical notation support, and comprehensive typography configuration.
///
/// ## Basic Usage
///
/// ```swift
/// let markdown = WebUIMarkdown()
/// let content = """
/// ---
/// title: Example Post
/// date: January 1, 2024
/// ---
/// # Hello World
/// This is a sample post with `inline code` and:
///
/// ```swift
/// let example = "syntax highlighted code"
/// ```
/// """
///
/// // Basic rendering
/// let result = try markdown.parseMarkdown(content)
/// print("Title: \(result.frontMatter["title"] ?? "Unknown")")
/// print("HTML: \(result.htmlContent)")
/// ```
///
/// ## Enhanced Rendering
///
/// ```swift
/// // Configure enhanced features
/// let options = MarkdownRenderingOptions.enhanced
/// let typography = MarkdownTypography.documentation
/// let markdown = WebUIMarkdown(options: options, typography: typography)
///
/// // Render with table of contents
/// let (html, toc) = try markdown.parseMarkdownWithTableOfContents(content)
/// print("Content: \(html)")
/// print("Table of Contents: \(toc)")
/// ```
///
/// ## Error Handling
///
/// The module provides both throwing and safe variants of parsing methods for robust error handling.
public struct WebUIMarkdown: Sendable {

  // MARK: - Configuration

  /// Rendering options that control advanced features
  public let options: MarkdownRenderingOptions

  /// Typography configuration for styling
  public let typography: MarkdownTypography

  // MARK: - Initialization

  /// Initialize with default configuration
  public init() {
    self.options = MarkdownRenderingOptions(codeBlocks: MarkdownRenderingOptions.CodeBlockOptions())
    self.typography = MarkdownTypography(defaultFontSize: .body)
  }

  /// Initialize with custom configuration
  public init(options: MarkdownRenderingOptions, typography: MarkdownTypography) {
    self.options = options
    self.typography = typography
  }

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

  /// Parses a Markdown string into front matter and HTML content using enhanced rendering.
  ///
  /// This method processes a Markdown string, separating the front matter (if present) and converting
  /// the Markdown content into HTML with advanced features like syntax highlighting, table of contents,
  /// interactive code blocks, and mathematical notation support based on the configuration.
  ///
  /// - Parameter content: The raw Markdown string to parse.
  /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and enhanced HTML content.
  /// - Throws: `WebUIMarkdownError` if the content cannot be parsed or rendering fails.
  public func parseMarkdown(_ content: String) throws -> ParsedMarkdown {
    guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else {
      throw WebUIMarkdownError.emptyContent
    }

    let (frontMatter, markdownContent) = try extractFrontMatter(from: content)

    // Parse the markdown content to HTML using enhanced renderer
    let document = Markdown.Document(parsing: markdownContent)
    var renderer = EnhancedHTMLRenderer(options: options, typography: typography)
    let html = try renderer.render(document)

    return ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
  }

  /// Parses a Markdown string with table of contents generation.
  ///
  /// This method provides the same functionality as `parseMarkdown(_:)` but additionally generates
  /// a table of contents if enabled in the rendering options. The table of contents is returned
  /// as separate HTML content that can be displayed independently.
  ///
  /// - Parameter content: The raw Markdown string to parse.
  /// - Returns: A tuple containing the parsed result and table of contents HTML.
  /// - Throws: `WebUIMarkdownError` if the content cannot be parsed or rendering fails.
  public func parseMarkdownWithTableOfContents(_ content: String) throws -> (
    result: ParsedMarkdown, tableOfContents: String
  ) {
    guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else {
      throw WebUIMarkdownError.emptyContent
    }

    let (frontMatter, markdownContent) = try extractFrontMatter(from: content)

    // Parse the markdown content to HTML using enhanced renderer
    let document = Markdown.Document(parsing: markdownContent)
    var renderer = EnhancedHTMLRenderer(options: options, typography: typography)
    let (html, toc) = try renderer.renderWithTableOfContents(document)

    let result = ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
    return (result, toc)
  }

  /// Parses a Markdown string into front matter and HTML content with graceful error handling.
  ///
  /// This is a convenience method that handles errors gracefully by returning default values
  /// when parsing fails. Suitable for use cases where you want to display content even if
  /// parsing encounters errors. Uses enhanced rendering when successful.
  ///
  /// - Parameter content: The raw Markdown string to parse.
  /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and HTML content.
  ///           Returns empty front matter and escaped HTML content if parsing fails.
  public func parseMarkdownSafely(_ content: String) -> ParsedMarkdown {
    do {
      return try parseMarkdown(content)
    } catch {
      // Return safe fallback content using enhanced renderer's escape method
      let renderer = EnhancedHTMLRenderer(options: options, typography: typography)
      let escapedContent = renderer.escapeHTML(content)
      return ParsedMarkdown(
        frontMatter: [:], htmlContent: "<pre class=\"markdown-error\">\(escapedContent)</pre>")
    }
  }

  /// Safely parses a Markdown string with table of contents generation.
  ///
  /// This method provides graceful error handling for table of contents generation.
  /// If parsing fails, returns the fallback content with an empty table of contents.
  ///
  /// - Parameter content: The raw Markdown string to parse.
  /// - Returns: A tuple containing the parsed result and table of contents HTML.
  public func parseMarkdownSafelyWithTableOfContents(_ content: String) -> (
    result: ParsedMarkdown, tableOfContents: String
  ) {
    do {
      return try parseMarkdownWithTableOfContents(content)
    } catch {
      let fallbackResult = parseMarkdownSafely(content)
      return (fallbackResult, "")
    }
  }

  // MARK: - CSS Generation

  /// Generates CSS styles for the configured typography.
  ///
  /// This method produces CSS that can be included in HTML documents to style
  /// the rendered markdown content according to the typography configuration.
  ///
  /// - Returns: A CSS string containing styles for all configured typography elements.
  public func generateCSS() -> String {
    typography.generateCSS()
  }

  /// Generates advanced CSS styles with enhanced selectors.
  ///
  /// This method produces comprehensive CSS including both typography styles and
  /// advanced selectors for enhanced features like code blocks and table of contents.
  ///
  /// - Returns: A CSS string with comprehensive styling for enhanced markdown features.
  public func generateAdvancedCSS() -> String {
    typography.generateAdvancedCSS()
  }

  // MARK: - Configuration Access

  /// Creates a new WebUIMarkdown instance with modified rendering options.
  ///
  /// - Parameter options: The new rendering options to use.
  /// - Returns: A new WebUIMarkdown instance with the specified options.
  public func withOptions(_ options: MarkdownRenderingOptions) -> WebUIMarkdown {
    WebUIMarkdown(options: options, typography: typography)
  }

  /// Creates a new WebUIMarkdown instance with modified typography configuration.
  ///
  /// - Parameter typography: The new typography configuration to use.
  /// - Returns: A new WebUIMarkdown instance with the specified typography.
  public func withTypography(_ typography: MarkdownTypography) -> WebUIMarkdown {
    WebUIMarkdown(options: options, typography: typography)
  }

  /// Creates a new WebUIMarkdown instance with both options and typography modified.
  ///
  /// - Parameters:
  ///   - options: The new rendering options to use.
  ///   - typography: The new typography configuration to use.
  /// - Returns: A new WebUIMarkdown instance with the specified configuration.
  public func withConfiguration(options: MarkdownRenderingOptions, typography: MarkdownTypography)
    -> WebUIMarkdown
  {
    WebUIMarkdown(options: options, typography: typography)
  }

  /// Extracts front matter and Markdown content from a raw Markdown string.
  ///
  /// The front matter is expected to be enclosed in `---` delimiters at the start of the string.
  /// If no front matter is present, an empty dictionary is returned, and the entire string is treated
  /// as Markdown content.
  ///
  /// - Parameter content: The raw Markdown string.
  /// - Returns: A tuple containing the parsed front matter as a dictionary and the remaining Markdown content.
  /// - Throws: `WebUIMarkdownError.invalidFrontMatter` if front matter is not properly closed.
  public func extractFrontMatter(from content: String) throws -> (
    [String: Any], String
  ) {
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
        frontMatter = try parseFrontMatterLines(frontMatterLines)
      } else {
        throw WebUIMarkdownError.invalidFrontMatter
      }
    }

    // Join the remaining lines for the markdown content
    let markdownContent = lines[contentStartIndex...].joined(
      separator: "\n")
    return (frontMatter, markdownContent)
  }

  /// Parses front matter lines into a key-value dictionary.
  ///
  /// This method processes lines of front matter, splitting each line on the first colon to create
  /// key-value pairs. It also attempts to parse date values for keys containing "date" or "published".
  ///
  /// - Parameter lines: An array of strings representing front matter lines.
  /// - Returns: A dictionary containing the parsed key-value pairs.
  /// - Throws: `WebUIMarkdownError.malformedFrontMatter` if a line doesn't follow the expected format.
  public func parseFrontMatterLines(_ lines: [String]) throws -> [String: Any] {
    var frontMatter: [String: Any] = [:]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy"

    for line in lines {
      let trimmed = line.trimmingCharacters(in: .whitespaces)
      if trimmed.isEmpty {
        continue
      }

      // Split on the first colon to separate key and value
      let components = trimmed.split(
        separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
      guard components.count == 2 else {
        throw WebUIMarkdownError.malformedFrontMatter(line: trimmed)
      }

      let key = components[0].trimmingCharacters(in: .whitespaces)
        .lowercased()
      let valueString = components[1].trimmingCharacters(in: .whitespaces)

      // Attempt to parse the value as a date if the key suggests it
      if key.contains("date") || key == "published" {
        if let date = dateFormatter.date(from: valueString) {
          frontMatter[key] = date
        } else {
          // If date parsing fails, store as string with a warning
          frontMatter[key] = valueString
        }
      } else {
        // Store as string by default
        frontMatter[key] = valueString
      }
    }

    return frontMatter
  }
}
