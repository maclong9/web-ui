# ``WebUI``

A Swift framework for building static websites with a type-safe, declarative syntax.

## Overview

WebUI enables you to build static websites using Swift with a powerful, type-safe API that generates clean HTML. It provides built-in support for:

- SEO optimization with metadata and structured data
- Responsive design with type-safe styling
- Component-based architecture
- Built-in sitemap and robots.txt generation
- Theme customization
- Favicons and metadata handling

## Basic Usage

```swift
let app = Website(
    routes: [
        Document(
            path: "index",
            metadata: .init(
                title: "Hello",
                description: "Welcome to my site"
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
        }
    ]
)

try app.build(to: URL(fileURLWithPath: "build"))
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:CoreConcepts>

### Website Structure

- ``Document``
- ``Website``
- ``Theme``

### Metadata and SEO

- ``Metadata``
- ``StructuredData``
- ``SitemapEntry``
- ``RobotsRule``

### Styling

- <doc:StylingGuide>
- ``Style``
- <doc:ResponsiveDesign>

### Advanced Topics

- <doc:CustomElements>
- ``HTML``
- ``Children``
