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
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-markdown", from: "0.6.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: "WebUI",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .target(
            name: "WebUIMarkdown",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Markdown", package: "swift-markdown"),
            ]
        ),
        .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
    ]
)
