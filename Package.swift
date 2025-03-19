// swift-tools-version: 6.0

import PackageDescription

// Roadmap
// Version 1.0.0
// TODO: Increase test coverage to > 95%
// TODO: Attempt adding a server style process using SwiftNIO to drop Hummingbird
// TODO: Implement asset file creation for JS and CSS on build
// Version 1.1.0
// TODO: Implement Custom CSS (classes evaluated at end of document render)
// TODO: Extend enumerations, such as ContentType, with more options
// TODO: Add documentation for enumerations that aren't self explanatory
// Version 1.2.0
// TODO: Create tutorial for static site generation with blog, ensure usage of SwiftPM Snippets
// TODO: Create tutorial for SSR Hummingbird site with todos
// TODO: Create tutorial for scaling todos app with Cloudflare
// Version 1.3.0
// TODO: Implement complex components like accordion, dialog, admonition and tabs
// TODO: Create tutorial for Ecommerce with Hummingbird and Stripe

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
