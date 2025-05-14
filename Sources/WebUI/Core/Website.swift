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
  ///
  /// - Example:
  ///   ```swift
  ///   let site = Website(
  ///     metadata: Metadata(site: "My Site", description: "A great website"),
  ///     stylesheets: ["main.css"],
  ///     scripts: ["main.js": .defer],
  ///     routes: [homePage, aboutPage, contactPage]
  ///   )
  ///   ```
  public init(
    metadata: Metadata? = nil,
    theme: Theme? = nil,
    stylesheets: [String]? = nil,
    scripts: [String: ScriptAttribute?]? = nil,
    head: String? = nil,
    routes: [Document]
  ) {
    self.metadata = metadata
    self.theme = theme
    self.stylesheets = stylesheets
    self.scripts = scripts
    self.head = head
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
    logger.info("Build completed successfully with \(routes.count) routes")
  }

  /// Errors that can occur during the website build process.
  public enum BuildError: Error {
    /// Indicates a failure to create a specific file. Contains the path that failed.
    case fileCreationFailed(String)

    /// Indicates that one or more routes failed to build. Contains the list of failed route paths.
    case failedRoutes([String])
  }
}
