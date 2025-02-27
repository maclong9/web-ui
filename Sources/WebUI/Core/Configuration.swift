struct Social {
  let label: String
  let url: String
  let icon: String?  // TODO: Implement an icon pack prefarably as fonts
  
  init(label: String, url: String, icon: String? = nil) {
    self.label = label
    self.url = url
    self.icon = icon
  }
}

/// Represents the configuration settings for a document, including metadata, theme, and layout.
public struct Configuration {
  let metadata: Metadata
  let theme: Theme
  let layout: Layout
  let socials: [Social]?

  /// Creates a new `Configuration` instance with default or provided settings.
  ///
  /// - Parameters:
  ///   - metadata: Metadata information.
  ///   - theme: The theme settings.
  ///   - layout: The layout settings.
  ///   - socials: An array of social media platforms.
  init(
    metadata: Metadata = Metadata(), theme: Theme = Theme(), layout: Layout = Layout(),
    socials: [Social]? = nil
  ) {
    self.metadata = metadata
    self.theme = theme
    self.layout = layout
    self.socials = socials
  }
}
