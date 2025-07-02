import Foundation

/// Utility for managing Lucide icon font styles in documents with performance optimization.
///
/// This utility provides convenient methods for including the Lucide CSS
/// in your documents, preferring local assets over CDN for improved performance.
/// It can be used directly in Document implementations or as part of a Website's global styles.
///
/// ## Performance Strategy
/// 
/// The utility follows a performance-first approach:
/// 1. **Local assets first**: When available, use locally hosted assets for faster loading
/// 2. **CDN fallback**: Falls back to CDN when local assets aren't available
/// 3. **Conditional loading**: Only include CSS when Lucide icons are actually used
///
/// ## Usage in Document
/// ```swift
/// struct MyPage: Document {
///     var stylesheets: [String]? {
///         LucideStyles.optimized
///     }
/// }
/// ```
///
/// ## Usage in Website
/// ```swift
/// struct MyWebsite: Website {
///     var stylesheets: [String]? {
///         ["/css/styles.css"] + LucideStyles.optimized
///     }
/// }
/// ```
public enum LucideStyles {
    
    // MARK: - Local Asset Paths
    
    /// The local path for Lucide CSS assets.
    ///
    /// Use this when you want to serve Lucide CSS from your own domain
    /// for better performance and offline support.
    public static let localPath = "/css/lucide.css"
    
    /// The local path for Lucide font directory.
    ///
    /// This is where the downloaded font files are typically stored.
    public static let localFontPath = "/fonts/"
    
    /// Array containing the local stylesheet path.
    ///
    /// Convenient for use in Document or Website stylesheet arrays when
    /// you're hosting Lucide CSS locally.
    public static let local: [String] = [localPath]
    
    // MARK: - CDN Fallback
    
    /// The CDN URL for the latest Lucide icon font.
    ///
    /// This loads the Lucide CSS from the unpkg.com CDN, which provides
    /// fast global delivery and automatic caching.
    public static let cdnURL = "https://unpkg.com/lucide-static@latest/font/lucide.css"
    
    /// The CDN URL for a specific version of Lucide icon font.
    ///
    /// Use this when you need to pin to a specific version for consistency
    /// across deployments.
    ///
    /// - Parameter version: The version string (e.g., "0.294.0")
    /// - Returns: The versioned CDN URL
    public static func cdnURL(version: String) -> String {
        return "https://unpkg.com/lucide-static@\(version)/font/lucide.css"
    }
    
    /// Array containing the CDN stylesheet URL.
    ///
    /// Convenient for use in Document or Website stylesheet arrays.
    public static let cdn: [String] = [cdnURL]
    
    /// Array containing a versioned CDN stylesheet URL.
    ///
    /// - Parameter version: The version string (e.g., "0.294.0")
    /// - Returns: Array with the versioned CDN URL
    public static func cdn(version: String) -> [String] {
        return [cdnURL(version: version)]
    }
    
    // MARK: - Optimized Asset Loading
    
    /// Optimized stylesheets that prefer local assets over CDN.
    ///
    /// This property automatically determines whether to use local or CDN assets
    /// based on availability. It provides the best performance by prioritizing
    /// locally hosted assets.
    ///
    /// **Performance benefits of local assets:**
    /// - Faster loading (no external DNS resolution)
    /// - Better caching control
    /// - Offline support
    /// - No external dependencies
    /// - Enhanced privacy (no third-party requests)
    public static var optimized: [String] {
        if isLocalAssetAvailable() {
            return local
        } else {
            return cdn
        }
    }
    
    /// Optimized stylesheets with version pinning that prefer local assets over CDN.
    ///
    /// - Parameter version: The version string for CDN fallback (e.g., "0.294.0")
    /// - Returns: Array with local path if available, otherwise versioned CDN URL
    public static func optimized(version: String) -> [String] {
        if isLocalAssetAvailable() {
            return local
        } else {
            return cdn(version: version)
        }
    }
    
    // MARK: - Asset Detection
    
    /// Checks if local Lucide assets are available.
    ///
    /// This method attempts to verify that the local CSS file exists and is accessible.
    /// In a web context, this would typically check if the file exists in the public directory.
    ///
    /// - Returns: true if local assets are available and accessible
    private static func isLocalAssetAvailable() -> Bool {
        // In a Swift-based static site generator, we check if the file exists
        // in the expected output location
        let possiblePaths = [
            ".output/public\(localPath)",
            "public\(localPath)",
            "Resources\(localPath)"
        ]
        
        return possiblePaths.contains { path in
            FileManager.default.fileExists(atPath: path)
        }
    }
    
