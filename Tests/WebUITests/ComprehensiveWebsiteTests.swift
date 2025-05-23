import Foundation
import Testing

@testable import WebUI

// MARK: - Example Website with SwiftUI-like Pattern

// Reusable UI components
struct PageLayout: Element {
    var title: String
    var description: String
    var content: () -> [any HTML]

    init(title: String, description: String, @HTMLBuilder content: @escaping () -> [any HTML]) {
        self.title = title
        self.description = description
        self.content = content
    }

    var body: some HTML {
        Stack {
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
                .font(color: .white)
            }
            Main {
                Stack {
                    Section {
                        Heading(.title) { title }
                        Text { description }
                    }
                    .padding()
                    .margins(at: .bottom)

                    content()
                }
                .padding()
                .margins(at: .horizontal, auto: true)
                .frame(maxWidth: .container(.extraLarge))
            }
            Footer {
                Stack {
                    Text { "© 2024 My Portfolio. All rights reserved." }
                    Stack {
                        Link(to: "https://github.com", newTab: true) { "GitHub" }
                        Link(to: "https://linkedin.com", newTab: true) { "LinkedIn" }
                        Link(to: "https://twitter.com", newTab: true) { "Twitter" }
                    }
                    .flex()
                    .spacing(of: 4)
                }
                .flex(justify: .between, align: .center)
                .padding()
                .background(color: .gray(._800))
                .font(color: .white)
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
            Image(src: imageUrl, alt: title)
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
                .flex(wrap: .wrap)
                .spacing(of: 2)
                .margins(of: 4, at: .top)

                Link(to: link, newTab: true) {
                    "View Project"
                }
                .padding()
                .background(color: .blue(._600))
                .font(color: .white)
                .font(weight: .medium)
                .rounded(.md)
                .display(.block)
                .margins(of: 4, at: .top)
                .on {
                    hover {
                        background(color: .blue(._700))
                    }
                }
            }
            .padding()
        }
        .border()
        .rounded(.lg)
        .shadow()
        .overflow(.hidden)
        .on {
            hover {
                transform(scale: (x: 102, y: 102))
            }
        }
        .transition(of: .transform, for: 300)
    }
}

struct ExperienceItem: Element {
    var role: String
    var company: String
    var period: String
    var description: String

    var body: some HTML {
        Stack {
            Stack {
                Heading(.headline) { role }
                Stack {
                    Text { company }
                    Text { period }
                }
                .flex(align: .center)
                .spacing(of: 2)
                .font(size: .sm)
                .font(color: .gray(._600))
            }
            .margins(of: 2, at: .bottom)

            Text { description }
        }
        .padding()
        .border(at: .left, color: .blue(._600), of: 4)
        .background(color: .gray(._50))
        .rounded(.md)
    }
}

struct SkillCategory: Element {
    var category: String
    var skills: [String]

    var body: some HTML {
        Stack {
            Heading(.headline) { category }
            Stack {
                for skill in skills {
                    Stack {
                        Text { skill }
                    }
                    .padding()
                    .background(color: .gray(._100))
                    .font(color: .gray(._800))
                    .rounded(.md)
                    .border(color: .gray(._300))
                }
            }
            .grid(columns: 2, gap: 2)
            .responsive {
                md {
                    grid(columns: 3)
                }
            }
        }
        .padding()
        .border()
        .rounded(.md)
    }
}

struct ContactForm: Element {
    var body: some HTML {
        Form(action: "/submit", method: .post) {
            Stack {
                Stack {
                    Label(for: "name") { "Name" }
                    Input(name: "name", type: .text, required: true, id: "name")
                        .padding()
                        .border()
                        .rounded(.md)
                        .frame(width: .full)
                }
                .margins(of: 4, at: .bottom)

                Stack {
                    Label(for: "email") { "Email" }
                    Input(name: "email", type: .email, required: true, id: "email")
                        .padding()
                        .border()
                        .rounded(.md)
                        .frame(width: .full)
                }
                .margins(of: 4, at: .bottom)

                Stack {
                    Label(for: "message") { "Message" }
                    TextArea(name: "message", required: true, id: "message")
                        .padding()
                        .border()
                        .rounded(.md)
                        .frame(width: .full, height: .spacing(40))
                }
                .margins(of: 4, at: .bottom)

                Button(type: .submit) {
                    "Send Message"
                }
                .padding()
                .background(color: .blue(._600))
                .font(color: .white())
                .font(weight: .medium)
                .rounded(.md)
                .margins(of: 4, at: .top)
                .on {
                    hover {
                        background(color: .blue(._700))
                    }
                }
            }
        }
        .padding()
        .border()
        .rounded(.lg)
        .shadow()
    }
}

