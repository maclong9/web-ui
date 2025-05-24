import Foundation

/// Style operation for font styling
///
/// Provides a unified implementation for font styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct FontStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for font styling
    public struct Parameters {
        /// The font size
        public let size: TextSize?

        /// The font weight
        public let weight: Weight?

        /// The text alignment
        public let alignment: Alignment?

        /// The letter spacing
        public let tracking: Tracking?

        /// The line height
        public let leading: Leading?

        /// The text decoration
        public let decoration: Decoration?

        /// The text wrapping behavior
        public let wrapping: Wrapping?

        /// The text color
        public let color: Color?

        /// The font family
        public let family: String?

        /// Creates parameters for font styling
        ///
        /// - Parameters:
        ///   - size: The font size
        ///   - weight: The font weight
        ///   - alignment: The text alignment
        ///   - tracking: The letter spacing
        ///   - leading: The line height
        ///   - decoration: The text decoration
        ///   - wrapping: The text wrapping behavior
        ///   - color: The text color
        ///   - family: The font family
        public init(
            size: TextSize? = nil,
            weight: Weight? = nil,
            alignment: Alignment? = nil,
            tracking: Tracking? = nil,
            leading: Leading? = nil,
            decoration: Decoration? = nil,
            wrapping: Wrapping? = nil,
            color: Color? = nil,
            family: String? = nil
        ) {
            self.size = size
            self.weight = weight
            self.alignment = alignment
            self.tracking = tracking
            self.leading = leading
            self.decoration = decoration
            self.wrapping = wrapping
            self.color = color
            self.family = family
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: FontStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                size: params.get("size"),
                weight: params.get("weight"),
                alignment: params.get("alignment"),
                tracking: params.get("tracking"),
                leading: params.get("leading"),
                decoration: params.get("decoration"),
                wrapping: params.get("wrapping"),
                color: params.get("color"),
                family: params.get("family")
            )
        }
    }

    /// Applies the font style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for font styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []

        if let size = params.size { classes.append(size.className) }
        if let weight = params.weight { classes.append(weight.className) }
        if let alignment = params.alignment { classes.append(alignment.className) }
        if let tracking = params.tracking { classes.append(tracking.className) }
        if let leading = params.leading { classes.append(leading.className) }
        if let decoration = params.decoration { classes.append(decoration.className) }
        if let wrapping = params.wrapping { classes.append(wrapping.className) }
        if let color = params.color { classes.append("text-\(color.rawValue)") }
        if let family = params.family { classes.append("font-[\(family)]") }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = FontStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide font styling
extension HTML {
    /// Applies font styling to the element with optional modifiers.
    ///
    /// This comprehensive method allows controlling all aspects of typography including
    /// size, weight, alignment, spacing, color, and font family. Each parameter targets
    /// a specific aspect of text appearance, and can be combined with modifiers for
    /// responsive or state-based typography.
    ///
    /// - Parameters:
    ///   - size: The font size from extra-small to extra-large variants.
    ///   - weight: The font weight from thin to black/heavy.
    ///   - alignment: The text alignment (left, center, right).
    ///   - tracking: The letter spacing (character spacing).
    ///   - leading: The line height (vertical spacing between lines).
    ///   - decoration: The text decoration style (underline, strikethrough, etc.).
    ///   - wrapping: The text wrapping behavior.
    ///   - color: The text color from the color palette.
    ///   - family: The font family name or stack (e.g., "sans-serif").
    ///   - modifiers: Zero or more modifiers to scope the styles (e.g., responsive breakpoints or states).
    /// - Returns: A new element with updated font styling classes.
    ///
    /// ## Example
    /// ```swift
    /// Text { "Welcome to our site" }
    ///   .font(
    ///     size: .xl2,
    ///     weight: .bold,
    ///     alignment: .center,
    ///     tracking: .wide,
    ///     color: .blue(._600)
    ///   )
    ///
    /// // Responsive typography
    /// Heading(.one) { "Responsive Title" }
    ///   .font(size: .xl3)
    ///   .font(size: .xl5, on: .lg)  // Larger on desktop
    /// ```
    public func font(
        size: TextSize? = nil,
        weight: Weight? = nil,
        alignment: Alignment? = nil,
        tracking: Tracking? = nil,
        leading: Leading? = nil,
        decoration: Decoration? = nil,
        wrapping: Wrapping? = nil,
        color: Color? = nil,
        family: String? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = FontStyleOperation.Parameters(
            size: size,
            weight: weight,
            alignment: alignment,
            tracking: tracking,
            leading: leading,
            decoration: decoration,
            wrapping: wrapping,
            color: color,
            family: family
        )

        return FontStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Extension for ResponsiveBuilder to provide font styling
extension ResponsiveBuilder {
    /// Applies font styling in a responsive context.
    ///
    /// - Parameters:
    ///   - size: The font size.
    ///   - weight: The font weight.
    ///   - alignment: The text alignment.
    ///   - tracking: The letter spacing.
    ///   - leading: The line height.
    ///   - decoration: The text decoration.
    ///   - wrapping: The text wrapping behavior.
    ///   - color: The text color.
    ///   - family: The font family name.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func font(
        size: TextSize? = nil,
        weight: Weight? = nil,
        alignment: Alignment? = nil,
        tracking: Tracking? = nil,
        leading: Leading? = nil,
        decoration: Decoration? = nil,
        wrapping: Wrapping? = nil,
        color: Color? = nil,
        family: String? = nil
    ) -> ResponsiveBuilder {
        let params = FontStyleOperation.Parameters(
            size: size,
            weight: weight,
            alignment: alignment,
            tracking: tracking,
            leading: leading,
            decoration: decoration,
            wrapping: wrapping,
            color: color,
            family: family
        )

        return FontStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies font styling in the responsive context.
///
/// - Parameters:
///   - size: The font size.
///   - weight: The font weight.
///   - alignment: The text alignment.
///   - tracking: The letter spacing.
///   - leading: The line height.
///   - decoration: The text decoration.
///   - wrapping: The text wrapping behavior.
///   - color: The text color.
///   - family: The font family name.
/// - Returns: A responsive modification for font styling.
public func font(
    size: TextSize? = nil,
    weight: Weight? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil,
    wrapping: Wrapping? = nil,
    color: Color? = nil,
    family: String? = nil
) -> ResponsiveModification {
    let params = FontStyleOperation.Parameters(
        size: size,
        weight: weight,
        alignment: alignment,
        tracking: tracking,
        leading: leading,
        decoration: decoration,
        wrapping: wrapping,
        color: color,
        family: family
    )

    return FontStyleOperation.shared.asModification(params: params)
}
