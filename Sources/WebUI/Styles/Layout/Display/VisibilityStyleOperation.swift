import Foundation

/// Style operation for visibility styling
///
/// Provides a unified implementation for visibility styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct VisibilityStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for visibility styling
    public struct Parameters {
        /// Whether the element should be hidden
        public let isHidden: Bool

        /// Creates parameters for visibility styling
        ///
        /// - Parameter isHidden: Whether the element should be hidden
        public init(isHidden: Bool = true) {
            self.isHidden = isHidden
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: VisibilityStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                isHidden: params.get("isHidden") ?? true
            )
        }
    }

    /// Applies the visibility style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for visibility styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        if params.isHidden {
            return ["hidden"]
        } else {
            return []
        }
    }

    /// Shared instance for use across the framework
    public static let shared = VisibilityStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide visibility styling
extension Element {
    /// Controls the visibility of an element with optional modifiers.
    ///
    /// - Parameters:
    ///   - isHidden: Whether the element should be hidden (default: true).
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated visibility classes.
    ///
    /// ## Example
    /// ```swift
    /// // Hide an element
    /// Element(tag: "div").hidden()
    ///
    /// // Show an element on hover
    /// Element(tag: "div").hidden(on: .hover)
    ///
    /// // Hide an element on medium screens and up
    /// Element(tag: "div").hidden(on: .md)
    ///
    /// // Make visible on medium screens
    /// Element(tag: "div").hidden(false, on: .md)
    /// ```
    public func hidden(
        _ isHidden: Bool = true,
        on modifiers: Modifier...
    ) -> Element {
        let params = VisibilityStyleOperation.Parameters(isHidden: isHidden)

        return VisibilityStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide visibility styling
extension ResponsiveBuilder {
    /// Controls the visibility of an element in a responsive context.
    ///
    /// - Parameter isHidden: Whether the element should be hidden (default: true).
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func hidden(_ isHidden: Bool = true) -> ResponsiveBuilder {
        let params = VisibilityStyleOperation.Parameters(isHidden: isHidden)

        return VisibilityStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Controls the visibility of an element in the responsive context.
///
/// - Parameter isHidden: Whether the element should be hidden (default: true).
/// - Returns: A responsive modification for visibility.
public func hidden(_ isHidden: Bool = true) -> ResponsiveModification {
    let params = VisibilityStyleOperation.Parameters(isHidden: isHidden)

    return VisibilityStyleOperation.shared.asModification(params: params)
}
