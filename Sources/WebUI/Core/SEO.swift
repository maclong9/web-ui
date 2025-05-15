import Foundation
import Logging

/// Represents a rule in a robots.txt file.
///
/// Used to define instructions for web crawlers about which parts of the website should be crawled.
public struct RobotsRule {
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
}

/// Represents a sitemap entry for a URL with metadata.
///
/// Used to define information for a URL to be included in a sitemap.xml file.
/// Follows the Sitemap protocol as defined at https://www.sitemaps.org/protocol.html.
public struct SitemapEntry {
    /// The URL of the page.
    public let url: String

    /// The date when the page was last modified.
    public let lastModified: Date?

    /// The expected frequency of changes to the page.
    public enum ChangeFrequency: String {
        case always, hourly, daily, weekly, monthly, yearly, never
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
        self.priority = priority
    }
}

/// Utility functions for generating SEO-related files for a website.
///
/// This class provides methods for generating sitemap.xml and robots.txt files,
/// which are important for search engine optimization (SEO) and web crawler control.
public struct SEOUtils {
    private static let logger = Logger(label: "com.webui.seo.utils")

    /// Generates a sitemap.xml file content from website routes and custom entries.
    ///
    /// This method creates a standard sitemap.xml file that includes all routes in the website,
    /// plus any additional custom sitemap entries. It follows the Sitemap protocol specification
    /// from sitemaps.org.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL of the website (e.g., "https://example.com").
    ///   - routes: The document routes in the website.
    ///   - customEntries: Additional sitemap entries to include.
    /// - Returns: A string containing the XML content of the sitemap.
    ///
    /// - Note: If any route has a `metadata.date` value, it will be used as the lastmod date
    ///   in the sitemap. Priority is set based on the path depth (home page gets 1.0).
    public static func generateSitemapXML(
        baseURL: String,
        routes: [Document],
        customEntries: [SitemapEntry]?
    ) -> String {
        let dateFormatter = ISO8601DateFormatter()

        var xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

            """

        // Add entries for all routes
        for route in routes {
            let path = route.path ?? "index"
            let url = "\(baseURL)/\(path == "index" ? "" : "\(path).html")"

            var entry = "  <url>\n    <loc>\(url)</loc>\n"

            // Add lastmod if metadata has a date
            if let date = route.metadata.date {
                entry += "    <lastmod>\(dateFormatter.string(from: date))</lastmod>\n"
            }

            // Set priority based on path depth (home page gets higher priority)
            let depth = path.components(separatedBy: "/").count
            let priority = path == "index" ? 1.0 : max(0.5, 1.0 - Double(depth) * 0.1)
            entry += "    <priority>\(String(format: "%.1f", priority))</priority>\n"

            // Add changefreq based on path (index and main sections change more frequently)
            if path == "index" {
                entry += "    <changefreq>weekly</changefreq>\n"
            } else if depth == 1 {
                entry += "    <changefreq>monthly</changefreq>\n"
            } else {
                entry += "    <changefreq>yearly</changefreq>\n"
            }

            entry += "  </url>\n"
            xml += entry
        }

        // Add custom sitemap entries
        if let customEntries = customEntries {
            for entry in customEntries {
                xml += "  <url>\n    <loc>\(entry.url)</loc>\n"

                if let lastMod = entry.lastModified {
                    xml += "    <lastmod>\(dateFormatter.string(from: lastMod))</lastmod>\n"
                }

                if let changeFreq = entry.changeFrequency {
                    xml += "    <changefreq>\(changeFreq.rawValue)</changefreq>\n"
                }

                if let priority = entry.priority {
                    xml += "    <priority>\(String(format: "%.1f", priority))</priority>\n"
                }

                xml += "  </url>\n"
            }
        }

        xml += "</urlset>"
        return xml
    }

    /// Generates a robots.txt file content.
    ///
    /// This method creates a standard robots.txt file that includes instructions for web crawlers,
    /// including a reference to the sitemap if one exists.
    ///
    /// - Parameters:
    ///   - baseURL: The optional base URL of the website (e.g., "https://example.com").
    ///   - generateSitemap: Whether a sitemap is being generated for this website.
    ///   - robotsRules: Custom rules to include in the robots.txt file.
    /// - Returns: A string containing the content of the robots.txt file.
    ///
    /// - Note: If custom rules are provided, they will be included in the file.
    ///   Otherwise, a default permissive robots.txt will be generated.
    public static func generateRobotsTxt(
        baseURL: String?,
        generateSitemap: Bool,
        robotsRules: [RobotsRule]?
    ) -> String {
        var content = "# robots.txt generated by WebUI\n\n"

        // Add custom rules if provided
        if let rules = robotsRules, !rules.isEmpty {
            for rule in rules {
                // Add user-agent section
                content += "User-agent: \(rule.userAgent)\n"

                // Add disallow paths
                if let disallow = rule.disallow, !disallow.isEmpty {
                    for path in disallow {
                        content += "Disallow: \(path)\n"
                    }
                }

                // Add allow paths
                if let allow = rule.allow, !allow.isEmpty {
                    for path in allow {
                        content += "Allow: \(path)\n"
                    }
                }

                // Add crawl delay if provided
                if let crawlDelay = rule.crawlDelay {
                    content += "Crawl-delay: \(crawlDelay)\n"
                }

                content += "\n"
            }
        } else {
            // Default permissive robots.txt
            content += "User-agent: *\nAllow: /\n\n"
        }

        // Add sitemap reference if sitemap is generated and baseURL is provided
        if generateSitemap, let baseURL = baseURL {
            content += "Sitemap: \(baseURL)/sitemap.xml\n"
        }

        return content
    }
}
