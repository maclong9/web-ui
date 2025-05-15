import Foundation
import Logging

/// Manages and builds a collection of routes (documents) into a complete static website.
///
/// The `Website` struct serves as the entry point for creating a static site, managing
/// shared resources, and generating the final HTML files. It handles merging of common
/// assets (like scripts and stylesheets) and provides a clean API for building multiple
/// pages with consistent styling and behavior.
public struct Website {
  private let logger = Logger(label: "com.webui.application")

  /// Optional default metadata applied to all routes unless overridden.
  public let metadata: Metadata?

  /// Optional default theme applied to all routes unless overridden.
  public let theme: Theme?

  /// Optional stylesheet URLs applied to all routes.
  public let stylesheets: [String]?

  /// Optional JavaScript sources with their loading attributes applied to all routes.
  public let scripts: [String: ScriptAttribute?]?

  /// Optional custom HTML to append to all document head sections.
  public let head: String?

  /// Collection of document routes that make up the website.
  public let routes: [Document]

  /// Base URL of the website for sitemap generation.
  public let baseURL: String?

  /// Custom sitemap entries to include in the sitemap.xml.
  public let sitemapEntries: [SitemapEntry]?

  /// Controls whether to generate a sitemap.xml file.
  public let generateSitemap: Bool

  /// Controls whether to generate a robots.txt file.
  public let generateRobotsTxt: Bool

  /// Custom rules to include in robots.txt file.
  public let robotsRules: [RobotsRule]?

  /// Initializes a static site with shared resources and a collection of routes.
  ///
  /// This initializer configures a website with shared assets and settings that apply
  /// to all routes. Individual routes can override these settings as needed.
  ///
  /// - Parameters:
  ///   - metadata: Optional default metadata for all routes (title, description, etc.).
  ///   - theme: Optional default theme for all routes (colors, typography, etc.).
  ///   - stylesheets: Optional stylesheet URLs to include in all routes.
  ///   - scripts: Optional JavaScript sources with their loading attributes for all routes.
  ///   - head: Optional custom head tags to include in all routes (analytics, fonts, etc.).
  ///   - routes: Collection of document routes to build into HTML files.
  ///   - baseURL: Base URL of the website for sitemap generation (e.g., "https://example.com").
  ///   - sitemapEntries: Custom sitemap entries to include in addition to the routes.
  ///   - generateSitemap: Whether to generate a sitemap.xml file (defaults to true if baseURL is provided).
  ///   - generateRobotsTxt: Whether to generate a robots.txt file (defaults to true if baseURL is provided).
  ///   - robotsRules: Custom rules to include in the robots.txt file.
  ///
  /// - Example:
  ///   ```swift
  ///   let site = Website(
  ///     metadata: Metadata(site: "My Site", description: "A great website"),
  ///     stylesheets: ["main.css"],
  ///     scripts: ["main.js": .defer],
  ///     routes: [homePage, aboutPage, contactPage],
  ///     baseURL: "https://example.com",
  ///     generateSitemap: true
  ///   )
  ///   ```
  public init(
    metadata: Metadata? = nil,
    theme: Theme? = nil,
    stylesheets: [String]? = nil,
    scripts: [String: ScriptAttribute?]? = nil,
    head: String? = nil,
    routes: [Document],
    baseURL: String? = nil,
    sitemapEntries: [SitemapEntry]? = nil,
    generateSitemap: Bool? = nil,
    generateRobotsTxt: Bool? = nil,
    robotsRules: [RobotsRule]? = nil
  ) {
    self.metadata = metadata
    self.theme = theme
    self.stylesheets = stylesheets
    self.scripts = scripts
    self.head = head
    self.baseURL = baseURL
    self.sitemapEntries = sitemapEntries
    self.generateSitemap = generateSitemap ?? (baseURL != nil)
    self.generateRobotsTxt = generateRobotsTxt ?? (baseURL != nil)
    self.robotsRules = robotsRules
    self.routes = routes.map { document in
      // Merge scripts: Website scripts + Document scripts (Document scripts override duplicates)
      var mergedScripts = scripts ?? [:]
      if let documentScripts = document.scripts {
        mergedScripts.merge(documentScripts) { _, new in new }
      }

      // Merge stylesheets: Website stylesheets + Document stylesheets (combine, remove duplicates)
      let mergedStylesheets = Array(
        Set((stylesheets ?? []) + (document.stylesheets ?? []))
      )

      // Merge head: Use Document head if provided, otherwise use Website head
      let mergedHead = document.head ?? head

      // Create new Document with merged properties
      return Document(
        path: document.path,
        metadata: document.metadata,
        scripts: mergedScripts.isEmpty ? nil : mergedScripts,
        stylesheets: mergedStylesheets.isEmpty ? nil : mergedStylesheets,
        theme: document.theme ?? theme,
        head: mergedHead,
        content: document.contentBuilder
      )
    }

    logger.info(
      "Initialized '\(metadata?.site ?? "Untitled")' with \(routes.count) routes, theme: \(theme != nil ? "set" : "none")"
    )
  }

