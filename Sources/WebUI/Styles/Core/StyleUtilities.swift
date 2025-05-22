import Foundation

/// Utilities for working with style operations
public enum StyleUtilities {
    /// Converts a varargs parameter to an array
    ///
    /// This is useful for converting the `edges: Edge...` parameter to an array
    /// that can be used with style operations.
    ///
    /// - Parameter varargs: The varargs parameter
    /// - Returns: An array containing the varargs elements, or [.all] if empty
    public static func toArray<T>(_ varargs: T...) -> [T] {
        varargs.isEmpty ? [] : varargs
    }

    /// Safely combines a class with modifiers
    ///
    /// This is a safer version of the combineClasses function that handles
    /// nil or empty arrays gracefully.
    ///
    /// - Parameters:
    ///   - baseClass: The base class name
    ///   - modifiers: The modifiers to apply
    /// - Returns: The combined class names
    public static func combineClass(_ baseClass: String, withModifiers modifiers: [Modifier]) -> [String] {
        if modifiers.isEmpty {
            return [baseClass]
        }

        let modifierPrefix = modifiers.map { modifier in modifier.rawValue }.joined()
        return ["\(modifierPrefix)\(baseClass)"]
    }

    /// Safely combines multiple classes with modifiers
    ///
    /// This is a safer version of the combineClasses function that handles
    /// nil or empty arrays gracefully.
    ///
    /// - Parameters:
    ///   - baseClasses: The base class names
    ///   - modifiers: The modifiers to apply
    /// - Returns: The combined class names
    public static func combineClasses(_ baseClasses: [String], withModifiers modifiers: [Modifier]) -> [String] {
        if baseClasses.isEmpty {
            return []
        }

        if modifiers.isEmpty {
            return baseClasses
        }

        let modifierPrefix = modifiers.map { modifier in modifier.rawValue }.joined()
        return baseClasses.map { baseClass in "\(modifierPrefix)\(baseClass)" }
    }
}
