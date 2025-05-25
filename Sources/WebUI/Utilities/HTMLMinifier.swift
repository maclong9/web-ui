import Foundation

/// Provides HTML minification functionality to reduce file size and improve performance.
///
/// The `HTMLMinifier` removes unnecessary whitespace, comments, and redundant
/// formatting from HTML content while preserving the structure and
/// functionality of the document.  This optimization reduces bandwidth usage
/// and improves page load times.
///
/// ## Example
/// ```swift
/// let html = """
///     <html>
///         <body>
///             <h1>Hello World</h1>
///         </body>
///     </html>
/// """
/// let minified = HTMLMinifier.minify(html)
/// // Result: "<html><body><h1>Hello World</h1></body></html>"
/// ```
public struct HTMLMinifier {

    /// Minifies HTML content by removing unnecessary whitespace and formatting.
    ///
    /// This method performs the following optimizations:
    /// - Removes leading and trailing whitespace from lines
    /// - Collapses multiple consecutive whitespace characters into single spaces
    /// - Removes empty lines
    /// - Preserves content within `<pre>`, `<code>`, `<script>`, and `<style>` tags
    /// - Removes HTML comments (except conditional comments for IE)
    /// - Removes whitespace around certain HTML tags
    ///
    /// - Parameters:
    ///   - html: The HTML content to minify.
    /// - Returns: Minified HTML content as a string.
    ///
    /// ## Example
    /// ```swift
    /// let original = """
    ///     <!DOCTYPE html>
    ///     <html>
    ///       <head>
    ///         <title>Page Title</title>
    ///       </head>
    ///       <body>
    ///         <h1>Heading</h1>
    ///         <p>Paragraph content</p>
    ///       </body>
    ///     </html>
    /// """
    /// let minified = HTMLMinifier.minify(original)
    /// ```
    public static func minify(_ html: String) -> String {
        var result = html

        // Remove HTML comments (but preserve conditional comments)
        result = removeComments(from: result)

        // Preserve content in pre, code, script, and style tags
        let preservedBlocks = extractPreservedBlocks(from: result)
        result = replacePreservedBlocks(in: result, with: preservedBlocks)

        // Remove excessive whitespace
        result = normalizeWhitespace(result)

        // Restore preserved blocks
        result = restorePreservedBlocks(in: result, from: preservedBlocks)

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Removes HTML comments while preserving conditional comments for Internet Explorer.
    private static func removeComments(from html: String) -> String {
        let pattern = "<!--(?!\\[if).*?-->"
        do {
            let regex = try NSRegularExpression(
                pattern: pattern, options: [.dotMatchesLineSeparators])
            let range = NSRange(location: 0, length: html.utf16.count)
            return regex.stringByReplacingMatches(
                in: html, options: [], range: range, withTemplate: "")
        } catch {
            return html
        }
    }

    /// Extracts content from tags that should preserve their formatting.
    private static func extractPreservedBlocks(from html: String) -> [String:
        String]
    {
        var preservedBlocks: [String: String] = [:]
        let preserveTags = ["pre", "code", "script", "style", "textarea"]

        for tag in preserveTags {
            let pattern = "<\(tag)\\b[^>]*>.*?</\(tag)>"
            do {
                let regex = try NSRegularExpression(
                    pattern: pattern,
                    options: [.dotMatchesLineSeparators, .caseInsensitive])
                let matches = regex.matches(
                    in: html, options: [],
                    range: NSRange(location: 0, length: html.utf16.count))

                for (index, match) in matches.enumerated() {
                    if let range = Range(match.range, in: html) {
                        let content = String(html[range])
                        let placeholder =
                            "<!--PRESERVE_BLOCK_\(tag.uppercased())_\(index)-->"
                        preservedBlocks[placeholder] = content
                    }
                }
            } catch {
                continue
            }
        }

        return preservedBlocks
    }

    /// Replaces preserved blocks with placeholders.
    private static func replacePreservedBlocks(
        in html: String, with blocks: [String: String]
    ) -> String {
        var result = html

        for (placeholder, content) in blocks {
            result = result.replacingOccurrences(of: content, with: placeholder)
        }

        return result
    }

    /// Normalizes whitespace by removing excessive spaces and newlines.
    private static func normalizeWhitespace(_ html: String) -> String {
        var result = html

        // Replace multiple whitespace characters with single spaces
        do {
            let multiSpaceRegex = try NSRegularExpression(
                pattern: "\\s+", options: [])
            let range = NSRange(location: 0, length: result.utf16.count)
            result = multiSpaceRegex.stringByReplacingMatches(
                in: result, options: [], range: range, withTemplate: " ")
        } catch {
            // Fallback to basic replacement
            result = result.replacingOccurrences(of: "\n", with: " ")
            result = result.replacingOccurrences(of: "\r", with: " ")
            result = result.replacingOccurrences(of: "\t", with: " ")
        }

        // Remove spaces around certain tags
        let tagPatterns = [
            ("> <", "><"),
            (" >", ">"),
            ("< ", "<"),
        ]

        for (pattern, replacement) in tagPatterns {
            result = result.replacingOccurrences(of: pattern, with: replacement)
        }

        return result
    }

    /// Restores preserved blocks from placeholders.
    private static func restorePreservedBlocks(
        in html: String, from blocks: [String: String]
    ) -> String {
        var result = html

        for (placeholder, content) in blocks {
            result = result.replacingOccurrences(of: placeholder, with: content)
        }

        return result
    }
}