  /// Builds HTML files for each route and copies assets to the specified output directory.
  ///
  /// This method performs the following operations:
  /// 1. Creates or clears the output directory
  /// 2. Renders each document to its corresponding HTML file
  /// 3. Creates any necessary subdirectories based on route paths
  /// 4. Copies public assets to the output directory
  ///
  /// - Parameters:
  ///   - outputDirectory: Directory where the generated HTML files and assets will be placed. Defaults to `.output`.
  ///   - assetsPath: Path to the directory containing public assets (images, client-side JS, etc.). Defaults to `Sources/Public`.
  /// - Throws: `BuildError` if file operations fail, which can include file creation failures or route processing failures.
  ///
  /// - Example:
  ///   ```swift
  ///   do {
  ///     try site.build(to: URL(filePath: "public"), assetsPath: "Resources/Assets")
  ///     print("Site built successfully!")
  ///   } catch {
  ///     print("Failed to build site: \(error)")
  ///   }
  ///   ```
  public func build(
    to outputDirectory: URL = URL(filePath: ".output"),
    assetsPath: String = "Sources/Public"
  ) throws {
    logger.info(
      "Starting build to '\(outputDirectory.path)' with assets from '\(assetsPath)'"
    )
    let fileManager = FileManager.default

    // Clear and create output directory
    logger.debug(
      "Checking for existing output directory at '\(outputDirectory.path)'"
    )
    if fileManager.fileExists(atPath: outputDirectory.path) {
      logger.trace("Removing existing output directory")
      try fileManager.removeItem(at: outputDirectory)
      logger.debug("Cleared existing output directory")
    } else {
      logger.trace("No existing output directory found")
    }

    logger.trace("Creating output directory at '\(outputDirectory.path)'")
    try fileManager.createDirectory(
      at: outputDirectory,
      withIntermediateDirectories: true
    )
    logger.debug("Created output directory")

    // Build routes
    logger.info("Building \(routes.count) routes")
    var failedRoutes: [String] = []
    for (index, route) in routes.enumerated() {
      let routePath = route.path ?? "unnamed"
      logger.debug(
        "Processing route [\(index+1)/\(routes.count)]: '\(routePath)'"
      )

      do {
        let pathComponents = route.path?.split(separator: "/") ?? [""]
        let fileName = pathComponents.last.map(String.init) ?? "index"
        var currentPath = outputDirectory

        // Create intermediate directories
        if pathComponents.count > 1 {
          logger.trace(
            "Creating directories for path components: \(pathComponents.dropLast())"
          )
          for component in pathComponents.dropLast() {
            currentPath.appendPathComponent(String(component))
            try fileManager.createDirectory(
              at: currentPath,
              withIntermediateDirectories: true
            )
          }
          logger.debug("Created intermediate directories for '\(routePath)'")
        }

        // Write HTML file
        let filePath = currentPath.appendingPathComponent("\(fileName).html")
        logger.trace("Rendering HTML for '\(routePath)' to '\(filePath.path)'")
        let htmlContent = route.render().data(using: .utf8)
        guard
          fileManager.createFile(atPath: filePath.path, contents: htmlContent)
        else {
          throw BuildError.fileCreationFailed(routePath)
        }
        logger.debug("Successfully wrote HTML file for '\(routePath)'")
      } catch {
        logger.error("Failed to build route '\(routePath)': \(error)")
        failedRoutes.append(routePath)
      }
    }

    // Copy assets
    let sourceURL = URL(fileURLWithPath: assetsPath)
    let destinationURL = outputDirectory.appendingPathComponent("public")
    logger.info(
      "Copying assets from '\(sourceURL.path)' to '\(destinationURL.path)'"
    )
    if fileManager.fileExists(atPath: sourceURL.path) {
      logger.trace("Copying assets directory")
      try fileManager.copyItem(at: sourceURL, to: destinationURL)
      logger.debug("Successfully copied assets")
    } else {
      logger.warning("Assets directory not found at '\(sourceURL.path)'")
    }

    // Report failures
    if !failedRoutes.isEmpty {
      logger.error(
        "Build completed with \(failedRoutes.count) failed routes: \(failedRoutes.joined(separator: ", "))"
      )
      throw BuildError.failedRoutes(failedRoutes)
    }

    // Generate sitemap if enabled and baseURL is set
    if generateSitemap, let baseURL = baseURL {
      logger.info("Generating sitemap.xml")
      let sitemapPath = outputDirectory.appendingPathComponent("sitemap.xml")

      // Generate sitemap content
      let sitemapContent = generateSitemapXML(baseURL: baseURL)

      // Write sitemap to file
      do {
        try sitemapContent.write(
          to: sitemapPath,
          atomically: true,
          encoding: .utf8
        )
        logger.debug("Successfully wrote sitemap.xml")
      } catch {
        logger.error("Failed to write sitemap.xml: \(error)")
        throw BuildError.fileCreationFailed("sitemap.xml")
      }
    }

    // Generate robots.txt if enabled
    if generateRobotsTxt {
      logger.info("Generating robots.txt")
      let robotsPath = outputDirectory.appendingPathComponent("robots.txt")

      // Generate robots.txt content
      let robotsContent = generateRobotsTxt(baseURL: baseURL)

      // Write robots.txt to file
      do {
        try robotsContent.write(
          to: robotsPath,
          atomically: true,
          encoding: .utf8
        )
        logger.debug("Successfully wrote robots.txt")
      } catch {
        logger.error("Failed to write robots.txt: \(error)")
        throw BuildError.fileCreationFailed("robots.txt")
      }
    }

    logger.info("Build completed successfully with \(routes.count) routes")
  }

