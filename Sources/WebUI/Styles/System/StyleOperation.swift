import Foundation

/// Protocol defining a unified style operation that can be used across different styling contexts
///
/// This protocol enables defining a style operation once and reusing it across Element methods
/// and the Declaritive DSL functions, ensuring consistency and maintainability.
public protocol StyleOperation {
    /// The parameters type used by this style operation
    associatedtype Parameters

    /// Applies the style operation and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for this style operation
    /// - Returns: An array of stylesheet class names to be applied
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

/// A modifier to add classes to a markup element
public struct StyleModifier<T: Markup>: Markup {
    private let content: T
    private let classes: [String]

    public init(content: T, classes: [String]) {
        self.content = content
        self.classes = classes
    }

    public var body: some Markup {
        content.addingClasses(classes)
    }
}

/// A utility for adapting style operations to Element extensions
extension StyleOperation {
    /// Applies the style operation and returns the appropriate stylesheet classes (improved clarity)
    ///
    /// - Parameter configuration: The parameters for this style operation
    /// - Returns: An array of stylesheet class names to be applied
    public func applyClasses(using configuration: Parameters) -> [String] {
        applyClasses(params: configuration)
    }
    /// Adapts this style operation for use with Element extensions
    ///
    /// - Parameters:
    ///   - content: The markup content to apply styles to
    ///   - params: The parameters for this style operation
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: A new element with the styles applied
    public func applyTo<T: Markup>(
        _ content: T, params: Parameters, modifiers: [Modifier] = []
    ) -> StyleModifier<T> {
        let classes = applyClasses(params: params)
        let newClasses = StyleUtilities.combineClasses(
            classes, withModifiers: modifiers)

        return StyleModifier(content: content, classes: newClasses)
    }

    /// Applies style to an element and returns the modified element
    ///
    /// - Parameters:
    ///   - element: The element to apply styles to
    ///   - params: The parameters for this style operation
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: A new element with the styles applied
    public func applyToElement<T: Markup>(
        _ element: T, params: Parameters, modifiers: Modifier...
    ) -> StyleModifier<T> {
        applyTo(element, params: params, modifiers: modifiers)
    }

    /// Internal adapter for use with the responsive builder
    ///
    /// - Parameters:
    ///   - builder: The responsive builder to apply styles to
    ///   - params: The parameters for this style operation
    /// - Returns: The builder for method chaining
    public func applyToBuilder(_ builder: ResponsiveBuilder, params: Parameters)
        -> ResponsiveBuilder
    {
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

    // MARK: - Improved Clarity Methods

    /// Adapts this style operation for use with Element extensions (improved clarity)
    ///
    /// - Parameters:
    ///   - content: The markup content to apply styles to
    ///   - configuration: The parameters for this style operation
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: A new element with the styles applied
    public func applyTo<T: Markup>(
        _ content: T, using configuration: Parameters, modifiers: [Modifier] = []
    ) -> StyleModifier<T> {
        applyTo(content, params: configuration, modifiers: modifiers)
    }

    /// Applies style to an element and returns the modified element (improved clarity)
    ///
    /// - Parameters:
    ///   - element: The element to apply styles to
    ///   - configuration: The parameters for this style operation
    ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
    /// - Returns: A new element with the styles applied
    public func applyToElement<T: Markup>(
        _ element: T, using configuration: Parameters, modifiers: Modifier...
    ) -> StyleModifier<T> {
        applyTo(element, params: configuration, modifiers: Array(modifiers))
    }

    /// Internal adapter for use with the responsive builder (improved clarity)
    ///
    /// - Parameters:
    ///   - builder: The responsive builder to apply styles to
    ///   - configuration: The parameters for this style operation
    /// - Returns: The builder for method chaining
    public func applyToBuilder(_ builder: ResponsiveBuilder, using configuration: Parameters)
        -> ResponsiveBuilder
    {
        applyToBuilder(builder, params: configuration)
    }

    /// Adapts this style operation for use with the Declaritive result builder syntax (improved clarity)
    ///
    /// - Parameter configuration: The parameters for this style operation
    /// - Returns: A responsive modification that can be used in responsive blocks
    public func asModification(using configuration: Parameters) -> ResponsiveModification {
        asModification(params: configuration)
    }
}
