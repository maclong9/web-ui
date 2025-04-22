import Foundation
import Logging

/// A structure that manages and builds a collection of routes into HTML files.
public struct Application {
  /// The logger instance for the Application
  private let logger = Logger(label: "com.webui.application")

  /// The collection of routes to be built.
  public let routes: [Document]

  /// Initializes an application with a collection of routes.
  /// - Parameter routes: The routes to be built into HTML files.
  public init(routes: [Document]) {
    self.routes = routes
    logger.info("Application initialized with \(routes.count) routes")
  }

  /// Builds the application by generating HTML files for each route in the specified directory.
  /// - Parameters:
  ///   - outputDirectory: The directory where HTML files will be generated. Defaults to `.output`.
  ///   - assetsPath: The path to the public assets directory. Defaults to `Sources/Public`.
  /// - Throws: `BuildError` if directory creation, file creation, or asset copying fails.
  /// - Complexity: O(n) where n is the number of routes.
  public func build(
    to outputDirectory: URL = URL(fileURLWithPath: ".output"),
    assetsPath: String = "Sources/Public"
  ) throws {
    logger.info("Starting build process to \(outputDirectory.path)")
    logger.debug("Using assets path: \(assetsPath)")

    let fileManager = FileManager.default

    // Remove existing output directory if it exists
    logger.debug("Checking for existing output directory")
    try removeExistingDirectory(at: outputDirectory, using: fileManager)

    // Create output directory
    logger.debug("Creating output directory")
    try createDirectory(at: outputDirectory, using: fileManager)

    // Build each route
    logger.info("Building \(routes.count) routes")
    var failedRoutes: [String] = []
    try buildRoutes(
      routes,
      to: outputDirectory,
      trackingFailuresIn: &failedRoutes,
      using: fileManager
    )

    // Copy assets
    logger.info("Copying assets from \(assetsPath) to output")
    try copyAssets(
      from: URL(fileURLWithPath: assetsPath),
      to: outputDirectory.appendingPathComponent("public"),
      using: fileManager
    )

    // Throw error if any routes failed
    if !failedRoutes.isEmpty {
      logger.error("Build completed with \(failedRoutes.count) failed routes")
      throw BuildError.failedRoutes(failedRoutes)
    }

    logger.notice("Build completed successfully.")
  }

  /// Removes an existing directory if it exists.
  /// - Parameters:
  ///   - url: The URL of the directory to remove.
  ///   - fileManager: The file manager to use for operations.
  /// - Throws: `BuildError.directoryCreationFailed` if removal fails.
  private func removeExistingDirectory(
    at url: URL,
    using fileManager: FileManager
  ) throws {
    if fileManager.fileExists(atPath: url.path()) {
      logger.debug("Removing existing directory at \(url.path())")
      do {
        try fileManager.removeItem(at: url)
        logger.debug("Successfully removed existing directory")
      } catch {
        logger.error("Failed to remove existing directory: \(error.localizedDescription)")
        throw BuildError.directoryCreationFailed(error)
      }
    } else {
      logger.debug("No existing directory found at \(url.path())")
    }
  }

  /// Creates a directory at the specified URL.
  /// - Parameters:
  ///   - url: The URL where the directory should be created.
  ///   - fileManager: The file manager to use for operations.
  /// - Throws: `BuildError.directoryCreationFailed` if creation fails.
  private func createDirectory(
    at url: URL,
    using fileManager: FileManager
  ) throws {
    logger.debug("Creating directory at \(url.path())")
    do {
      try fileManager.createDirectory(
        at: url,
        withIntermediateDirectories: true
      )
      logger.debug("Successfully created directory")
    } catch {
      logger.error("Failed to create directory: \(error.localizedDescription)")
      throw BuildError.directoryCreationFailed(error)
    }
  }

