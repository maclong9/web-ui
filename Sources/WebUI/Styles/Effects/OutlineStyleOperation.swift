import Foundation

/// Style operation for outline styling
///
/// Provides a unified implementation for outline styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct OutlineStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for outline styling
    public struct Parameters {
        /// The outline width
        public let width: Int?
        
        /// The outline style (solid, dashed, etc.)
        public let style: BorderStyle?
        
        /// The outline color
        public let color: Color?
        
        /// The outline offset
        public let offset: Int?
        
        /// Creates parameters for outline styling
        ///
        /// - Parameters:
        ///   - width: The outline width
        ///   - style: The outline style
        ///   - color: The outline color
        ///   - offset: The outline offset
        public init(
            width: Int? = nil,
            style: BorderStyle? = nil,
            color: Color? = nil,
            offset: Int? = nil
        ) {
            self.width = width
            self.style = style
            self.color = color
            self.offset = offset
        }
        
        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: OutlineStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                width: params.get("width"),
                style: params.get("style"),
                color: params.get("color"),
                offset: params.get("offset")
            )
        }
    }
    
    /// Applies the outline style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for outline styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes = [String]()
        
        if let width = params.width {
            classes.append("outline-\(width)")
        }
        
        if let style = params.style {
            classes.append("outline-\(style.rawValue)")
        }
        
        if let color = params.color {
            classes.append("outline-\(color.rawValue)")
        }
        
        if let offset = params.offset {
            classes.append("outline-offset-\(offset)")
        }
        
        if classes.isEmpty {
            classes.append("outline")
        }
        
        return classes
    }
    
    /// Shared instance for use across the framework
    public static let shared = OutlineStyleOperation()
    
    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide outline styling
extension Element {
    /// Sets outline properties with optional modifiers.
    ///
    /// - Parameters:
    ///   - width: The outline width.
    ///   - style: The outline style (solid, dashed, etc.).
    ///   - color: The outline color.
    ///   - offset: The outline offset in pixels.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated outline classes.
    ///
    /// ## Example
    /// ```swift
    /// // Add a basic outline
    /// Element(tag: "div").outline()
    ///
    /// // Add a 2px outline with color
    /// Element(tag: "div").outline(of: 2, color: .blue(._500))
    ///
    /// // Add a dashed outline on focus
    /// Element(tag: "div").outline(style: .dashed, on: .focus)
    /// ```
    public func outline(
        of width: Int? = nil,
        style: BorderStyle? = nil,
        color: Color? = nil,
        offset: Int? = nil,
        on modifiers: Modifier...
    ) -> Element {
        let params = OutlineStyleOperation.Parameters(
            width: width,
            style: style,
            color: color,
            offset: offset
        )
        
        return OutlineStyleOperation.shared.applyToElement(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide outline styling
extension ResponsiveBuilder {
    /// Sets outline properties in a responsive context.
    ///
    /// - Parameters:
    ///   - width: The outline width.
    ///   - style: The outline style (solid, dashed, etc.).
    ///   - color: The outline color.
    ///   - offset: The outline offset in pixels.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func outline(
        of width: Int? = nil,
        style: BorderStyle? = nil,
        color: Color? = nil,
        offset: Int? = nil
    ) -> ResponsiveBuilder {
        let params = OutlineStyleOperation.Parameters(
            width: width,
            style: style,
            color: color,
            offset: offset
        )
        
        return OutlineStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Sets outline properties in the responsive context.
///
/// - Parameters:
///   - width: The outline width.
///   - style: The outline style (solid, dashed, etc.).
///   - color: The outline color.
///   - offset: The outline offset in pixels.
/// - Returns: A responsive modification for outline.
public func outline(
    of width: Int? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    offset: Int? = nil
) -> ResponsiveModification {
    let params = OutlineStyleOperation.Parameters(
        width: width,
        style: style,
        color: color,
        offset: offset
    )
    
    return OutlineStyleOperation.shared.asModification(params: params)
}
