/// Holds configuration settings for the HTML document.
/// This contains `metadata` and `theme` properties, which are used to customize the HTML document's metadata and styling, respectively.
public struct Configuration {
  let metadata: Metadata
  let theme: Theme

  init(metadata: Metadata = Metadata(), theme: Theme = Theme()) {
    self.metadata = metadata
    self.theme = theme
  }
}
