import Foundation

/// Protocol defining a unified style operation that can be used across different styling contexts
///
/// This protocol enables defining a style operation once and reusing it across Element methods
/// and the Declaritive DSL functions, ensuring consistency and maintainability.
public protocol StyleOperation {
    /// The parameters type used by this style operation
    associatedtype Parameters

    /// Applies the style operation and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for this style operation
    /// - Returns: An array of CSS class names to be applied
    func applyClasses(params: Parameters) -> [String]
}

/// A container for style parameters to simplify parameter passing
public struct StyleParameters {
    /// The underlying storage for parameters
    private var values: [String: Any] = [:]

    /// Creates an empty parameters container
    public init() {}

    /// Sets a parameter value
    ///
    /// - Parameters:
    ///   - key: The parameter name
    ///   - value: The parameter value
    public mutating func set<T>(_ key: String, value: T?) {
        if let value = value {
            values[key] = value
        }
    }

    /// Gets a parameter value
    ///
    /// - Parameter key: The parameter name
    /// - Returns: The parameter value, or nil if not present
    public func get<T>(_ key: String) -> T? {
        values[key] as? T
    }

    /// Gets a parameter value with a default fallback
    ///
    /// - Parameters:
    ///   - key: The parameter name
    ///   - defaultValue: The default value to use if the parameter is not present
    /// - Returns: The parameter value, or the default if not present
    public func get<T>(_ key: String, default defaultValue: T) -> T {
        (values[key] as? T) ?? defaultValue
    }
}

/// A utility for adapting style operations to Element extensions
extension StyleOperation {
    /// Adapts this style operation for use with Element extensions
    ///
    /// - Parameters:
    ///   - element: The element to apply styles to
    ///   - params: The parameters for this style operation
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: A new element with the styles applied
    public func applyToElement(_ element: Element, params: Parameters, modifiers: [Modifier] = []) -> Element {
        let classes = applyClasses(params: params)
        let newClasses = combineClasses(classes, withModifiers: modifiers)

        return Element(
            tag: element.tag,
            id: element.id,
            classes: (element.classes ?? []) + newClasses,
            role: element.role,
            label: element.label,
            data: element.data,
            isSelfClosing: element.isSelfClosing,
            customAttributes: element.customAttributes,
            content: element.contentBuilder
        )
    }

    /// Internal adapter for use with the responsive builder
    ///
    /// - Parameters:
    ///   - builder: The responsive builder to apply styles to
    ///   - params: The parameters for this style operation
    /// - Returns: The builder for method chaining
    public func applyToBuilder(_ builder: ResponsiveBuilder, params: Parameters) -> ResponsiveBuilder {
        let classes = applyClasses(params: params)
        for className in classes {
            builder.addClass(className)
        }
        return builder
    }

    /// Adapts this style operation for use with the Declaritive result builder syntax
    ///
    /// - Parameter params: The parameters for this style operation
    /// - Returns: A responsive modification that can be used in responsive blocks
    public func asModification(params: Parameters) -> ResponsiveModification {
        StyleModification { builder in
            _ = applyToBuilder(builder, params: params)
        }
    }
}