// Define pages
struct HomePage: Document {
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
            description: "Full-stack developer passionate about creating amazing web experiences"
        ) {
            Stack {
                Stack {
                    Image(src: "/images/profile.jpg", alt: "Profile Photo")
                        .frame(width: .spacing(60), height: .spacing(60))
                        .rounded(.full)
                        .overflow(.hidden)
                        .margins(at: .horizontal, auto: true)

                    Heading(.headline) { "Hi, I'm John Doe" }
                        .font(alignment: .center)

                    Text { "I'm a full-stack developer with expertise in Swift, JavaScript, and modern web technologies. I love building high-quality, user-focused applications that solve real problems." }
                        .font(alignment: .center)

                    Stack {
                        Link(to: "/about") { "Learn more about me" }
                            .padding()
                            .background(color: .blue(._600))
                            .font(color: .white)
                            .rounded(.md)
                            .on {
                                hover {
                                    background(color: .blue(._700))
                                }
                            }

                        Link(to: "/projects") { "View my projects" }
                            .padding()
                            .background(color: .gray(._700))
                            .font(color: .white)
                            .rounded(.md)
                            .on {
                                hover {
                                    background(color: .gray(._800))
                                }
                            }
                    }
                    .flex(justify: .center)
                    .spacing(of: 4)
                    .margins(of: 6, at: .top)
                }
                .padding()
                .background(color: .white)
                .rounded(.lg)
                .shadow()

                Heading(.title) { "Featured Projects" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    ProjectCard(
                        title: "Portfolio Website",
                        description: "A responsive portfolio website built with SwiftUI-like pattern.",
                        technologies: ["Swift", "WebUI", "HTML", "CSS"],
                        imageUrl: "/images/project1.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Task Manager",
                        description: "A web application for managing tasks and projects.",
                        technologies: ["JavaScript", "React", "Node.js"],
                        imageUrl: "/images/project2.jpg",
                        link: "#"
                    )
                }
                .grid(columns: 1, gap: 6)
                .responsive {
                    md {
                        grid(columns: 2)
                    }
                }

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
                    Image(src: "/images/profile.jpg", alt: "Profile Photo")
                        .frame(width: .full)
                        .rounded(.lg)

                    Text { "I'm a full-stack developer with over 5 years of experience building web and mobile applications. I have a passion for clean code, intuitive user interfaces, and solving complex problems with elegant solutions." }
                        .padding()
                }
                .grid(columns: 1, gap: 4)
                .responsive {
                    md {
                        grid(columns: 2)
                    }
                }
                .padding()
                .background(color: .white)
                .rounded(.lg)
                .shadow()

                Heading(.title) { "Skills" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    SkillCategory(
                        category: "Frontend",
                        skills: ["HTML", "CSS", "JavaScript", "TypeScript", "React", "Vue.js"]
                    )

                    SkillCategory(
                        category: "Backend",
                        skills: ["Swift", "Node.js", "Python", "Express", "Hummingbird", "MongoDB"]
                    )

                    SkillCategory(
                        category: "Tools & Others",
                        skills: ["Git", "Docker", "AWS", "CI/CD", "Figma", "Responsive Design"]
                    )
                }
                .grid(columns: 1, gap: 4)
                .responsive {
                    md {
                        grid(columns: 2)
                    }
                    lg {
                        grid(columns: 3)
                    }
                }

                Heading(.title) { "Experience" }
                    .margins(of: 8, at: .top)
                    .margins(of: 4, at: .bottom)

                Stack {
                    ExperienceItem(
                        role: "Senior Developer",
                        company: "Tech Solutions Inc",
                        period: "2021 - Present",
                        description: "Leading the development of web applications, mentoring junior developers, and implementing best practices for code quality and performance."
                    )

                    ExperienceItem(
                        role: "Frontend Developer",
                        company: "Digital Innovations",
                        period: "2019 - 2021",
                        description: "Built responsive user interfaces with React, improved application performance, and collaborated with the design team to implement UI/UX improvements."
                    )

                    ExperienceItem(
                        role: "Web Developer",
                        company: "Creative Studios",
                        period: "2017 - 2019",
                        description: "Developed and maintained client websites, implemented responsive designs, and optimized website performance."
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
                        description: "A responsive portfolio website built with SwiftUI-like pattern.",
                        technologies: ["Swift", "WebUI", "HTML", "CSS"],
                        imageUrl: "/images/project1.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Task Manager",
                        description: "A web application for managing tasks and projects.",
                        technologies: ["JavaScript", "React", "Node.js"],
                        imageUrl: "/images/project2.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "E-commerce Store",
                        description: "A fully functional e-commerce store with product listings, cart, and checkout.",
                        technologies: ["React", "Node.js", "MongoDB", "Stripe"],
                        imageUrl: "/images/project3.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Weather App",
                        description: "A weather application that shows current weather and forecasts.",
                        technologies: ["Swift", "iOS", "API Integration"],
                        imageUrl: "/images/project4.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Blog Platform",
                        description: "A blogging platform with user authentication and content management.",
                        technologies: ["Node.js", "Express", "MongoDB", "React"],
                        imageUrl: "/images/project5.jpg",
                        link: "#"
                    )

                    ProjectCard(
                        title: "Recipe App",
                        description: "An application for browsing and saving recipes.",
                        technologies: ["Swift", "iOS", "Core Data"],
                        imageUrl: "/images/project6.jpg",
                        link: "#"
                    )
                }
                .grid(columns: 1, gap: 6)
                .responsive {
                    md {
                        grid(columns: 2)
                    }
                    lg {
                        grid(columns: 3)
                    }
                }
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
            description: "Get in touch for collaborations, job opportunities, or just to say hello"
        ) {
            Stack {
                Stack {
                    Stack {
                        Heading(.headline) { "Contact Information" }

                        Stack {
                            Stack {
                                Text { "Email:" }
                                Text { "john.doe@example.com" }
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
                            Link(to: "https://github.com", newTab: true) { "GitHub" }
                                .padding(of: 2)
                                .background(color: .gray(._800))
                                .font(color: .white)
                                .rounded(.md)
                                .frame(width: .full)
                                .font(alignment: .center)

                            Link(to: "https://linkedin.com", newTab: true) { "LinkedIn" }
                                .padding(of: 2)
                                .background(color: .blue(._700))
                                .font(color: .white)
                                .rounded(.md)
                                .frame(width: .full)
                                .font(alignment: .center)

                            Link(to: "https://twitter.com", newTab: true) { "Twitter" }
                                .padding(of: 2)
                                .background(color: .blue(._400))
                                .font(color: .white)
                                .rounded(.md)
                                .frame(width: .full)
                                .font(alignment: .center)
                        }
                        .spacing(of: 3, along: .vertical)
                        .margins(of: 4, at: .top)
                    }
                    .padding()
                    .background(color: .white)
                    .rounded(.lg)
                    .shadow()

                    Stack {
                        Heading(.headline) { "Send Me a Message" }
                        ContactForm()
                    }
                    .padding()
                    .background(color: .white)
                    .rounded(.lg)
                    .shadow()
                }
                .grid(columns: 1, gap: 6)
                .responsive {
                    lg {
                        grid(columns: 2)
                    }
                }
            }
        }
    }
}

