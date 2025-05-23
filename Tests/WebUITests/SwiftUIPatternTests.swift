import Foundation
import Testing

@testable import WebUI

// MARK: - Test Models

// Test Element
struct Card: Element {
    var title: String
    var content: String
    
    var body: some HTML {
        Stack {
            Heading(.title) { title }
            Text { content }
        }
        .padding()
        .border(of: 1, color: .gray(._300))
        .rounded(.md)
    }
}

// Test Document
struct HomePage: Document {
    var metadata: Metadata {
        Metadata(title: "Home", description: "Welcome to our site")
    }
    
    var body: some HTML {
        Stack {
            Heading(.largeTitle) { "Welcome" }
            Card(title: "Hello, World", content: "This is a SwiftUI-like pattern")
            Button(type: .button) { "Click Me" }
                .padding()
                .background(color: .blue(._500))
                .font(color: .white)
                .rounded(.md)
        }
        .padding()
    }
}

struct AboutPage: Document {
    var metadata: Metadata {
        Metadata(title: "About", description: "About our website")
    }
    
    var path: String? { "about-us" }
    
    var body: some HTML {
        Article {
            Heading(.largeTitle) { "About Us" }
            Text { "We're a great company" }
        }
        .padding()
    }
}

// Test Website
struct TestPortfolio: Website {
    var metadata: Metadata {
        Metadata(
            site: "Test Portfolio",
            title: "My Portfolio",
            description: "A showcase of my work"
        )
    }
    
    var routes {
        HomePage()
        AboutPage()
    }
}

// MARK: - SwiftUI Pattern Tests

@Suite("SwiftUI Pattern Tests")
struct SwiftUIPatternTests {
    
    @Test("Element pattern works correctly")
    func testElementPattern() {
        let card = Card(title: "Test Title", content: "Test Content")
        let html = card.render()
        
        #expect(html.contains("Test Title"))
        #expect(html.contains("Test Content"))
        #expect(html.contains("<h2>Test Title</h2>"))
        #expect(html.contains("<div class="))
        #expect(html.contains("padding"))
        #expect(html.contains("border"))
        #expect(html.contains("rounded"))
    }
    
    @Test("Document pattern works correctly")
    func testDocumentPattern() {
        let home = HomePage()
        let doc = home.document()
        let html = doc.render()
        
        #expect(html.contains("<!DOCTYPE html>"))
        #expect(html.contains("<title>Home</title>"))
        #expect(html.contains("<meta name=\"description\" content=\"Welcome to our site\">"))
        #expect(html.contains("<h1>Welcome</h1>"))
        #expect(html.contains("<h2>Hello, World</h2>"))
        #expect(html.contains("This is a SwiftUI-like pattern"))
        #expect(html.contains("<button type=\"button\""))
        #expect(html.contains("Click Me"))
    }
    
    @Test("Document custom path works")
    func testDocumentCustomPath() {
        let about = AboutPage()
        #expect(about.path == "about-us")
        
        let doc = about.document()
        #expect(doc.path == "about-us")
    }
    
    @Test("Website pattern works correctly")
    func testWebsitePattern() {
        let portfolio = TestPortfolio()
        
        #expect(portfolio.metadata.site == "Test Portfolio")
        #expect(portfolio.metadata.title == "My Portfolio")
        #expect(portfolio.routes.count == 2)
        
        // Test that routes are the expected types
        #expect(portfolio.routes[0] is HomePage)
        #expect(portfolio.routes[1] is AboutPage)
        
        // Test path resolution
        let documents = portfolio.routes.map { $0.document() }
        let paths = documents.compactMap { $0.path }
        
        #expect(paths.contains("home"))
        #expect(paths.contains("about-us"))
    }
    
    @Test("Nested elements render correctly")
    func testNestedElements() {
        struct ProfileCard: Element {
            var name: String
            var role: String
            var image: String
            
            var body: some HTML {
                Stack {
                    Image(src: image, alt: name)
                    Heading(.title) { name }
                    Text { role }
                }
                .padding()
                .border()
                .rounded(.md)
            }
        }
        
        struct TeamSection: Element {
            var members: [(name: String, role: String, image: String)]
            
            var body: some HTML {
                Section {
                    Heading(.headline) { "Our Team" }
                    Stack {
                        for member in members {
                            ProfileCard(
                                name: member.name,
                                role: member.role,
                                image: member.image
                            )
                        }
                    }
                    .spacing(of: 4)
                }
                .padding()
            }
        }
        
        // Test nested components
        let team = TeamSection(members: [
            (name: "John Doe", role: "CEO", image: "/john.jpg"),
            (name: "Jane Smith", role: "CTO", image: "/jane.jpg")
        ])
        
        let html = team.render()
        
        #expect(html.contains("<h3>Our Team</h3>"))
        #expect(html.contains("<h2>John Doe</h2>"))
        #expect(html.contains("<h2>Jane Smith</h2>"))
        #expect(html.contains("<span>CEO</span>"))
        #expect(html.contains("<span>CTO</span>"))
        #expect(html.contains("<img src=\"/john.jpg\" alt=\"John Doe\">"))
        #expect(html.contains("<img src=\"/jane.jpg\" alt=\"Jane Smith\">"))
        #expect(html.contains("space-"))
    }
    
