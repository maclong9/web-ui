/// Represents different styles of the header in a layout.
enum HeaderVariant {
  case hidden, normal, logoCentered
}

/// Represents different styles of the footer in a layout.
enum FooterVariant {
  case hidden, normal, minimal
}

/// Represents a navigational route within the layout.
struct Route {
  let label: String
  let path: String
}

/// Represents the overall layout structure, including navigation, header, footer, and sitemap.
struct Layout {
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
  init(
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