  /// Builds routes by creating HTML files in the output directory.
  /// - Parameters:
  ///   - routes: The routes to build.
  ///   - outputDirectory: The directory where HTML files will be created.
  ///   - failedRoutes: An array to track routes that fail to build.
  ///   - fileManager: The file manager to use for operations.
  /// - Throws: `BuildError.fileCreationFailed` if a file cannot be created.
  private func buildRoutes(
    _ routes: [Document],
    to outputDirectory: URL,
    trackingFailuresIn failedRoutes: inout [String],
    using fileManager: FileManager
  ) throws {
    for (index, route) in routes.enumerated() {
      let routePath = route.path ?? "unnamed"
      logger.debug("Building route [\(index+1)/\(routes.count)]: \(routePath)")

      do {
        let pathComponents = route.path?.split(separator: "/") ?? [""]
        let fileName = pathComponents.last.map(String.init) ?? "index"

        logger.trace("Creating path for route with components: \(pathComponents), filename: \(fileName)")
        let filePath = try createPath(
          for: pathComponents,
          in: outputDirectory,
          with: fileName,
          using: fileManager
        )

        logger.debug("Rendering HTML for route: \(routePath)")
        let htmlContent = route.render().data(using: .utf8)

        logger.debug("Creating file at: \(filePath.path)")
        guard
          fileManager.createFile(
            atPath: filePath.path,
            contents: htmlContent
          )
        else {
          logger.error("Failed to create file for route: \(routePath)")
          throw BuildError.fileCreationFailed(
            routePath,
            nil
          )
        }

        logger.debug("Successfully built route: \(routePath)")
      } catch {
        logger.error("Failed to build route '\(routePath)': \(error.localizedDescription)")
        failedRoutes.append(routePath)
        print(
          "Failed to build route '\(routePath)': \(error.localizedDescription)")
      }
    }

    if failedRoutes.isEmpty {
      logger.info("All routes built successfully")
    } else {
      logger.warning("\(failedRoutes.count) routes failed to build")
    }
  }

  /// Creates the file path for a route, including any necessary directories.
  /// - Parameters:
  ///   - components: The path components of the route.
  ///   - outputDirectory: The base output directory.
  ///   - fileName: The name of the HTML file.
  ///   - fileManager: The file manager to use for operations.
  /// - Returns: The URL of the created file path.
  /// - Throws: `BuildError.directoryCreationFailed` if directory creation fails.
  private func createPath(
    for components: [Substring],
    in outputDirectory: URL,
    with fileName: String,
    using fileManager: FileManager
  ) throws -> URL {
    var currentPath = outputDirectory

    if components.count > 1 {
      for component in components.dropLast() {
        currentPath = currentPath.appendingPathComponent(String(component))
        logger.trace("Creating directory for path component: \(component)")
        try createDirectory(at: currentPath, using: fileManager)
      }
    }

    let finalPath = currentPath.appendingPathComponent("\(fileName).html")
    logger.trace("Final file path created: \(finalPath.path)")
    return finalPath
  }

  /// Copies assets from the source to the destination directory.
  /// - Parameters:
  ///   - sourceURL: The source URL of the assets.
  ///   - destinationURL: The destination URL for the assets.
  ///   - fileManager: The file manager to use for operations.
  /// - Throws: `BuildError.publicCopyFailed` if copying fails.
  private func copyAssets(
    from sourceURL: URL,
    to destinationURL: URL,
    using fileManager: FileManager
  ) throws {
    if fileManager.fileExists(atPath: sourceURL.path) {
      logger.debug("Assets directory exists at: \(sourceURL.path)")
      do {
        logger.debug("Copying assets to: \(destinationURL.path)")
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        logger.debug("Successfully copied assets")
      } catch {
        logger.error("Failed to copy assets: \(error.localizedDescription)")
        throw BuildError.publicCopyFailed(error)
      }
    } else {
      logger.warning("Assets directory not found at: \(sourceURL.path)")
    }
  }

  /// Errors that can occur during the build process.
  public enum BuildError: Error {
    /// Indicates failure to create a directory.
    case directoryCreationFailed(Error)

    /// Indicates failure to create a file for a route.
    case fileCreationFailed(String, Error?)

    /// Indicates that some routes failed to build.
    case failedRoutes([String])

    /// Indicates failure to copy public assets.
    case publicCopyFailed(Error)
  }
}