  /// Generates a sitemap.xml file content from the website routes.
  ///
  /// This method creates a standard sitemap.xml file that includes all routes in the website,
  /// plus any additional custom sitemap entries. It follows the Sitemap protocol specification
  /// from sitemaps.org.
  ///
  /// - Parameter baseURL: The base URL of the website (e.g., "https://example.com").
  /// - Returns: A string containing the XML content of the sitemap.
  ///
  /// - Note: If any route has a `metadata.date` value, it will be used as the lastmod date
  ///   in the sitemap. Priority is set based on the path depth (home page gets 1.0).
  private func generateSitemapXML(baseURL: String) -> String {
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
    if let customEntries = sitemapEntries {
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
  /// - Parameter baseURL: The optional base URL of the website (e.g., "https://example.com").
  /// - Returns: A string containing the content of the robots.txt file.
  ///
  /// - Note: If custom rules are provided via the `robotsRules` property, they will be included in the file.
  ///   Otherwise, a default permissive robots.txt will be generated.
  private func generateRobotsTxt(baseURL: String?) -> String {
    var content = "# robots.txt generated by WebUI\n\n"

    // Add custom rules if provided
    if let rules = robotsRules, !rules.isEmpty {
      for rule in rules {
        // Add user-agent section
        if rule.userAgent == "*" {
          content += "User-agent: *\n"
        } else {
          content += "User-agent: \(rule.userAgent)\n"
        }

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

  /// Errors that can occur during the website build process.
  public enum BuildError: Error {
    /// Indicates a failure to create a specific file. Contains the path that failed.
    case fileCreationFailed(String)

    /// Indicates that one or more routes failed to build. Contains the list of failed route paths.
    case failedRoutes([String])
  }
}
