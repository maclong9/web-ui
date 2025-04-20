import Foundation

public struct Application {
  let routes: [Document]

  public init(routes: [Document]) {
    self.routes = routes
  }

  public func build(
    to directory: URL = URL(fileURLWithPath: ".output"),
    assets: String = "Sources/Public"
  ) throws {
    let fileManager = FileManager.default

    do {
      if fileManager.fileExists(atPath: directory.path()) {
        try fileManager.removeItem(at: directory)
      }
    }

    do {
      try fileManager.createDirectory(
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
        let pathComponents = route.path?.split(separator: "/") ?? [""]
        var currentPath = directory

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

        let fileName = pathComponents.last.map { String($0) } ?? ""
        let filePath = currentPath.appendingPathComponent("\(fileName).html")

        let renderedHTML = route.render()
        let htmlContent = renderedHTML.data(using: .utf8)

        guard fileManager.createFile(atPath: filePath.path, contents: htmlContent) else {
          throw BuildError.fileCreationFailed(route.path ?? "unnamed", nil)
        }
      } catch {
        failedRoutes.append(route.path ?? "unnamed")
        print("Failed to build route '\(route.path ?? "unnamed")': \(error.localizedDescription)")
      }
    }

    let publicSourceURL = URL(fileURLWithPath: assets)
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

    print("Build completed successfully with minified HTML.")
  }

  enum BuildError: Error {
    case directoryCreationFailed(Error)
    case fileCreationFailed(String, Error?)
    case someRoutesFailed([String])
    case publicCopyFailed(Error)
  }
}
