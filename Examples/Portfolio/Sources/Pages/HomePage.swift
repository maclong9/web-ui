import Foundation
import WebUI

/// Home page matching portfolio/index.html output structure
struct HomePage: Document {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Portfolio",
            description: "Personal portfolio and web tools"
        )
    }
    
    var path: String? { "portfolio/index" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            alpineComponent: "portfolioApp()"
        ) {
            Stack {
                // Hero section
                Section {
                    Stack {
                        Heading(.largeTitle, "Mac Long", classes: ["text-4xl", "md:text-6xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Text("Software Engineer & Web Developer", classes: ["text-xl", "text-zinc-600", "dark:text-zinc-400", "mb-8"])
                        
                        Text("Building modern web applications with focus on performance, user experience, and clean code.", classes: ["text-lg", "text-zinc-500", "dark:text-zinc-500", "max-w-2xl", "mx-auto"])
                    }
                }
                
                // Recent posts section
                Section {
                    Heading(.title, "Recent Posts", classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-8"])
                    
                    Stack {
                        PostCard(
                            title: "Building Modern Web Tools",
                            description: "Building modern utility tools with TailwindCSS v4, Alpine.js, and progressive enhancement techniques.",
                            date: "2025-07-25",
                            readTime: "5 min read",
                            emoji: "🛠️",
                            slug: "building-modern-web-tools"
                        )
                        
                        PostCard(
                            title: "Dotfiles Setup",
                            description: "My complete development environment setup and dotfiles configuration.",
                            date: "2025-07-20", 
                            readTime: "3 min read",
                            emoji: "⚙️",
                            slug: "dotfiles-setup"
                        )
                        
                        PostCard(
                            title: "Templating System Benefits",
                            description: "The advantages of using modern templating systems for web development.",
                            date: "2025-07-15",
                            readTime: "4 min read", 
                            emoji: "📝",
                            slug: "templating-system-benefits"
                        )
                    }
                    
                    Stack {
                        Link("View all posts", to: "/posts", classes: ["inline-flex", "items-center", "px-6", "py-3", "bg-teal-600", "hover:bg-teal-700", "text-white", "font-medium", "rounded-lg", "transition-colors"])
                    }
                }
                
                // Tools section
                Section {
                    Heading(.title, "Web Tools", classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-8"])
                    
                    Stack {
                        ToolCard(
                            title: "Barre Scales",
                            description: "Interactive guitar barre scales chart with multiple scales and positions.",
                            icon: "🎸",
                            href: "https://tools.maclong.uk/barre-scales"
                        )
                        
                        ToolCard(
                            title: "Schengen Tracker", 
                            description: "Track your visits to Schengen Area countries with automatic day calculations.",
                            icon: "✈️",
                            href: "https://tools.maclong.uk/schengen-tracker"
                        )
                    }
                }
            }
        }
    }
}

struct PostCard: Markup {
    let title: String
    let description: String
    let date: String
    let readTime: String
    let emoji: String
    let slug: String
    
    var body: some Markup {
        Link(to: "/posts/\(slug)", classes: ["group"]) {
            Article(classes: ["block", "p-6", "bg-white", "dark:bg-zinc-800", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700", "hover:border-teal-500", "dark:hover:border-teal-400", "transition-colors"]) {
                Stack {
                    Text(emoji, classes: ["text-2xl"])
                    
                    Text(readTime, classes: ["text-sm", "text-zinc-500", "dark:text-zinc-400"])
                }
                
                Heading(.headline, title, classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-2"])
                
                Text(description, classes: ["text-zinc-600", "dark:text-zinc-400", "text-sm", "mb-3", "line-clamp-3"])
                
                Text(date, classes: ["text-xs", "text-zinc-500", "dark:text-zinc-500"])
            }
        }
    }
}

struct ToolCard: Markup {
    let title: String
    let description: String
    let icon: String
    let href: String
    
    var body: some Markup {
        Link(to: href, newTab: true, classes: ["group"]) {
            Article(classes: ["block", "p-6", "bg-white", "dark:bg-zinc-800", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700", "hover:border-teal-500", "dark:hover:border-teal-400", "transition-colors"]) {
                Stack {
                    Text(icon, classes: ["text-2xl"])
                    
                    Icon("external-link", classes: ["w-5", "h-5", "text-zinc-400", "dark:text-zinc-500"])
                }
                
                Heading(.headline, title, classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-2"])
                
                Text(description, classes: ["text-zinc-600", "dark:text-zinc-400", "text-sm"])
            }
        }
    }
}