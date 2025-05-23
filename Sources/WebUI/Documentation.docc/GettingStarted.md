# Getting Started with WebUI

Learn how to create static websites using WebUI's type-safe Swift API.

## Overview

WebUI is a static site generator that leverages Swift's type system to create maintainable and SEO-friendly websites. This guide will help you get started with WebUI.

## Installation

Add WebUI to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0")
]
```

## Basic Example

Here's a simple website with two pages:

```swift
import WebUI

// Create a basic website with an index page
let app = Website(
    routes: [
        Document(
            path: "index",
            metadata: .init(
                title: "Home",
                description: "Welcome to my website"
            )
        ) {
            Header {
                Text { "Logo" }
                Navigation {
                    Link(to: "about") { "About" }
                }
            }
            Main {
                Stack {
                    Heading(.largeTitle) { "Welcome" }
                    Text { "Built with WebUI" }
                }
            }
        },
        Document(
            path: "about",
            metadata: .init(
                title: "About",
                description: "Learn more about us"
            )
        ) {
            Article {
                Heading(.title) { "About Us" }
                Text { "Our story begins here..." }
            }
        }
    ]
)

// Build the website to the output directory
try app.build(to: URL(fileURLWithPath: ".build"))
```

## Adding SEO Features

WebUI provides comprehensive SEO support:

```swift
let app = Website(
    routes: [/* your routes */],
    baseURL: "https://example.com",
    // Generate sitemap.xml
    sitemapEntries: [
        SitemapEntry(
            url: "https://example.com/custom",
            lastModified: Date(),
            changeFrequency: .monthly,
            priority: 0.8
        )
    ],
    // Configure robots.txt
    robotsRules: [
        RobotsRule(
            userAgent: "*",
            disallow: ["/private/"],
            allow: ["/public/"],
            crawlDelay: 10
        )
    ]
)
```

## Metadata and Favicons

Add rich metadata and favicon support:

```swift
Document(
    path: "index",
    metadata: Metadata(
        site: "My Site",
        title: "Welcome",
        description: "A beautiful website built with WebUI",
        image: "/images/og.jpg",
        author: "Jane Doe",
        keywords: ["swift", "web", "ui"],
        twitter: "@handle",
        locale: .en,
        type: .website,
        favicons: [
            Favicon("/favicon-32.png", dark: "/favicon-dark-32.png", size: "32x32"),
            Favicon("/favicon.ico", type: "image/x-icon")
        ]
    )
) {
    // Your content here
}
```

## Topics

### Basics

- <doc:CoreConcepts>
- <doc:StylingGuide>

### Advanced Features

- <doc:SEOGuide>
- <doc:CustomElements>
