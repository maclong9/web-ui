# Core Concepts

Learn about the fundamental building blocks and architecture of WebUI.

## Overview

WebUI is built around several key concepts that work together to create static websites:

- Documents: The foundation of each page
- Elements: Type-safe HTML components
- Themes: Consistent styling across your site
- Metadata: SEO and social sharing optimization

## Documents

A Document represents a single page in your website. It handles:

- HTML structure
- Metadata and SEO
- Scripts and stylesheets
- Content organization

```swift
Document(
    path: "about",
    metadata: Metadata(
        title: "About Us",
        description: "Learn about our team"
    ),
    scripts: [
        Script(src: "/scripts/main.js", attribute: .defer)
    ],
    stylesheets: [
        "/styles/main.css"
    ],
    head: """
        <script>
          console.log('Custom head content');
        </script>
    """
) {
    Article {
        Heading(.title) { "About Us" }
        Text { "Our story..." }
    }
}
```

## Elements

Elements are the building blocks of your pages. WebUI provides type-safe wrappers around HTML elements:

```swift
Header {
    Text { "Logo" }
    Navigation {
        Link(to: "home") { "Home" }
        Link(to: "about") { "About" }
        Link(to: "https://example.com", newTab: true) { "External" }
    }
}

Main {
    Stack {
        Heading(.largeTitle) { "Welcome" }
        Text { "Main content here" }
    }
}
```

## Theme System

The Theme system allows you to define consistent design tokens:

```swift
let theme = Theme(
    colors: [
        "primary": "blue",
        "secondary": "#10b981"
    ],
    spacing: [
        "4": "1rem"
    ],
    textSizes: [
        "lg": "1.25rem"
    ],
    custom: [
        "opacity": ["faint": "0.1"]
    ]
)
```

Apply the theme to your website:

```swift
Website(
    routes: [/* your routes */],
    theme: theme
)
```

## Website Structure

The Website type is the main container that:

- Organizes your routes
- Handles build process
- Manages SEO features
- Configures global settings

```swift
let app = Website(
    routes: [/* your documents */],
    baseURL: "https://example.com",
    theme: theme,
    generateSitemap: true
)

try app.build(to: URL(fileURLWithPath: ".build"))
```

## Topics

### Essentials

- ``Document``
- ``Element``
- ``Website``

### Styling

- ``Theme``
- ``Style``

### Content

- ``HTML``
- ``Children``
- ``HTMLBuilder``
