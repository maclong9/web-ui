import Foundation
import WebUI

/// Mobile menu overlay component
struct MobileMenuOverlay: Markup {
    var body: some Markup {
        Stack {
            Stack {
                // Menu header
                Stack {
                    Heading(.headline, "Navigation", classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100"])
                    
                    Button(classes: ["p-1", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200"]) {
                        Icon("x", classes: ["w-5", "h-5"])
                    }
                }
                
                // Navigation links
                MobileMenuLink(
                    href: "/posts",
                    icon: "file-text",
                    title: "Posts"
                )
                
                MobileMenuLink(
                    href: "mailto:hello@maclong.uk",
                    icon: "mail", 
                    title: "Email"
                )
                
                MobileMenuLink(
                    href: "https://github.com/maclong9",
                    icon: "github",
                    title: "GitHub",
                    isExternal: true
                )
                
                // Theme selection
                Stack {
                    Heading(.subheadline, "Theme", classes: ["text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300", "mb-3"])
                    
                    Stack {
                        MobileThemeButton(
                            theme: "system",
                            icon: "palette",
                            title: "System"
                        )
                        
                        MobileThemeButton(
                            theme: "light",
                            icon: "sun",
                            title: "Light"
                        )
                        
                        MobileThemeButton(
                            theme: "dark",
                            icon: "moon",
                            title: "Dark"
                        )
                    }
                }
            }
        }
    }
}

struct MobileMenuLink: Markup {
    let href: String
    let icon: String
    let title: String
    let isExternal: Bool
    
    init(href: String, icon: String, title: String, isExternal: Bool = false) {
        self.href = href
        self.icon = icon
        self.title = title
        self.isExternal = isExternal
    }
    
    var body: some Markup {
        Link(to: href, newTab: isExternal, classes: ["flex", "items-center", "space-x-3", "p-3", "text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600", "dark:hover:text-teal-400", "hover:bg-zinc-50", "dark:hover:bg-zinc-700", "rounded-lg", "transition-colors", "cursor-pointer"]) {
            Icon(icon, classes: ["w-5", "h-5"])
            Text(title)
        }
    }
}

struct MobileThemeButton: Markup {
    let theme: String
    let icon: String
    let title: String
    
    var body: some Markup {
        Button(classes: ["w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-lg", "text-sm", "transition-colors", "cursor-pointer"]) {
            Icon(icon, classes: ["w-4", "h-4"])
            Text(title)
        }
    }
}