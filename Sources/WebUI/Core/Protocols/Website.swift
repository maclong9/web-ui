import Foundation

/// A protocol for defining complete websites with a SwiftUI-like pattern.
///
/// The `Website` protocol allows you to define websites using a declarative
/// syntax similar to SwiftUI, with computed properties for metadata and
/// routes.
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
    /// Defines the default site title, description, and other metadata that
    /// will be applied to all routes unless overridden.
    var metadata: Metadata { get }

    /// The routes that make up this website.
    ///
    /// Each route represents a page in the website. Routes can override the
    /// website's default metadata and styling as needed.
    /// - Throws: An error if route construction fails (e.g., when fetching dynamic routes).
    @WebsiteRouteBuilder
    var routes: [any Document] { get throws }

    /// Optional default theme applied to all routes unless overridden.
    var theme: Theme? { get }

    /// Optional stylesheet URLs applied to all routes.
    var stylesheets: [String]? { get }

    /// Optional JavaScript sources with their loading attributes applied to all routes.
    var scripts: [Script]? { get }

    /// Optional custom HTML to append to all document head sections.
    var head: String? { get }

    /// Base web address of the website for sitemap generation.
    var baseWebAddress: String? { get }

    /// Custom sitemap entries to include in the sitemap.xml.
    var sitemapEntries: [SitemapEntry]? { get }

    /// Controls whether to generate a sitemap.xml file.
    var shouldGenerateSitemap: Bool { get }

    /// Controls whether to generate a robots.txt file.
    var shouldGenerateRobotsTxt: Bool { get }

    /// Optional custom rules to include in robots.txt file.
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

    /// Default base web address implementation returns nil.
    public var baseWebAddress: String? { nil }

    /// Default sitemapEntries implementation returns nil.
    public var sitemapEntries: [SitemapEntry]? { nil }

    /// Default sitemap generation implementation returns true if base web address is provided.
    public var shouldGenerateSitemap: Bool { baseWebAddress != nil }

    /// Default robots.txt generation implementation returns true if base web address is provided.
    public var shouldGenerateRobotsTxt: Bool { baseWebAddress != nil }

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
    /// - Throws: A `WebsiteBuildError` if the build fails or route construction fails.
    public func build(
        to outputDirectory: URL = URL(filePath: ".output"),
        assetsPath: String = "Public"
    ) throws {
        // Clear previous build
        if FileManager.default.fileExists(atPath: outputDirectory.path()) {
            do {
                try FileManager.default.removeItem(at: outputDirectory)
            } catch {
                throw WebsiteBuildError.oldOutputDirectoryDeletionFailed(path: outputDirectory.path)
            }
        }

        // Create output directory
        do {
            try FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true
            )
        } catch {
            throw WebsiteBuildError.directoryCreationFailed(path: outputDirectory.path)
        }

        // Copy assets if they exist
        let assetsURL = URL(filePath: assetsPath)
        if FileManager.default.fileExists(atPath: assetsURL.path()) {
            let publicURL = outputDirectory.appending(path: "public")
            do {
                try FileManager.default.copyItem(at: assetsURL, to: publicURL)
            } catch {
                throw WebsiteBuildError.assetCopyFailed(source: assetsURL.path, destination: publicURL.path)
            }
        }

        // Generate state scripts first (before building routes)
        try generateStateScripts(in: outputDirectory)

        // Build each route
        let routes = try self.routes  // Fetch routes, propagating errors
        for route in routes {
            try buildRoute(route, in: outputDirectory)
        }

        // Generate sitemap if enabled
        if shouldGenerateSitemap, let baseWebAddress = baseWebAddress {
            try generateSitemapXML(in: outputDirectory, baseWebAddress: baseWebAddress)
        }

        // Generate robots.txt if enabled
        if shouldGenerateRobotsTxt {
            try generateRobotsTxt(in: outputDirectory)
        }
    }

    private func buildRoute(_ route: any Document, in directory: URL) throws {
        // Get the route's path, defaulting to index for root
        let path = route.path ?? "index"

        // Generate document-specific state scripts if needed
        try route.generateStateScripts(in: directory, path: path)

        // Create the full path for the HTML file
        var components = path.split(separator: "/")
        let filename = components.removeLast()
        let fullPath = directory.appending(path: components.joined(separator: "/"))

        // Create intermediate directories
        do {
            try FileManager.default.createDirectory(
                at: fullPath,
                withIntermediateDirectories: true
            )
        } catch {
            throw WebsiteBuildError.directoryCreationFailed(path: fullPath.path)
        }

        // Generate HTML content by building document tree
        let html = try route.render()

        // Write the HTML file
        guard let data = html.data(using: String.Encoding.utf8) else {
            throw WebsiteBuildError.htmlEncodingFailed(path: "\(filename).html")
        }
        do {
            try data.write(
                to: fullPath.appending(path: "\(filename).html"), options: .atomic)
        } catch {
            throw WebsiteBuildError.fileWriteFailed(path: fullPath.appending(path: "\(filename).html").path)
        }
    }

    private func generateSitemapXML(in directory: URL, baseWebAddress: String) throws {
        var entries = try routes.compactMap { route -> SitemapEntry? in
            guard let path = route.path else { return nil }
            return SitemapEntry(
                url: "\(baseWebAddress)/\(path).html",
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
            throw WebsiteBuildError.sitemapEncodingFailed
        }
        do {
            try data.write(
                to: directory.appending(path: "sitemap.xml"), options: .atomic)
        } catch {
            throw WebsiteBuildError.fileWriteFailed(path: directory.appending(path: "sitemap.xml").path)
        }
    }

    private func generateRobotsTxt(in directory: URL) throws {
        // Use the dedicated Robots.generateTxt method
        let robotsTxt = Robots.generateTxt(
            baseWebAddress: baseWebAddress,
            shouldGenerateSitemap: shouldGenerateSitemap,
            robotsRules: robotsRules
        )

        // Write robots.txt
        guard let data = robotsTxt.data(using: String.Encoding.utf8) else {
            throw WebsiteBuildError.robotsTxtEncodingFailed
        }
        do {
            try data.write(
                to: directory.appending(path: "robots.txt"), options: [.atomic])
        } catch {
            throw WebsiteBuildError.fileWriteFailed(path: directory.appending(path: "robots.txt").path)
        }
    }
}

