import Foundation

/// Provides common styling utilities for HTML elements
public enum ElementStyling {
    /// Applies CSS classes to HTML content
    ///
    /// - Parameters:
    ///   - content: The HTML content to apply classes to
    ///   - classes: The CSS classes to apply
    /// - Returns: HTML content with classes applied
    public static func applyClasses<T: HTML>(_ content: T, classes: [String])
        -> some HTML
    {
        content.addingClasses(classes)
    }

    /// Combines base classes with modifier classes
    ///
    /// - Parameters:
    ///   - baseClasses: The base CSS classes
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: Combined array of CSS classes
    public static func combineClasses(
        _ baseClasses: [String], withModifiers modifiers: [Modifier]
    ) -> [String] {
        guard !modifiers.isEmpty else {
            return baseClasses
        }

        let modifierPrefix = modifiers.map { $0.rawValue }.joined()
        return baseClasses.map { "\(modifierPrefix)\($0)" }
    }
}

/// Extension to provide styling helpers for HTML protocol
extension HTML {
    /// Adds CSS classes to an HTML element
    ///
    /// - Parameter classNames: The CSS class names to add
    /// - Returns: HTML with the classes applied
    public func addClass(_ classNames: String...) -> some HTML {
        addingClasses(classNames)
    }

    /// Adds CSS classes to an HTML element
    ///
    /// - Parameter classNames: The CSS class names to add
    /// - Returns: HTML with the classes applied
    public func addClasses(_ classNames: [String]) -> some HTML {
        addingClasses(classNames)
    }

    /// Applies a style with modifier to the element
    ///
    /// - Parameters:
    ///   - baseClasses: The base CSS classes to apply
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: HTML with the styled classes applied
    public func applyStyle(baseClasses: [String], modifiers: [Modifier] = [])
        -> some HTML
    {
        let classes = ElementStyling.combineClasses(
            baseClasses, withModifiers: modifiers)
        return addingClasses(classes)
    }
}
