import Foundation

/// Defines supported Open Graph content types for a document.
public enum ContentType: String, Sendable {
  case website, article, video, profile
}

/// Defines supported language locales for a document.
public enum Locale: String, Sendable {
  case en, sp, fr, de, ja
}

/// Stores metadata configuration for a document’s head section.
public struct Metadata: Sendable {
  public var site: String?
  public var title: String
  public var titleSeperator: String
  public var pageTitle: String
  public var description: String
  public var date: Date?
  public var image: String?
  public var author: String?
  public var keywords: [String]?
  public var twitter: String?
  public var locale: Locale
  public var type: ContentType?

  /// Creates metadata for a document’s head section.
  ///
  /// - Parameters:
  ///   - site: Website name used in title and branding, optional.
  ///   - title: Base title template for the page.
  ///   - titleSeperator: Separator between title and site, defaults to "|".
  ///   - description: Brief summary of page content for meta tags.
  ///   - image: Displayed when the url is shared on social media.
  ///   - author: Author name, optional.
  ///   - keywords: SEO keywords, optional.
  ///   - twitter: Twitter handle without "@", optional.
  ///   - locale: Language setting, defaults to `.en`.
  ///   - type: Open Graph content type, optional.
  public init(
    site: String? = nil,
    title: String,
    titleSeperator: String = "|",
    description: String,
    date: Date? = nil,
    image: String? = nil,
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: Locale = .en,
    type: ContentType? = nil
  ) {
    self.site = site
    self.title = title
    self.titleSeperator = titleSeperator
    self.pageTitle = "\(title)\(site.map { " \(titleSeperator) \($0)" } ?? "")"
    self.description = description
    self.image = image
    self.author = author
    self.keywords = keywords
    self.twitter = twitter
    self.locale = locale
    self.type = type
  }
}
