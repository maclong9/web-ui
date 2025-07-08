import Foundation
import Testing

@testable import WebUI

@Suite("Website Build System Tests")
struct WebsiteBuildSystemTests {
    
    // MARK: - Test Data Setup
    
    struct TestWebsite: Website {
        var metadata: Metadata {
            Metadata(
                site: "Test Site",
                title: "Test Website",
                description: "A test website for build system validation"
            )
        }
        
        @WebsiteRouteBuilder
        var routes: [any Document] {
            HomePage()
            AboutPage()
            ContactPage()
        }
        
        var baseWebAddress: String? { "https://example.com" }
    }
    
    struct HomePage: Document {
        var path: String? { "index" }
        
        var metadata: Metadata {
            Metadata(
                site: "Test Site",
                title: "Home - Test Website",
                description: "Welcome to our test website"
            )
        }
        
        var body: some Markup {
            BodyWrapper {
                Heading(.title, "Welcome Home")
                Text("This is the home page content")
            }
        }
    }
    
    struct AboutPage: Document {
        var path: String? { "about" }
        
        var metadata: Metadata {
            Metadata(
                site: "Test Site", 
                title: "About - Test Website",
                description: "Learn more about us"
            )
        }
        
        var body: some Markup {
            BodyWrapper {
                Heading(.title, "About Us")
                Text("This is the about page content")
            }
        }
    }
    
    struct ContactPage: Document {
        var path: String? { "contact" }
        
        var metadata: Metadata {
            Metadata(
                site: "Test Site",
                title: "Contact - Test Website", 
                description: "Get in touch with us"
            )
        }
        
        var body: some Markup {
            BodyWrapper {
                Heading(.title, "Contact Us")
                Text("This is the contact page content")
            }
        }
    }
    
    // MARK: - Build Directory and File Creation Tests
    
    @Test("Website build creates correct directory structure")
    func websiteBuildDirectoryStructure() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        // Build the website
        try website.build(to: tempDir)
        
        // Verify main directory exists
        #expect(FileManager.default.fileExists(atPath: tempDir.path()))
        
        // Verify HTML files are created for each route
        let indexPath = tempDir.appendingPathComponent("index.html")
        let aboutPath = tempDir.appendingPathComponent("about.html")
        let contactPath = tempDir.appendingPathComponent("contact.html")
        
        #expect(FileManager.default.fileExists(atPath: indexPath.path()))
        #expect(FileManager.default.fileExists(atPath: aboutPath.path()))
        #expect(FileManager.default.fileExists(atPath: contactPath.path()))
        
        // Verify sitemap.xml is created
        let sitemapPath = tempDir.appendingPathComponent("sitemap.xml")
        #expect(FileManager.default.fileExists(atPath: sitemapPath.path()))
        
