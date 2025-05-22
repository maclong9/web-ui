import Foundation

/// Style operation for transform styling
///
/// Provides a unified implementation for transform styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct TransformStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for transform styling
    public struct Parameters {
        /// The scale values (x, y)
        public let scale: (x: Int?, y: Int?)?

        /// The rotation angle in degrees
        public let rotate: Int?

        /// The translation values (x, y)
        public let translate: (x: Int?, y: Int?)?

        /// The skew values (x, y)
        public let skew: (x: Int?, y: Int?)?

        /// Creates parameters for transform styling
        ///
        /// - Parameters:
        ///   - scale: The scale values (x, y)
        ///   - rotate: The rotation angle in degrees
        ///   - translate: The translation values (x, y)
        ///   - skew: The skew values (x, y)
        public init(
            scale: (x: Int?, y: Int?)? = nil,
            rotate: Int? = nil,
            translate: (x: Int?, y: Int?)? = nil,
            skew: (x: Int?, y: Int?)? = nil
        ) {
            self.scale = scale
            self.rotate = rotate
            self.translate = translate
            self.skew = skew
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: TransformStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                scale: params.get("scale"),
                rotate: params.get("rotate"),
                translate: params.get("translate"),
                skew: params.get("skew")
            )
        }
    }

    /// Applies the transform style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for transform styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = ["transform"]

        if let scaleTuple = params.scale {
            if let x = scaleTuple.x { classes.append("scale-x-\(x)") }
            if let y = scaleTuple.y { classes.append("scale-y-\(y)") }
        }

        if let rotate = params.rotate {
            classes.append(rotate < 0 ? "-rotate-\(-rotate)" : "rotate-\(rotate)")
        }

        if let translateTuple = params.translate {
            if let x = translateTuple.x {
                classes.append(x < 0 ? "-translate-x-\(-x)" : "translate-x-\(x)")
            }
            if let y = translateTuple.y {
                classes.append(y < 0 ? "-translate-y-\(-y)" : "translate-y-\(y)")
            }
        }

        if let skewTuple = params.skew {
            if let x = skewTuple.x {
                classes.append(x < 0 ? "-skew-x-\(-x)" : "skew-x-\(x)")
            }
            if let y = skewTuple.y {
                classes.append(y < 0 ? "-skew-y-\(-y)" : "skew-y-\(y)")
            }
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = TransformStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide transform styling
extension Element {
    /// Applies transformation styling to the element.
    ///
    /// Adds classes for scaling, rotating, translating, and skewing, optionally scoped to modifiers.
    /// Transform values are provided as (x: Int?, y: Int?) tuples for individual axis control.
    ///
    /// - Parameters:
    ///   - scale: Sets scale factor(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - rotate: Specifies the rotation angle in degrees.
    ///   - translate: Sets translation distance(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - skew: Sets skew angle(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated transform classes.
    public func transform(
        scale: (x: Int?, y: Int?)? = nil,
        rotate: Int? = nil,
        translate: (x: Int?, y: Int?)? = nil,
        skew: (x: Int?, y: Int?)? = nil,
        on modifiers: Modifier...
    ) -> Element {
        let params = TransformStyleOperation.Parameters(
            scale: scale,
            rotate: rotate,
            translate: translate,
            skew: skew
        )

        return TransformStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide transform styling
extension ResponsiveBuilder {
    /// Applies transform styling in a responsive context.
    ///
    /// - Parameters:
    ///   - scale: The scale values (x, y).
    ///   - rotate: The rotation angle in degrees.
    ///   - translate: The translation values (x, y).
    ///   - skew: The skew values (x, y).
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func transform(
        scale: (x: Int?, y: Int?)? = nil,
        rotate: Int? = nil,
        translate: (x: Int?, y: Int?)? = nil,
        skew: (x: Int?, y: Int?)? = nil
    ) -> ResponsiveBuilder {
        let params = TransformStyleOperation.Parameters(
            scale: scale,
            rotate: rotate,
            translate: translate,
            skew: skew
        )

        return TransformStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies transform styling in the responsive context.
///
/// - Parameters:
///   - scale: The scale values (x, y).
///   - rotate: The rotation angle in degrees.
///   - translate: The translation values (x, y).
///   - skew: The skew values (x, y).
/// - Returns: A responsive modification for transform.
public func transform(
    scale: (x: Int?, y: Int?)? = nil,
    rotate: Int? = nil,
    translate: (x: Int?, y: Int?)? = nil,
    skew: (x: Int?, y: Int?)? = nil
) -> ResponsiveModification {
    let params = TransformStyleOperation.Parameters(
        scale: scale,
        rotate: rotate,
        translate: translate,
        skew: skew
    )

    return TransformStyleOperation.shared.asModification(params: params)
}
