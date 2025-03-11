// swift-tools-version: 6.0

import PackageDescription

// TODO: Implement Custom CSS (classes evaluated at end of document render)
// TODO: Implement asset file creation for JS and CSS on build

let package = Package(
  name: "WebUI",
  platforms: [.macOS(.v15)],
  products: [
    .library(name: "WebUI", targets: ["WebUI"])
  ],
  targets: [
    .target(name: "WebUI"),
    .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
  ]
)
