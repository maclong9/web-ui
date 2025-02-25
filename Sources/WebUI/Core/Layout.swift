import Foundation

/// Represents different styles of the header in a layout.
public enum HeaderVariant {
  case hidden, normal, logoCentered
}

/// Represents different styles of the footer in a layout.
public enum FooterVariant {
  case hidden, normal, minimal
}

/// Represents a navigational route within the layout.
public struct Route {
  let label: String
  let path: String

  /// Initializes a new `Route`.
  ///
  /// - Parameters:
  ///   - label: The display label for the route.
  ///   - path: The URL path for the route.
  public init(label: String, path: String) {
    self.label = label
    self.path = path
  }
}

// MARK: - Layout
/// Represents the overall layout structure, including navigation, header, footer, and sitemap.
public struct Layout {
  let navigation: [Route]
  let header: HeaderVariant
  let footer: FooterVariant
  let sitemap: [Route]

  /// Initializes a new `Layout` with optional parameters.
  ///
  /// - Parameters:
  ///   - navigation: The navigation routes, defaulting to three sample routes.
  ///   - header: The header style, defaulting to `.normal`.
  ///   - footer: The footer style, defaulting to `.normal`.
  ///   - sitemap: The sitemap routes, defaulting to five sample routes.
  public init(
    navigation: [Route] = [
      Route(label: "here", path: "/here"),
      Route(label: "there", path: "/there"),
      Route(label: "everywhere", path: "/everywhere"),
    ],
    header: HeaderVariant = .normal,
    footer: FooterVariant = .normal,
    sitemap: [Route] = [
      Route(label: "here", path: "/here"),
      Route(label: "there", path: "/there"),
      Route(label: "everywhere", path: "/everywhere"),
      Route(label: "terms", path: "/terms"),
      Route(label: "privacy", path: "/privacy"),
    ]
  ) {
    self.navigation = navigation
    self.header = header
    self.footer = footer
    self.sitemap = sitemap
  }
}

// TODO: Update to Get Socials from Configuration not Metadata
// MARK: - Layout Renderer
/// A utility struct to handle rendering of layout components like headers and footers.
public struct LayoutRenderer {
  let configuration: Configuration
  let headerVariant: HeaderVariant
  let footerVariant: FooterVariant

  /// Initializes a new LayoutRenderer instance.
  ///
  /// - Parameters:
  ///   - configuration: The configuration settings.
  ///   - headerVariant: The header variant to use (can be overridden).
  ///   - footerVariant: The footer variant to use (can be overridden).
  public init(
    configuration: Configuration,
    headerVariant: HeaderVariant,
    footerVariant: FooterVariant
  ) {
    self.configuration = configuration
    self.headerVariant = headerVariant
    self.footerVariant = footerVariant
  }

  // MARK: Render Header
  /// Renders the header based on the specified variant.
  public func renderHeader() -> String {
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

  // MARK: Render Footer
  /// Renders the footer based on the specified variant.
  public func renderFooter() -> String {
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
                <a href="https://twitter.com/\(configuration.metadata.twitter ?? "")">Twitter</a>
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
