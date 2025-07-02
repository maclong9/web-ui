import Foundation

/// Style operation for opacity styling
///
/// Provides a unified implementation for opacity styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct OpacityStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for opacity styling
    public struct Parameters {
        /// The opacity value (0-100)
        public let value: Int

        /// Creates parameters for opacity styling
        ///
        /// - Parameter value: The opacity value (0-100)
        public init(value: Int) {
            self.value = value
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: OpacityStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                value: params.get("value")!
            )
        }
    }

    /// Applies the opacity style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for opacity styling
    /// - Returns: An array of stylesheet class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        ["opacity-\(params.value)"]
    }

    /// Shared instance for use across the framework
    public static let shared = OpacityStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide opacity styling
extension Markup {
    /// Sets the opacity of the element with optional modifiers.
    ///
    /// - Parameters:
    ///   - value: The opacity value, typically between 0 and 100.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: Markup with updated opacity classes including applied modifiers.
    ///
    /// ## Example
    /// ```swift
    /// Image(source: "/images/profile.jpg", description: "Profile Photo")
    ///   .opacity(50)
    ///   .opacity(100, on: .hover)
    /// ```
    public func opacity(
        _ value: Int,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = OpacityStyleOperation.Parameters(value: value)

        return OpacityStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide opacity styling
extension ResponsiveBuilder {
    /// Applies opacity styling in a responsive context.
    ///
    /// - Parameter value: The opacity value (0-100).
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func opacity(_ value: Int) -> ResponsiveBuilder {
        let params = OpacityStyleOperation.Parameters(value: value)

        return OpacityStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies opacity styling in the responsive context.
///
/// - Parameter value: The opacity value (0-100).
/// - Returns: A responsive modification for opacity.
public func opacity(_ value: Int) -> ResponsiveModification {
    let params = OpacityStyleOperation.Parameters(value: value)

    return OpacityStyleOperation.shared.asModification(params: params)
}
