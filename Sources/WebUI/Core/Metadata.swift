import Foundation

/// Defines supported Open Graph content types for a document.
public enum ContentType: String {
  case website, article, video, profile
}

/// Defines supported language locales for a document.
public enum Locale: String {
  case en, sp, fr, de, ja, ru
}

/// Represents theme colors for light and dark modes.
public struct ThemeColor {
  public let light: String
  public let dark: String

  /// Creates a theme color with light and dark mode values.
  ///
  /// - Parameters:
  ///   - light: Hex color code for light mode (e.g., "#FFFFFF").
  ///   - dark: Hex color code for dark mode (e.g., "#000000").
  public init(light: String, dark: String) {
    self.light = light
    self.dark = dark
  }
}

/// Stores metadata configuration for a document’s head section.
public struct Metadata {
  public var site: String?
  public var title: String?
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
  public var themeColor: ThemeColor?

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
  ///   - themeColor: Theme colors for light and dark modes, optional.
  public init(
    site: String? = nil,
    title: String? = nil,
    titleSeperator: String = "|",
    description: String,
    date: Date? = nil,
    image: String? = nil,
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: Locale = .en,
    type: ContentType? = nil,
    themeColor: ThemeColor? = nil
  ) {
    self.site = site
    self.title = title
    self.titleSeperator = titleSeperator
    self.pageTitle =
      "\(title ?? "")\(site.map { " \(titleSeperator) \($0)" } ?? "")"
    self.description = description
    self.date = date
    self.image = image
    self.author = author
    self.keywords = keywords
    self.twitter = twitter
    self.locale = locale
    self.type = type
    self.themeColor = themeColor
  }
}

extension Metadata {
  /// Initializes a new `Metadata` instance based on an existing one, with optional modifications to any property.
  ///
  /// - Parameters:
  ///   - base: The original `Metadata` instance.
  ///   - site: Optional site value, default is `nil`.
  ///   - title: Optional title value, default is `nil`.
  ///   - titleSeperator: Optional title separator, default is the same as `base`.
  ///   - description: Optional description value, default is the same as `base`.
  ///   - date: Optional date value, default is the same as `base`.
  ///   - image: Optional image value, default is the same as `base`.
  ///   - author: Optional author value, default is the same as `base`.
  ///   - keywords: Optional keywords value, default is the same as `base`.
  ///   - twitter: Optional twitter handle, default is the same as `base`.
  ///   - locale: Optional locale value, default is the same as `base`.
  ///   - type: Optional content type, default is the same as `base`.
  ///   - themeColor: Optional theme color, default is the same as `base`.
  public init(
    base: Metadata,
    site: String? = nil,
    title: String? = nil,
    titleSeperator: String? = nil,
    description: String? = nil,
    date: Date? = nil,
    image: String? = nil,
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: Locale? = nil,
    type: ContentType? = nil,
    themeColor: ThemeColor? = nil
  ) {
    self.site = site ?? base.site
    self.title = title ?? base.title
    self.titleSeperator = titleSeperator ?? base.titleSeperator
    self.pageTitle =
      "\(title ?? "")\(site.map { " \(titleSeperator ?? "|") \($0)" } ?? "")"
    self.description = description ?? base.description
    self.date = date ?? base.date
    self.image = image ?? base.image
    self.author = author ?? base.author
    self.keywords = keywords ?? base.keywords
    self.twitter = twitter ?? base.twitter
    self.locale = locale ?? base.locale
    self.type = type ?? base.type
    self.themeColor = themeColor ?? base.themeColor
  }
}
