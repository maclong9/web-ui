// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Portfolio",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "Portfolio",
            dependencies: [
                .product(name: "WebUI", package: "web-ui"),
                .product(name: "WebUIMarkdown", package: "web-ui")
            ],
            path: "Sources"
        ),
    ]
)