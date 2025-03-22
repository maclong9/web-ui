// swift-tools-version: 6.0

import PackageDescription

// Roadmap
// Version 0.0.5
// TODO: Create tutorial for static site generation with blog, ensure usage of SwiftPM Snippets
// Version 1.0.0
// TODO: Extend enumerations, such as ContentType, with more options
// TODO: Implement arbirtray `Script` and `Style` for overriding library
// TODO: Implement asset file creation for JS and CSS on build
// Version 1.1.0
// TODO: Implement Custom CSS (classes evaluated at end of document render)
// Version 1.3.0
// TODO: Implement complex components like accordion, dialog, admonition, card should have link span inset-0 nested rounding subtract padding and tabs
// Version 2.0.0
// TODO: Attempt extending to contain server and framework functionality

// Documentation
// TODO: Create a snippet for core layouts, see deno fresh apps for examples
// TODO: Write reasoning for choices such as utiltiy classes and the Image class in README
// TODO: Create tutorial for SSR Hummingbird site with todos
// TODO: Create tutorial for scaling todos app with Cloudflare
// TODO: Create tutorial for Ecommerce with Hummingbird and Stripe
// TODO: Create tutorial for Page Builder and Content Management System

let package = Package(
  name: "WebUI",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "WebUI", targets: ["WebUI"])
  ],
  targets: [
    .target(name: "WebUI"),
    .testTarget(name: "WebUITests", dependencies: ["WebUI"]),
  ]
)
