import Foundation

/// Style operation for positioning elements
///
/// Provides a unified implementation for position styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct PositionStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for position styling
    public struct Parameters {
        /// The position type
        public let type: PositionType?

        /// The edges to apply positioning to
        public let edges: [Edge]

        /// The offset value for positioning
        public let offset: Int?

        /// Creates parameters for position styling
        ///
        /// - Parameters:
        ///   - type: The position type
        ///   - edges: The edges to apply positioning to
        ///   - offset: The offset value for positioning
        public init(
            type: PositionType? = nil,
            edges: [Edge] = [.all],
            offset: Int? = nil
        ) {
            self.type = type
            self.edges = edges.isEmpty ? [.all] : edges
            self.offset = offset
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: PositionStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                type: params.get("type"),
                edges: params.get("edges", default: [.all]),
                offset: params.get("offset")
            )
        }
    }

    /// Applies the position style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for position styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []

        if let type = params.type {
            classes.append(type.rawValue)
        }

        if let offset = params.offset {
            for edge in params.edges {
                let edgePrefix: String
                switch edge {
                case .all: edgePrefix = "inset"
                case .top: edgePrefix = "top"
                case .leading: edgePrefix = "left"
                case .trailing: edgePrefix = "right"
                case .bottom: edgePrefix = "bottom"
                case .horizontal: edgePrefix = "inset-x"
                case .vertical: edgePrefix = "inset-y"
                }

                if offset < 0 {
                    classes.append("-\(edgePrefix)-\(abs(offset))")
                } else {
                    classes.append("\(edgePrefix)-\(offset)")
                }
            }
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = PositionStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide position styling
extension HTML {
    /// Applies positioning styling to the element with one or more edges.
    ///
    /// Sets the position type and optional inset values for specified edges, scoped to modifiers if provided.
    ///
    /// - Parameters:
    ///   - type: Specifies the positioning method (e.g., absolute, fixed).
    ///   - edges: One or more edges to apply the inset to. Defaults to `.all`.
    ///   - length: The distance value for the specified edges (e.g., "0", "4", "auto").
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated position classes.
    public func position(
        _ type: PositionType? = nil,
        at edges: Edge...,
        offset length: Int? = nil,
        on modifiers: Modifier...
    ) -> any Element {
        let params = PositionStyleOperation.Parameters(
            type: type,
            edges: edges,
            offset: length
        )

        return PositionStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide position styling
extension ResponsiveBuilder {
    /// Applies position styling in a responsive context.
    ///
    /// - Parameters:
    ///   - type: The position type.
    ///   - edges: The edges to apply positioning to.
    ///   - offset: The offset value for positioning.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func position(
        _ type: PositionType? = nil,
        at edges: Edge...,
        offset: Int? = nil
    ) -> ResponsiveBuilder {
        let params = PositionStyleOperation.Parameters(
            type: type,
            edges: edges,
            offset: offset
        )

        return PositionStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies position styling in the responsive context.
///
/// - Parameters:
///   - type: The position type.
///   - edges: The edges to apply positioning to.
///   - offset: The offset value for positioning.
/// - Returns: A responsive modification for positioning.
public func position(
    _ type: PositionType? = nil,
    at edges: Edge...,
    offset: Int? = nil
) -> ResponsiveModification {
    let params = PositionStyleOperation.Parameters(
        type: type,
        edges: edges,
        offset: offset
    )

    return PositionStyleOperation.shared.asModification(params: params)
}
