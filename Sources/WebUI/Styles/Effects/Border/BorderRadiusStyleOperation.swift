import Foundation

/// Style operation for border radius styling
///
/// Provides a unified implementation for border radius styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct BorderRadiusStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for border radius styling
    public struct Parameters {
        /// The border radius size
        public let size: RadiusSize?

        /// The sides to apply the radius to
        public let sides: [RadiusSide]

        /// Creates parameters for border radius styling
        ///
        /// - Parameters:
        ///   - size: The border radius size
        ///   - sides: The sides to apply the radius to
        public init(
            size: RadiusSize? = .md,
            sides: [RadiusSide] = [.all]
        ) {
            self.size = size
            self.sides = sides.isEmpty ? [.all] : sides
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: BorderRadiusStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                size: params.get("size"),
                sides: params.get("sides", default: [.all])
            )
        }
    }

    /// Applies the border radius style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for border radius styling
    /// - Returns: An array of stylesheet class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []
        let size = params.size
        let sides = params.sides

        for side in sides {
            let sidePrefix = side == .all ? "" : "-\(side.rawValue)"
            let sizeValue = size != nil ? "-\(size!.rawValue)" : ""

            classes.append("rounded\(sidePrefix)\(sizeValue)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = BorderRadiusStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide border radius styling
extension Markup {
    /// Applies border radius styling to the element.
    ///
    /// - Parameters:
    ///   - size: The radius size from none to full.
    ///   - sides: Zero or more sides to apply the radius to. Defaults to all sides.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated border radius classes.
    ///
    /// ## Example
    /// ```swift
    /// Button() { "Sign Up" }
    ///   .rounded(.lg)
    ///
    /// Stack(classes: ["card"])
    ///   .rounded(.xl, .top)
    ///   .rounded(.lg, .bottom, on: .hover)
    /// ```
    public func rounded(
        _ size: RadiusSize? = .md,
        _ sides: RadiusSide...,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = BorderRadiusStyleOperation.Parameters(
            size: size,
            sides: sides
        )

        return BorderRadiusStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide border radius styling
extension ResponsiveBuilder {
    /// Applies border radius styling in a responsive context.
    ///
    /// - Parameters:
    ///   - size: The radius size from none to full.
    ///   - sides: Zero or more sides to apply the radius to.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func rounded(
        _ size: RadiusSize? = .md,
        _ sides: RadiusSide...
    ) -> ResponsiveBuilder {
        let params = BorderRadiusStyleOperation.Parameters(
            size: size,
            sides: sides
        )

        return BorderRadiusStyleOperation.shared.applyToBuilder(
            self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies border radius styling in the responsive context.
///
/// - Parameters:
///   - size: The radius size from none to full.
///   - sides: The sides to apply the radius to.
/// - Returns: A responsive modification for border radius.
public func rounded(
    _ size: RadiusSize? = .md,
    _ sides: RadiusSide...
) -> ResponsiveModification {
    let params = BorderRadiusStyleOperation.Parameters(
        size: size,
        sides: sides
    )

    return BorderRadiusStyleOperation.shared.asModification(params: params)
}
