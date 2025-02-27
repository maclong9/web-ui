// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "WebUI",
  products: [
    .library(name: "WebUI", targets: ["WebUI"])
  ],
  targets: [
    .target(name: "WebUI"),
    .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
  ]
)