// Define the complete website
struct Portfolio: Website {
    var metadata: Metadata {
        Metadata(
            site: "Jane Doe",
            title: "Portfolio",
            description: "Full-stack developer portfolio",
            author: "Jane Doe",
            keywords: ["developer", "portfolio", "web development", "swift", "javascript"],
            twitter: "janedoe",
            themeColor: .init("#3B82F6")
        )
    }

    var routes: [Document] {
        HomePage()
        AboutPage()
        ProjectsPage()
        ContactPage()
    }

    var baseURL: String? {
        "https://johndoe.dev"
    }

    var scripts: [Script]? {
        [
            Script(src: "/js/main.js", attribute: .defer),
            Script(src: "/js/analytics.js", attribute: .async)
        ]
    }

    var stylesheets: [String]? {
        ["/css/styles.css"]
    }
}

// MARK: - Tests

@Suite("Comprehensive Website Tests")
struct ComprehensiveWebsiteTests {

    @Test("Website structure is correct")
    func testWebsiteStructure() {
        let portfolio = Portfolio()

        #expect(portfolio.metadata.site == "John Doe")
        #expect(portfolio.metadata.title == "Portfolio")
        #expect(portfolio.routes.count == 4)

        let routeTypes = portfolio.routes.map { type(of: $0) }
        #expect(routeTypes.contains { $0 == HomePage.self })
        #expect(routeTypes.contains { $0 == AboutPage.self })
        #expect(routeTypes.contains { $0 == ProjectsPage.self })
        #expect(routeTypes.contains { $0 == ContactPage.self })
    }

