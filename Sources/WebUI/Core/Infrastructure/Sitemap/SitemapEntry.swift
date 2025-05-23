import Foundation

/// Represents a sitemap entry for a URL with metadata.
///
/// Used to define information for a URL to be included in a sitemap.xml file.
/// Follows the Sitemap protocol as defined at https://www.sitemaps.org/protocol.html.
/// Sitemap entries enhance SEO by providing search engines with metadata about your content.
public struct SitemapEntry: Equatable, Hashable {
    /// The URL of the page.
    public let url: String

    /// The date when the page was last modified.
    public let lastModified: Date?

    /// The expected frequency of changes to the page.
    public enum ChangeFrequency: String, Equatable, Hashable, CaseIterable {
        /// Content that changes every time it's accessed
        case always
        /// Content that changes hourly
        case hourly
        /// Content that changes daily
        case daily
        /// Content that changes weekly
        case weekly
        /// Content that changes monthly
        case monthly
        /// Content that changes yearly
        case yearly
        /// Content that never changes
        case never
    }

    /// How frequently the page is likely to change.
    public let changeFrequency: ChangeFrequency?

    /// The priority of this URL relative to other URLs on your site (0.0 to 1.0).
    public let priority: Double?
    
    /// Creates a new sitemap entry for a URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the page.
    ///   - lastModified: The date when the page was last modified.
    ///   - changeFrequency: How frequently the page is likely to change.
    ///   - priority: The priority of this URL relative to other URLs (0.0 to 1.0).
    ///
    /// - Example:
    ///   ```swift
    ///   let homepage = SitemapEntry(
    ///     url: "https://example.com/",
    ///     lastModified: Date(),
    ///     changeFrequency: .weekly,
    ///     priority: 1.0
    ///   )
    ///   ```
    public init(
        url: String,
        lastModified: Date? = nil,
        changeFrequency: ChangeFrequency? = nil,
        priority: Double? = nil
    ) {
        self.url = url
        self.lastModified = lastModified
        self.changeFrequency = changeFrequency
        
        // Ensure priority is within valid range
        if let priority = priority {
            self.priority = min(1.0, max(0.0, priority))
        } else {
            self.priority = nil
        }
    }
    
    /// Creates a homepage sitemap entry with recommended settings.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL of the website.
    ///   - lastModified: The date when the homepage was last modified.
    /// - Returns: A sitemap entry configured for a homepage.
    ///
    /// - Example:
    ///   ```swift
    ///   let homepage = SitemapEntry.homepage(baseURL: "https://example.com")
    ///   ```
    public static func homepage(baseURL: String, lastModified: Date? = nil) -> SitemapEntry {
        SitemapEntry(
            url: baseURL,
            lastModified: lastModified,
            changeFrequency: .weekly,
            priority: 1.0
        )
    }
    
    /// Creates a content page sitemap entry with recommended settings.
    ///
    /// - Parameters:
    ///   - url: The URL of the content page.
    ///   - lastModified: The date when the page was last modified.
    ///   - isSection: Whether the page is a section page (defaults to false).
    /// - Returns: A sitemap entry configured for a content page.
    ///
    /// - Example:
    ///   ```swift
    ///   let blogPost = SitemapEntry.contentPage(
    ///     url: "https://example.com/blog/post-1",
    ///     lastModified: Date()
    ///   )
    ///   ```
    public static func contentPage(
        url: String,
        lastModified: Date? = nil,
        isSection: Bool = false
    ) -> SitemapEntry {
        SitemapEntry(
            url: url,
            lastModified: lastModified,
            changeFrequency: isSection ? .monthly : .yearly,
            priority: isSection ? 0.8 : 0.6
        )
    }
}