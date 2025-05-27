import Foundation
import Testing

@testable import WebUI

// MARK: - Example Website with SwiftUI-like Pattern

// Reusable UI components
struct PageLayout: Element {
    var title: String
    var description: String
    var content: HTMLContentBuilder

    init(
        title: String, description: String,
        @HTMLBuilder content: @escaping HTMLContentBuilder
    ) {
        self.title = title
        self.description = description
        self.content = content
    }

    var body: some HTML {
        BodyWrapper {
            Header {
                Stack {
                    Heading(.largeTitle) { "My Portfolio" }
                    Navigation {
                        Link(to: "/") { "Home" }
                        Link(to: "/about") { "About" }
                        Link(to: "/projects") { "Projects" }
                        Link(to: "/contact") { "Contact" }
                    }
                    .flex()
                    .spacing(of: 4)
                }
                .flex(justify: .between, align: .center)
                .padding()
                .background(color: .gray(._800))
                .font(color: .white())
            }
            Main {
                Stack {
                    Section {
                        Heading(.title) { title }
                        Text { description }
                    }
                    .padding()
                    .margins(at: .bottom)

                    HTMLString(content: content().map { $0.render() }.joined())
                }
                .padding()
                .margins(at: .horizontal, auto: true)
                .frame(maxWidth: .container(.extraLarge))
            }
            Stack {
                "Placeholder content for testing responsive modifiers"
            }
            .background(color: .gray(._100))
            .padding(of: 4)

            Footer {
                Stack {
                    Text { "© 2024 My Portfolio. All rights reserved." }
                    Stack {
                        Link(to: "https://github.com", newTab: true) {
                            "GitHub"
                        }
                        Link(to: "https://linkedin.com", newTab: true) {
                            "LinkedIn"
                        }
                        Link(to: "https://twitter.com", newTab: true) {
                            "Twitter"
                        }
                    }
                    .flex()
                    .spacing(of: 4)
                }
                .flex(justify: .between, align: .center)
                .padding()
                .background(color: .gray(._800))
                .font(color: .white())
            }
        }
    }
}

struct ProjectCard: Element {
    var title: String
    var description: String
    var technologies: [String]
    var imageUrl: String
    var link: String

    var body: some HTML {
        Stack {
            Image(
                source: imageUrl, description: title,
                size: MediaSize(width: 400, height: 300)
            )
            .frame(width: .full)
            .aspectRatioVideo()
            .overflow(.hidden)

            Stack {
                Heading(.title) { title }
                Text { description }

                Stack {
                    for tech in technologies {
                        Stack {
                            Text { tech }
                        }
                        .padding(of: 2, at: .horizontal)
                        .padding(of: 1, at: .vertical)
                        .background(color: .blue(._100))
                        .font(color: .blue(._800))
                        .rounded(.full)
                    }
                }
                .flex()
                .spacing(of: 2)
                .margins(of: 4, at: .top)

                Link(to: link, newTab: true) {
                    "View Project"
                }
                .padding()
                .background(color: .blue(._600))
                .font(color: .white())
                .font(weight: .medium)
                .rounded(.md)
                .display(.block)
                .margins(of: 4, at: .top)
            }
            .padding()
        }
        .border()
        .rounded(.lg)
        .shadow(size: .md)
        .overflow(.hidden)
    }
}

struct ExperienceItem: Element {
    var role: String
    var company: String
    var period: String
    var description: String

    var body: some HTML {
        Stack {
            Heading(.headline) { role }
            Text { company }
            Text { description }
        }
    }
}

struct SkillCategory: Element {
    var category: String
    var skills: [String]

    var body: some HTML {
        Stack {
            Heading(.subheadline) { category }
            Stack {
                for skill in skills {
                    Text { skill }
                }
            }
        }
    }
}

struct ContactForm: Element {
    var body: some HTML {
        Form(action: "/submit", method: .post) {
            Stack {
                Label(for: "name") { "Name" }
                Input(name: "name", type: .text, required: true, id: "name")
                Label(for: "email") { "Email" }
                Input(name: "email", type: .email, required: true, id: "email")
                Label(for: "message") { "Message" }
                TextArea(name: "message", required: true, id: "message")
                Button(type: .submit) { "Send Message" }
            }
        }
    }
}

struct HomePage: Document {
    var path: String? { "index" }

    var metadata: Metadata {
        Metadata(
            from: Portfolio().metadata,
            title: "Home",
            description: "Welcome to my portfolio website"
        )
    }

