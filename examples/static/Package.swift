// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Portfolio",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "Application",
            dependencies: [
                .product(name: "WebUI", package: "web-ui")
            ],
            path: "Sources",
            resources: [.process("Public")]
        )
    ]
)
