import Foundation

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

/// Represents a document containing content, configuration, and rendering logic.
public struct Document {
  let configuration: Configuration
  let title: String
  let description: String?
  let headerOverride: HeaderVariant?
  let footerOverride: FooterVariant?

  private let contentBuilder: () -> [any HTML]

  /// The computed property that evaluates the content builder to get the nested HTML components.
  var content: [any HTML] {
    get { contentBuilder() }
  }

  /// Initializes a new `Document` instance.
  ///
  /// - Parameters:
  ///   - configuration: The configuration settings.
  ///   - title: The document title.
  ///   - description: An optional description.
  ///   - content: The main content of the document.
  ///   - headerOverride: An optional header override.
  ///   - footerOverride: An optional footer override.
  init(
    configuration: Configuration = Configuration(),
    title: String,
    description: String?,
    headerOverride: HeaderVariant? = nil,
    footerOverride: FooterVariant? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.configuration = configuration
    self.title = title
    self.description = description
    self.headerOverride = headerOverride
    self.footerOverride = footerOverride
    self.contentBuilder = content
  }

  /// Renders the document as an HTML string.
  ///
  /// - Returns: A `String` containing the rendered HTML document.
  func render() -> String {
    let pageTitle = "\(title) | \(configuration.metadata.site)"
    let renderedContent = content.map { $0.render() }.joined()

    return """
      <!DOCTYPE html>
      <html lang="\(configuration.metadata.locale)">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta name="author" content="\(configuration.metadata.author)">
          <meta name="description" content="\(description ?? "")">
          <meta name="keywords" content="\(configuration.metadata.keywords.joined(separator: ", "))">
          <meta name="twitter:creator" content="\(configuration.metadata.twitter)">
          <meta property="og:type" content="\(configuration.metadata.type)">
          <meta property="og:title" content="\(pageTitle)">
          <meta property="og:description" content="\(description ?? "")">
          <title>\(pageTitle)</title>
          <link rel="stylesheet" href="/\(title.replacingOccurrences(of: " ", with: "-")).css">
        </head>
        <body>
          \(renderHeader())
          \(renderedContent)
          \(renderFooter())
        </body>
      </html>
      """
  }

  /// Renders the document header based on configuration or overrides.
  private func renderHeader() -> String {
    let headerVariant = headerOverride ?? configuration.layout.header  // Use override if present
    switch headerVariant {
    case .hidden:
      return ""
    case .normal:
      return """
        <header class="header-normal">
          <div class="logo">\(configuration.metadata.site)</div>
          <nav>
            <ul>
              \(configuration.layout.navigation.map { "<li><a href='\($0.path)'>\($0.label)</a></li>" }.joined(separator: "\n"))
            </ul>
          </nav>
        </header>
        """
    case .logoCentered:
      return """
        <header class="header-centered">
          <div class="logo">\(configuration.metadata.site)</div>
          <nav>
            <ul>
              \(configuration.layout.navigation.map { "<li><a href='\($0.path)'>\($0.label)</a></li>" }.joined(separator: "\n"))
            </ul>
          </nav>
        </header>
        """
    }
  }

  /// Renders the document footer based on configuration or overrides.
  private func renderFooter() -> String {
    let footerVariant = footerOverride ?? configuration.layout.footer  // Use override if present
    switch footerVariant {
    case .hidden:
      return ""
    case .normal:
      return """
        <footer class="footer-normal">
          <div class="logo">\(configuration.metadata.site)</div>
          <nav class="footer-grid">
            \(configuration.layout.sitemap.map { "<a href='\($0.path)'>\($0.label)</a>" }.joined(separator: "\n"))
          </nav>
          <div class="footer-lower">
            <span>© \(configuration.metadata.site) \(Date().formattedYear())</span>
            <div class="social-icons">
              <a href="https://twitter.com/\(configuration.metadata.twitter)">Twitter</a>
            </div>
          </div>
        </footer>
        """
    case .minimal:
      return """
        <footer class="footer-minimal">
          <p>© \(configuration.metadata.site) \(Date().formattedYear())</p>
        </footer>
        """
    }
  }
}
