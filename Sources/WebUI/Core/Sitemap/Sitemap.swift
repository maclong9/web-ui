import Foundation

/// Provides functionality for generating sitemap XML files.
///
/// The `Sitemap` struct offers methods for creating standards-compliant
/// sitemap.xml files that inform search engines about the structure of a
/// website and the relative importance of its pages. Sitemaps improve SEO by
/// ensuring all content is discoverable.
public struct Sitemap {
    /// XML namespace for the sitemap protocol
    private static let sitemapNamespace =
        "http://www.sitemaps.org/schemas/sitemap/0.9"

    /// Generates a sitemap.xml file content from website routes and custom entries.
    ///
    /// This method creates a standard sitemap.xml file that includes all
    /// routes in the website, plus any additional custom sitemap entries. It
    /// follows the Sitemap protocol specification from sitemaps.org.
    ///
    /// - Parameters:
    ///   - baseWebAddress: The base web address of the website (e.g., "https://example.com").
    ///   - routes: The document routes in the website.
    ///   - customEntries: Additional sitemap entries to include.
    /// - Returns: A string containing the extensible markup language content of the sitemap.
    ///
    /// - Example:
    ///   ```swift
    ///   let sitemapMarkup = Sitemap.generateExtensibleMarkupLanguageDocument(
    ///     baseWebAddress: "https://example.com",
    ///     routes: website.routes,
    ///     customEntries: additionalEntries
    ///   )
    ///   ```
    ///
    /// - Note: If any route has a `metadata.date` value, it will be used as the lastmod date
    ///   in the sitemap. Priority is set based on the path depth (home page gets 1.0).
    public static func generateExtensibleMarkupLanguageDocument(
        baseWebAddress: String,
        routes: [any Document],
        customEntries: [SitemapEntry]? = nil
    ) -> String {
        let dateFormatter = ISO8601DateFormatter()

        var xmlComponents = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<urlset xmlns=\"\(sitemapNamespace)\">",
        ]

        // Add entries for all routes
        for route in routes {
            let path = route.path ?? "index"
            let url = "\(baseWebAddress)/\(path == "index" ? "" : "\(path).html")"

            var urlComponents = ["  <url>", "    <loc>\(url)</loc>"]

            // Add lastmod if metadata has a date
            if let date = route.metadata.date {
                urlComponents.append(
                    "    <lastmod>\(dateFormatter.string(from: date))</lastmod>"
                )
            }

            // Set priority based on path depth (home page gets higher priority)
            let depth = path.components(separatedBy: "/").count
            let priority =
                path == "index" ? 1.0 : max(0.5, 1.0 - Double(depth) * 0.1)
            urlComponents.append(
                "    <priority>\(String(format: "%.1f", priority))</priority>")

            // Add changefreq based on path (index and main sections change more frequently)
            let changeFreq: SitemapEntry.ChangeFrequency = {
                if path == "index" {
                    return .weekly
                } else if depth == 1 {
                    return .monthly
                } else {
                    return .yearly
                }
            }()
            urlComponents.append(
                "    <changefreq>\(changeFreq.rawValue)</changefreq>")

            urlComponents.append("  </url>")
            xmlComponents.append(urlComponents.joined(separator: "\n"))
        }

        // Add custom sitemap entries
        if let customEntries = customEntries, !customEntries.isEmpty {
            for entry in customEntries {
                var urlComponents = ["  <url>", "    <loc>\(entry.url)</loc>"]

                if let lastMod = entry.lastModified {
                    urlComponents.append(
                        "    <lastmod>\(dateFormatter.string(from: lastMod))</lastmod>"
                    )
                }

                if let changeFreq = entry.changeFrequency {
                    urlComponents.append(
                        "    <changefreq>\(changeFreq.rawValue)</changefreq>")
                }

                if let priority = entry.priority {
                    urlComponents.append(
                        "    <priority>\(String(format: "%.1f", priority))</priority>"
                    )
                }

                urlComponents.append("  </url>")
                xmlComponents.append(urlComponents.joined(separator: "\n"))
            }
        }

        xmlComponents.append("</urlset>")
        return xmlComponents.joined(separator: "\n")
    }

    /// Validates if a web address is properly formatted for inclusion in a sitemap.
    ///
    /// - Parameter url: The web address to validate.
    /// - Returns: True if the web address is valid for a sitemap, false otherwise.
    public static func isValidURL(_ url: String) -> Bool {
        guard let url = URL(string: url) else {
            return false
        }

        return url.scheme != nil && url.host != nil
    }

    /// Backward compatibility method for generating XML sitemap content.
    ///
    /// - Deprecated: Use `generateExtensibleMarkupLanguageDocument(baseWebAddress:routes:customEntries:)` instead.
    /// - Parameters:
    ///   - baseURL: The base URL of the website.
    ///   - routes: The document routes in the website.
    ///   - customEntries: Additional sitemap entries to include.
    /// - Returns: A string containing the XML content of the sitemap.
    @available(
        *, deprecated,
        message: "Use generateExtensibleMarkupLanguageDocument(baseWebAddress:routes:customEntries:) instead"
    )
    public static func generateXML(
        baseURL: String,
        routes: [any Document],
        customEntries: [SitemapEntry]? = nil
    ) -> String {
        generateExtensibleMarkupLanguageDocument(
            baseWebAddress: baseURL,
            routes: routes,
            customEntries: customEntries
        )
    }
}
