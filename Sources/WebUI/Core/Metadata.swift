// Metadata.swift
import Foundation

public enum ContentType: String {
  case website, article, video, profile
}

public enum Locale: String {
  case en, sp, fr, de, ja, ru
}

public struct ThemeColor {
  public let light: String
  public let dark: String

  public init(light: String, dark: String) {
    self.light = light
    self.dark = dark
  }
}

public struct Metadata {
  public var site: String?
  public var title: String?
  public var titleSeperator: String
  public var description: String
  public var date: Date?
  public var image: String?
  public var author: String?
  public var keywords: [String]?
  public var twitter: String?
  public var locale: Locale
  public var type: ContentType
  public var themeColor: ThemeColor?

  public var pageTitle: String {
    "\(title ?? "")\(titleSeperator)\(site ?? "")"
  }

  public init(
    site: String? = nil,
    title: String? = nil,
    titleSeperator: String = " | ",
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
        "<meta name=\"theme-color\" content=\"\(themeColor.light)\" media=\"(prefers-color-scheme: light)\">"
      )
      baseTags.append(
        "<meta name=\"theme-color\" content=\"\(themeColor.dark)\" media=\"(prefers-color-scheme: dark)\">"
      )
    }

    return baseTags
  }
}
