//
//  RingStyleOperation.swift
//  web-ui
//
//  Created by Mac Long on 2025.05.22.
//

import Foundation

/// Style operation for ring styling
///
/// Provides a unified implementation for ring styling that can be used across
/// Element methods and the Declaritive DSL functions.
public struct RingStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for ring styling
    public struct Parameters {
        /// The ring width
        public let size: Int?

        /// The ring color
        public let color: Color?

        /// Creates parameters for ring styling
        ///
        /// - Parameters:
        ///   - size: the width of the ring
        ///   - color: The ring color
        public init(
            size: Int? = 1,
            color: Color? = nil
        ) {
            self.size = size
            self.color = color
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: RingStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                size: params.get("size"),
                color: params.get("color")
            )
        }
    }

    /// Applies the ring style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for ring styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []
        let size = params.size ?? 1
        let color = params.color

        classes.append("ring-\(size)")

        if let color = color {
            classes.append("ring-\(color.rawValue)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = RingStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide ring styling
extension HTML {
    /// Applies ring styling to the element with specified attributes.
    ///
    /// Adds rings with custom width, style, and color to specified edges of an element.
    ///
    /// - Parameters:
    ///   - size: The width of the ring.
    ///   - color: The ring color.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: HTML with updated ring classes.
    ///
    /// ## Example
    /// ```swift
    /// Stack()
    ///   .ring(of: 2, at: .bottom, color: .blue(._500))
    ///   .ring(of: 1, at: .horizontal, color: .gray(._200), on: .hover)
    /// ```
    public func ring(
        size: Int = 1,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = RingStyleOperation.Parameters(
            size: size,
            color: color
        )

        return RingStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide ring styling
extension ResponsiveBuilder {
    /// Applies ring styling in a responsive context.
    ///
    /// - Parameters:
    ///   - size: The width of the ring.
    ///   - color: The ring color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ring(
        size: Int = 1,
        color: Color? = nil
    ) -> ResponsiveBuilder {
        let params = RingStyleOperation.Parameters(
            size: size,
            color: color
        )

        return RingStyleOperation.shared.applyToBuilder(self, params: params)
    }

    /// Helper method to apply just a ring color.
    ///
    /// - Parameter color: The ring color to apply.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ring(color: Color) -> ResponsiveBuilder {
        let params = RingStyleOperation.Parameters(color: color)
        return RingStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declaritive DSL
/// Applies ring styling in the responsive context.
///
/// - Parameters:
///   - size: The width of the ring.
///   - color: The ring color.
/// - Returns: A responsive modification for rings.
public func ring(
    of size: Int = 1,
    color: Color? = nil
) -> ResponsiveModification {
    let params = RingStyleOperation.Parameters(
        size: size,
        color: color
    )

    return RingStyleOperation.shared.asModification(params: params)
}
