// swift-tools-version: 6.0

import PackageDescription

// Roadmap
// Version 1.0.0
// TODO: Rewrite the styling and behavior model in a better designed way
// TODO: Extend enumerations, such as ContentType, with more options
// TODO: Implement arbitrary `Script` and `Style` for overriding library
// Version 1.1.0
// TODO: Implement Custom CSS (classes evaluated at end of document render)
// Version 1.3.0
// TODO: Implement complex components like accordion, dialog, admonition, card
// Version 2.0.0
// TODO: Attempt extending to contain server side and framework functionality
// TODO: Create a deployment solution that automates builds on a git push

// Documentation
// TODO: Create components for core layouts, see deno fresh apps for examples
// TODO: Write reasoning for choices such as utility classes and the Image class in README
// TODO: Create tutorial for static site generation with blog, ensure usage of SwiftPM Snippets
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
