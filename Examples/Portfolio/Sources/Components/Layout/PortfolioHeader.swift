import Foundation
import WebUI

/// Header component matching the portfolio header.liquid partial
struct PortfolioHeader: Markup {
    let breadcrumbs: [BaseDocument<AnyMarkup>.Breadcrumb]?
    let emoji: String?
    let toolControls: String?
    let hidePostsLink: Bool
    
    var body: some Markup {
        Header(id: "main-header", classes: ["fixed", "top-0", "left-0", "right-0", "bg-white", "dark:bg-zinc-800", "border-b", "border-zinc-200", "dark:border-zinc-700", "px-4", "py-6", "z-50", "transition-transform", "duration-300", "ease-in-out"]) {
            Stack {
                Stack {
                    // Navigation/Breadcrumbs
                    if let breadcrumbs = breadcrumbs {
                        BreadcrumbNavigation(breadcrumbs: breadcrumbs, emoji: emoji)
                    } else {
                        Text("Mac Long", classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"])
                    }
                    
                    // Header Controls
                    Stack {
                        Stack {
                            // Tool controls if provided
                            if let toolControls = toolControls {
                                MarkupString(content: toolControls)
                                
                                // Separator
                                MarkupString(content: "<div class=\"hidden md:block w-px h-6 bg-gray-300 dark:bg-zinc-600\"></div>")
                            }
                            
                            // Mobile hamburger menu
                            MobileMenuButton()
                            
                            // Desktop navigation icons
                            DesktopNavigation(hidePostsLink: hidePostsLink)
                        }
                    }
                }
            }
        }
    }
}

struct BreadcrumbNavigation: Markup {
    let breadcrumbs: [BaseDocument<AnyMarkup>.Breadcrumb]
    let emoji: String?
    
    var body: some Markup {
        Stack {
            // Mobile breadcrumbs (show first 2 + emoji/icon for third)
            Navigation {
                ForEach(breadcrumbs.enumerated().prefix(2)) { index, crumb in
                    if index == 1 && breadcrumbs.count > 2 {
                        Link(crumb.title, to: crumb.url, classes: ["text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600", "dark:hover:text-teal-400", "transition-colors", "cursor-pointer"])
                        Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                    } else if index == breadcrumbs.count - 1 {
                        Text(crumb.title, classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"])
                    } else {
                        Link(crumb.title, to: crumb.url, classes: ["text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600", "dark:hover:text-teal-400", "transition-colors", "cursor-pointer"])
                        Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                    }
                }
                
                if breadcrumbs.count > 2 {
                    Text(emoji ?? breadcrumbs[2].title, classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium", "text-lg"])
                }
            }
            
            // Desktop breadcrumbs (show all)
            Navigation {
                ForEach(breadcrumbs.enumerated()) { index, crumb in
                    if index == breadcrumbs.count - 1 {
                        Text(crumb.title, classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"])
                    } else {
                        Link(crumb.title, to: crumb.url, classes: ["text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600", "dark:hover:text-teal-400", "transition-colors", "cursor-pointer"])
                        Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                    }
                }
            }
        }
    }
}

struct MobileMenuButton: Markup {
    var body: some Markup {
        Stack {
            Button(classes: ["p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer"]) {
                Icon("chevron-left", classes: ["w-5", "h-5"])
            }
        }
    }
}

struct DesktopNavigation: Markup {
    let hidePostsLink: Bool
    
    var body: some Markup {
        Stack {
            if !hidePostsLink {
                Link(to: "/posts", classes: ["p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer"]) {
                    Icon("file-text", classes: ["w-5", "h-5"])
                }
            }
            
            Link(to: "mailto:hello@maclong.uk", classes: ["p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer"]) {
                Icon("mail", classes: ["w-5", "h-5"])
            }
            
            Link(to: "https://github.com/maclong9", newTab: true, classes: ["p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer"]) {
                Icon("github", classes: ["w-5", "h-5"])
            }
            
            ThemeDropdown()
        }
    }
}