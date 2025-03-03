public struct Configuration {
  let metadata: Metadata
  let theme: Theme

  init(metadata: Metadata = Metadata(), theme: Theme = Theme()) {
    self.metadata = metadata
    self.theme = theme
  }
}
