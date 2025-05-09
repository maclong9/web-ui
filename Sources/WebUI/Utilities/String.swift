/// Utility string extensions
extension String: HTML {
  /// Renders the string as HTML content.
  public func render() -> String { self }

  /// Sanitizes strings for use in CSS variable names
  public func sanitizedForCSS() -> String {
    self.replacingOccurrences(of: "[^a-zA-Z0-9-]", with: "-", options: .regularExpression)
      .lowercased()
  }

  /// Converts the string to a lowercase, hyphen-separated path representation.
  public func pathFormatted() -> String {
    self.lowercased()
      .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
      .split(separator: " ")
      .filter { !$0.isEmpty }
      .joined(separator: "-")
      .trimmingCharacters(in: .whitespaces)
  }
}
