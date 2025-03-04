/// This extension enables strings to be treated as raw HTML content.
/// The `render()` method simply returns the string itself, which is assumed to be valid HTML.
extension String: HTML {
  public func render() -> String { self }
}
