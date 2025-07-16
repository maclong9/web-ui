import Foundation

/// Provides markup escaping functionality to prevent XSS attacks and ensure proper markup rendering.
///
/// The `HTMLEscaper` converts special characters that have meaning in markup
/// into their corresponding markup entities, ensuring that user content is
/// safely displayed without breaking markup structure or introducing security
/// vulnerabilities.
///
/// ## Example
/// ```swift
/// let userInput = "Hello <script>alert('XSS')</script> & goodbye"
/// let safeHTML = HTMLEscaper.escape(userInput)
/// // Result: "Hello &lt;script&gt;alert('XSS')&lt;/script&gt; &amp; goodbye"
/// ```
public struct HTMLEscaper {
    /// Escapes special markup characters in a string to prevent injection and parsing errors.
    ///
    /// This method converts the following characters to their markup entities:
    /// - `&` becomes `&amp;` (must be first to avoid double-escaping)
    /// - `<` becomes `&lt;`
    /// - `>` becomes `&gt;`
    /// - `"` becomes `&quot;`
    /// - `'` becomes `&#39;`
    ///
    /// - Parameter string: The string containing potentially unsafe markup characters.
    /// - Returns: A string with markup characters properly escaped.
    ///
    /// ## Example
    /// ```swift
    /// let unsafe = "Click <a href=\"javascript:alert('XSS')\">here</a> & enjoy"
    /// let safe = HTMLEscaper.escape(unsafe)
    /// // Result: "Click &lt;a href=&quot;javascript:alert('XSS')&quot;&gt;here&lt;/a&gt; &amp; enjoy"
    /// ```
    public static func escape(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")  // Must be first
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    /// Escapes markup characters specifically for use in markup attribute values.
    ///
    /// This method is optimized for attribute contexts where quotes and ampersands
    /// are the primary concerns. It performs the same escaping as `escape(_:)` but
    /// is semantically distinct for clarity of intent.
    ///
    /// - Parameter attributeValue: The string to be used as a markup attribute value.
    /// - Returns: A string safe for use in markup attribute values.
    ///
    /// ## Example
    /// ```swift
    /// let title = "User's \"favorite\" item & more"
    /// let safeTitle = HTMLEscaper.escapeAttribute(title)
    /// // Result: "User&#39;s &quot;favorite&quot; item &amp; more"
    /// ```
    public static func escapeAttribute(_ attributeValue: String) -> String {
        escape(attributeValue)
    }

    /// Escapes markup characters specifically for use in markup text content.
    ///
    /// This method is optimized for text content contexts where angle brackets
    /// and ampersands are the primary concerns. Single and double quotes are
    /// less critical in text content but are still escaped for consistency.
    ///
    /// - Parameter textContent: The string to be used as markup text content.
    /// - Returns: A string safe for use as markup text content.
    ///
    /// ## Example
    /// ```swift
    /// let content = "The <script> tag & special chars"
    /// let safeContent = HTMLEscaper.escapeContent(content)
    /// // Result: "The &lt;script&gt; tag &amp; special chars"
    /// ```
    public static func escapeContent(_ textContent: String) -> String {
        escape(textContent)
    }
}
