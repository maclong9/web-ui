import Foundation

/// Style operation for border styling
///
/// Provides a unified implementation for border styling that can be used across
/// Element methods and the Declaritive DSL functions.
public struct BorderStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for border styling
    public struct Parameters {
        /// The border width
        public let width: Int?

        /// The edges to apply the border to
        public let edges: [Edge]

        /// The border style
        public let style: BorderStyle?

        /// The border color
        public let color: Color?

        /// Creates parameters for border styling
        ///
        /// - Parameters:
        ///   - width: The border width
        ///   - edges: The edges to apply the border to
        ///   - style: The border style
        ///   - color: The border color
        public init(
            width: Int? = 1,
            edges: [Edge] = [.all],
            style: BorderStyle? = nil,
            color: Color? = nil
        ) {
            self.width = width
            self.edges = edges.isEmpty ? [.all] : edges
            self.style = style
            self.color = color
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: BorderStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                width: params.get("width"),
                edges: params.get("edges", default: [.all]),
                style: params.get("style"),
                color: params.get("color")
            )
        }
    }

    /// Applies the border style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for border styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []
        let width = params.width
        let edges = params.edges
        let style = params.style
        let color = params.color

        for edge in edges {
            if let style = style, style == .divide {
                if let width = width {
                    let divideClass = edge == .horizontal ? "divide-x-\(width)" : "divide-y-\(width)"
                    classes.append(divideClass)
                }
            } else {
                let prefix = edge == .all ? "border" : "border-\(edge.rawValue)"
                if let width = width {
                    classes.append("\(prefix)-\(width)")
                } else {
                    classes.append(prefix)
                }
            }
        }

        if let style = style, style != .divide {
            classes.append("border-\(style.rawValue)")
        }

        if let color = color {
            classes.append("border-\(color.rawValue)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = BorderStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide border styling
extension HTML {
    /// Applies border styling to the element with specified attributes.
    ///
    /// Adds borders with custom width, style, and color to specified edges of an element.
    ///
    /// - Parameters:
    ///   - width: The border width in pixels.
    ///   - edges: One or more edges to apply the border to. Defaults to `.all`.
    ///   - style: The border style (solid, dashed, etc.).
    ///   - color: The border color.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated border classes.
    ///
    /// ## Example
    /// ```swift
    /// Stack()
    ///   .border(of: 2, at: .bottom, color: .blue(._500))
    ///   .border(of: 1, at: .horizontal, color: .gray(._200), on: .hover)
    /// ```
    public func border(
        width: Int? = nil,
        style: BorderStyle? = nil,
        at edges: Edge...,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> any Element {
        let params = BorderStyleOperation.Parameters(
            width: width,
            edges: edges,
            style: style,
            color: color
        )

        return BorderStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide border styling
extension ResponsiveBuilder {
    /// Applies border styling in a responsive context.
    ///
    /// - Parameters:
    ///   - width: The border width in pixels.
    ///   - edges: One or more edges to apply the border to. Defaults to `.all`.
    ///   - style: The border style (solid, dashed, etc.).
    ///   - color: The border color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func border(
        of width: Int? = 1,
        at edges: Edge...,
        style: BorderStyle? = nil,
        color: Color? = nil
    ) -> ResponsiveBuilder {
        let params = BorderStyleOperation.Parameters(
            width: width,
            edges: edges,
            style: style,
            color: color
        )

        return BorderStyleOperation.shared.applyToBuilder(self, params: params)
    }

    /// Helper method to apply just a border style.
    ///
    /// - Parameter style: The border style to apply.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func border(style: BorderStyle) -> ResponsiveBuilder {
        let params = BorderStyleOperation.Parameters(style: style)
        return BorderStyleOperation.shared.applyToBuilder(self, params: params)
    }

    /// Helper method to apply just a border color.
    ///
    /// - Parameter color: The border color to apply.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func border(color: Color) -> ResponsiveBuilder {
        let params = BorderStyleOperation.Parameters(color: color)
        return BorderStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declaritive DSL
/// Applies border styling in the responsive context.
///
/// - Parameters:
///   - width: The border width.
///   - edges: The edges to apply the border to.
///   - style: The border style.
///   - color: The border color.
/// - Returns: A responsive modification for borders.
public func border(
    of width: Int? = 1,
    at edges: Edge...,
    style: BorderStyle? = nil,
    color: Color? = nil
) -> ResponsiveModification {
    let params = BorderStyleOperation.Parameters(
        width: width,
        edges: edges,
        style: style,
        color: color
    )

    return BorderStyleOperation.shared.asModification(params: params)
}
