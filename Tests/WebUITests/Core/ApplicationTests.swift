import Foundation
import Logging
import Testing

@testable import WebUI

@Suite("Application Tests") struct ApplicationTests {
    @Test("Creates the build directory and populates correctly")
    func createsAndPopulatesBuildDirectory() throws {
        let app = Website(
            routes: [
                Document(
                    path: "index",
                    metadata: .init(title: "Hello", description: "Some cool description")
                ) {
                    Header {
                        Text { "Logo" }
                        Navigation {
                            Link(to: "home") { "Home" }
                            Link(to: "about") { "About" }
                            Link(to: "https://example.com", newTab: true) { "Other" }
                        }
                    }
                    Main {
                        Stack {
                            Heading(.largeTitle) { "Tagline" }
                            Text { "Lorem ipsum dolor sit amet." }
                        }
                    }
                    Footer {
                        Text { "Logo" }
                    }
                },
                Document(
                    path: "about",
                    metadata: .init(title: "About", description: "Learn more here")
                ) {
                    Article {
                        Heading(.title) { "Article Heading" }
                        Text { "Lorem ipsum dolor sit amet." }
                    }
                },
            ]
        )

        try app.build(to: URL(fileURLWithPath: ".build"))
        #expect(FileManager.default.fileExists(atPath: ".build/index.html"))
        #expect(FileManager.default.fileExists(atPath: ".build/about.html"))
        #expect(
            try String(
                contentsOfFile: ".build/index.html",
                encoding: .utf8
            ).contains(
                """
                <header><span>Logo</span><nav><a href="home">Home</a><a href="about">About</a><a href="https://example.com" target="_blank" rel="noreferrer">Other</a></nav></header><main><div><h1>Tagline</h1><span>Lorem ipsum dolor sit amet.</span></div></main><footer><span>Logo</span></footer>
                """
            )
        )
        #expect(
            try String(
                contentsOfFile: ".build/about.html",
                encoding: .utf8
            ).contains(
                "<article><h2>Article Heading</h2><span>Lorem ipsum dolor sit amet.</span></article>"
            )
        )
    }

    @Test("Generates sitemap.xml correctly")
    func generatesSitemapCorrectly() throws {
        let testDate = Date()

        let app = Website(
            routes: [
                Document(
                    path: "index",
                    metadata: .init(title: "Home", description: "Home page", date: testDate)
                ) {
                    Text { "Home page" }
                },
                Document(
                    path: "about",
                    metadata: .init(title: "About", description: "About page")
                ) {
                    Text { "About page" }
                },
                Document(
                    path: "blog/post1",
                    metadata: .init(title: "Post 1", description: "Blog post 1")
                ) {
                    Text { "Blog post 1" }
                },
            ],
            baseURL: "https://example.com",
            sitemapEntries: [
                SitemapEntry(
                    url: "https://example.com/custom",
                    lastModified: testDate,
                    changeFrequency: .monthly,
                    priority: 0.8
                )
            ]
        )

        try app.build(to: URL(fileURLWithPath: ".build-sitemap"))

        // Check sitemap.xml was created
        #expect(FileManager.default.fileExists(atPath: ".build-sitemap/sitemap.xml"))

        // Read sitemap content
        let sitemapContent = try String(contentsOfFile: ".build-sitemap/sitemap.xml", encoding: .utf8)

        // Check basic structure
        #expect(sitemapContent.contains("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
        #expect(sitemapContent.contains("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"))

        // Check home page (index) with date and highest priority
        #expect(sitemapContent.contains("<loc>https://example.com/</loc>"))
        #expect(sitemapContent.contains("<priority>1.0</priority>"))
        #expect(sitemapContent.contains("<changefreq>weekly</changefreq>"))

        // Check about page
        #expect(sitemapContent.contains("<loc>https://example.com/about.html</loc>"))

        // Check nested blog post
        #expect(sitemapContent.contains("<loc>https://example.com/blog/post1.html</loc>"))
        #expect(sitemapContent.contains("<changefreq>yearly</changefreq>"))

        // Check custom entry
        #expect(sitemapContent.contains("<loc>https://example.com/custom</loc>"))
        #expect(sitemapContent.contains("<changefreq>monthly</changefreq>"))
        #expect(sitemapContent.contains("<priority>0.8</priority>"))

        // Clean up
        try FileManager.default.removeItem(atPath: ".build-sitemap")
    }

    @Test("Generates robots.txt correctly")
    func generatesRobotsTxtCorrectly() throws {
        let app = Website(
            routes: [
                Document(
                    path: "index",
                    metadata: .init(title: "Home", description: "Home page")
                ) {
                    Text { "Home page" }
                }
            ],
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
                ),
            ]
        )

        try app.build(to: URL(fileURLWithPath: ".build-robots"))

        // Check robots.txt was created
        #expect(FileManager.default.fileExists(atPath: ".build-robots/robots.txt"))

        // Read robots.txt content
        let robotsContent = try String(contentsOfFile: ".build-robots/robots.txt", encoding: .utf8)

        // Check general rule
        #expect(robotsContent.contains("User-agent: *"))
        #expect(robotsContent.contains("Disallow: /private/"))
        #expect(robotsContent.contains("Disallow: /admin/"))
        #expect(robotsContent.contains("Allow: /public/"))
        #expect(robotsContent.contains("Crawl-delay: 10"))

        // Check Googlebot specific rule
        #expect(robotsContent.contains("User-agent: Googlebot"))
        #expect(robotsContent.contains("Disallow: /nogoogle/"))

        // Check sitemap reference
        #expect(robotsContent.contains("Sitemap: https://example.com/sitemap.xml"))

        // Test with default robots.txt (no custom rules)
        let defaultApp = Website(
            routes: [
                Document(
                    path: "index",
                    metadata: .init(title: "Home", description: "Home page")
                ) {
                    Text { "Home page" }
                }
            ],
            baseURL: "https://example.com"
        )

        try defaultApp.build(to: URL(fileURLWithPath: ".build-robots-default"))

        // Check default robots.txt was created
        #expect(FileManager.default.fileExists(atPath: ".build-robots-default/robots.txt"))

        // Read default robots.txt content
        let defaultRobotsContent = try String(contentsOfFile: ".build-robots-default/robots.txt", encoding: .utf8)

        // Check default content
        #expect(defaultRobotsContent.contains("User-agent: *"))
        #expect(defaultRobotsContent.contains("Allow: /"))

        // Clean up
        try FileManager.default.removeItem(atPath: ".build-robots")
        try FileManager.default.removeItem(atPath: ".build-robots-default")
    }
}
