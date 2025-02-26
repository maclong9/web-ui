import Foundation

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

    // Create a LayoutRenderer with the appropriate variants
    let layoutRenderer = LayoutRenderer(
      configuration: configuration,
      headerVariant: headerOverride ?? configuration.layout.header,
      footerVariant: footerOverride ?? configuration.layout.footer
    )
    
    let metadata = configuration.metadata

    return """
      <!DOCTYPE html>
      <html lang="\(configuration.metadata.locale)">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          \(metadata.author.map { "<meta name=\"author\" content=\"\($0)\">" } ?? "")
          \(description.map { "<meta name=\"description\" content=\"\($0)\">" } ?? "")
          \(metadata.keywords.map { "<meta name=\"keywords\" content=\"\($0.joined(separator: ", "))\">" } ?? "")
          \(metadata.twitter.map { "<meta name=\"twitter:creator\" content=\"\($0)\">" } ?? "")
          \(metadata.type.map { "<meta property=\"og:type\" content=\"\($0)\">" } ?? "")
          <meta property="og:title" content="\(pageTitle)">
          \(description.map { "<meta property=\"og:description\" content=\"\($0)\">" } ?? "")
          <title>\(pageTitle)</title>
          <link rel="stylesheet" href="/\(title.replacingOccurrences(of: " ", with: "-")).css">
        </head>
        <body>
          \(layoutRenderer.renderHeader())
          \(renderedContent)
          \(layoutRenderer.renderFooter())
        </body>
      </html>
      """
  }
}