    @Test("HomePage renders correctly")
    func testHomePageRendering() {
        let home = HomePage()
        let doc = home.document()
        let html = doc.render()

        #expect(html.contains("<title>Home"))
        #expect(html.contains("Welcome to My Portfolio"))
        #expect(html.contains("Hi, I'm John Doe"))
        #expect(html.contains("Featured Projects"))
        #expect(html.contains("Portfolio Website"))
        #expect(html.contains("Task Manager"))
    }

    @Test("AboutPage renders correctly")
    func testAboutPageRendering() {
        let about = AboutPage()
        let doc = about.document()
        let html = doc.render()

        #expect(html.contains("<title>About"))
        #expect(html.contains("About Me"))
        #expect(html.contains("Skills"))
        #expect(html.contains("Frontend"))
        #expect(html.contains("Backend"))
        #expect(html.contains("Experience"))
        #expect(html.contains("Senior Developer"))
    }

    @Test("ProjectsPage renders correctly")
    func testProjectsPageRendering() {
        let projects = ProjectsPage()
        let doc = projects.document()
        let html = doc.render()

        #expect(html.contains("<title>Projects"))
        #expect(html.contains("My Projects"))
        #expect(html.contains("Portfolio Website"))
        #expect(html.contains("Task Manager"))
        #expect(html.contains("E-commerce Store"))
        #expect(html.contains("Weather App"))
        #expect(html.contains("Blog Platform"))
        #expect(html.contains("Recipe App"))
    }

    @Test("ContactPage renders correctly")
    func testContactPageRendering() {
        let contact = ContactPage()
        let doc = contact.document()
        let html = doc.render()

        #expect(html.contains("<title>Contact"))
        #expect(html.contains("Contact Me"))
        #expect(html.contains("Contact Information"))
        #expect(html.contains("john.doe@example.com"))
        #expect(html.contains("Social Media"))
        #expect(html.contains("GitHub"))
        #expect(html.contains("LinkedIn"))
        #expect(html.contains("Twitter"))
        #expect(html.contains("Send Me a Message"))
        #expect(html.contains("<form"))
        #expect(html.contains("contact-form.js"))
    }

    @Test("Responsive design attributes present")
    func testResponsiveDesignAttributes() {
        let home = HomePage()
        let html = home.body.render()

        #expect(html.contains("md:grid-cols-2"))

        let projects = ProjectsPage()
        let projectsHtml = projects.body.render()

        #expect(projectsHtml.contains("md:grid-cols-2"))
        #expect(projectsHtml.contains("lg:grid-cols-3"))
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
