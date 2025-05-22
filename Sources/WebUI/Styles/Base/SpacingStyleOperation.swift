import Foundation

/// Style operation for spacing styling
///
/// Provides a unified implementation for spacing styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct SpacingStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for spacing styling
    public struct Parameters {
        /// The spacing value
        public let length: Int?

        /// The axis to apply the spacing to
        public let axis: Axis

        /// Creates parameters for spacing styling
        ///
        /// - Parameters:
        ///   - length: The spacing value
        ///   - axis: The axis to apply the spacing to
        public init(
            length: Int? = 4,
            axis: Axis = .both
        ) {
            self.length = length
            self.axis = axis
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: SpacingStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                length: params.get("length"),
                axis: params.get("axis", default: .both)
            )
        }
    }

    /// Applies the spacing style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for spacing styling
    /// - Returns: An array of CSS class names to be applied
    public func applyClasses(params: Parameters) -> [String] {
        guard let length = params.length else {
            return []
        }

        switch params.axis {
        case .horizontal:
            return ["space-x-\(length)"]
        case .vertical:
            return ["space-y-\(length)"]
        case .both:
            return ["space-x-\(length)", "space-y-\(length)"]
        }
    }

    /// Shared instance for use across the framework
    public static let shared = SpacingStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide spacing styling
extension Element {
    /// Applies spacing between child elements horizontally and/or vertically.
    ///
    /// - Parameters:
    ///   - length: The spacing value in `0.25rem` increments.
    ///   - direction: The direction(s) to apply spacing (`horizontal`, `vertical`, or both).
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated spacing classes.
    public func spacing(
        of length: Int? = 4,
        along direction: Axis = .both,
        on modifiers: Modifier...
    ) -> Element {
        let params = SpacingStyleOperation.Parameters(
            length: length,
            axis: direction
        )

        return SpacingStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide spacing styling
extension ResponsiveBuilder {
    /// Applies spacing between child elements in a responsive context.
    ///
    /// - Parameters:
    ///   - length: The spacing value in `0.25rem` increments.
    ///   - direction: The direction(s) to apply spacing (`horizontal`, `vertical`, or both).
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func spacing(
        of length: Int? = 4,
        along direction: Axis = .both
    ) -> ResponsiveBuilder {
        let params = SpacingStyleOperation.Parameters(
            length: length,
            axis: direction
        )

        return SpacingStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies spacing styling in the responsive context with Declarative syntax.
///
/// - Parameters:
///   - length: The spacing value.
///   - direction: The axis to apply spacing to.
/// - Returns: A responsive modification for spacing.
public func spacing(
    of length: Int? = 4,
    along direction: Axis = .both
) -> ResponsiveModification {
    let params = SpacingStyleOperation.Parameters(
        length: length,
        axis: direction
    )

    return SpacingStyleOperation.shared.asModification(params: params)
}
