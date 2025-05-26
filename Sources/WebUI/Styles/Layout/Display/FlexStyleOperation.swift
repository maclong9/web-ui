import Foundation

/// Style operation for flex container styling
///
/// Provides a unified implementation for flex styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct FlexStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for flex styling
    public struct Parameters {
        /// The flex direction (row, column, etc.)
        public let direction: FlexDirection?

        /// The justify content property (start, center, between, etc.)
        public let justify: FlexJustify?

        /// The align items property (start, center, end, etc.)
        public let align: FlexAlign?

        /// The flex grow property
        public let grow: FlexGrow?

        /// Creates parameters for flex styling
        ///
        /// - Parameters:
        ///   - direction: The flex direction
        ///   - justify: The justify content property
        ///   - align: The align items property
        ///   - grow: The flex grow property
        public init(
            direction: FlexDirection? = nil,
            justify: FlexJustify? = nil,
            align: FlexAlign? = nil,
            grow: FlexGrow? = nil
        ) {
            self.direction = direction
            self.justify = justify
            self.align = align
            self.grow = grow
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: FlexStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                direction: params.get("direction"),
                justify: params.get("justify"),
                align: params.get("align"),
                grow: params.get("grow")
            )
        }
    }

    /// Applies the flex style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for flex styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes = ["flex"]

        if let direction = params.direction {
            classes.append("flex-\(direction.rawValue)")
        }

        if let justify = params.justify {
            classes.append("justify-\(justify.rawValue)")
        }

        if let align = params.align {
            classes.append("items-\(align.rawValue)")
        }

        if let grow = params.grow {
            classes.append("flex-\(grow.rawValue)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = FlexStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

/// Defines the flex direction
public enum FlexDirection: String {
    /// Items are arranged horizontally (left to right)
    case row

    /// Items are arranged horizontally in reverse (right to left)
    case rowReverse = "row-reverse"

    /// Items are arranged vertically (top to bottom)
    case column = "col"

    /// Items are arranged vertically in reverse (bottom to top)
    case columnReverse = "col-reverse"
}

/// Defines how flex items are justified along the main axis
public enum FlexJustify: String {
    /// Items are packed at the start of the container
    case start

    /// Items are packed at the end of the container
    case end

    /// Items are centered along the line
    case center

    /// Items are evenly distributed with equal space between them
    case between

    /// Items are evenly distributed with equal space around them
    case around

    /// Items are evenly distributed with equal space between and around them
    case evenly
}

/// Defines how flex items are aligned along the cross axis
public enum FlexAlign: String {
    /// Items are aligned at the start of the cross axis
    case start

    /// Items are aligned at the end of the cross axis
    case end

    /// Items are centered along the cross axis
    case center

    /// Items are stretched to fill the container
    case stretch

    /// Items are aligned at the baseline
    case baseline
}

/// Defines the flex grow factor
public enum FlexGrow: String {
    /// No growing
    case none = "0"

    /// Grow
    case one = "1"
}

// Extension for HTML to provide flex styling
extension HTML {
    /// Sets flex container properties with optional modifiers.
    ///
    /// - Parameters:
    ///   - direction: The flex direction (row, column, etc.).
    ///   - justify: How to align items along the main axis.
    ///   - align: How to align items along the cross axis.
    ///   - grow: The flex grow factor.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: HTML with updated flex classes.
    ///
    /// ## Example
    /// ```swift
    /// // Create a flex container with column layout
    /// Stack()(tag: "div").flex(direction: .column)
    ///
    /// // Create a flex container with row layout and centered content
    /// Stack()(tag: "div").flex(direction: .row, justify: .center, align: .center)
    ///
    /// // Apply flex layout only on medium screens and up
    /// Stack()(tag: "div").flex(direction: .row, on: .md)
    /// ```
    public func flex(
        direction: FlexDirection? = nil,
        justify: FlexJustify? = nil,
        align: FlexAlign? = nil,
        grow: FlexGrow? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = FlexStyleOperation.Parameters(
            direction: direction,
            justify: justify,
            align: align,
            grow: grow
        )

        return FlexStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide flex styling
extension ResponsiveBuilder {
    /// Sets flex container properties in a responsive context.
    ///
    /// - Parameters:
    ///   - direction: The flex direction (row, column, etc.).
    ///   - justify: How to align items along the main axis.
    ///   - align: How to align items along the cross axis.
    ///   - grow: The flex grow factor.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func flex(
        direction: FlexDirection? = nil,
        justify: FlexJustify? = nil,
        align: FlexAlign? = nil,
        grow: FlexGrow? = nil
    ) -> ResponsiveBuilder {
        let params = FlexStyleOperation.Parameters(
            direction: direction,
            justify: justify,
            align: align,
            grow: grow
        )

        return FlexStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Sets flex container properties in the responsive context.
///
/// - Parameters:
///   - direction: The flex direction (row, column, etc.).
///   - justify: How to align items along the main axis.
///   - align: How to align items along the cross axis.
///   - grow: The flex grow factor.
/// - Returns: A responsive modification for flex container.
public func flex(
    direction: FlexDirection? = nil,
    justify: FlexJustify? = nil,
    align: FlexAlign? = nil,
    grow: FlexGrow? = nil
) -> ResponsiveModification {
    let params = FlexStyleOperation.Parameters(
        direction: direction,
        justify: justify,
        align: align,
        grow: grow
    )

    return FlexStyleOperation.shared.asModification(params: params)
}
