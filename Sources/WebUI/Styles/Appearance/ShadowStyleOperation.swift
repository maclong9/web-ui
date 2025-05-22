import Foundation

/// Style operation for shadow styling
///
/// Provides a unified implementation for shadow styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct ShadowStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for shadow styling
    public struct Parameters {
        /// The shadow size
        public let size: ShadowSize?
        
        /// The shadow color
        public let color: Color?
        
        /// Creates parameters for shadow styling
        ///
        /// - Parameters:
        ///   - size: The shadow size
        ///   - color: The shadow color
        public init(
            size: ShadowSize? = nil,
            color: Color? = nil
        ) {
            self.size = size
            self.color = color
        }
        
        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: ShadowStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                size: params.get("size"),
                color: params.get("color")
            )
        }
    }
    
    /// Applies the shadow style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for shadow styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes = [String]()
        
        if let size = params.size {
            classes.append("shadow-\(size.rawValue)")
        } else {
            classes.append("shadow")
        }
        
        if let color = params.color {
            classes.append("shadow-\(color.rawValue)")
        }
        
        return classes
    }
    
    /// Shared instance for use across the framework
    public static let shared = ShadowStyleOperation()
    
    /// Private initializer to enforce singleton usage
    private init() {}
}

// Using the existing ShadowSize enum from BorderTypes.swift

// Extension for Element to provide shadow styling
extension Element {
    /// Sets shadow properties with optional modifiers.
    ///
    /// - Parameters:
    ///   - size: The shadow size.
    ///   - color: The shadow color.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated shadow classes.
    ///
    /// ## Example
    /// ```swift
    /// // Add a basic shadow
    /// Element(tag: "div").shadow()
    ///
    /// // Add a large shadow
    /// Element(tag: "div").shadow(of: .lg)
    ///
    /// // Add a colored shadow on hover
    /// Element(tag: "div").shadow(of: .md, color: .gray(._500), on: .hover)
    /// ```
    public func shadow(
        of size: ShadowSize? = nil,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> Element {
        let params = ShadowStyleOperation.Parameters(
            size: size,
            color: color
        )
        
        return ShadowStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide shadow styling
extension ResponsiveBuilder {
    /// Sets shadow properties in a responsive context.
    ///
    /// - Parameters:
    ///   - size: The shadow size.
    ///   - color: The shadow color.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func shadow(
        of size: ShadowSize? = nil,
        color: Color? = nil
    ) -> ResponsiveBuilder {
        let params = ShadowStyleOperation.Parameters(
            size: size,
            color: color
        )
        
        return ShadowStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Sets shadow properties in the responsive context.
///
/// - Parameters:
///   - size: The shadow size.
///   - color: The shadow color.
/// - Returns: A responsive modification for shadow.
public func shadow(
    of size: ShadowSize? = nil,
    color: Color? = nil
) -> ResponsiveModification {
    let params = ShadowStyleOperation.Parameters(
        size: size,
        color: color
    )
    
    return ShadowStyleOperation.shared.asModification(params: params)
}