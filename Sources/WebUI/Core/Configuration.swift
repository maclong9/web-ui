/// Holds configuration settings for the HTML document.
/// This contains `metadata` and `theme` properties, which are used to customize the HTML document's metadata and styling, respectively.
public struct Configuration {
  let metadata: Metadata

  /// Creates configuration for an HTML document.
  /// This prepares the metadata and theme settings to customize the webpage.
  /// - Parameters:
  ///   - metadata: Details like site name and title format, with a default if not provided.
  init(metadata: Metadata = Metadata()) {
    self.metadata = metadata
  }
}

