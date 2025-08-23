import Foundation
import WebUI

/// Base document structure matching base.liquid template
struct BaseDocument<Content: Markup>: Markup {
    let pageMetadata: Metadata
    let content: Content
    let breadcrumbs: [Breadcrumb]?
    let emoji: String?
    let customCSS: String?
    let toolControls: String?
    let hidePostsLink: Bool
    let alpineComponent: String
    
    struct Breadcrumb {
        let title: String
        let url: String
    }
    
    init(
        metadata: Metadata,
        breadcrumbs: [Breadcrumb]? = nil,
        emoji: String? = nil,
        customCSS: String? = nil,
        toolControls: String? = nil,
        hidePostsLink: Bool = false,
        alpineComponent: String = "portfolioApp()",
        @MarkupBuilder content: () -> Content
    ) {
        self.pageMetadata = metadata
        self.breadcrumbs = breadcrumbs
        self.emoji = emoji
        self.customCSS = customCSS
        self.toolControls = toolControls
        self.hidePostsLink = hidePostsLink
        self.alpineComponent = alpineComponent
        self.content = content()
    }
    
    // Metadata for Document protocol
    var documentMetadata: Metadata { pageMetadata }
    
    var body: some Markup {
        Stack {
            // Mobile menu overlay
            MobileMenuOverlay()
            
            // Main content container
            Stack {
                PortfolioHeader(
                    breadcrumbs: breadcrumbs,
                    emoji: emoji,
                    toolControls: toolControls,
                    hidePostsLink: hidePostsLink
                )
                
                Stack {
                    content
                }
                
                PortfolioFooter()
            }
        }
    }
    
    var scripts: [Script]? {
        [
            Script(source: "/vendor/alpine.min.js", defer: true),
            Script(source: "/vendor/lucide.js?v=3"),
            Script(
                placement: .head,
                content: """
                // Prevent FOUC by setting theme immediately
                (function () {
                  const savedTheme = localStorage.getItem('theme');
                  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

                  let actualTheme = 'light';
                  if (
                    savedTheme === 'dark' ||
                    (savedTheme === 'system' && systemPrefersDark) ||
                    (!savedTheme && systemPrefersDark)
                  ) {
                    actualTheme = 'dark';
                  }

                  document.documentElement.setAttribute('data-theme', actualTheme);
                })();
                """
            )
        ]
    }
    
    var stylesheets: [String]? {
        ["/assets/main.css"]
    }
    
    var head: String? {
        var headContent = """
        <meta name="author" content="Mac Long">
        <link
          rel="icon"
          href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='48' height='48' viewBox='0 0 16 16'><text x='0' y='14'>\(emoji ?? "👨‍💻")</text></svg>"
        >
        """
        
        if let customCSS = customCSS {
            headContent += """
            <style>
            \(customCSS)
            </style>
            """
        }
        
        headContent += """
        <style>
          /* Ensure no gaps above fixed header */
          html,
          body {
            margin: 0;
            padding: 0;
          }
          #main-header {
            top: 0 !important;
            margin-top: 0 !important;
          }
        </style>
        """
        
        return headContent
    }
}