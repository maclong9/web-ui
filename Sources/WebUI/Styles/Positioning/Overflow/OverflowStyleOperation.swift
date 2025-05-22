import Foundation

/// Style operation for overflow styling
///
/// Provides a unified implementation for overflow styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct OverflowStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for overflow styling
    public struct Parameters {
        /// The overflow type
        public let type: OverflowType

        /// The axis to apply overflow to
        public let axis: Axis

        /// Creates parameters for overflow styling
        ///
        /// - Parameters:
        ///   - type: The overflow type
        ///   - axis: The axis to apply overflow to
        public init(
            type: OverflowType,
            axis: Axis = .both
        ) {
            self.type = type
            self.axis = axis
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: OverflowStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                type: params.get("type")!,
                axis: params.get("axis", default: .both)
            )
        }
    }

    /// Applies the overflow style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for overflow styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        let axisString = params.axis.rawValue.isEmpty ? "" : "-\(params.axis.rawValue)"
        return ["overflow\(axisString)-\(params.type.rawValue)"]
    }

    /// Shared instance for use across the framework
    public static let shared = OverflowStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide overflow styling
extension Element {
    /// Applies overflow styling to the element.
    ///
    /// Sets how overflowing content is handled, optionally on a specific axis and with modifiers.
    ///
    /// - Parameters:
    ///   - type: Determines the overflow behavior (e.g., hidden, scroll).
    ///   - axis: Specifies the axis for overflow (defaults to both).
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated overflow classes.
    ///
    /// ## Example
    /// ```swift
    /// Stack(classes: ["content-container"])
    ///   .overflow(.scroll, axis: .y)
    ///   .frame(height: .spacing(300))
    ///
    /// Stack(classes: ["image-container"])
    ///   .overflow(.hidden)
    ///   .rounded(.lg)
    /// ```
    public func overflow(
        _ type: OverflowType,
        axis: Axis = .both,
        on modifiers: Modifier...
    ) -> Element {
        let params = OverflowStyleOperation.Parameters(
            type: type,
            axis: axis
        )

        return OverflowStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide overflow styling
extension ResponsiveBuilder {
    /// Applies overflow styling in a responsive context.
    ///
    /// - Parameters:
    ///   - type: The overflow type.
    ///   - axis: The axis to apply overflow to.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func overflow(
        _ type: OverflowType,
        axis: Axis = .both
    ) -> ResponsiveBuilder {
        let params = OverflowStyleOperation.Parameters(
            type: type,
            axis: axis
        )

        return OverflowStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies overflow styling in the responsive context.
///
/// - Parameters:
///   - type: The overflow type.
///   - axis: The axis to apply overflow to.
/// - Returns: A responsive modification for overflow.
public func overflow(
    _ type: OverflowType,
    axis: Axis = .both
) -> ResponsiveModification {
    let params = OverflowStyleOperation.Parameters(
        type: type,
        axis: axis
    )

    return OverflowStyleOperation.shared.asModification(params: params)
}
