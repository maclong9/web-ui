import Foundation
import Markdown

/// A module for parsing and rendering Markdown content with front matter support.
///
/// This module provides functionality to transform Markdown text into markup and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
/// A module for parsing and rendering Markdown content with front matter support and configurable code block rendering.
///
/// This module provides functionality to transform Markdown text into markup and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
/// Code block rendering features such as syntax highlighting, filename display, copy button,
/// and line numbers can be enabled or disabled via boolean flags.
///
/// ## Error Handling
///
/// The module provides both throwing and safe variants of parsing methods:
///
/// ```swift
/// let markdown = WebUIMarkdown()
/// let content = """
/// ---
/// title: Example Post
/// date: January 1, 2024
/// ---
/// # Hello World
/// This is a sample post.
/// """
///
/// // Throwing version - use when you need to handle errors explicitly
/// do {
///     let result = try markdown.parseMarkdown(content)
///     print("Title: \(result.frontMatter["title"] ?? "Unknown")")
///     print("HTML: \(result.htmlContent)")
/// } catch WebUIMarkdownError.invalidFrontMatter {
///     print("Front matter is not properly closed")
/// } catch WebUIMarkdownError.emptyContent {
///     print("Content is empty")
/// } catch {
///     print("Parsing failed: \(error)")
/// }
///
/// // Safe version - returns default values on error
/// let safeResult = markdown.parseMarkdownSafely(content)
/// print("HTML: \(safeResult.htmlContent)")
/// ```
public struct WebUIMarkdown {
    /// public init otherwise it breaks
    public init() {}

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
    /// - Throws: `WebUIMarkdownError` if the content cannot be parsed or `HtmlRendererError` if HTML rendering fails.
    public func parseMarkdown(_ content: String) throws -> ParsedMarkdown {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            throw WebUIMarkdownError.emptyContent
        }

        let (frontMatter, markdownContent) = try extractFrontMatter(
            from: content)

        // Parse the markdown content to HTML
        let document = Markdown.Document(parsing: markdownContent)
        var renderer = HtmlRenderer()
        let html = try renderer.render(document)

        return ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
    }

    /// Parses a Markdown string into front matter and HTML content with graceful error handling.
    ///
    /// This is a convenience method that handles errors gracefully by returning default values
    /// when parsing fails. Suitable for use cases where you want to display content even if
    /// parsing encounters errors.
    ///
    /// - Parameter content: The raw Markdown string to parse.
    /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and HTML content.
    ///           Returns empty front matter and escaped HTML content if parsing fails.
    public func parseMarkdownSafely(_ content: String) -> ParsedMarkdown {
        do {
            return try parseMarkdown(content)
        } catch {
            // Return safe fallback content
            let renderer = HtmlRenderer()
            let escapedContent = renderer.escapeHTML(content)
            return ParsedMarkdown(
                frontMatter: [:], htmlContent: "<pre>\(escapedContent)</pre>")
        }
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
