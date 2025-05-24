/// Utility string extensions for HTML rendering and formatting.
///
/// These extensions enable strings to be used directly in HTML content and provide
/// utility methods for common string transformations needed in web development.
extension String: HTML {
    public var body: some HTML { self }
    /// Renders the string as HTML content with proper escaping.
    ///
    /// This implementation allows plain strings to be used directly in HTML content builders,
    /// automatically escaping HTML special characters to prevent XSS attacks and ensure
    /// proper rendering.
    ///
    /// - Returns: The string with HTML characters properly escaped.
    ///
    /// - Example:
    ///   ```swift
    ///   let userInput = "Hello <script>alert('XSS')</script> & goodbye"
    ///   let content: [any HTML] = [
    ///     userInput,  // Automatically escaped to: "Hello &lt;script&gt;alert('XSS')&lt;/script&gt; &amp; goodbye"
    ///     Heading(.one) { "Title" }
    ///   ]
    ///   ```
    public func render() -> String { HTMLEscaper.escapeContent(self) }

    /// Sanitizes strings for use in CSS variable names.
    ///
    /// Converts a string into a valid CSS variable name by replacing invalid characters
    /// with hyphens and converting to lowercase, ensuring the result is compliant with
    /// CSS naming conventions.
    ///
    /// - Returns: A sanitized string suitable for use as a CSS variable name.
    ///
    /// - Example:
    ///   ```swift
    ///   let rawName = "Button Color!"
    ///   let cssName = rawName.sanitizedForCSS() // Returns "button-color-"
    ///   let css = "--\(cssName): blue;"
    ///   ```
    public func sanitizedForCSS() -> String {
        self.replacingOccurrences(
            of: "[^a-zA-Z0-9-]", with: "-", options: .regularExpression
        )
        .lowercased()
    }

    /// Converts the string to a lowercase, hyphen-separated path representation.
    ///
    /// Transforms a string into a URL-friendly slug by removing special characters,
    /// replacing spaces with hyphens, and converting to lowercase. This is useful
    /// for generating clean URLs or file paths from titles or headings.
    ///
    /// - Returns: A formatted string suitable for use in URLs or file paths.
    ///
    /// - Example:
    ///   ```swift
    ///   let title = "Hello, World! 123"
    ///   let path = title.pathFormatted() // Returns "hello-world-123"
    ///   let url = "/blog/\(path)"
    ///   ```
    public func pathFormatted() -> String {
        self.lowercased()
            .replacingOccurrences(
                of: "[^a-z0-9 ]", with: "", options: .regularExpression
            )
            .split(separator: " ")
            .filter { !$0.isEmpty }
            .joined(separator: "-")
            .trimmingCharacters(in: .whitespaces)
    }
}
