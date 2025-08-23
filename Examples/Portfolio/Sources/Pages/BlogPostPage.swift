import Foundation
import WebUI

/// Generic blog post page that renders markdown content
struct BlogPostPage: Document {
    let post: Post
    
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: post.title,
            description: post.description
        )
    }
    
    var path: String? { "portfolio/posts/\(post.slug)" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            breadcrumbs: [
                .init(title: "Portfolio", url: "/"),
                .init(title: "Posts", url: "/posts"),
                .init(title: post.title, url: "/posts/\(post.slug)")
            ],
            emoji: post.emoji
        ) {
            Stack {
                // Article header
                Section {
                    Stack {
                        Text(post.emoji, classes: ["text-4xl", "mb-4"])
                        
                        Heading(.largeTitle, post.title, classes: ["text-3xl", "md:text-4xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Text(post.description, classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400", "mb-6", "max-w-2xl", "mx-auto"])
                        
                        Stack {
                            Text(post.date)
                            Text("•")
                            Text(post.readTime)
                        }
                        
                        Stack {
                            ForEach(post.tags) { tag in
                                Text(tag, classes: ["px-3", "py-1", "bg-teal-100", "dark:bg-teal-900/30", "text-teal-700", "dark:text-teal-300", "text-sm", "rounded-full"])
                            }
                        }
                    }
                }
                
                // Article content
                Article(classes: ["mb-12"]) {
                    MarkupString(content: post.content)
                }
                
                // Navigation
                Section {
                    Stack {
                        Link("← All Posts", to: "/posts", classes: ["text-teal-600", "dark:text-teal-400", "hover:text-teal-700", "dark:hover:text-teal-300", "font-medium"])
                        
                        Link("Home →", to: "/", classes: ["text-teal-600", "dark:text-teal-400", "hover:text-teal-700", "dark:hover:text-teal-300", "font-medium"])
                    }
                }
            }
        }
    }
}