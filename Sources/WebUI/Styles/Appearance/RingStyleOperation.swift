import Foundation

/// Style operation for ring styling
///
/// Provides a unified implementation for ring styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct RingStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for ring styling
    public struct Parameters {
        /// The ring width
        public let width: Int?
        
        /// The ring color
        public let color: Color?
        
        /// Creates parameters for ring styling
        ///
        /// - Parameters:
        ///   - width: The ring width
        ///   - color: The ring color
        public init(
            width: Int? = nil,
            color: Color? = nil
        ) {
            self.width = width
            self.color = color
        }
        
        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: RingStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                width: params.get("width"),
                color: params.get("color")
            )
        }
    }
    
    /// Applies the ring style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for ring styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes = [String]()
        
        if let width = params.width {
            classes.append("ring-\(width)")
        } else {
            classes.append("ring-1")
        }
        
        if let color = params.color {
            classes.append("ring-\(color.rawValue)")
        }
        
        return classes
    }
    
    /// Shared instance for use across the framework
    public static let shared = RingStyleOperation()
    
    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide ring styling
extension Element {
    /// Sets ring properties with optional modifiers.
    ///
    /// - Parameters:
    ///   - width: The ring width.
    ///   - color: The ring color.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated ring classes.
    ///
    /// ## Example
    /// ```swift
    /// // Add a basic ring
    /// Element(tag: "div").ring()
    ///
    /// // Add a 2px ring with color
    /// Element(tag: "div").ring(of: 2, color: .blue(._500))
    ///
    /// // Add a colored ring on focus
    /// Element(tag: "div").ring(of: 2, color: .pink(._400), on: .focus)
    /// ```
    public func ring(
        of width: Int? = nil,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> Element {
        let params = RingStyleOperation.Parameters(
            width: width,
            color: color
        )
        
        return RingStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide ring styling
extension ResponsiveBuilder {
    /// Sets ring properties in a responsive context.
    ///
    /// - Parameters:
    ///   - width: The ring width.
    ///   - color: The ring color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ring(
        of width: Int? = nil,
        color: Color? = nil
    ) -> ResponsiveBuilder {
        let params = RingStyleOperation.Parameters(
            width: width,
            color: color
        )
        
        return RingStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Sets ring properties in the responsive context.
///
/// - Parameters:
///   - width: The ring width.
///   - color: The ring color.
/// - Returns: A responsive modification for ring.
public func ring(
    of width: Int? = nil,
    color: Color? = nil
) -> ResponsiveModification {
    let params = RingStyleOperation.Parameters(
        width: width,
        color: color
    )
    
    return RingStyleOperation.shared.asModification(params: params)
}