    @Test("Complete website pattern works")
    func testCompleteWebsitePattern() {
        struct MainLayout: Element {
            var content: () -> [any HTML]
            
            init(@HTMLBuilder content: @escaping () -> [any HTML]) {
                self.content = content
            }
            
            var body: some HTML {
                Stack {
                    Header {
                        Heading(.largeTitle) { "My Website" }
                        Navigation {
                            Link(to: "/") { "Home" }
                            Link(to: "/about-us") { "About" }
                        }
                    }
                    Main {
                        content()
                    }
                    Footer {
                        Text { "© 2024 My Company" }
                    }
                }
            }
        }
        
        struct CompleteHome: Document {
            var metadata: Metadata {
                Metadata(title: "Home", description: "Welcome to our website")
            }
            
            var body: some HTML {
                MainLayout {
                    Heading(.headline) { "Welcome to our site" }
                    Text { "This is a complete website example using SwiftUI pattern" }
                    Card(
                        title: "Featured Content",
                        content: "This is our featured content"
                    )
                }
            }
        }
        
        struct CompleteAbout: Document {
            var metadata: Metadata {
                Metadata(title: "About", description: "About our company")
            }
            
            var path: String? { "about-us" }
            
            var body: some HTML {
                MainLayout {
                    Heading(.headline) { "About Us" }
                    Text { "We are a company that specializes in..." }
                }
            }
        }
        
        struct CompleteWebsite: Website {
            var metadata: Metadata {
                Metadata(
                    site: "Complete Website",
                    title: "My Complete Website",
                    description: "A complete website example"
                )
            }
            
            var routes {
                CompleteHome()
                CompleteAbout()
            }
        }
        
        let website = CompleteWebsite()
        let home = website.routes[0] as! CompleteHome
        let about = website.routes[1] as! CompleteAbout
        
        let homeDoc = home.document()
        let aboutDoc = about.document()
        
        let homeHtml = homeDoc.render()
        let aboutHtml = aboutDoc.render()
        
        // Test home page
        #expect(homeHtml.contains("<title>Home"))
        #expect(homeHtml.contains("<header>"))
        #expect(homeHtml.contains("<h1>My Website</h1>"))
        #expect(homeHtml.contains("<nav>"))
        #expect(homeHtml.contains("<a href=\"/\">Home</a>"))
        #expect(homeHtml.contains("<main>"))
        #expect(homeHtml.contains("<h3>Welcome to our site</h3>"))
        #expect(homeHtml.contains("This is a complete website example"))
        #expect(homeHtml.contains("<h2>Featured Content</h2>"))
        #expect(homeHtml.contains("This is our featured content"))
        #expect(homeHtml.contains("<footer>"))
        #expect(homeHtml.contains("© 2024 My Company"))
        
        // Test about page
        #expect(aboutHtml.contains("<title>About"))
        #expect(aboutHtml.contains("<h3>About Us</h3>"))
        #expect(aboutHtml.contains("We are a company that specializes in..."))
    }
    
    @Test("Multiple levels of nesting works correctly")
    func testMultipleLevelsOfNesting() {
        struct IconButton: Element {
            var text: String
            var icon: String
            
            var body: some HTML {
                Button(type: .button) {
                    Stack {
                        Image(src: icon, alt: "")
                        Text { text }
                    }
                    .flex(align: .center)
                    .spacing(of: 2)
                }
                .padding()
                .background(color: .blue(._500))
                .font(color: .white)
                .rounded(.md)
            }
        }
        
        struct FeatureCard: Element {
            var title: String
            var description: String
            var buttonText: String
            
            var body: some HTML {
                Stack {
                    Heading(.title) { title }
                    Text { description }
                    IconButton(text: buttonText, icon: "/icons/arrow.svg")
                }
                .padding()
                .border()
                .rounded(.lg)
                .shadow()
            }
        }
        
        struct FeatureSection: Element {
            var features: [(title: String, description: String, buttonText: String)]
            
            var body: some HTML {
                Section {
                    Heading(.headline) { "Our Features" }
                    Stack {
                        for feature in features {
                            FeatureCard(
                                title: feature.title,
                                description: feature.description,
                                buttonText: feature.buttonText
                            )
                        }
                    }
                    .grid(columns: 3, gap: 4)
                }
                .padding()
                .background(color: .gray(._100))
            }
        }
        
        // Test multiple levels of nesting
        let features = FeatureSection(features: [
            (title: "Feature 1", description: "Description 1", buttonText: "Learn More"),
            (title: "Feature 2", description: "Description 2", buttonText: "Get Started")
        ])
        
        let html = features.render()
        
        #expect(html.contains("<section"))
        #expect(html.contains("<h3>Our Features</h3>"))
        #expect(html.contains("<h2>Feature 1</h2>"))
        #expect(html.contains("<h2>Feature 2</h2>"))
        #expect(html.contains("Description 1"))
        #expect(html.contains("Description 2"))
        #expect(html.contains("<button type=\"button\""))
        #expect(html.contains("<img src=\"/icons/arrow.svg\""))
        #expect(html.contains("Learn More"))
        #expect(html.contains("Get Started"))
        #expect(html.contains("grid-cols-3"))
        #expect(html.contains("gap-4"))
        #expect(html.contains("bg-gray-100"))
    }
}