import Foundation

public struct Application {
  let routes: [Document]

  public init(routes: [Document]) {
    self.routes = routes
  }

  private func minifyHTML(_ html: String) -> String {
    var minified = html

    // Remove unnecessary whitespace
    minified = minified.replacingOccurrences(
      of: "\\s+",
      with: " ",
      options: .regularExpression
    )

    // Remove whitespace between tags
    minified = minified.replacingOccurrences(
      of: ">\\s+<",
      with: "><",
      options: .regularExpression
    )

    // Additional minification steps:

    // Remove space after DOCTYPE
    minified = minified.replacingOccurrences(
      of: "<!DOCTYPE\\s+html>",
      with: "<!doctype html>",
      options: .regularExpression
    )

    // Remove quotes around attributes with simple values (no spaces or special chars)
    minified = minified.replacingOccurrences(
      of: "=\\\"([^\\s>]+)\\\"",
      with: "=$1",
      options: .regularExpression
    )

    // Remove optional closing tags for certain elements
    minified = minified.replacingOccurrences(
      of: "</li>",
      with: "",
      options: .regularExpression
    )

    // Minimize attribute spacing
    minified = minified.replacingOccurrences(
      of: "\\s+([a-zA-Z:]+)=([\"'])",
      with: " $1=$2",
      options: .regularExpression
    )

    // Remove space between attributes when followed by another attribute
    minified = minified.replacingOccurrences(
      of: "(\\w+)=\"([^\"]*)\"\\s+(\\w+=)",
      with: "$1=\"$2\"$3",
      options: .regularExpression
    )

    // Remove space before self-closing tags
    minified = minified.replacingOccurrences(
      of: "\\s+/>",
      with: "/>",
      options: .regularExpression
    )

    // Trim leading and trailing whitespace
    minified = minified.trimmingCharacters(in: .whitespacesAndNewlines)

    return minified
  }

  public func build(
    to directory: URL = URL(fileURLWithPath: ".output"),
    publicDirectory: String = "Sources/Public"
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
        let minifiedHTML = minifyHTML(renderedHTML)
        let htmlContent = minifiedHTML.data(using: .utf8)

        guard fileManager.createFile(atPath: filePath.path, contents: htmlContent) else {
          throw BuildError.fileCreationFailed(route.path ?? "unnamed", nil)
        }
      } catch {
        failedRoutes.append(route.path ?? "unnamed")
        print("Failed to build route '\(route.path ?? "unnamed")': \(error.localizedDescription)")
      }
    }

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

    print("Build completed successfully with minified HTML.")
  }

  enum BuildError: Error {
    case directoryCreationFailed(Error)
    case fileCreationFailed(String, Error?)
    case someRoutesFailed([String])
    case publicCopyFailed(Error)
  }
}
