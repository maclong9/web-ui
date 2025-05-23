import Foundation
import Logging
import Testing

@testable import WebUI

struct HomePage: Document {
    var path: String? { "index" }
    var metadata: Metadata {
        Metadata(title: "Hello", description: "Some cool description")
    }
    
    var body: some HTML {
        Stack {
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
        }
    }
}

struct AboutPage: Document {
    var path: String? { "about" }
    var metadata: Metadata {
        Metadata(title: "About", description: "Learn more here")
    }
    
    var body: some HTML {
        Article {
            Heading(.title) { "Article Heading" }
            Text { "Lorem ipsum dolor sit amet." }
        }
    }
}

struct SitemapHomePage: Document {
    let testDate: Date
    
    var path: String? { "index" }
    var metadata: Metadata {
        Metadata(title: "Home", description: "Home page", date: testDate)
    }
    
    var body: some HTML {
        Text { "Home page" }
    }
}

struct SitemapAboutPage: Document {
    var path: String? { "about" }
    var metadata: Metadata {
        Metadata(title: "About", description: "About page")
    }
    
    var body: some HTML {
        Text { "About page" }
    }
}

struct BlogPost1: Document {
    var path: String? { "blog/post1" }
    var metadata: Metadata {
        Metadata(title: "Post 1", description: "Blog post 1")
    }
    
    var body: some HTML {
        Text { "Blog post 1" }
    }
}

struct RobotsHomePage: Document {
    var path: String? { "index" }
    var metadata: Metadata {
        Metadata(title: "Home", description: "Home page")
    }
    
    var body: some HTML {
        Text { "Home page" }
    }
}

@Suite("Website Tests") struct WebsiteTests {
    @Test("Creates the build directory and populates correctly")
    func createsAndPopulatesBuildDirectory() throws {
        struct TestWebsite: Website {
            var metadata: Metadata {
                Metadata()
            }
            
            var routes {
                HomePage()
                AboutPage()
            }
        }
        
        let app = TestWebsite()

        try app.build()
        #expect(FileManager.default.fileExists(atPath: ".build/index.html"))
        #expect(FileManager.default.fileExists(atPath: ".build/about.html"))
        #expect(
            try String(
                contentsOfFile: ".output/index.html",
                encoding: .utf8
            ).contains(
                """
                <header><span>Logo</span><nav><a href="home">Home</a><a href="about">About</a><a href="https://example.com" target="_blank" rel="noreferrer">Other</a></nav></header><main><div><h1>Tagline</h1><span>Lorem ipsum dolor sit amet.</span></div></main><footer><span>Logo</span></footer>
                """
            )
        )
        #expect(
            try String(
                contentsOfFile: ".output/about.html",
                encoding: .utf8
            ).contains(
                "<article><h2>Article Heading</h2><span>Lorem ipsum dolor sit amet.</span></article>"
            )
        )
    }

    @Test("Generates sitemap.xml correctly")
    func generatesSitemapCorrectly() throws {
        let testDate = Date()

        struct TestSitemapWebsite: Website {
            let testDate: Date
            
            var metadata: Metadata {
                Metadata()
            }
            
            var baseURL: String? {
                "https://example.com"
            }
            
            var sitemapEntries: [SitemapEntry]? {
                [
                    SitemapEntry(
                        url: "https://example.com/custom",
                        lastModified: testDate,
                        changeFrequency: .monthly,
                        priority: 0.8
                    )
                ]
            }
            
            var routes {
                SitemapHomePage(testDate: testDate)
                SitemapAboutPage()
                BlogPost1()
            }
        }
        
        let app = TestSitemapWebsite(testDate: testDate)

        try app.build()

        // Check sitemap.xml was created
        #expect(FileManager.default.fileExists(atPath: ".output/sitemap.xml"))

        // Read sitemap content
        let sitemapContent = try String(contentsOfFile: ".output/sitemap.xml", encoding: .utf8)

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
    }

    @Test("Generates robots.txt correctly")
    func generatesRobotsTxtCorrectly() throws {
        struct TestRobotsWebsite: Website {
            var metadata: Metadata {
                Metadata()
            }
            
            var baseURL: String? {
                "https://example.com"
            }
            
            var robotsRules: [RobotsRule]? {
                [
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
            }
            
            var routes {
                RobotsHomePage()
            }
        }
        
        let app = TestRobotsWebsite()

        try app.build()

        // Check robots.txt was created
        #expect(FileManager.default.fileExists(atPath: ".output/robots.txt"))

        // Read robots.txt content
        let robotsContent = try String(contentsOfFile: ".output/robots.txt", encoding: .utf8)

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
        struct TestDefaultRobotsWebsite: Website {
            var metadata: Metadata {
                Metadata()
            }
            
            var baseURL: String? {
                "https://example.com"
            }
            
            var routes {
                RobotsHomePage()
            }
        }
        
        let defaultApp = TestDefaultRobotsWebsite()

        try defaultApp.build()

        // Check default robots.txt was created
        #expect(FileManager.default.fileExists(atPath: ".output/robots.txt"))

        // Read default robots.txt content
        let defaultRobotsContent = try String(contentsOfFile: ".output/robots.txt", encoding: .utf8)

        // Check default content
        #expect(defaultRobotsContent.contains("User-agent: *"))
        #expect(defaultRobotsContent.contains("Allow: /"))
    }
}