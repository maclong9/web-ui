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