    var body: some HTML {
        PageLayout(
            title: "Welcome to My Portfolio",
            description:
                "Full-stack developer passionate about creating amazing web experiences"
        ) {
            Stack {
                Stack {
                    Image(
                        source: "/images/profile.jpg",
                        description: "Profile Photo"
                    )
                    .frame(width: .spacing(60), height: .spacing(60))
                    .rounded(.full)
                    .overflow(.hidden)
                    .margins(at: .horizontal, auto: true)

                    Heading(.headline) { "Hi, I'm Jane Doe" }
                        .font(alignment: .center)

                    Text {
                        "I'm a full-stack developer with expertise in Swift, JavaScript, and modern web technologies. I love building high-quality, user-focused applications that solve real problems."
                    }
                    .font(alignment: .center)

                    Stack {
                        Link(to: "/about") { "Learn more about me" }
                            .padding()
                            .background(color: .blue(._600))
                            .font(color: .white())
                            .rounded(.md)

                        Link(to: "/projects") { "View my projects" }
                            .padding()
                            .background(color: .gray(._700))
                            .font(color: .white())
                            .rounded(.md)
                    }
                    .flex(justify: .center)
                    .spacing(of: 4)
                    .margins(of: 6, at: .top)
                }
                .padding()
                .background(color: .white())
                .rounded(.lg)
                .shadow(size: .md)

                Heading(.title) { "Featured Projects" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    ProjectCard(
                        title: "Portfolio Website",
                        description:
                            "A responsive portfolio website built with SwiftUI-like pattern.",
                        technologies: ["Swift", "WebUI", "HTML", "CSS"],
                        imageUrl: "/images/project1.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Task Manager",
                        description:
                            "A web application for managing tasks and projects.",
                        technologies: ["JavaScript", "React", "Node.js"],
                        imageUrl: "/images/project2.jpg",
                        link: "#"
                    )
                }
                .grid(columns: 1)

                Link(to: "/projects") {
                    "View all projects →"
                }
                .display(.block)
                .font(alignment: .center)
                .font(size: .lg)
                .margins(of: 8, at: .top)
            }
        }
    }
}

struct AboutPage: Document {
    var metadata: Metadata {
        Metadata(
            from: Portfolio().metadata,
            title: "About",
            description: "Learn more about me and my experience"
        )
    }

    var body: some HTML {
        PageLayout(
            title: "About Me",
            description: "Learn about my background, skills, and experience"
        ) {
            Stack {
                Stack {
                    Image(
                        source: "/images/profile.jpg",
                        description: "Profile Photo"
                    )
                    .frame(width: .full)
                    .rounded(.lg)

                    Text {
                        "I'm a full-stack developer with over 5 years of experience building web and mobile applications. I have a passion for clean code, intuitive user interfaces, and solving complex problems with elegant solutions."
                    }
                    .padding()
                }
                .grid(columns: 1)
                .padding()
                .background(color: .white())
                .rounded(.lg)
                .shadow(size: .md)

                Heading(.title) { "Skills" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    SkillCategory(
                        category: "Frontend",
                        skills: [
                            "HTML", "CSS", "JavaScript", "TypeScript", "React",
                            "Vue.js",
                        ]
                    )

                    SkillCategory(
                        category: "Backend",
                        skills: [
                            "Swift", "Node.js", "Python", "Express",
                            "Hummingbird", "MongoDB",
                        ]
                    )

                    SkillCategory(
                        category: "Tools & Others",
                        skills: [
                            "Git", "Docker", "AWS", "CI/CD", "Figma",
                            "Responsive Design",
                        ]
                    )
                }
                .grid(columns: 1)

                Heading(.title) { "Experience" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    ExperienceItem(
                        role: "Senior Developer",
                        company: "Tech Solutions Inc",
                        period: "2021 - Present",
                        description:
                            "Leading the development of web applications, mentoring junior developers, and implementing best practices for code quality and performance."
                    )

                    ExperienceItem(
                        role: "Frontend Developer",
                        company: "Digital Innovations",
                        period: "2019 - 2021",
                        description:
                            "Built responsive user interfaces with React, improved application performance, and collaborated with the design team to implement UI/UX improvements."
                    )

                    ExperienceItem(
                        role: "Web Developer",
                        company: "Creative Studios",
                        period: "2017 - 2019",
                        description:
                            "Developed and maintained client websites, implemented responsive designs, and optimized website performance."
                    )
                }
                .spacing(of: 6, along: .vertical)
            }
        }
    }
}

struct ProjectsPage: Document {
    var metadata: Metadata {
        Metadata(
            from: Portfolio().metadata,
            title: "Projects",
            description: "View my recent projects and work"
        )
    }

