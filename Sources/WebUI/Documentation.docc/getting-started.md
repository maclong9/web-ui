# Getting Started with WebUI

Create static and dynamic websites using Swift with WebUI's component-based, type-safe API.

## Overview

WebUI is a Swift library for building websites using a declarative, component-based approach. It offers a type-safe way to create HTML, with built-in styling inspired by SwiftUI, and all in pure Swift. WebUI can be used for both static site generation and dynamic server-rendered content.

This article covers the basics of getting started with WebUI, from installation to creating your first page.

## Adding WebUI to Your Project

Add WebUI to your Swift package by adding it as a dependency in your `Package.swift` file:

```swift
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "MyWebsite",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyWebsite",
            dependencies: [
                .product(name: "WebUI", package: "web-ui")
            ],
            path: "Sources",
            resources: [.process("Public")] // Add your asset files here
        )
    ]
)
```

> You can also create a site as part of a monorepo project by removing the `path` from the target and creating the directory structure for your site as `Sources/TargetName/*`.

## Creating Your First Page

To create a basic web page with WebUI, you need three key components:

1. **Metadata**: Information about the page like title and description
2. **Content**: The actual HTML elements and text for the page
3. **Document**: The container that brings metadata and content together

Here's a simple example:

```swift
import WebUI

let homePage = Document(
    path: "index",
    metadata: Metadata(
        title: "My First Page",
        description: "A simple page built with WebUI"
    ),
    content: {
        Header {
            Heading(.largeTitle) { "Welcome to My Website" }
        }

        Main {
            Text { "This is my first page built with WebUI. It's so easy!" }

            Link(to: "https://github.com") { "Visit GitHub" }
        }

        Footer {
            Text { "© 2025 My Website" }
        }
    }
)
```

## Building a Complete Website

To create a complete website with multiple pages, you'll use the ``Website`` struct, the ``Metadata`` here is applied to all pages:

```swift
import WebUI

let website = Website(
    metadata: Metadata(
        site: "My Website",
        description: "A website built with WebUI"
    ),
    routes: [
        homePage,
        aboutPage,
        contactPage
    ]
)

// Build the static site
try website.build(to: URL(filePath: ".output")) // `.output` is the default value
```

## Styling Elements

WebUI provides a SwiftUI like modifier API for styling your elements:

```swift
Button(type: .submit) { "Submit" }
    .background(color: .blue(.500))
    .font(color: .white)
    .padding(of: 4, at: .all)
    .rounded(.md)
    .font(weight: .semibold)
```


Button(type: .submit) { "Submit" }
    .background(color: .blue(.500))