        // Verify robots.txt is created
        let robotsPath = tempDir.appendingPathComponent("robots.txt")
        #expect(FileManager.default.fileExists(atPath: robotsPath.path()))
    }
    
    @Test("Website build creates valid HTML files")
    func websiteBuildValidHTMLFiles() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-html-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        // Read and validate index.html
        let indexPath = tempDir.appendingPathComponent("index.html")
        let indexContent = try String(contentsOf: indexPath, encoding: .utf8)
        
        #expect(indexContent.contains("<!DOCTYPE html>"))
        #expect(indexContent.contains("<html"))
        #expect(indexContent.contains("<head>"))
        #expect(indexContent.contains("<title>Home - Test Website Test Site</title>"))
        #expect(indexContent.contains("<meta name=\"description\" content=\"Welcome to our test website\">"))
        #expect(indexContent.contains("<body>"))
        #expect(indexContent.contains("Welcome Home"))
        #expect(indexContent.contains("This is the home page content"))
        #expect(indexContent.contains("</body>"))
        #expect(indexContent.contains("</html>"))
        
        // Read and validate about.html
        let aboutPath = tempDir.appendingPathComponent("about.html")
        let aboutContent = try String(contentsOf: aboutPath, encoding: .utf8)
        
        #expect(aboutContent.contains("<title>About - Test Website Test Site</title>"))
        #expect(aboutContent.contains("About Us"))
        #expect(aboutContent.contains("This is the about page content"))
        
        // Read and validate contact.html
        let contactPath = tempDir.appendingPathComponent("contact.html")
        let contactContent = try String(contentsOf: contactPath, encoding: .utf8)
        
        #expect(contactContent.contains("<title>Contact - Test Website Test Site</title>"))
        #expect(contactContent.contains("Contact Us"))
        #expect(contactContent.contains("This is the contact page content"))
    }
    
    @Test("Website build creates valid sitemap.xml")
    func websiteBuildValidSitemap() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-sitemap-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        let sitemapPath = tempDir.appendingPathComponent("sitemap.xml")
        let sitemapContent = try String(contentsOf: sitemapPath, encoding: .utf8)
        
        // Verify XML structure
        #expect(sitemapContent.contains("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
        #expect(sitemapContent.contains("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"))
        #expect(sitemapContent.contains("</urlset>"))
        
        // Verify URLs are included
        #expect(sitemapContent.contains("<loc>https://example.com/index.html</loc>"))
        #expect(sitemapContent.contains("<loc>https://example.com/about.html</loc>"))
        #expect(sitemapContent.contains("<loc>https://example.com/contact.html</loc>"))
        
        // Verify URL elements
        #expect(sitemapContent.contains("<url>"))
        #expect(sitemapContent.contains("</url>"))
        #expect(sitemapContent.contains("<changefreq>"))
        #expect(sitemapContent.contains("<priority>"))
    }
    
    @Test("Website build creates valid robots.txt")
    func websiteBuildValidRobotsTxt() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-robots-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        let robotsPath = tempDir.appendingPathComponent("robots.txt")
        let robotsContent = try String(contentsOf: robotsPath, encoding: .utf8)
        
        // Verify robots.txt structure
        #expect(robotsContent.contains("User-agent: *"))
        #expect(robotsContent.contains("Allow: /"))
        #expect(robotsContent.contains("Sitemap: https://example.com/sitemap.xml"))
    }
    
    @Test("Website build handles assets directory copying")
    func websiteBuildAssetsDirectoryCopying() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-assets-test-\(UUID().uuidString)")
        let assetsDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-assets-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
            try? FileManager.default.removeItem(at: assetsDir)
        }
        
        // Create temporary assets directory with test files
        try FileManager.default.createDirectory(at: assetsDir, withIntermediateDirectories: true)
        
        let cssFile = assetsDir.appendingPathComponent("styles.css")
        let jsFile = assetsDir.appendingPathComponent("scripts.js")
        let imageFile = assetsDir.appendingPathComponent("logo.png")
        
        try "body { margin: 0; }".write(to: cssFile, atomically: true, encoding: .utf8)
        try "console.log('Hello');".write(to: jsFile, atomically: true, encoding: .utf8)
        try Data([0x89, 0x50, 0x4E, 0x47]).write(to: imageFile) // PNG header
        
        // Build with custom assets path
        try website.build(to: tempDir, assetsPath: assetsDir.path())
        
        // Verify assets were copied to public directory
        let publicDir = tempDir.appendingPathComponent("public")
        #expect(FileManager.default.fileExists(atPath: publicDir.path()))
        
        let copiedCss = publicDir.appendingPathComponent("styles.css")
        let copiedJs = publicDir.appendingPathComponent("scripts.js")
        let copiedImage = publicDir.appendingPathComponent("logo.png")
        
        #expect(FileManager.default.fileExists(atPath: copiedCss.path()))
        #expect(FileManager.default.fileExists(atPath: copiedJs.path()))
        #expect(FileManager.default.fileExists(atPath: copiedImage.path()))
        
        // Verify file contents were preserved
        let copiedCssContent = try String(contentsOf: copiedCss, encoding: .utf8)
        #expect(copiedCssContent == "body { margin: 0; }")
    }
    
    @Test("Website build cleans previous output directory")
    func websiteBuildCleansOutputDirectory() throws {
        let website = TestWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-clean-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        // Create directory with existing content
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let oldFile = tempDir.appendingPathComponent("old-file.txt")
        try "old content".write(to: oldFile, atomically: true, encoding: .utf8)
        
        #expect(FileManager.default.fileExists(atPath: oldFile.path()))
        
        // Build website (should clean and recreate)
        try website.build(to: tempDir)
        
        // Verify old file is gone and new files exist
        #expect(!FileManager.default.fileExists(atPath: oldFile.path()))
        #expect(FileManager.default.fileExists(atPath: tempDir.appendingPathComponent("index.html").path()))
    }
    
    @Test("Website build handles nested route paths")
    func websiteBuildNestedRoutePaths() throws {
        struct NestedWebsite: Website {
            var metadata: Metadata {
                Metadata(site: "Nested Test", title: "Nested Routes")
            }
            
            @WebsiteRouteBuilder
            var routes: [any Document] {
                NestedPage()
                DeeplyNestedPage()
            }
        }
        
        struct NestedPage: Document {
            var path: String? { "blog/first-post" }
            var metadata: Metadata {
                Metadata(site: "Test", title: "First Post")
            }
            var body: some Markup {
                BodyWrapper {
                    Text("Blog post content")
                }
            }
        }
        
        struct DeeplyNestedPage: Document {
            var path: String? { "docs/api/v1/getting-started" }
            var metadata: Metadata {
                Metadata(site: "Test", title: "API Docs")
            }
            var body: some Markup {
                BodyWrapper {
                    Text("API documentation")
                }
            }
        }
        
        let website = NestedWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-nested-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        // Verify nested directories are created
        let blogDir = tempDir.appendingPathComponent("blog")
        let docsApiDir = tempDir.appendingPathComponent("docs/api/v1")
        
        #expect(FileManager.default.fileExists(atPath: blogDir.path()))
        #expect(FileManager.default.fileExists(atPath: docsApiDir.path()))
        
        // Verify nested files exist
        let blogPost = blogDir.appendingPathComponent("first-post.html")
        let apiDocs = docsApiDir.appendingPathComponent("getting-started.html")
        
        #expect(FileManager.default.fileExists(atPath: blogPost.path()))
        #expect(FileManager.default.fileExists(atPath: apiDocs.path()))
        
        // Verify content
        let blogContent = try String(contentsOf: blogPost, encoding: .utf8)
        let apiContent = try String(contentsOf: apiDocs, encoding: .utf8)
        
        #expect(blogContent.contains("Blog post content"))
        #expect(apiContent.contains("API documentation"))
    }
    
    @Test("Website build handles error conditions gracefully")
    func websiteBuildErrorHandling() throws {
        struct ErrorWebsite: Website {
            var metadata: Metadata {
                Metadata(site: "Error Test", title: "Error Website")
            }
            
            var routes: [any Document] {
                get throws {
                    throw TestError.simulatedError
                }
            }
        }
        
        enum TestError: Error {
            case simulatedError
        }
        
        let website = ErrorWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-error-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        // Verify that route construction errors are propagated
        #expect(throws: TestError.self) {
            try website.build(to: tempDir)
        }
    }
    
    @Test("Website build skips sitemap and robots when no base URL")
    func websiteBuildSkipsFilesWithoutBaseURL() throws {
        struct NoBaseURLWebsite: Website {
            var metadata: Metadata {
                Metadata(site: "No Base URL", title: "Test")
            }
            
            @WebsiteRouteBuilder
            var routes: [any Document] {
                HomePage()
            }
            
            var baseWebAddress: String? { nil }
        }
        
        let website = NoBaseURLWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-no-base-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        // Verify HTML files are created
        #expect(FileManager.default.fileExists(atPath: tempDir.appendingPathComponent("index.html").path()))
        
        // Verify sitemap and robots.txt are NOT created
        #expect(!FileManager.default.fileExists(atPath: tempDir.appendingPathComponent("sitemap.xml").path()))
        #expect(!FileManager.default.fileExists(atPath: tempDir.appendingPathComponent("robots.txt").path()))
    }
    
    @Test("Website build includes custom sitemap entries")
    func websiteBuildCustomSitemapEntries() throws {
        struct CustomSitemapWebsite: Website {
            var metadata: Metadata {
                Metadata(site: "Custom Sitemap", title: "Test")
            }
            
            @WebsiteRouteBuilder
            var routes: [any Document] {
                HomePage()
            }
            
            var baseWebAddress: String? { "https://custom.com" }
            
            var sitemapEntries: [SitemapEntry]? {
                [
                    SitemapEntry(
                        url: "https://custom.com/special-page.html",
                        lastModified: Date(timeIntervalSince1970: 1640995200), // 2022-01-01
                        changeFrequency: .weekly,
                        priority: 0.8
                    )
                ]
            }
        }
        
        let website = CustomSitemapWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-custom-sitemap-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        let sitemapPath = tempDir.appendingPathComponent("sitemap.xml")
        let sitemapContent = try String(contentsOf: sitemapPath, encoding: .utf8)
        
        // Verify custom entry is included
        #expect(sitemapContent.contains("https://custom.com/special-page.html"))
        #expect(sitemapContent.contains("<changefreq>weekly</changefreq>"))
        #expect(sitemapContent.contains("<priority>0.8</priority>"))
        
        // Verify route-based entries are also included
        #expect(sitemapContent.contains("https://custom.com/index.html"))
    }
    
    @Test("Website build handles custom robots rules")
    func websiteBuildCustomRobotsRules() throws {
        struct CustomRobotsWebsite: Website {
            var metadata: Metadata {
                Metadata(site: "Custom Robots", title: "Test")
            }
            
            @WebsiteRouteBuilder
            var routes: [any Document] {
                HomePage()
            }
            
            var baseWebAddress: String? { "https://robots.com" }
            
            var robotsRules: [RobotsRule]? {
                [
                    RobotsRule(userAgent: "Googlebot", disallow: ["/admin"]),
                    RobotsRule(userAgent: "*", allow: ["/public"])
                ]
            }
        }
        
        let website = CustomRobotsWebsite()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("build-custom-robots-test-\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try website.build(to: tempDir)
        
        let robotsPath = tempDir.appendingPathComponent("robots.txt")
        let robotsContent = try String(contentsOf: robotsPath, encoding: .utf8)
        
        // Verify custom rules are included
        #expect(robotsContent.contains("User-agent: Googlebot"))
        #expect(robotsContent.contains("Disallow: /admin"))
        #expect(robotsContent.contains("Allow: /public"))
        
        // Verify sitemap reference is included
        #expect(robotsContent.contains("Sitemap: https://robots.com/sitemap.xml"))
    }
}