    var body: some HTML {
        PageLayout(
            title: "My Projects",
            description: "A showcase of my recent work and projects"
        ) {
            Stack {
                Stack {
                    ProjectCard(
                        title: "Portfolio Website",
                        description:
                            "A responsive portfolio website built with SwiftUI-like pattern.",
                        technologies: ["Swift", "WebUI", "HTML", "CSS"],
                        imageUrl: "/images/project1.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Task Manager",
                        description:
                            "A web application for managing tasks and projects.",
                        technologies: ["JavaScript", "React", "Node.js"],
                        imageUrl: "/images/project2.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "E-commerce Store",
                        description:
                            "A fully functional e-commerce store with product listings, cart, and checkout.",
                        technologies: [
                            "React", "Node.js", "MongoDB", "Stripe",
                        ],
                        imageUrl: "/images/project3.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Weather App",
                        description:
                            "A weather application that shows current weather and forecasts.",
                        technologies: ["Swift", "iOS", "API Integration"],
                        imageUrl: "/images/project4.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Blog Platform",
                        description:
                            "A blogging platform with user authentication and content management.",
                        technologies: [
                            "Node.js", "Express", "MongoDB", "React",
                        ],
                        imageUrl: "/images/project5.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Recipe App",
                        description:
                            "An application for browsing and saving recipes.",
                        technologies: ["Swift", "iOS", "Core Data"],
                        imageUrl: "/images/project6.jpg",
                        link: "#"
                    )
                }
                .grid(columns: 1)
            }
        }
    }
}

struct ContactPage: Document {
    var metadata: Metadata {
        Metadata(
            from: Portfolio().metadata,
            title: "Contact",
            description: "Get in touch with me"
        )
    }

    var scripts: [Script]? {
        [Script(src: "/js/contact-form.js", attribute: .defer)]
    }

    var body: some HTML {
        PageLayout(
            title: "Contact Me",
            description:
                "Get in touch for collaborations, job opportunities, or just to say hello"
        ) {
            Stack {
                Stack {
                    Stack {
                        Heading(.headline) { "Contact Information" }

                        Stack {
                            Stack {
                                Text { "Email:" }
                                Text { "jane.doe@example.com" }
                            }
                            .flex()
                            .spacing(of: 2)

                            Stack {
                                Text { "Phone:" }
                                Text { "+1 (555) 123-4567" }
                            }
                            .flex()
                            .spacing(of: 2)

                            Stack {
                                Text { "Location:" }
                                Text { "San Francisco, CA" }
                            }
                            .flex()
                            .spacing(of: 2)
                        }
                        .spacing(of: 3, along: .vertical)
                        .margins(of: 4, at: .top)

                        Heading(.headline) { "Social Media" }
                            .margins(of: 4, at: .top)

                        Stack {
                            Link(to: "https://github.com", newTab: true) {
                                "GitHub"
                            }
                            .padding(of: 2)
                            .background(color: .gray(._800))
                            .font(color: .white())
                            .rounded(.md)
                            .frame(width: .full)
                            .font(alignment: .center)

                            Link(to: "https://linkedin.com", newTab: true) {
                                "LinkedIn"
                            }
                            .padding(of: 2)
                            .background(color: .blue(._700))
                            .font(color: .white())
                            .rounded(.md)
                            .frame(width: .full)
                            .font(alignment: .center)

                            Link(to: "https://twitter.com", newTab: true) {
                                "Twitter"
                            }
                            .padding(of: 2)
                            .background(color: .blue(._400))
                            .font(color: .white())
                            .rounded(.md)
                            .frame(width: .full)
                            .font(alignment: .center)
                        }
                        .spacing(of: 3, along: .vertical)
                        .margins(of: 4, at: .top)
                    }
                    .padding()
                    .background(color: .white())
                    .rounded(.lg)
                    .shadow(size: .md)

                    Stack {
                        Heading(.headline) { "Send Me a Message" }
                        ContactForm()
                    }
                    .padding()
                    .background(color: .white())
                    .rounded(.lg)
                    .shadow(size: .md)
                }
                .grid(columns: 1)
            }
        }
    }
}

// Define the complete website
struct Portfolio: Website {
    var metadata: Metadata {
        Metadata(
            site: "Jane Doe",
            description: "Full-stack developer portfolio",
            author: "Jane Doe",
            keywords: [
                "developer", "portfolio", "web development", "swift",
                "javascript",
            ],
            twitter: "janedoe",
            themeColor: .init("#3B82F6")
        )
    }

    @WebsiteRouteBuilder
    var routes: [any Document] {
        HomePage()
        AboutPage()
        ProjectsPage()
        ContactPage()
    }

