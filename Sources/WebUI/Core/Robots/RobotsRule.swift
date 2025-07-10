import Foundation

/// Represents a rule in a robots.txt file.
///
/// Used to define instructions for web crawlers about which parts of the
/// website should be crawled.  Each rule specifies which user agents
/// (crawlers) it applies to and what paths they can access.  For more
/// information about the robots.txt standard, see:
/// https://developers.google.com/search/docs/crawling-indexing/robots/intro
public struct RobotsRule: Equatable, Hashable {
  /// The user agent the rule applies to (e.g., "Googlebot" or "*" for all crawlers).
  public let userAgent: String

  /// Paths that should not be crawled.
  public let disallow: [String]?

  /// Paths that are allowed to be crawled (overrides disallow rules).
  public let allow: [String]?

  /// The delay between successive crawls in seconds.
  public let crawlDelay: Int?

  /// Creates a new robots.txt rule.
  ///
  /// - Parameters:
  ///   - userAgent: The user agent the rule applies to (e.g., "Googlebot" or "*" for all crawlers).
  ///   - disallow: Paths that should not be crawled.
  ///   - allow: Paths that are allowed to be crawled (overrides disallow rules).
  ///   - crawlDelay: The delay between successive crawls in seconds.
  ///
  /// - Example:
  ///   ```swift
  ///   let rule = RobotsRule(
  ///     userAgent: "*",
  ///     disallow: ["/admin/", "/private/"],
  ///     allow: ["/public/"],
  ///     crawlDelay: 10
  ///   )
  ///   ```
  public init(
    userAgent: String,
    disallow: [String]? = nil,
    allow: [String]? = nil,
    crawlDelay: Int? = nil
  ) {
    self.userAgent = userAgent
    self.disallow = disallow
    self.allow = allow
    self.crawlDelay = crawlDelay
  }

  /// Creates a rule that allows all crawlers to access the entire site.
  ///
  /// - Returns: A rule that allows all paths for all user agents.
  ///
  /// - Example:
  ///   ```swift
  ///   let allowAllRule = RobotsRule.allowAll()
  ///   ```
  public static func allowAll() -> RobotsRule {
    RobotsRule(userAgent: "*", allow: ["/"])
  }

  /// Creates a rule that disallows all crawlers from accessing the entire site.
  ///
  /// - Returns: A rule that disallows all paths for all user agents.
  ///
  /// - Example:
  ///   ```swift
  ///   let disallowAllRule = RobotsRule.disallowAll()
  ///   ```
  public static func disallowAll() -> RobotsRule {
    RobotsRule(userAgent: "*", disallow: ["/"])
  }
}
