/// Represents the configuration settings for a document, including metadata, theme, and layout.
public struct Configuration {
  let metadata: Metadata
  let theme: Theme
  let layout: Layout

  /// Initializes a new `Configuration` instance with default or provided settings.
  ///
  /// - Parameters:
  ///   - metadata: Metadata information.
  ///   - theme: The theme settings.
  ///   - layout: The layout settings.
  init(metadata: Metadata = Metadata(), theme: Theme = Theme(), layout: Layout = Layout()) {
    self.metadata = metadata
    self.theme = theme
    self.layout = layout
  }
}
