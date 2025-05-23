import Foundation

/// Style operation for background styling
///
/// Provides a unified implementation for background styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct BackgroundStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for background styling
    public struct Parameters {
        /// The background color
        public let color: Color

        /// Creates parameters for background styling
        ///
        /// - Parameters:
        ///   - color: The background color
        public init(color: Color) {
            self.color = color
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: BackgroundStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                color: params.get("color")!
            )
        }
    }

    /// Applies the background style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for background styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        ["bg-\(params.color.rawValue)"]
    }

    /// Shared instance for use across the framework
    public static let shared = BackgroundStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide background styling
extension HTML {
    /// Applies background color to the element.
    ///
    /// Adds a background color class based on the provided color and optional modifiers.
    /// This method applies Tailwind CSS background color classes to the element.
    ///
    /// - Parameters:
    ///   - color: Sets the background color from the color palette or a custom value.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated background color classes.
    ///
    /// ## Example
    /// ```swift
    /// // Simple background color
    /// Button() { "Submit" }
    ///   .background(color: .green(._500))
    ///
    /// // Background color with modifiers
    /// Button() { "Hover me" }
    ///   .background(color: .white, on: .dark)
    ///   .background(color: .blue(._500), on: .hover)
    /// ```
    public func background(
        color: Color,
        on modifiers: Modifier...
    ) -> any Element {
        let params = BackgroundStyleOperation.Parameters(color: color)

        return BackgroundStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide background styling
extension ResponsiveBuilder {
    /// Applies background color in a responsive context.
    ///
    /// - Parameter color: The background color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func background(color: Color) -> ResponsiveBuilder {
        let params = BackgroundStyleOperation.Parameters(color: color)

        return BackgroundStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies background color styling in the responsive context.
///
/// - Parameter color: The background color.
/// - Returns: A responsive modification for background color.
public func background(color: Color) -> ResponsiveModification {
    let params = BackgroundStyleOperation.Parameters(color: color)

    return BackgroundStyleOperation.shared.asModification(params: params)
}
