import Foundation

/// A protocol for defining complete websites with a SwiftUI-like pattern.
///
/// The `Website` protocol allows you to define websites using a declarative syntax
/// similar to SwiftUI, with computed properties for metadata and routes.
///
/// ## Example
/// ```swift
/// struct Portfolio: Website {
///   var metadata {
///     Metadata(site: "Portfolio", title: "My Portfolio")
///   }
///
///   var routes {
///     Home()
///     About()
///   }
/// }
/// ```
public protocol Website {
    /// The metadata configuration for this website.
    ///
    /// Defines the default site title, description, and other metadata that will be
    /// applied to all routes unless overridden.
    var metadata: Metadata { get }

    /// The routes that make up this website.
    ///
    /// Each route represents a page in the website. Routes can override
    /// the website's default metadata and styling as needed.
    @WebsiteRouteBuilder
    var routes: [any Document] { get }

    /// Optional default theme applied to all routes unless overridden.
    var theme: Theme? { get }

    /// Optional stylesheet URLs applied to all routes.
    var stylesheets: [String]? { get }

    /// Optional JavaScript sources with their loading attributes applied to all routes.
    var scripts: [Script]? { get }

    /// Optional custom HTML to append to all document head sections.
    var head: String? { get }

    /// Base URL of the website for sitemap generation.
    var baseURL: String? { get }

    /// Custom sitemap entries to include in the sitemap.xml.
    var sitemapEntries: [SitemapEntry]? { get }

    /// Controls whether to generate a sitemap.xml file.
    var generateSitemap: Bool { get }

    /// Controls whether to generate a robots.txt file.
    var generateRobotsTxt: Bool { get }

    /// Custom rules to include in robots.txt file.
    var robotsRules: [RobotsRule]? { get }
}

// MARK: - Default Implementations

extension Website {
    /// Default theme implementation returns nil.
    public var theme: Theme? { nil }

    /// Default stylesheets implementation returns nil.
    public var stylesheets: [String]? { nil }

    /// Default scripts implementation returns nil.
    public var scripts: [Script]? { nil }

    /// Default head implementation returns nil.
    public var head: String? { nil }

    /// Default baseURL implementation returns nil.
    public var baseURL: String? { nil }

    /// Default sitemapEntries implementation returns nil.
    public var sitemapEntries: [SitemapEntry]? { nil }

    /// Default generateSitemap implementation returns true if baseURL is provided.
    public var generateSitemap: Bool { baseURL != nil }

    /// Default generateRobotsTxt implementation returns true if baseURL is provided.
    public var generateRobotsTxt: Bool { baseURL != nil }

    /// Default robotsRules implementation returns nil.
    public var robotsRules: [RobotsRule]? { nil }

    /// Builds the website to the specified output directory.
    ///
    /// This method renders each route to HTML and saves it to the output directory.
    /// It also generates sitemap.xml and robots.txt files if configured.
    ///
    /// - Parameters:
    ///   - outputDirectory: The directory to output the built website.
    ///   - assetsPath: The path to the public assets directory.
    /// - Throws: An error if the build fails.
    public func build(
        to outputDirectory: URL = URL(filePath: ".output"),
        assetsPath: String = "Sources/Public"
    ) throws {
        // Convert document instances
        let documents = routes.map { $0.document() }

        // Create concrete website instance
        let website = ConcreteWebsite(
            metadata: metadata,
            theme: theme,
            stylesheets: stylesheets,
            scripts: scripts,
            head: head,
            routes: documents,
            baseURL: baseURL,
            sitemapEntries: sitemapEntries,
            generateSitemap: generateSitemap,
            generateRobotsTxt: generateRobotsTxt,
            robotsRules: robotsRules
        )

        // Build the website
        try website.build(to: outputDirectory, assetsPath: assetsPath)
    }
}

// MARK: - Route Builder

/// A result builder for creating website routes.
@resultBuilder
public struct WebsiteRouteBuilder {
    public static func buildBlock(_ components: any Document...) -> [any Document] {
        components
    }

    public static func buildOptional(_ component: [any Document]?) -> [any Document] {
        component ?? []
    }

    public static func buildEither(first component: [any Document]) -> [any Document] {
        component
    }

    public static func buildEither(second component: [any Document]) -> [any Document] {
        component
    }

    public static func buildArray(_ components: [[any Document]]) -> [any Document] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: any Document) -> [any Document] {
        [expression]
    }
}
