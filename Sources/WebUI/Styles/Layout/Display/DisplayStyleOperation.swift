import Foundation

/// Style operation for display styling
///
/// Provides a unified implementation for display styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct DisplayStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for display styling
    public struct Parameters {
        /// The display type
        public let type: DisplayType

        /// Creates parameters for display styling
        ///
        /// - Parameter type: The display type
        public init(type: DisplayType) {
            self.type = type
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: DisplayStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                type: params.get("type")!
            )
        }
    }

    /// Applies the display style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for display styling
    /// - Returns: An array of stylesheet class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        ["display-\(params.type.rawValue)"]
    }

    /// Shared instance for use across the framework
    public static let shared = DisplayStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide display styling
extension Markup {
    /// Sets the CSS display property with optional modifiers.
    ///
    /// - Parameters:
    ///   - type: The display type to apply.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated display classes.
    ///
    /// ## Example
    /// ```swift
    /// // Make an element a block
    /// Element(tag: "span").display(.block)
    ///
    /// // Make an element inline-block on hover
    /// Element(tag: "div").display(.inlineBlock, on: .hover)
    ///
    /// // Display as table on medium screens and up
    /// Element(tag: "div").display(.table, on: .md)
    /// ```
    public func display(
        _ type: DisplayType,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = DisplayStyleOperation.Parameters(type: type)

        return DisplayStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide display styling
extension ResponsiveBuilder {
    /// Sets the CSS display property in a responsive context.
    ///
    /// - Parameter type: The display type to apply.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func display(_ type: DisplayType) -> ResponsiveBuilder {
        let params = DisplayStyleOperation.Parameters(type: type)

        return DisplayStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Sets the CSS display property in the responsive context.
///
/// - Parameter type: The display type to apply.
/// - Returns: A responsive modification for display.
public func display(_ type: DisplayType) -> ResponsiveModification {
    let params = DisplayStyleOperation.Parameters(type: type)

    return DisplayStyleOperation.shared.asModification(params: params)
}
