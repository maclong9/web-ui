// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "web-ui",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "WebUI", targets: ["WebUI"])
  ],
  targets: [
    .target(name: "WebUI"),
    .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
  ]
)
