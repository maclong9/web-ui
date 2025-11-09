/// Utility string extensions for markup rendering and formatting.
///
/// These extensions enable strings to be used directly in markup content and provide
/// utility methods for common string transformations needed in web development.
extension String: Markup {
    public var body: some Markup { self }
    /// Renders the string as markup content.
    ///
    /// This implementation allows plain strings to be used directly in markup content builders.
    /// Strings render as-is; escaping is handled by elements that consume user text.
    ///
    /// - Returns: The string unchanged.
    ///
    /// - Example:
    ///   ```swift
    ///   let content: [any Markup] = [
    ///     "Some text",
    ///     Heading(.one) { "Title" }
    ///   ]
    ///   ```
    public func render() -> String { self }

    /// Sanitizes strings for use in stylesheet variable names.
    ///
    /// Converts a string into a valid stylesheet variable name by replacing invalid characters
    /// with hyphens and converting to lowercase, ensuring the result is compliant with
    /// stylesheet naming conventions.
    ///
    /// - Returns: A sanitized string suitable for use as a stylesheet variable name.
    ///
    /// - Example:
    ///   ```swift
    ///   let rawName = "Button Color!"
    ///   let styleName = rawName.sanitizedForStyleSheet() // Returns "button-color-"
    ///   let css = "--\(styleName): blue;"
    ///   ```
    public func sanitizedForStyleSheet() -> String {
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
                of: "[^a-z0-9 -]", with: "", options: .regularExpression
            )
            .split(separator: " ")
            .filter { !$0.isEmpty }
            .joined(separator: "-")
            .trimmingCharacters(in: .whitespaces)
    }

    // MARK: - Backward Compatibility

    /// Backward compatibility alias for `sanitizedForStyleSheet()`.
    ///
    /// - Deprecated: Use `sanitizedForStyleSheet()` instead.
    /// - Returns: A sanitized string suitable for use as a stylesheet variable name.
    @available(*, deprecated, message: "Use sanitizedForStyleSheet() instead")
    public func sanitizedForCSS() -> String {
        return sanitizedForStyleSheet()
    }
}
