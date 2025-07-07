// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "web-ui",
    platforms: [
        .macOS(.v15), .tvOS(.v13), .iOS(.v13), .watchOS(.v6), .visionOS(.v2),
    ],
    products: [
        .library(name: "WebUI", targets: ["WebUI"]),
        .library(name: "WebUIMarkdown", targets: ["WebUIMarkdown"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown", from: "0.6.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(name: "WebUI"),
        .target(
            name: "WebUIMarkdown",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ]
        ),
        .target(
            name: "WebUIDevServer",
            path: "Sources/WebUI/Core/DevServer"
        ),
        .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
        .testTarget(name: "WebUIMarkdownTests", dependencies: ["WebUIMarkdown"]),
        .testTarget(name: "WebUIDevServerTests", dependencies: ["WebUIDevServer"]),
    ]
)
