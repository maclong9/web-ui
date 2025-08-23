import Foundation
import WebUI

/// Tools index page matching tools/index.html output structure  
struct ToolsIndexPage: Document {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Tools",
            description: "Web-based utility tools for developers and everyday use"
        )
    }
    
    var path: String? { "tools/index" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            breadcrumbs: [
                .init(title: "Tools", url: "/tools")
            ]
        ) {
            Stack {
                // Header
                Section {
                    Stack {
                        Heading(.largeTitle, "Web Tools", classes: ["text-3xl", "md:text-4xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Text("A collection of web-based utility tools built with modern technologies for developers and everyday use.", classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400", "max-w-2xl", "mx-auto"])
                    }
                }
                
                // Tools grid
                Section {
                    Stack {
                        LargeToolCard(
                            title: "Barre Scales",
                            description: "Interactive guitar barre scales chart with multiple scales and positions. Explore different musical scales and their fingering patterns on the guitar fretboard.",
                            icon: "🎸",
                            href: "/barre-scales",
                            features: [
                                "Interactive fretboard visualization", 
                                "Multiple scale types",
                                "Position variations",
                                "Mobile-friendly interface"
                            ]
                        )
                        
                        LargeToolCard(
                            title: "Schengen Tracker",
                            description: "Track your visits to Schengen Area countries with automatic day calculations. Perfect for managing the 90-day rule for visa-free travel.",
                            icon: "✈️",
                            href: "/schengen-tracker",
                            features: [
                                "Automatic day calculations",
                                "Schengen Area country support", 
                                "Travel history tracking",
                                "Visa compliance checking"
                            ]
                        )
                    }
                }
                
                // Footer note
                Section {
                    Stack {
                        Text("All tools are built with modern web technologies and work offline. No data is collected or stored on external servers.", classes: ["text-center", "text-sm", "text-zinc-500", "dark:text-zinc-400", "p-6", "bg-zinc-50", "dark:bg-zinc-800", "rounded-lg"])
                    }
                }
            }
        }
    }
}

struct LargeToolCard: Markup {
    let title: String
    let description: String
    let icon: String
    let href: String
    let features: [String]
    
    var body: some Markup {
        Link(to: href, classes: ["group"]) {
            Article(classes: ["block", "p-6", "bg-white", "dark:bg-zinc-800", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700", "hover:border-teal-500", "dark:hover:border-teal-400", "transition-all", "duration-200", "h-full"]) {
                Stack {
                    Text(icon, classes: ["text-4xl"])
                    
                    Icon("arrow-right", classes: ["w-6", "h-6", "text-zinc-400", "dark:text-zinc-500", "transform", "transition-transform", "group-hover:translate-x-1"])
                }
                
                Heading(.title, title, classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-3"])
                
                Text(description, classes: ["text-zinc-600", "dark:text-zinc-400", "mb-4"])
                
                Stack {
                    ForEach(features) { feature in
                        Stack {
                            Icon("check", classes: ["w-4", "h-4", "text-teal-500", "mr-2"])
                            Text(feature)
                        }
                    }
                }
            }
        }
    }
}