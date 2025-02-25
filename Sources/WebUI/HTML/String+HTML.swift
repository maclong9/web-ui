extension String: HTML {
  /// Renders the string as HTML content directly.
  /// - This allows strings to be seamlessly used within the HTML builder DSL.
  /// - Returns: The string itself, as it's already valid content.
  func render() -> String { self }
}
