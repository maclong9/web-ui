import Foundation

// TODO: Create optimised bundles of CSS and JS named `{page-title}.css`
// TODO: Validate the HTML, CSS and JS output on build

/// Represents a document containing content, configuration, and rendering logic.
public struct Document {
  let configuration: Configuration
  let title: String
  let description: String
  let keywords: [String]?
  let author: String?
  let type: String?
  let headerOverride: HeaderVariant?
  let footerOverride: FooterVariant?

  private let contentBuilder: () -> [any HTML]

  /// The computed property that evaluates the content builder to get the nested HTML components.
  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates a new `Document` instance.
  ///
  /// - Parameters:
  ///   - configuration: The configuration settings.
  ///   - title: The document title.
  ///   - description: A description of the document content.
  ///   - keywords: An array of keywords for seo.
  ///   - content: The main content of the document.
  ///   - headerOverride: An optional header override.
  ///   - footerOverride: An optional footer override.
  init(
    configuration: Configuration = Configuration(),
    title: String,
    description: String,
    keywords: [String]? = nil,
    author: String? = nil,
    type: String? = nil,
    headerOverride: HeaderVariant? = nil,
    footerOverride: FooterVariant? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.configuration = configuration
    self.title = title
    self.description = description
    self.keywords = keywords
    self.author = author
    self.type = type
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
    let twitterSocial = URL(
      string: configuration.socials?.first {
        $0.label.lowercased().contains("twitter") || $0.label.lowercased().contains("x")
          || $0.url.contains("twitter.com")
          || $0.url.contains("x.com")
      }?.url ?? "")?.lastPathComponent

    // Create a LayoutRenderer with the appropriate variants
    let layoutRenderer = LayoutRenderer(
      configuration: configuration,
      headerVariant: headerOverride ?? configuration.layout.header,
      footerVariant: footerOverride ?? configuration.layout.footer
    )

    return """
      <!DOCTYPE html>
      <html lang="\(configuration.metadata.locale)">
        \(configuration.metadata.render(
          pageTitle: pageTitle,
          description: description,
          twitter: twitterSocial,
          author: author,
          keywords: keywords,
          type: type
        ))
        <body>
          \(layoutRenderer.renderHeader() ?? "")
          \(renderedContent)
          \(layoutRenderer.renderFooter() ?? "")
        </body>
      </html>
      """
  }
}
