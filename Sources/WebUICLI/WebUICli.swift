import ArgumentParser
import Foundation
import WebUI
import WebUIMarkdown

@main
struct WebUICLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "webui-cli",
        abstract: "WebUI static site generator command-line tool",
        version: "1.0.0",
        subcommands: [Build.self, Serve.self, Init.self]
    )
}

struct Build: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Build a static site from a WebUI Swift project"
    )

    @Option(name: .long, help: "Path to the Swift project directory")
    var projectPath: String = "."

    @Option(name: .long, help: "Output directory for generated site")
    var outputDirectory: String = ".output"

    @Option(name: .long, help: "Swift executable name")
    var executable: String = "Application"

    @Flag(help: "Enable verbose logging")
    var verbose: Bool = false

    func run() throws {
        let fileManager = FileManager.default
        let projectURL = URL(fileURLWithPath: projectPath).standardized
        let outputURL = projectURL.appendingPathComponent(outputDirectory)

        if verbose {
            print("🔧 Building WebUI project at: \(projectURL.path)")
            print("📁 Output directory: \(outputURL.path)")
        }

        // Change to project directory
        fileManager.changeCurrentDirectoryPath(projectURL.path)

        // Build the Swift project
        if verbose { print("🔨 Building Swift project...") }
        let buildResult = shell("swift build -c release")
        if buildResult.exitCode != 0 {
            print("❌ Build failed:")
            print(buildResult.stderr)
            throw ExitCode(buildResult.exitCode)
        }

        if verbose { print("✅ Build completed successfully") }

        // Run the executable to generate the site
        if verbose { print("🚀 Generating static site...") }
        let generateResult = shell("swift run \(executable)")
        if generateResult.exitCode != 0 {
            print("❌ Site generation failed:")
            print(generateResult.stderr)
            throw ExitCode(generateResult.exitCode)
        }

        if verbose { print("✅ Static site generated successfully") }

        // Verify output directory exists and has content
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: outputURL.path, isDirectory: &isDirectory),
            isDirectory.boolValue
        else {
            print("❌ Output directory not found: \(outputURL.path)")
            throw ExitCode.failure
        }

        let contents = try fileManager.contentsOfDirectory(atPath: outputURL.path)
        if contents.isEmpty {
            print("⚠️  Warning: Output directory is empty")
        } else {
            if verbose {
                print("📦 Generated \(contents.count) files/directories:")
                for item in contents.prefix(10) {
                    print("  • \(item)")
                }
                if contents.count > 10 {
                    print("  ... and \(contents.count - 10) more")
                }
            } else {
                print("✅ Site generated with \(contents.count) items in \(outputDirectory)")
            }
        }
    }
}

struct Serve: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "serve",
        abstract: "Serve the generated site locally for development"
    )

    @Option(name: .long, help: "Path to serve from")
    var path: String = ".output"

    @Option(name: .long, help: "Port to serve on")
    var port: Int = 8080

    @Flag(help: "Enable auto-rebuild on file changes")
    var watch: Bool = false

    func run() throws {
        let fileManager = FileManager.default
        let serveURL = URL(fileURLWithPath: path).standardized

        guard fileManager.fileExists(atPath: serveURL.path) else {
            print("❌ Serve path not found: \(serveURL.path)")
            print("💡 Run 'webui-cli build' first to generate the site")
            throw ExitCode.failure
        }

        print("🌐 Starting local server...")
        print("📁 Serving: \(serveURL.path)")
        print("🔗 Local: http://localhost:\(port)")
        print("⏹️  Press Ctrl+C to stop")

        if watch {
            print("👀 Watching for changes...")
        }

        // Start a simple HTTP server using Python (most systems have it)
        let result = shell("cd '\(serveURL.path)' && python3 -m http.server \(port)")
        if result.exitCode != 0 {
            // Fallback to Python 2
            let result2 = shell("cd '\(serveURL.path)' && python -m SimpleHTTPServer \(port)")
            if result2.exitCode != 0 {
                print("❌ Failed to start server. Make sure Python is installed.")
                throw ExitCode.failure
            }
        }
    }
}

struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initialize a new WebUI project"
    )

    @Argument(help: "Project name")
    var name: String

    @Flag(help: "Enable verbose logging")
    var verbose: Bool = false

    func run() throws {
        let fileManager = FileManager.default
        let projectURL = URL(fileURLWithPath: name)

        if fileManager.fileExists(atPath: projectURL.path) {
            print("❌ Directory '\(name)' already exists")
            throw ExitCode.failure
        }

        if verbose { print("📁 Creating project directory: \(name)") }
        try fileManager.createDirectory(at: projectURL, withIntermediateDirectories: true)

        // Create basic project structure
        let sourcesURL = projectURL.appendingPathComponent("Sources/Application")
        try fileManager.createDirectory(at: sourcesURL, withIntermediateDirectories: true)

        // Create Package.swift
        let packageSwift = """
            // swift-tools-version: 6.1

            import PackageDescription

            let package = Package(
              name: "\(name)",
              platforms: [.macOS(.v15)],
              dependencies: [
                .package(url: "https://github.com/maclong9/web-ui", from: "1.0.0")
              ],
              targets: [
                .executableTarget(
                  name: "Application",
                  dependencies: [
                    .product(name: "WebUI", package: "web-ui"),
                    .product(name: "WebUIMarkdown", package: "web-ui"),
                  ],
                )
              ]
            )
            """

        try packageSwift.write(
            to: projectURL.appendingPathComponent("Package.swift"),
            atomically: true, encoding: .utf8)

        // Create main.swift
        let mainSwift = """
            import Foundation
            import WebUI

            @main
            struct \(name.capitalized)Website: Website {
              var body: some Markup {
                HomePage()
              }
            }

            struct HomePage: Document {
              var body: some Markup {
                Text("Hello, WebUI!")
                  .fontSize(.extraLarge)
                  .fontWeight(.bold)
                  .textAlignment(.center)
                  .padding(.large)
              }
            }
            """

        try mainSwift.write(
            to: sourcesURL.appendingPathComponent("main.swift"),
            atomically: true, encoding: .utf8)

        // Create .gitignore
        let gitignore = """
            .build/
            .output/
            .DS_Store
            *.xcodeproj
            *.swiftpm
            """

        try gitignore.write(
            to: projectURL.appendingPathComponent(".gitignore"),
            atomically: true, encoding: .utf8)

        print("✅ Created new WebUI project: \(name)")
        print("📁 To get started:")
        print("   cd \(name)")
        print("   webui-cli build")
        print("   webui-cli serve")
    }
}
