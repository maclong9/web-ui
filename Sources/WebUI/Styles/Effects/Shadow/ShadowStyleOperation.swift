import Foundation

/// Style operation for box shadow styling
///
/// Provides a unified implementation for box shadow styling that can be used across
/// Element methods and the Declaritive DSL functions.
public struct ShadowStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for shadow styling
    public struct Parameters {
        /// The shadow size
        public let size: ShadowSize?

        /// The shadow color
        public let color: Color?

        /// Creates parameters for shadow styling
        ///
        /// - Parameters:
        ///   - size: The shadow size
        ///   - color: The shadow color
        public init(
            size: ShadowSize? = nil,
            color: Color? = nil
        ) {
            self.size = size
            self.color = color
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: ShadowStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                size: params.get("size"),
                color: params.get("color")
            )
        }
    }

    /// Applies the shadow style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for shadow styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []
        let size = params.size ?? ShadowSize.md
        let color = params.color

        classes.append("shadow-\(size.rawValue)")

        if let color = color {
            classes.append("shadow-\(color.rawValue)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = ShadowStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide shadow styling
extension HTML {
    /// Applies shadow styling to the element with specified attributes.
    ///
    /// Adds shadows with custom size and color to an element.
    ///
    /// - Parameters:
    ///   - size: The shadow size (sm, md, lg).
    ///   - color: The shadow color.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: HTML with updated shadow classes.
    ///
    /// ## Example
    /// ```swift
    /// Stack()
    ///   .shadow(size: .lg, color: .blue(._500))
    ///   .shadow(size: .sm, color: .gray(._200), on: .hover)
    /// ```
    public func shadow(
        size: ShadowSize,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = ShadowStyleOperation.Parameters(
            size: size,
            color: color
        )

        return ShadowStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide shadow styling
extension ResponsiveBuilder {
    /// Applies shadow styling in a responsive context.
    ///
    /// - Parameters:
    ///   - size: The shadow size.
    ///   - color: The shadow color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func shadow(
        size: ShadowSize? = .md,
        color: Color? = nil,
    ) -> ResponsiveBuilder {
        let params = ShadowStyleOperation.Parameters(
            size: size,
            color: color
        )

        return ShadowStyleOperation.shared.applyToBuilder(self, params: params)
    }

    /// Helper method to apply just a shadow color.
    ///
    /// - Parameter color: The shadow color to apply.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func shadow(color: Color) -> ResponsiveBuilder {
        let params = ShadowStyleOperation.Parameters(
            size: .md,
            color: color
        )

        return ShadowStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declaritive DSL
/// Applies shadow styling in the responsive context.
///
/// - Parameters:
///   - size: The shadow size.
///   - color: The shadow color.
/// - Returns: A responsive modification for shadows.
public func shadow(
    of size: ShadowSize? = .md,
    color: Color? = nil
) -> ResponsiveModification {
    let params = ShadowStyleOperation.Parameters(
        size: size,
        color: color
    )

    return ShadowStyleOperation.shared.asModification(params: params)
}
