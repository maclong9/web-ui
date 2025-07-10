#!/usr/bin/env swift

import Foundation

enum Template: String, CaseIterable {
  case `static`
  case server
}

enum InitError: Error, CustomStringConvertible {
  case invalidTemplate(String)
  case fileCopyFailed(String)
  case downloadFailed
  case templateNotFound(String)
  case fileReplacementFailed(String)
  case contentReplacementFailed(Error)

  var description: String {
    switch self {
    case .invalidTemplate(let value):
      return
        "Invalid template '\(value)'. Valid options: \(Template.allCases.map { $0.rawValue }.joined(separator: ", "))"
    case .fileCopyFailed(let path):
      return "Failed to copy template to '\(path)'"
    case .downloadFailed:
      return "Failed to download or extract template"
    case .templateNotFound(let path):
      return "Template not found at: \(path)"
    case .fileReplacementFailed(let path):
      return "Couldn't update content in '\(path)'"
    case .contentReplacementFailed(let error):
      return "Failed to replace content: \(error)"
    }
  }
}

func parseArgs() throws -> (template: Template, projectName: String) {
  let args = Array(CommandLine.arguments.dropFirst())

  guard !args.isEmpty else {
    print("❌ Project name required")
    print("Usage: ./init.swift [--template|-t static|server] project-name")
    exit(1)
  }

  let projectName = args.last!
  var template: Template = .static
  var i = 0

  while i < args.count - 1 {
    switch args[i] {
    case "--template", "-t":
      guard i + 1 < args.count - 1 else {
        throw InitError.invalidTemplate("missing value")
      }

      i += 1
      guard let t = Template(rawValue: args[i]) else {
        throw InitError.invalidTemplate(args[i])
      }
      template = t

    case let arg where arg.starts(with: "-"):
      print("❌ Unknown option: \(arg)")
      print(
        "Usage: ./init.swift [--template|-t static|server] project-name"
      )
      exit(1)

    default:
      print("❌ Unexpected argument: \(args[i])")
      print(
        "Usage: ./init.swift [--template|-t static|server] project-name"
      )
      exit(1)
    }
    i += 1
  }

  return (template, projectName)
}

func downloadAndExtractTemplate(to directory: URL) throws {
  let templateURL =
    "https://github.com/maclong9/web-ui/archive/refs/heads/main.tar.gz"

  let curl = Process()
  curl.executableURL = URL(fileURLWithPath: "/usr/bin/env")
  curl.arguments = ["curl", "-fsSL", templateURL]

  let tar = Process()
  tar.executableURL = URL(fileURLWithPath: "/usr/bin/env")
  tar.arguments = ["tar", "-xz", "-C", directory.path]

  let pipe = Pipe()
  curl.standardOutput = pipe
  tar.standardInput = pipe

  try curl.run()
  try tar.run()
  curl.waitUntilExit()
  tar.waitUntilExit()

  guard curl.terminationStatus == 0 && tar.terminationStatus == 0 else {
    throw InitError.downloadFailed
  }
}

func replaceContentIn(file path: String, projectName: String) throws {
  guard let url = URL(string: "file://\(path)") else { return }

  do {
    var content = try String(contentsOf: url, encoding: .utf8)
    content = content.replacingOccurrences(of: "example", with: projectName)
    try content.write(to: url, atomically: true, encoding: .utf8)
  } catch {
    throw InitError.contentReplacementFailed(error)
  }
}

// Main execution
do {
  let (template, projectName) = try parseArgs()

  // Create temp directory
  let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
    .appendingPathComponent(UUID().uuidString)
  try FileManager.default.createDirectory(
    at: tmpDir, withIntermediateDirectories: true)

  // Download and extract
  try downloadAndExtractTemplate(to: tmpDir)

  // Setup paths
  let templatePath = tmpDir.appendingPathComponent(
    "web-ui-main/examples/\(template.rawValue)")
  let destination =
    FileManager.default.currentDirectoryPath + "/" + projectName

  // Verify template exists
  guard FileManager.default.fileExists(atPath: templatePath.path) else {
    throw InitError.templateNotFound(templatePath.path)
  }

  // Copy template to destination
  do {
    try FileManager.default.copyItem(
      at: templatePath, to: URL(fileURLWithPath: destination))
  } catch {
    throw InitError.fileCopyFailed(destination)
  }

  // Replace placeholders in files
  try replaceContentIn(
    file: "\(destination)/Package.swift", projectName: projectName)
  try replaceContentIn(
    file: "\(destination)/Sources/Application.swift",
    projectName: projectName)

  // Cleanup
  try? FileManager.default.removeItem(atPath: "\(destination)/.git")
  try? FileManager.default.removeItem(at: tmpDir)

  print("\u{001B}[1;32m✓ \(projectName) initialisation complete")

  if template == .static {
    print(
      "Run \u{001B}[1;33mcd \(projectName) && swift run\u{001B}[0m to build your static site to the \u{001B}[1;36m.output\u{001B}[0m directory.\n"
    )
  } else {
    print("🚧 Example coming soon")
  }

} catch let error as InitError {
  print("❌ \(error.description)")
  exit(1)
} catch {
  print("❌ Something went wrong: \(error.localizedDescription)")
  exit(1)
}
