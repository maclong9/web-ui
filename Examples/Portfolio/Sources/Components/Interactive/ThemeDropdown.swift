import Foundation
import WebUI

/// Theme dropdown component for desktop navigation
struct ThemeDropdown: Markup {
    var body: some Markup {
        Stack {
            // Theme toggle button
            Button(classes: ["p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer"]) {
                Icon("palette", classes: ["w-5", "h-5"])
                Icon("sun", classes: ["w-5", "h-5"])
                Icon("moon", classes: ["w-5", "h-5"])
            }
            
            // Dropdown menu
            Stack {
                ThemeDropdownItem(
                    theme: "system",
                    icon: "palette",
                    title: "System"
                )
                
                ThemeDropdownItem(
                    theme: "light", 
                    icon: "sun",
                    title: "Light"
                )
                
                ThemeDropdownItem(
                    theme: "dark",
                    icon: "moon", 
                    title: "Dark"
                )
            }
        }
    }
}

struct ThemeDropdownItem: Markup {
    let theme: String
    let icon: String
    let title: String
    
    var body: some Markup {
        Button(classes: ["w-full", "flex", "items-center", "space-x-2", "px-3", "py-2", "text-sm", "transition-colors", "cursor-pointer"]) {
            Icon(icon, classes: ["w-4", "h-4"])
            Text(title)
        }
    }
}