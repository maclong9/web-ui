import Foundation

/// Utility for managing Lucide icon font styles in documents.
///
/// This utility provides convenient methods for including the Lucide CSS
/// in your documents, either via CDN or local assets. It can be used
/// directly in Document implementations or as part of a Website's global styles.
///
/// ## Usage in Document
/// ```swift
/// struct MyPage: Document {
///     var stylesheets: [String]? {
///         LucideStyles.cdn
///     }
/// }
/// ```
///
/// ## Usage in Website
/// ```swift
/// struct MyWebsite: Website {
///     var stylesheets: [String]? {
///         ["/css/styles.css"] + LucideStyles.cdn
///     }
/// }
/// ```
public enum LucideStyles {
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
        "https://unpkg.com/lucide-static@\(version)/font/lucide.css"
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
        [cdnURL(version: version)]
    }

    /// The local path for Lucide CSS assets.
    ///
    /// Use this when you want to serve Lucide CSS from your own domain
    /// for better performance or offline support.
    public static let localPath = "/css/lucide.css"

    /// Array containing the local stylesheet path.
    ///
    /// Convenient for use in Document or Website stylesheet arrays when
    /// you're hosting Lucide CSS locally.
    public static let local: [String] = [localPath]

    /// Checks if any Lucide icons are used in the given HTML content.
    ///
    /// This method can be used to conditionally include Lucide CSS only
    /// when icons are actually used on a page.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: true if Lucide icon classes are found
    public static func containsLucideIcons(in content: String) -> Bool {
        content.contains("lucide-") || content.contains("class=\"lucide")
    }

    /// Returns CDN stylesheets only if Lucide icons are detected in content.
    ///
    /// This method provides automatic optimization by only including
    /// Lucide CSS when icons are actually used.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: Array with CDN URL if icons are found, empty array otherwise
    public static func conditionalCDN(for content: String) -> [String] {
        containsLucideIcons(in: content) ? cdn : []
    }

    /// Returns local stylesheets only if Lucide icons are detected in content.
    ///
    /// - Parameter content: The HTML content to analyze
    /// - Returns: Array with local path if icons are found, empty array otherwise
    public static func conditionalLocal(for content: String) -> [String] {
        containsLucideIcons(in: content) ? local : []
    }
}

/// Extension to Document for easy Lucide CSS inclusion.
extension Document {
    /// Stylesheets that include Lucide CSS via CDN.
    ///
    /// Use this computed property when you want to automatically include
    /// Lucide CSS in your document.
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
