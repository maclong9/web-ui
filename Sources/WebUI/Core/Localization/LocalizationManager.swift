import Foundation

/// Manages localization state and provides string resolution for WebUI components
///
/// The `LocalizationManager` serves as the central point for managing localization
/// within WebUI applications. It tracks the current locale, manages localization
/// resolvers, and provides utilities for detecting and resolving localization keys.
///
/// ## Usage
/// ```swift
/// // Set up localization for your website
/// LocalizationManager.shared.currentLocale = Locale(identifier: "es")
/// LocalizationManager.shared.resolver = CustomLocalizationResolver()
/// 
/// // Text components will automatically use the configured localization
/// Text("welcome_message")  // Resolves using current locale and resolver
/// ```
public final class LocalizationManager: @unchecked Sendable {
    /// Shared instance for global localization management
    public static let shared = LocalizationManager()
    
    /// Current locale for localization resolution
    public var currentLocale: Locale = .en {
        didSet {
            // Notify components that locale has changed if needed
            // This could be extended to support reactive updates
        }
    }
    
    /// The resolver used to convert localization keys to strings
    public var resolver: LocalizationResolver = FoundationLocalizationResolver()
    
    /// Whether localization is enabled globally
    public var isLocalizationEnabled: Bool = true
    
    private init() {}
    
    /// Resolves a localization key to its string representation
    ///
    /// This method serves as the main entry point for localization resolution.
    /// It handles fallback logic and determines whether a string should be
    /// treated as a localization key or used as-is.
    ///
    /// - Parameter key: The localization key to resolve
    /// - Returns: The resolved localized string
    public func resolveKey(_ key: LocalizationKey) -> String {
        guard isLocalizationEnabled else {
            return key.key
        }
        
        return resolver.resolveLocalizationKey(key)
    }
    
    /// Determines if a string should be treated as a localization key
    ///
    /// This heuristic helps identify strings that are likely localization keys
    /// versus regular text content. The detection is based on common localization
    /// key patterns used in software development.
    ///
    /// - Parameter text: The text to analyze
    /// - Returns: true if the text appears to be a localization key
    public func isLikelyLocalizationKey(_ text: String) -> Bool {
        // Skip very short strings (likely not localization keys)
        guard text.count >= 2 else { return false }
        
        // Skip strings that are clearly regular sentences
        if text.contains(" ") && text.count > 50 {
            return false
        }
        
        // Check for common localization key patterns
        let hasUnderscores = text.contains("_")
        let hasDots = text.contains(".")
        let isAllLowercase = text == text.lowercased()
        let hasNoSpaces = !text.contains(" ")
        
        // Common patterns for localization keys:
        // - snake_case: "welcome_message", "user_profile_title"
        // - dot.notation: "app.welcome.message", "error.network.timeout"
        // - Mixed patterns: "button.save_changes"
        return (hasUnderscores || hasDots) && isAllLowercase && hasNoSpaces
    }
    
    /// Resolves a string that may or may not be a localization key
    ///
    /// This method provides automatic detection of localization keys within
    /// regular text content. If the text appears to be a localization key,
    /// it will be resolved. Otherwise, the original text is returned.
    ///
    /// - Parameter text: The text to potentially resolve
    /// - Returns: The resolved text or original text if not a localization key
    public func resolveIfLocalizationKey(_ text: String) -> String {
        guard isLikelyLocalizationKey(text) else {
            return text
        }
        
        let key = LocalizationKey(text)
        return resolveKey(key)
    }
    
    /// Sets up localization for a specific locale and bundle
    ///
    /// - Parameters:
    ///   - locale: The locale to use for localization
    ///   - bundle: Optional bundle containing localization resources
    ///   - resolver: Optional custom resolver to use
    public func configure(
        locale: Locale,
        bundle: Bundle? = nil,
        resolver: LocalizationResolver? = nil
    ) {
        self.currentLocale = locale
        
        if let customResolver = resolver {
            self.resolver = customResolver
        } else if let bundle = bundle {
            self.resolver = BundleLocalizationResolver(bundle: bundle)
        }
    }
}

/// Localization resolver that uses a specific bundle for string resolution
public struct BundleLocalizationResolver: LocalizationResolver {
    private let bundle: Bundle
    
    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    public func resolveLocalizationKey(_ key: LocalizationKey) -> String {
        let targetBundle = key.bundle ?? bundle
        let tableName = key.tableName
        
        let localizedString = NSLocalizedString(
            key.key,
            tableName: tableName,
            bundle: targetBundle,
            comment: ""
        )
        
        guard !key.arguments.isEmpty else {
            return localizedString
        }
        
        return performStringInterpolation(localizedString, arguments: key.arguments)
    }
    
    private func performStringInterpolation(_ format: String, arguments: [String]) -> String {
        var result = format
        var argumentIndex = 0
        
        while result.contains("%@") && argumentIndex < arguments.count {
            if let range = result.range(of: "%@") {
                result.replaceSubrange(range, with: arguments[argumentIndex])
                argumentIndex += 1
            }
        }
        
        return result
    }
}