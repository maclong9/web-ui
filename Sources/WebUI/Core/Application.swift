import Foundation

/// Creates  an application with a collection of routes
///
/// Enables building which will create a `.build` directory
/// this directory is then populated with rendered HTML files and
/// related assets such as images, css and js files.
public struct Application {
  let routes: [Document]

  func build(to directory: URL = URL(fileURLWithPath: ".build")) throws {
    let fileManager = FileManager.default
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)

    for route in routes {
      try fileManager.createDirectory(
        at: directory.appendingPathComponent(route.path),
        withIntermediateDirectories: true
      )
      // create file at ".build/\(route.path).html"
      fileManager.createFile(
        atPath: ".build/\(route.path).html",
        contents: route.render().data(using: .utf8) ?? "".data(using: .utf8)
      )
    }
  }
}