    var baseURL: String? {
        "https://janedoe.dev"
    }

    var scripts: [Script]? {
        [
            Script(src: "/js/main.js", attribute: .defer),
            Script(src: "/js/analytics.js", attribute: .async),
        ]
    }

    var stylesheets: [String]? {
        ["/css/styles.css"]
    }

    var sitemapEntries: [SitemapEntry]? {
        [
            SitemapEntry(
                url: "https://janedoe.dev/blog",
                lastModified: Date(),
                changeFrequency: .weekly,
                priority: 0.8
            ),
            SitemapEntry(
                url: "https://janedoe.dev/resume.pdf",
                lastModified: Date(),
                changeFrequency: .monthly,
                priority: 0.6
            ),
        ]
    }

    var robotsRules: [RobotsRule]? {
        [
            RobotsRule(
                userAgent: "*",
                disallow: ["/admin/", "/private/"],
                allow: ["/public/"],
                crawlDelay: 10
            ),
            RobotsRule(
                userAgent: "Googlebot",
                disallow: ["/temp/"]
            ),
        ]
    }
}

// MARK: - Tests

@Suite("Comprehensive Website Tests")
struct ComprehensiveWebsiteTests {

    @Test("Website structure is correct")
    func testWebsiteStructure() throws {
        let portfolio = Portfolio()

        #expect(portfolio.metadata.site == "Jane Doe")
        #expect(portfolio.routes.count == 4)
        #expect(portfolio.baseURL == "https://janedoe.dev")
        #expect(portfolio.sitemapEntries?.count == 2)
        #expect(portfolio.robotsRules?.count == 2)

        let routeTypes = portfolio.routes.map { type(of: $0) }
        #expect(routeTypes.contains { $0 == HomePage.self })
        #expect(routeTypes.contains { $0 == AboutPage.self })
        #expect(routeTypes.contains { $0 == ProjectsPage.self })
        #expect(routeTypes.contains { $0 == ContactPage.self })

        // Test build generation
        try portfolio.build(to: URL(fileURLWithPath: ".build-portfolio"))

        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/index.html"))
        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/about.html"))
        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/projects.html"))
        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/contact.html"))
        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/sitemap.xml"))
        #expect(
            FileManager.default.fileExists(
                atPath: ".build-portfolio/robots.txt"))

        // Test HTML content and structure
        let indexContent = try String(
            contentsOfFile: ".build-portfolio/index.html", encoding: .utf8)
        #expect(indexContent.contains("<html"))
        #expect(indexContent.contains("<head>"))
        #expect(indexContent.contains("<body>"))
        #expect(indexContent.contains("<header"))
        #expect(indexContent.contains("<main"))
        #expect(indexContent.contains("<footer"))
        #expect(indexContent.contains("<nav"))
        #expect(indexContent.contains("<h1"))
        #expect(indexContent.contains("<img"))

        // Test specific meta tags
        #expect(indexContent.contains("<title>Home Jane Doe</title>"))
        #expect(indexContent.contains("<meta charset=\"UTF-8\">"))
        #expect(indexContent.contains("<meta name=\"viewport\""))
        #expect(indexContent.contains("width=device-width"))
        #expect(indexContent.contains("<meta name=\"description\""))
        #expect(indexContent.contains("<meta name=\"author\""))
        #expect(indexContent.contains("content=\"Jane Doe\""))
        #expect(indexContent.contains("<meta name=\"keywords\""))
        #expect(indexContent.contains("<meta name=\"twitter:card\""))
        #expect(indexContent.contains("<meta name=\"twitter:creator\""))
        #expect(indexContent.contains("<meta property=\"og:title\""))
        #expect(indexContent.contains("<meta property=\"og:description\""))
        #expect(indexContent.contains("<meta property=\"og:type\""))
        #expect(indexContent.contains("<meta name=\"theme-color\""))
        #expect(indexContent.contains("content=\"#3B82F6\""))

        // Test CSS classes are present
        #expect(indexContent.contains("class="))
        #expect(indexContent.contains("flex"))
        #expect(indexContent.contains("p-4"))
        #expect(indexContent.contains("mt-4"))
        #expect(indexContent.contains("bg-"))
        #expect(indexContent.contains("text-"))
        #expect(indexContent.contains("rounded"))

