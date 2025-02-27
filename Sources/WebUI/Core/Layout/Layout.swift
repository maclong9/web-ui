import Foundation

/// Represents the overall layout structure, including navigation, header, footer, and sitemap.
public struct Layout {
  let navigation: [Route]
  let header: HeaderVariant
  let footer: FooterVariant
  let sitemap: [Route]

  /// Creates a new `Layout` with optional parameters.
  ///
  /// - Parameters:
  ///   - navigation: The navigation routes, shown in the site `<header>`.
  ///   - header: The header style.
  ///   - footer: The footer style.
  ///   - sitemap: The additional sitemap routes, to be included in the footer. Generates from ``navigation`` and ``sitemap``
  public init(
    navigation: [Route] = [],
    header: HeaderVariant = .normal,
    footer: FooterVariant = .normal,
    sitemap: [Route] = []
  ) {
    self.navigation = navigation
    self.header = header
    self.footer = footer
    self.sitemap = navigation + sitemap
  }
}
