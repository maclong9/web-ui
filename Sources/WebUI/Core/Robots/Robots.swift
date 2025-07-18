import Foundation

/// Provides functionality for generating robots.txt files.
///
/// The `Robots` struct offers methods for creating standards-compliant
/// robots.txt files that provide instructions to web crawlers about which
/// parts of a website they can access.
public struct Robots {

    /// Generates a robots.txt file content.
    ///
    /// This method creates a standard robots.txt file that includes
    /// instructions for web crawlers, including a reference to the sitemap if
    /// one exists.
    ///
    /// - Parameters:
    ///   - baseWebAddress: The optional base web address of the website (e.g., "https://example.com").
    ///   - shouldGenerateSitemap: Whether a sitemap is being generated for this website.
    ///   - robotsRules: Custom rules to include in the robots.txt file.
    /// - Returns: A string containing the content of the robots.txt file.
    ///
    /// - Example:
    ///   ```swift
    ///   let content = Robots.generateTxt(
    ///     baseWebAddress: "https://example.com",
    ///     shouldGenerateSitemap: true,
    ///     robotsRules: [.allowAll()]
    ///   )
    ///   ```
    ///
    /// - Note: If custom rules are provided, they will be included in the file.
    ///   Otherwise, a default permissive robots.txt will be generated.
    public static func generateTxt(
        baseWebAddress: String? = nil,
        shouldGenerateSitemap: Bool = false,
        robotsRules: [RobotsRule]? = nil
    ) -> String {
        var contentComponents: [String] = []

        if let rules = robotsRules, !rules.isEmpty {
            // Add each custom rule
            for rule in rules {
                contentComponents.append(formatRule(rule))
            }
        } else {
            // Default permissive robots.txt
            contentComponents.append("User-agent: *\nAllow: /\n")
        }

        // Add sitemap reference if applicable
        if shouldGenerateSitemap, let baseWebAddress = baseWebAddress {
            contentComponents.append("Sitemap: \(baseWebAddress)/sitemap.xml")
        }

        return contentComponents.joined(separator: "\n")
    }

    /// Formats a single robots rule as a string.
    ///
    /// - Parameter rule: The robots rule to format.
    /// - Returns: A string representation of the rule.
    private static func formatRule(_ rule: RobotsRule) -> String {
        var ruleComponents = ["User-agent: \(rule.userAgent)"]

        // Add disallow paths first (standard practice)
        if let disallow = rule.disallow, !disallow.isEmpty {
            ruleComponents.append(
                contentsOf: disallow.map { "Disallow: \($0)" })
        }

        // Add allow paths after disallow
        if let allow = rule.allow, !allow.isEmpty {
            ruleComponents.append(contentsOf: allow.map { "Allow: \($0)" })
        }

        // Add crawl delay if provided
        if let crawlDelay = rule.crawlDelay {
            ruleComponents.append("Crawl-delay: \(crawlDelay)")
        }

        return ruleComponents.joined(separator: "\n") + "\n"
    }
}
