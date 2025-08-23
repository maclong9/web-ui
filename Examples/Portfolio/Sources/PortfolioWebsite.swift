import Foundation
import WebUI

/// The main Portfolio website structure matching the Node.js portfolio output structure
struct PortfolioWebsite: Website {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Portfolio", 
            description: "Personal portfolio and web tools",
            locale: .en,
            themeColor: ThemeColor("#14b8a6", dark: "#5eead4") // Teal theme colors
        )
    }
    
    var baseWebAddress: String? { "https://maclong.uk" }
    
    var routes: [any Document] {
        // Portfolio routes (maclong.uk domain)
        HomePage()
        PostsIndexPage()
        
        // Individual blog posts
        BuildingModernWebToolsPost()
        DotfilesSetupPost() 
        TemplatingSystemBenefitsPost()
        
        // Tools routes (tools.maclong.uk domain structure)
        ToolsIndexPage()
        BarreScalesTool()
        SchengenTrackerTool()
    }
}