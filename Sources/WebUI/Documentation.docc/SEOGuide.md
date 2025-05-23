# SEO and Metadata in WebUI

Learn how to optimize your WebUI websites for search engines and social sharing.

## Overview

WebUI provides comprehensive SEO tools including:
- Metadata management
- Structured data (Schema.org)
- Automatic sitemap generation
- Robots.txt configuration
- Social media optimization

## Basic Metadata

```swift
let metadata = Metadata(
    site: "My Website",
    title: "Welcome",
    titleSeperator: " | ",
    description: "A fantastic website built with WebUI",
    date: Date(),
    image: "/images/og.jpg",
    author: "Jane Doe",
    keywords: ["swift", "web", "static site"],
    twitter: "twitterhandle",
    locale: .en,
    type: .website
)
```

### Available Locales

WebUI supports numerous locales including:
- European: `.en`, `.es`, `.fr`, `.de`, `.it`, `.nl`
- Asian: `.ja`, `.zhCN`, `.zhTW`, `.ko`
- Middle Eastern: `.ar`, `.he`, `.tr`
- And many more

### Content Types

Available content types:
- `.website`
- `.article`
- `.video`
- `.profile`

## Structured Data

WebUI supports various Schema.org structured data types:

### Article Schema

```swift
let articleData = StructuredData.article(
    headline: "My Article",
    image: "https://example.com/image.jpg",
    author: "Jane Doe",
    publisher: "My Publication",
    datePublished: Date(),
    description: "An interesting article"
)
```

### Product Schema

```swift
let productData = StructuredData.product(
    name: "Amazing Product",
    image: "https://example.com/product.jpg",
    description: "Best product ever",
    sku: "PROD-123",
    brand: "My Brand",
    offers: [
        "price": "99.99",
        "priceCurrency": "USD",
        "availability": "InStock"
    ]
)
```

### Person Schema

```swift
let personData = StructuredData.person(
    name: "Jane Doe",
    givenName: "Jane",
    familyName: "Doe",
    image: "https://example.com/jane.jpg",
    jobTitle: "Software Engineer",
    email: "jane@example.com",
    telephone: "+1-555-123-4567",
    url: "https://janedoe.example.com",
    address: [
        "streetAddress": "123 Main St",
        "addressLocality": "Anytown",
        "postalCode": "12345",
        "addressCountry": "US"
    ]
)
```

## Sitemap Generation

Configure sitemap generation with custom entries:

```swift
let app = Website(
    routes: [/* your routes */],
    baseURL: "https://example.com",
    sitemapEntries: [
        SitemapEntry(
            url: "https://example.com/custom",
            lastModified: Date(),
            changeFrequency: .monthly,
            priority: 0.8
        )
    ]
)
```

## Robots.txt Configuration

Customize your robots.txt file:

```swift
let app = Website(
    routes: [/* your routes */],
    baseURL: "https://example.com",
    robotsRules: [
        RobotsRule(
            userAgent: "*",
            disallow: ["/private/", "/admin/"],
            allow: ["/public/"],
            crawlDelay: 10
        ),
        RobotsRule(
            userAgent: "Googlebot",
            disallow: ["/nogoogle/"]
        )
    ]
)
```

## Favicon Support

Add comprehensive favicon support with dark mode:

```swift
let metadata = Metadata(
    // ... other metadata ...
    favicons: [
        Favicon("/favicon-32.png", dark: "/favicon-dark-32.png", size: "32x32"),
        Favicon("/favicon-16.png", size: "16x16"),
        Favicon("/favicon.ico", type: "image/x-icon")
    ]
)
```

## Topics

### Basics

- ``Metadata``
- ``MetadataComponents``
- ``MetadataTypes``

### Structured Data

- ``StructuredData``
- ``ArticleSchema``
- ``ProductSchema``
- ``PersonSchema``

### SEO Tools

- ``SitemapEntry``
- ``RobotsRule``
- ``Favicon``
