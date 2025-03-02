/// Represents the configuration settings for a document, including metadata, theme, and layout.
public struct Configuration {
  let metadata: Metadata
  let theme: Theme

  /// Creates a new `Configuration` instance with default or provided settings.
  ///
  /// - Parameters:
  ///   - metadata: Metadata information.
  ///   - theme: The theme settings.
  init(metadata: Metadata = Metadata(), theme: Theme = Theme()) {
    self.metadata = metadata
    self.theme = theme
  }
}
