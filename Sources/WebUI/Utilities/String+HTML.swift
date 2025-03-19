/// Enables strings to represent raw HTML content.
///
/// Allows strings to conform to the HTML protocol by rendering themselves directly.
extension String: HTML {
  /// Renders the string as HTML content.
  ///
  /// - Returns: The string as HTML content.
  public func render() -> String { self }
}
