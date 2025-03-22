import Foundation

/// Manages an application’s routes and generates a build directory.
public struct Application {
  /// Collection of documents representing application routes.
  let routes: [Document]

  /// Creates an Application with a collection of routes.
  ///
  /// - Parameter routes: The routes to manage.
  public init(routes: [Document]) {
    self.routes = routes
  }

  /// Builds the application by rendering routes to a directory and copying public assets.
  ///
  /// Creates a `.output` directory if it doesn’t exist, writes HTML files for each route,
  /// and copies contents from the public directory to `.output/public`.
  ///
  /// - Parameter directory: Destination URL for build output, defaults to `.output`.
  /// - Parameter publicDirectory: Source directory for public assets, defaults to "Public".
  /// - Throws: Errors from directory creation, file writing, or public asset copying failures.
  /// - Complexity: O(n + m) where n is the number of routes and m is the size of public directory contents.
  public func build(
    to directory: URL = URL(fileURLWithPath: ".output"),
    publicDirectory: String = "Sources/Public"
  ) throws {
    let fileManager = FileManager.default

    // Clear previous output directory
    do {
      if fileManager.fileExists(atPath: directory.path()) {
        try fileManager.removeItem(at: directory)
      }
    }

    // Create output directory
    do {
      try fileManager.createDirectory(
        at: directory,
        withIntermediateDirectories: true,
        attributes: nil
      )
    } catch {
      throw BuildError.directoryCreationFailed(error)
    }

    // Render routes
    var failedRoutes = [String]()
    for route in routes {
      do {
        // Split the path into components
        let pathComponents = route.path?.split(separator: "/") ?? [""]
        var currentPath = directory

        // Create nested directories if path contains "/"
        if pathComponents.count > 1 {
          for component in pathComponents.dropLast() {
            currentPath = currentPath.appendingPathComponent(String(component))
            try fileManager.createDirectory(
              at: currentPath,
              withIntermediateDirectories: true,
              attributes: nil
            )
          }
        }

        // Create the final file
        let fileName = pathComponents.last.map { String($0) } ?? ""
        let filePath = currentPath.appendingPathComponent("\(fileName).html")
        let htmlContent = route.render().data(using: .utf8)

        guard fileManager.createFile(atPath: filePath.path, contents: htmlContent) else {
          throw BuildError.fileCreationFailed(route.path ?? "unnamed", nil)
        }
      } catch {
        failedRoutes.append(route.path ?? "unnamed")
        print("Failed to build route '\(route.path ?? "unnamed")': \(error.localizedDescription)")
      }
    }

    // Copy public directory contents
    let publicSourceURL = URL(fileURLWithPath: publicDirectory)
    let publicDestURL = directory.appendingPathComponent("public")

    if fileManager.fileExists(atPath: publicSourceURL.path) {
      do {
        try fileManager.copyItem(at: publicSourceURL, to: publicDestURL)
      } catch {
        throw BuildError.publicCopyFailed(error)
      }
    }

    if !failedRoutes.isEmpty {
      throw BuildError.someRoutesFailed(failedRoutes)
    }

    print("Build completed successfully.")
  }

  enum BuildError: Error {
    case directoryCreationFailed(Error)
    case fileCreationFailed(String, Error?)
    case someRoutesFailed([String])
    case publicCopyFailed(Error)
  }
}
