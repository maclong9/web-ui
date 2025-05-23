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

// MARK: - Concrete Implementation
private struct ConcreteWebsite: Website {
    let metadata: Metadata
    let theme: Theme?
    let stylesheets: [String]?
    let scripts: [Script]?
    let head: String?
    let routes: [any Document]
    let baseURL: String?
    let sitemapEntries: [SitemapEntry]?
    let generateSitemap: Bool
    let generateRobotsTxt: Bool
    let robotsRules: [RobotsRule]?

    func build(
        to outputDirectory: URL,
        assetsPath: String
    ) throws {
        // Create output directory if it doesn't exist
        try FileManager.default.createDirectory(
            at: outputDirectory,
            withIntermediateDirectories: true
        )

        // Copy assets if they exist
        let assetsURL = URL(filePath: assetsPath)
        if FileManager.default.fileExists(atPath: assetsURL.path()) {
            let publicURL = outputDirectory.appending(path: "public")
            try FileManager.default.copyItem(at: assetsURL, to: publicURL)
        }

        // Build each route
        for route in routes {
            try buildRoute(route, in: outputDirectory)
        }

        // Generate sitemap if enabled
        if generateSitemap, let baseURL = baseURL {
            try generateSitemapXML(in: outputDirectory, baseURL: baseURL)
        }

        // Generate robots.txt if enabled
        if generateRobotsTxt {
            try generateRobotsTxt(in: outputDirectory)
        }
    }

    private func buildRoute(_ route: any Document, in directory: URL) throws {
        // Get the route's path, defaulting to index for root
        let path = route.path ?? "index"

        // Create the full path for the HTML file
        var components = path.split(separator: "/")
        let filename = components.removeLast()
        let fullPath = directory.appending(path: components.joined(separator: "/"))

        // Create intermediate directories
        try FileManager.default.createDirectory(
            at: fullPath,
            withIntermediateDirectories: true
        )

        // Generate HTML content by building document tree
        let mergedMetadata = route.metadata
        let mergedTheme = route.theme ?? theme
        let mergedStylesheets = (route.stylesheets ?? []) + (stylesheets ?? [])
        let mergedScripts = (route.scripts ?? []) + (scripts ?? [])

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>\(String(describing: mergedMetadata.title))</title>
            \(mergedMetadata.description.map { "<meta name=\"description\" content=\"\($0)\">" } ?? "")
            \(mergedStylesheets.map { "<link rel=\"stylesheet\" href=\"\($0)\">" }.joined(separator: "\n"))
            \(mergedScripts.map { $0.render() }.joined(separator: "\n"))
            \(head ?? "")
        </head>
        <body>
            \(route.body.render())
        </body>
        </html>
        """

        // Write the HTML file
        guard let data = html.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "WebUI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode HTML"])
        }
        try data.write(to: fullPath.appending(path: "\(filename).html"), options: .atomic)
    }

    private func generateSitemapXML(in directory: URL, baseURL: String) throws {
        var entries = routes.compactMap { route -> SitemapEntry? in
            guard let path = route.path else { return nil }
            return SitemapEntry(
                url: "\(baseURL)/\(path).html",
                lastModified: route.metadata.date,
                changeFrequency: .monthly,
                priority: 0.5
            )
        }

        // Add custom sitemap entries
        if let customEntries = sitemapEntries {
            entries.append(contentsOf: customEntries)
        }

        // Generate sitemap XML
        let sitemap = """
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
            \(entries.map { entry in
                """
                <url>
                    <loc>\(entry.url)</loc>
                    \(entry.lastModified.map { "<lastmod>\($0.ISO8601Format())</lastmod>" } ?? "")
                    \(entry.changeFrequency.map { "<changefreq>\($0.rawValue)</changefreq>" } ?? "")
                    \(entry.priority.map { "<priority>\($0)</priority>" } ?? "")
                </url>
                """
            }.joined(separator: "\n"))
        </urlset>
        """

        // Write sitemap.xml
        guard let data = sitemap.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "WebUI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode sitemap.xml"])
        }
        try data.write(to: directory.appending(path: "sitemap.xml"), options: .atomic)
    }

    private func generateRobotsTxt(in directory: URL) throws {
        var rules = robotsRules ?? []

        // Add default allow all rule if no rules specified
        if rules.isEmpty {
            rules = [RobotsRule(userAgent: "*", allow: ["/"])]
        }

        // Generate robots.txt content
        let ruleStrings = rules.map { rule in
            [
                "User-agent: \(rule.userAgent)",
                rule.allow.map { "Allow: \($0)" }.joined(separator: "\n"),
                (rule.disallow ?? []).map { "Disallow: \($0)" }.joined(separator: "\n")
            ].filter { !$0.isEmpty }.joined(separator: "\n")
        }

        let sitemapLine = generateSitemap && baseURL != nil ? "\nSitemap: \(baseURL!)/sitemap.xml" : ""
        let robotsTxt = ruleStrings.joined(separator: "\n\n") + sitemapLine

        // Write robots.txt
        guard let data = robotsTxt.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "WebUI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode robots.txt"])
        }
        try data.write(to: directory.appending(path: "robots.txt"), options: .atomic)
    }
}