// MARK: - Error Handling

/// Errors that can occur during the website build process.
public enum WebsiteBuildError: Error, CustomStringConvertible {
    /// Failed to delete the old output directory
    case oldOutputDirectoryDeletionFailed(path: String)

    /// Failed to create a directory at the specified path.
    case directoryCreationFailed(path: String)

    /// Failed to copy assets from source to destination.
    case assetCopyFailed(source: String, destination: String)

    /// Failed to encode HTML content for a route.
    case htmlEncodingFailed(path: String)

    /// Failed to encode sitemap.xml content.
    case sitemapEncodingFailed

    /// Failed to encode robots.txt content.
    case robotsTxtEncodingFailed

    /// Failed to write a file to the specified path.
    case fileWriteFailed(path: String)

    public var description: String {
        switch self {
            case .oldOutputDirectoryDeletionFailed(let path):
                return "Failed to delete old output directory at path: \(path)"
            case .directoryCreationFailed(let path):
                return "Failed to create directory at path: \(path)"
            case .assetCopyFailed(let source, let destination):
                return "Failed to copy assets from \(source) to \(destination)"
            case .htmlEncodingFailed(let path):
                return "Failed to encode HTML for file: \(path)"
            case .sitemapEncodingFailed:
                return "Failed to encode sitemap.xml content"
            case .robotsTxtEncodingFailed:
                return "Failed to encode robots.txt content"
            case .fileWriteFailed(let path):
                return "Failed to write file at path: \(path)"
        }
    }
}