    /// Checks if any Lucide icons are used in the given HTML content.
    ///
    /// This method can be used to conditionally include Lucide CSS only
    /// when icons are actually used on a page.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: true if Lucide icon classes are found
    public static func containsLucideIcons(in content: String) -> Bool {
        return content.contains("lucide-") || content.contains("class=\"lucide")
    }
    
    /// Returns optimized stylesheets only if Lucide icons are detected in content.
    ///
    /// This method provides automatic optimization by only including
    /// Lucide CSS when icons are actually used, and preferring local assets.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: Array with optimized stylesheet URLs if icons are found, empty array otherwise
    public static func conditionalOptimized(for content: String) -> [String] {
        return containsLucideIcons(in: content) ? optimized : []
    }
    
    /// Returns CDN stylesheets only if Lucide icons are detected in content.
    ///
    /// This method provides automatic optimization by only including
    /// Lucide CSS when icons are actually used.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: Array with CDN URL if icons are found, empty array otherwise
    public static func conditionalCDN(for content: String) -> [String] {
        return containsLucideIcons(in: content) ? cdn : []
    }
    
    /// Returns local stylesheets only if Lucide icons are detected in content.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: Array with local path if icons are found, empty array otherwise
    public static func conditionalLocal(for content: String) -> [String] {
        return containsLucideIcons(in: content) ? local : []
    }
    
    // MARK: - Build Integration
    
    /// Information about asset optimization status.
    ///
    /// This can be used by build tools to provide feedback about
    /// whether assets are optimized or require downloading.
    public static var optimizationStatus: (isOptimized: Bool, recommendation: String) {
        let isOptimized = isLocalAssetAvailable()
        let recommendation = isOptimized
            ? "✅ Lucide assets are optimized (using local files)"
            : "⚠️  Consider running asset optimization script for better performance"
        
        return (isOptimized, recommendation)
    }
    
    /// Generates a font-face CSS block for local Lucide fonts.
    ///
    /// This method generates the CSS needed to load locally hosted Lucide fonts
    /// with proper fallbacks and optimization.
    ///
    /// - Returns: CSS string for font-face declarations
    public static func generateLocalFontCSS() -> String {
        return """
        @font-face {
            font-family: 'lucide';
            src: url('\(localFontPath)lucide.woff2') format('woff2'),
                 url('\(localFontPath)lucide.woff') format('woff'),
                 url('\(localFontPath)lucide.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
            font-display: swap;
        }
        
        .lucide {
            font-family: 'lucide' !important;
            speak: never;
            font-style: normal;
            font-weight: normal;
            font-variant: normal;
            text-transform: none;
            line-height: 1;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        """
    }
}

/// Extension to Document for easy optimized Lucide CSS inclusion.
extension Document {
    /// Stylesheets that include optimized Lucide CSS.
    ///
    /// This computed property automatically includes the most performant
    /// Lucide CSS option available (local assets preferred over CDN).
    ///
    /// ## Example
    /// ```swift
    /// struct MyPage: Document {
    ///     var stylesheets: [String]? {
    ///         withLucideOptimized
    ///     }
    /// }
    /// ```
    public var withLucideOptimized: [String] {
        let existing = stylesheets ?? []
        return existing + LucideStyles.optimized
    }
    
    /// Stylesheets that include Lucide CSS via CDN.
    ///
    /// Use this computed property when you want to automatically include
    /// Lucide CSS in your document via CDN (bypassing local optimization).
    ///
    /// ## Example
    /// ```swift
    /// struct MyPage: Document {
    ///     var stylesheets: [String]? {
    ///         withLucideCDN
    ///     }
    /// }
    /// ```
    public var withLucideCDN: [String] {
        let existing = stylesheets ?? []
        return existing + LucideStyles.cdn
    }
    
    /// Stylesheets that include local Lucide CSS.
    ///
    /// Use this computed property when you want to automatically include
    /// locally hosted Lucide CSS in your document.
    ///
    /// ## Example
    /// ```swift
    /// struct MyPage: Document {
    ///     var stylesheets: [String]? {
    ///         withLucideLocal
    ///     }
    /// }
    /// ```
    public var withLucideLocal: [String] {
        let existing = stylesheets ?? []
        return existing + LucideStyles.local
    }
}