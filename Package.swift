// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "web-ui",
    platforms: [
        .macOS(.v15), .tvOS(.v13), .iOS(.v13), .watchOS(.v6), .visionOS(.v2),
    ],
    products: [
        .library(name: "WebUI", targets: ["WebUI"]),
        .library(name: "WebUIMarkdown", targets: ["WebUIMarkdown"]),
        .executable(name: "webui-cli", targets: ["WebUICLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown", from: "0.6.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WebUI",
        ),
        .target(
            name: "WebUIMarkdown",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ]
        ),
        .executableTarget(
            name: "WebUICLI",
            dependencies: [
                "WebUI",
                "WebUIMarkdown",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
        .testTarget(name: "WebUIMarkdownTests", dependencies: ["WebUIMarkdown"]),
    ]
)
