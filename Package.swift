// swift-tools-version: 6.0

import PackageDescription

// TODO: Implement ``FormField`` component with label, input (validated) and error states
// TODO: Implement ``Application`` class for creating static sites (add ``Document(name: String? = nil)``
// TODO: Implement markdown rendering with admonitions and syntax highlighting
// TODO: Implement asset file creation for JS and CSS on build
// TODO: Implement Custom CSS (classes evaluated at end of document render)
// TODO: Create tutorial for static site generation with blog
// TODO: Create tutorial for SSR Hummingbird site with todos
// TODO: Create tutorial for scaling todos app with Cloudflare 

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
