import Foundation

/// Creates an application with a collection of routes.
///
/// Creates and populates a `.build` directory with rendered HTML, CSS, and JS.
/// Will also copy relevant image files to the build directory.
public struct Application {
  let routes: [Document]

  /// Builds the application by rendering routes to a directory.
  /// - Parameter directory: The target directory URL (defaults to `.build`).
  /// - Throws: An error if directory creation or file writing fails.
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
