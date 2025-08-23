import Foundation
import WebUIMarkdown

/// Manages content discovery and processing for the portfolio
struct ContentManager {
    private let markdown = WebUIMarkdown(
        options: .documentation,
        typography: .init(defaultFontSize: .body)
    )
    
    /// Discovers and loads all blog posts from the Content/posts directory
    func loadPosts() throws -> [Post] {
        let contentURL = URL(filePath: "Content/posts")
        
        guard FileManager.default.fileExists(atPath: contentURL.path()) else {
            print("⚠️  No Content/posts directory found, creating sample posts in memory")
            return createSamplePosts()
        }
        
        let markdownFiles = try FileManager.default
            .contentsOfDirectory(at: contentURL, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "md" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
        
        return try markdownFiles.compactMap { fileURL in
            let content = try String(contentsOf: fileURL)
            return try createPost(from: content, filename: fileURL.lastPathComponent)
        }
    }
    
    /// Creates a Post from markdown content
    private func createPost(from content: String, filename: String) throws -> Post? {
        let parsed = try markdown.parseMarkdown(content)
        let slug = String(filename.dropLast(3)) // Remove .md extension
        
        guard let title = parsed.frontMatter["title"] as? String,
              let description = parsed.frontMatter["description"] as? String else {
            print("⚠️  Skipping \(filename) - missing required frontmatter")
            return nil
        }
        
        let dateString = parsed.frontMatter["date"] as? String ?? ""
        let readTime = parsed.frontMatter["readtime"] as? String ?? "5 min read"
        let emoji = parsed.frontMatter["emoji"] as? String ?? "📄"
        let tagsString = parsed.frontMatter["tags"] as? String ?? ""
        let tags = tagsString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        return Post(
            slug: slug,
            title: title,
            description: description,
            content: parsed.htmlContent,
            date: dateString,
            readTime: readTime,
            emoji: emoji,
            tags: tags,
            excerpt: parsed.frontMatter["excerpt"] as? String ?? description
        )
    }
    
    /// Creates sample posts for demonstration when no Content directory exists
    private func createSamplePosts() -> [Post] {
        return [
            Post(
                slug: "building-modern-web-tools",
                title: "Building Modern Web Tools", 
                description: "Building modern utility tools with TailwindCSS v4, Alpine.js, and progressive enhancement techniques.",
                content: samplePostContent(),
                date: "2025-07-25",
                readTime: "5 min read", 
                emoji: "🛠️",
                tags: ["Web Development", "TailwindCSS", "Alpine.js"],
                excerpt: "Building modern utility tools with TailwindCSS v4, Alpine.js, and progressive enhancement techniques."
            ),
            Post(
                slug: "dotfiles-setup",
                title: "Dotfiles Setup",
                description: "My complete development environment setup and dotfiles configuration.",
                content: "<p>Complete guide to setting up a productive development environment...</p>",
                date: "2025-07-20",
                readTime: "3 min read",
                emoji: "⚙️", 
                tags: ["Development", "Configuration", "Productivity"],
                excerpt: "My complete development environment setup and configuration."
            ),
            Post(
                slug: "templating-system-benefits", 
                title: "Templating System Benefits",
                description: "The advantages of using modern templating systems for web development.",
                content: "<p>Modern templating systems provide numerous benefits...</p>",
                date: "2025-07-15",
                readTime: "4 min read",
                emoji: "📝",
                tags: ["Web Development", "Templates", "Architecture"],
                excerpt: "The advantages of using modern templating systems for web development."
            )
        ]
    }
    
    private func samplePostContent() -> String {
        return """
        <p>Recently, I embarked on a project to modernize my collection of web-based utility tools. What started as a simple migration turned into an exploration of cutting-edge web technologies and developer experience improvements.</p>
        
        <h2>The Challenge</h2>
        
        <p>My original tools were built with vanilla HTML, CSS, and JavaScript. While functional, they lacked consistency in design, had poor mobile responsiveness, and were becoming increasingly difficult to maintain.</p>
        
        <h2>The Tech Stack</h2>
        
        <p>After evaluating several options, I settled on a stack that prioritizes developer experience and performance:</p>
        
        <h3>TailwindCSS v4</h3>
        
        <p>The latest version of Tailwind brings significant improvements, including the new <code>@tailwindcss/browser</code> CDN that compiles styles on-demand.</p>
        
        <h3>Alpine.js</h3>
        
        <p>For interactivity, Alpine.js proved to be the perfect lightweight alternative to heavier frameworks. It provides reactive functionality while maintaining the simplicity of vanilla JavaScript.</p>
        """
    }
}

/// Represents a blog post with all metadata
struct Post {
    let slug: String
    let title: String
    let description: String
    let content: String
    let date: String
    let readTime: String
    let emoji: String
    let tags: [String]
    let excerpt: String
}