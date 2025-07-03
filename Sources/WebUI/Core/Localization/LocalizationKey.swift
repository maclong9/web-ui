import Foundation

/// Represents a localization key that can be resolved to localized text content.
///
/// This type follows SwiftUI's localization patterns, allowing developers to use
/// string literals that are automatically resolved to localized content based on
/// the current locale and available string resources.
///
/// ## Example
/// ```swift
/// Text("welcome_message")  // Resolves to localized welcome message
/// Text("user_count", arguments: [String(userCount)])  // With interpolation
/// ```
public struct LocalizationKey: ExpressibleByStringLiteral {
    /// The key used to look up the localized string
    public let key: String
    
    /// Optional arguments for string interpolation
    public let arguments: [String]
    
    /// Optional table name for organizing localization strings
    public let tableName: String?
    
    /// Optional bundle to search for localization resources
    public let bundle: Bundle?
    
    /// Creates a localization key with the specified parameters
    ///
    /// - Parameters:
    ///   - key: The localization key to resolve
    ///   - arguments: Optional arguments for string interpolation  
    ///   - tableName: Optional table name for string organization
    ///   - bundle: Optional bundle containing localization resources
    public init(
        _ key: String,
        arguments: [String] = [],
        tableName: String? = nil,
        bundle: Bundle? = nil
    ) {
        self.key = key
        self.arguments = arguments
        self.tableName = tableName
        self.bundle = bundle
    }
    
    /// Creates a localization key from a string literal
    ///
    /// This enables the convenient syntax: `Text("welcome_message")`
    /// where the string literal is automatically treated as a localization key.
    ///
    /// - Parameter value: The string literal to use as a localization key
    public init(stringLiteral value: String) {
        self.key = value
        self.arguments = []
        self.tableName = nil
        self.bundle = nil
    }
    
    /// Creates a localization key with interpolation arguments
    ///
    /// - Parameters:
    ///   - key: The localization key to resolve
    ///   - arguments: Arguments for string interpolation
    /// - Returns: A localization key configured for interpolation
    public static func interpolated(_ key: String, arguments: [String]) -> LocalizationKey {
        return LocalizationKey(key, arguments: arguments)
    }
    
    /// Creates a localization key with a specific table
    ///
    /// - Parameters:
    ///   - key: The localization key to resolve
    ///   - tableName: The table name containing the localization strings
    /// - Returns: A localization key configured for the specified table
    public static func fromTable(_ key: String, tableName: String) -> LocalizationKey {
        return LocalizationKey(key, tableName: tableName)
    }
}

/// Protocol for types that can resolve localization keys to strings
public protocol LocalizationResolver {
    /// Resolves a localization key to its localized string representation
    ///
    /// - Parameter key: The localization key to resolve
    /// - Returns: The localized string, or the key itself if no localization is found
    func resolveLocalizationKey(_ key: LocalizationKey) -> String
}

/// Default localization resolver that uses Foundation's NSLocalizedString
public struct FoundationLocalizationResolver: LocalizationResolver {
    public init() {}
    
    public func resolveLocalizationKey(_ key: LocalizationKey) -> String {
        let bundle = key.bundle ?? Bundle.main
        let tableName = key.tableName
        
        let localizedString = NSLocalizedString(
            key.key,
            tableName: tableName,
            bundle: bundle,
            comment: ""
        )
        
        // If no arguments for interpolation, return the localized string directly
        guard !key.arguments.isEmpty else {
            return localizedString
        }
        
        // Perform string interpolation with provided arguments
        return performStringInterpolation(localizedString, arguments: key.arguments)
    }
    
    private func performStringInterpolation(_ format: String, arguments: [String]) -> String {
        // Simple string interpolation implementation
        // Replaces %@ placeholders with provided arguments in order
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