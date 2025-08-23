import Foundation
import WebUI

/// Posts index page matching portfolio/posts/index.html output structure
struct PostsIndexPage: Document {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Posts",
            description: "Technical blog posts about web development, Swift, and software engineering"
        )
    }
    
    var path: String? { "portfolio/posts/index" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            breadcrumbs: [
                .init(title: "Portfolio", url: "/"),
                .init(title: "Posts", url: "/posts")
            ]
        ) {
            Stack {
                // Header
                Section(classes: ["mb-12"]) {
                    Heading(.largeTitle, "Blog Posts", classes: ["text-3xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                    
                    Text("Technical articles about web development, Swift programming, and software engineering practices.", classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400"])
                }
                
                // Posts grid
                Section {
                    Stack {
                        LargePostCard(
                            title: "Building Modern Web Tools",
                            description: "Recently, I embarked on a project to modernize my collection of web-based utility tools. What started as a simple migration turned into an exploration of cutting-edge web technologies and developer experience improvements.",
                            date: "July 25, 2025",
                            readTime: "5 min read",
                            emoji: "🛠️",
                            slug: "building-modern-web-tools",
                            tags: ["Web Development", "TailwindCSS", "Alpine.js"]
                        )
                        
                        LargePostCard(
                            title: "Dotfiles Setup",
                            description: "My complete development environment setup and configuration. Includes shell configuration, editor settings, and development tools that boost productivity.",
                            date: "July 20, 2025",
                            readTime: "3 min read",
                            emoji: "⚙️",
                            slug: "dotfiles-setup",
                            tags: ["Development", "Configuration", "Productivity"]
                        )
                        
                        LargePostCard(
                            title: "Templating System Benefits",
                            description: "The advantages of using modern templating systems for web development. Exploring how template engines improve maintainability and developer experience.",
                            date: "July 15, 2025", 
                            readTime: "4 min read",
                            emoji: "📝",
                            slug: "templating-system-benefits",
                            tags: ["Web Development", "Templates", "Architecture"]
                        )
                    }
                }
            }
        }
    }
}

struct LargePostCard: Markup {
    let title: String
    let description: String
    let date: String
    let readTime: String
    let emoji: String
    let slug: String
    let tags: [String]
    
    var body: some Markup {
        Link(to: "/posts/\(slug)") {
            Article(classes: ["block", "p-6", "bg-white", "dark:bg-zinc-800", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700", "hover:border-teal-500", "dark:hover:border-teal-400", "transition-colors", "h-full"]) {
                Stack {
                    Text(emoji, classes: ["text-3xl"])
                    
                    Stack {
                        Text(date, classes: ["block"])
                        Text(readTime, classes: ["block"])
                    }
                }
                
                Heading(.title, title, classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-3"])
                
                Text(description, classes: ["text-zinc-600", "dark:text-zinc-400", "mb-4", "line-clamp-3"])
                
                Stack {
                    ForEach(tags) { tag in
                        Text(tag, classes: ["px-2", "py-1", "bg-teal-100", "dark:bg-teal-900/30", "text-teal-700", "dark:text-teal-300", "text-xs", "rounded-full"])
                    }
                }
            }
        }
    }
}