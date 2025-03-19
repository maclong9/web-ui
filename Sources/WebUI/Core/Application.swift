import Foundation

/// Manages an application’s routes and generates a build directory.
public struct Application {
  /// Collection of documents representing application routes.
  let routes: [Document]

  /// Builds the application by rendering routes to a directory.
  ///
  /// Creates a `.build` directory if it doesn’t exist and writes HTML files for each route.
  ///
  /// - Parameter directory: Destination URL for build output, defaults to `.build`.
  /// - Throws: Errors from directory creation or file writing failures.
  /// - Complexity: O(n) where n is the number of routes.
  func build(to directory: URL = URL(fileURLWithPath: ".build")) throws {
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true,
      attributes: nil
    )

    for route in routes {
      try FileManager.default.createDirectory(
        at: directory.appendingPathComponent(route.path),
        withIntermediateDirectories: true
      )

      FileManager.default.createFile(
        atPath: directory.appendingPathComponent("\(route.path).html").path,
        contents: route.render().data(using: .utf8)
      )
    }
  }
}
