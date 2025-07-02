import Foundation

/// Style operation for z-index styling
///
/// Provides a unified implementation for z-index styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct ZIndexStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for z-index styling
    public struct Parameters {
        /// The z-index value
        public let value: Int

        /// Creates parameters for z-index styling
        ///
        /// - Parameter value: The z-index value
        public init(value: Int) {
            self.value = value
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: ZIndexStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                value: params.get("value")!
            )
        }
    }

    /// Applies the z-index style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for z-index styling
    /// - Returns: An array of stylesheet class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        ["z-\(params.value)"]
    }

    /// Shared instance for use across the framework
    public static let shared = ZIndexStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide z-index styling
extension Markup {
    /// Applies a z-index to the element.
    ///
    /// Sets the stacking order of the element, optionally scoped to modifiers.
    ///
    /// - Parameters:
    ///   - value: Specifies the z-index value as an integer.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: Markup with updated z-index classes.
    ///
    /// ## Example
    /// ```swift
    /// // Header that stays on top of other content
    /// Header()
    ///   .zIndex(50)
    ///
    /// // Dropdown menu that appears above other elements when activated
    /// Stack(classes: ["dropdown-menu"])
    ///   .zIndex(10, on: .hover)
    /// ```
    public func zIndex(
        _ value: Int,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = ZIndexStyleOperation.Parameters(value: value)

        return ZIndexStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide z-index styling
extension ResponsiveBuilder {
    /// Applies z-index styling in a responsive context.
    ///
    /// - Parameter value: The z-index value.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func zIndex(_ value: Int) -> ResponsiveBuilder {
        let params = ZIndexStyleOperation.Parameters(value: value)

        return ZIndexStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies z-index styling in the responsive context.
///
/// - Parameter value: The z-index value.
/// - Returns: A responsive modification for z-index.
public func zIndex(_ value: Int) -> ResponsiveModification {
    let params = ZIndexStyleOperation.Parameters(value: value)

    return ZIndexStyleOperation.shared.asModification(params: params)
}
