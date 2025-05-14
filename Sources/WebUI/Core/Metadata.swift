// Metadata.swift
import Foundation

/// Defines the type of content for Open Graph metadata.
///
/// Content type affects how social media platforms and search engines categorize and display the content.
public enum ContentType: String {
  /// Standard website content type.
  case website
  /// Article or blog post content type.
  case article
  /// Video content type.
  case video
  /// Personal or organizational profile content type.
  case profile
}

/// Defines supported language locales for content.
///
/// Used to specify the language of the document for accessibility and SEO purposes.
public enum Locale: String {
  /// English locale.
  case en
  /// Spanish locale.
  case sp
  /// French locale.
  case fr
  /// German locale.
  case de
  /// Japanese locale.
  case ja
  /// Russian locale.
  case ru
}

/// Represents a theme color with optional dark mode variant.
///
/// Used to specify the browser theme color for the document, supporting both light and dark mode.
public struct ThemeColor {
  /// The color value for light mode.
  public let light: String
  
  /// The optional color value for dark mode.
  public let dark: String?

  /// Creates a new theme color with optional dark mode variant.
  ///
  /// - Parameters:
  ///   - light: The color value for light mode (can be any valid CSS color).
  ///   - dark: The optional color value for dark mode (can be any valid CSS color).
  ///
  /// - Example:
  ///   ```swift
  ///   let brandColor = ThemeColor("#0077ff", dark: "#3399ff")
  ///   ```
  public init(_ light: String, dark: String? = nil) {
    self.light = light
    self.dark = dark
  }
}

/// Represents metadata for an HTML document including SEO and social media properties.
///
/// The `Metadata` struct encapsulates all the metadata that can be included in the `<head>` section
/// of an HTML document, such as title, description, Open Graph tags, and Twitter card information.
public struct Metadata {
  /// The name of the website or application.
  public var site: String?
  
  /// The title of the current page.
  public var title: String?
  
  /// The separator between the title and site name (e.g., " - " or " | ").
  public var titleSeperator: String?
  
  /// A concise description of the page content.
  public var description: String
  
  /// The publication date of the content.
  public var date: Date?
  
  /// URL to an image representing the content (for social media sharing).
  public var image: String?
  
  /// The name of the content author.
  public var author: String?
  
  /// Keywords relevant to the content for SEO.
  public var keywords: [String]?
  
  /// Twitter handle for attribution without the @ symbol.
  public var twitter: String?
  
  /// The language locale of the content.
  public var locale: Locale
  
  /// The type of content for Open Graph categorization.
  public var type: ContentType
  
  /// The browser theme color for the document.
  public var themeColor: ThemeColor?

  /// The fully formatted page title combining the title, separator, and site name.
  ///
  /// - Returns: A string combining the title, separator, and site name, handling nil values appropriately.
  public var pageTitle: String {
    "\(title ?? "")\(titleSeperator ?? "")\(site ?? "")"
  }

  /// Creates a new metadata configuration for an HTML document.
  ///
  /// - Parameters:
  ///   - site: The name of the website or application.
  ///   - title: The title of the current page.
  ///   - titleSeperator: The separator between title and site name (defaults to a space).
  ///   - description: A concise description of the page content.
  ///   - date: The publication date of the content.
  ///   - image: URL to an image representing the content.
  ///   - author: The name of the content author.
  ///   - keywords: Keywords relevant to the content for SEO.
  ///   - twitter: Twitter handle for attribution (without the @ symbol).
  ///   - locale: The language locale of the content (defaults to English).
  ///   - type: The type of content (defaults to "website").
  ///   - themeColor: The browser theme color for the document.
  ///
  /// - Example:
  ///   ```swift
  ///   let pageMetadata = Metadata(
  ///     site: "My Website",
  ///     title: "Welcome",
  ///     titleSeperator: " | ",
  ///     description: "A modern website built with WebUI",
  ///     author: "John Doe",
  ///     keywords: ["swift", "web", "ui"],
  ///     locale: .en,
  ///     themeColor: ThemeColor("#3366ff")
  ///   )
  ///   ```
  public init(
    site: String? = nil,
    title: String? = nil,
    titleSeperator: String? = " ",
    description: String,
    date: Date? = nil,
    image: String? = nil,
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: Locale = .en,
    type: ContentType = .website,
    themeColor: ThemeColor? = nil
  ) {
    self.site = site
    self.title = title
    self.titleSeperator = titleSeperator
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

  /// Creates a new metadata configuration by extending an existing one.
  ///
  /// This initializer allows creating a new metadata instance that inherits values from a base
  /// instance while selectively overriding specific properties. This is useful for creating page-specific
  /// metadata that inherits site-wide defaults.
  ///
  /// - Parameters:
  ///   - base: The base metadata to inherit values from.
  ///   - site: Override for the website name.
  ///   - title: Override for the page title.
  ///   - titleSeperator: Override for the title separator.
  ///   - description: Override for the description.
  ///   - date: Override for the publication date.
  ///   - image: Override for the image URL.
  ///   - author: Override for the author name.
  ///   - keywords: Override for the keywords.
  ///   - twitter: Override for the Twitter handle.
  ///   - locale: Override for the language locale.
  ///   - type: Override for the content type.
  ///   - themeColor: Override for the theme color.
  ///
  /// - Example:
  ///   ```swift
  ///   let siteMetadata = Metadata(
  ///     site: "My Website",
  ///     titleSeperator: " | ",
  ///     description: "A website about Swift"
  ///   )
  ///   
  ///   let pageMetadata = Metadata(
  ///     from: siteMetadata,
  ///     title: "Blog Post",
  ///     description: "A specific blog post about WebUI",
  ///     date: Date()
  ///   )
  ///   ```
  public init(
    from base: Metadata,
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

  /// Generates HTML meta tags from the metadata.
  ///
  /// This property converts the metadata into an array of HTML meta tag strings
  /// ready to be inserted into the document's head section, including Open Graph,
  /// Twitter card, and standard meta tags.
  ///
  /// - Returns: An array of HTML meta tag strings.
  ///
  /// - Note: This includes basic SEO tags, social media sharing tags, and theme color
  ///   tags with appropriate media queries for dark mode support when applicable.
  var tags: [String] {
    var baseTags: [String] = [
      "<meta property=\"og:title\" content=\"\(pageTitle)\">",
      "<meta name=\"description\" content=\"\(description)\">",
      "<meta property=\"og:description\" content=\"\(description)\">",
      "<meta property=\"og:type\" content=\"\(type.rawValue)\">",
      "<meta name=\"twitter:card\" content=\"summary_large_image\">",
    ]

    if let image, !image.isEmpty {
      baseTags.append("<meta property=\"og:image\" content=\"\(image)\">")
    }
    if let author, !author.isEmpty {
      baseTags.append("<meta name=\"author\" content=\"\(author)\">")
    }
    if let twitter, !twitter.isEmpty {
      baseTags.append("<meta name=\"twitter:creator\" content=\"@\(twitter)\">")
    }
    if let keywords, !keywords.isEmpty {
      baseTags.append(
        "<meta name=\"keywords\" content=\"\(keywords.joined(separator: ", "))\">"
      )
    }
    if let themeColor {
      baseTags.append(
        "<meta name=\"theme-color\" content=\"\(themeColor.light)\" \(themeColor.dark != nil ? "media=\"(prefers-color-scheme: light)\"" : "")>"
      )
      if let themeDark = themeColor.dark {
        baseTags.append(
          "<meta name=\"theme-color\" content=\"\(themeDark)\" media=\"(prefers-color-scheme: dark)\">"
        )
      }
    }

    return baseTags
  }
}