        // Test sitemap content
        let sitemapContent = try String(
            contentsOfFile: ".build-portfolio/sitemap.xml", encoding: .utf8)
        #expect(
            sitemapContent.contains(
                "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
        #expect(
            sitemapContent.contains(
                "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
            ))
        #expect(
            sitemapContent.contains("<loc>https://janedoe.dev/index.html</loc>")
        )
        #expect(
            sitemapContent.contains("<loc>https://janedoe.dev/about.html</loc>")
        )
        #expect(
            sitemapContent.contains(
                "<loc>https://janedoe.dev/projects.html</loc>"))
        #expect(
            sitemapContent.contains(
                "<loc>https://janedoe.dev/contact.html</loc>"))
        #expect(sitemapContent.contains("<loc>https://janedoe.dev/blog</loc>"))
        #expect(
            sitemapContent.contains("<loc>https://janedoe.dev/resume.pdf</loc>")
        )
        #expect(sitemapContent.contains("<changefreq>weekly</changefreq>"))
        #expect(sitemapContent.contains("<changefreq>monthly</changefreq>"))
        #expect(sitemapContent.contains("<priority>0.8</priority>"))
        #expect(sitemapContent.contains("<priority>0.6</priority>"))

        // Test robots.txt content
        let robotsContent = try String(
            contentsOfFile: ".build-portfolio/robots.txt", encoding: .utf8)
        #expect(robotsContent.contains("User-agent: *"))
        #expect(robotsContent.contains("Disallow: /admin/"))
        #expect(robotsContent.contains("Disallow: /private/"))
        #expect(robotsContent.contains("Allow: /public/"))
        #expect(robotsContent.contains("Crawl-delay: 10"))
        #expect(robotsContent.contains("User-agent: Googlebot"))
        #expect(robotsContent.contains("Disallow: /temp/"))
        #expect(
            robotsContent.contains("Sitemap: https://janedoe.dev/sitemap.xml"))

        // Clean up
        try FileManager.default.removeItem(atPath: ".build-portfolio")
    }

    @Test("HomePage renders correctly")
    func testHomePageRendering() {
        let home = HomePage()
        let html = home.body.render()

        #expect(html.contains("Welcome to My Portfolio"))
        #expect(html.contains("Hi, I'm Jane Doe"))
        #expect(html.contains("Featured Projects"))
    }

    @Test("AboutPage renders correctly")
    func testAboutPageRendering() {
        let about = AboutPage()
        let html = about.body.render()

        #expect(html.contains("About Me"))
        #expect(html.contains("Skills"))
        #expect(html.contains("Experience"))
    }

    @Test("ProjectsPage renders correctly")
    func testProjectsPageRendering() {
        let projects = ProjectsPage()
        let html = projects.body.render()

        #expect(html.contains("My Projects"))
        #expect(html.contains("Portfolio Website"))
        #expect(html.contains("Task Manager"))
        #expect(html.contains("E-commerce Store"))
    }

    @Test("ContactPage renders correctly")
    func testContactPageRendering() {
        let contact = ContactPage()
        let html = contact.body.render()

        #expect(html.contains("Contact Me"))
        #expect(html.contains("Contact Information"))
        #expect(html.contains("jane.doe@example.com"))
        #expect(html.contains("GitHub"))
        #expect(html.contains("LinkedIn"))
        #expect(html.contains("Twitter"))
        #expect(html.contains("Send Me a Message"))
    }

    @Test("Responsive design attributes present")
    func testResponsiveDesignAttributes() {
        let home = HomePage()
        let html = home.body.render()

        #expect(html.contains("Portfolio"))

        let projects = ProjectsPage()
        let projectsHtml = projects.body.render()

        #expect(projectsHtml.contains("Projects"))
    }

    @Test("UI components render correctly")
    func testUIComponentsRendering() {
        // Test ProjectCard
        let projectCard = ProjectCard(
            title: "Test Project",
            description: "Test description",
            technologies: ["Swift", "HTML"],
            imageUrl: "/test.jpg",
            link: "#test"
        )

        let cardHtml = projectCard.render()
        #expect(cardHtml.contains("Test Project"))
        #expect(cardHtml.contains("Test description"))
        #expect(cardHtml.contains("Swift"))
        #expect(cardHtml.contains("HTML"))
        #expect(cardHtml.contains("<img src=\"/test.jpg\""))
        #expect(cardHtml.contains("href=\"#test\""))

        // Test ContactForm
        let contactForm = ContactForm()
        let formHtml = contactForm.render()

        #expect(formHtml.contains("<form"))
        #expect(formHtml.contains("action=\"/submit\""))
        #expect(formHtml.contains("method=\"post\""))
        #expect(formHtml.contains("<input"))
        #expect(formHtml.contains("type=\"email\""))
        #expect(formHtml.contains("<textarea"))
        #expect(formHtml.contains("<button type=\"submit\""))
    }
}
