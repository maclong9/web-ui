import Foundation

/// Style operation for margin styling
///
/// Provides a unified implementation for margin styling that can be used across
/// Element methods and the Declaritive DSL functions.
public struct MarginsStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for margin styling
    public struct Parameters {
        /// The margin value
        public let length: Int?

        /// The edges to apply the margin to
        public let edges: [Edge]

        /// Whether to use automatic margins
        public let auto: Bool

        /// Creates parameters for margin styling
        ///
        /// - Parameters:
        ///   - length: The margin value
        ///   - edges: The edges to apply the margin to
        ///   - auto: Whether to use automatic margins
        public init(
            length: Int? = 4,
            edges: [Edge] = [.all],
            auto: Bool = false
        ) {
            self.length = length
            self.edges = edges.isEmpty ? [.all] : edges
            self.auto = auto
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: Parameters object for margin styling
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                length: params.get("length"),
                edges: params.get("edges", default: [.all]),
                auto: params.get("auto", default: false)
            )
        }
    }

    /// Applies the margin style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for margin styling
    /// - Returns: An array of stylesheet class names to be applied
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []

        for edge in params.edges {
            let prefix = edge == .all ? "m" : "m\(edge.rawValue)"

            if params.auto {
                classes.append("\(prefix)-auto")
            } else if let length = params.length {
                classes.append("\(prefix)-\(length)")
            }
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = MarginsStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide margin styling
extension Markup {
    /// Applies margin styling to the element with one or more edges.
    ///
    /// - Parameters:
    ///   - length: The spacing value in `0.25rem` increments.
    ///   - edges: One or more edges to apply the margin to. Defaults to `.all`.
    ///   - auto: Whether to use automatic margins instead of a specific length.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: Markup with updated margin classes.
    public func margins(
        of length: Int? = 4,
        at edges: Edge...,
        auto: Bool = false,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = MarginsStyleOperation.Parameters(
            length: length,
            edges: edges,
            auto: auto
        )

        return MarginsStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Global function for Declaritive DSL
/// Applies margin styling in the responsive context with Declaritive syntax.
///
/// - Parameters:
///   - length: The margin value.
///   - edges: The edges to apply margin to.
///   - auto: Whether to use automatic margins.
/// - Returns: A responsive modification for margins.
public func margins(
    of length: Int? = 4,
    at edges: Edge...,
    auto: Bool = false
) -> ResponsiveModification {
    let params = MarginsStyleOperation.Parameters(
        length: length,
        edges: edges,
        auto: auto
    )

    return MarginsStyleOperation.shared.asModification(params: params)
}
