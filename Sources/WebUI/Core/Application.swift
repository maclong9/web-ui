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

  /// Builds the application by rendering routes to a directory.
  ///
  /// Creates a `.build` directory if it doesn’t exist and writes HTML files for each route.
  ///
  /// - Parameter directory: Destination URL for build output, defaults to `.build`.
  /// - Throws: Errors from directory creation or file writing failures.
  /// - Complexity: O(n) where n is the number of routes.
  public func build(to directory: URL = URL(fileURLWithPath: ".output")) throws {
    do {
      try FileManager.default.createDirectory(
        at: directory,
        withIntermediateDirectories: true,
        attributes: nil
      )
    } catch {
      throw BuildError.directoryCreationFailed(error)
    }

    var failedRoutes = [String]()
    for route in routes {
      do {
        let filePath = directory.appendingPathComponent("\(route.path ?? "").html")
        let htmlContent = route.render().data(using: .utf8)
        guard FileManager.default.createFile(atPath: filePath.path, contents: htmlContent) else {
          throw BuildError.fileCreationFailed(route.path ?? "unnamed", nil)
        }
      } catch {
        failedRoutes.append(route.path ?? "unnamed")
        print("Failed to build route '\(route.path ?? "unnamed")': \(error.localizedDescription)")
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
  }
}
