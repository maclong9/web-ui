/// Defines sides for applying border radius.
///
/// Represents individual corners or groups of corners for styling border radius.
///
/// ## Example
/// ```swift
/// Button() { "Sign Up" }
///   .rounded(.lg, .top)
/// ```
public enum RadiusSide: String {
    /// Applies radius to all corners
    case all = ""
    /// Applies radius to the top side (top-left and top-right)
    case top = "t"
    /// Applies radius to the right side (top-right and bottom-right)
    case right = "r"
    /// Applies radius to the bottom side (bottom-left and bottom-right)
    case bottom = "b"
    /// Applies radius to the left side (top-left and bottom-left)
    case left = "l"
    /// Applies radius to the top-left corner
    case topLeft = "tl"
    /// Applies radius to the top-right corner
    case topRight = "tr"
    /// Applies radius to the bottom-left corner
    case bottomLeft = "bl"
    /// Applies radius to the bottom-right corner
    case bottomRight = "br"
}

/// Specifies sizes for border radius.
///
/// Defines a range of radius values from none to full circular.
///
/// ## Example
/// ```swift
/// Stack(classes: ["card"])
///   .rounded(.xl)
/// ```
public enum RadiusSize: String {
    /// No border radius (0)
    case none = "none"
    /// Extra small radius (0.125rem)
    case xs = "xs"
    /// Small radius (0.25rem)
    case sm = "sm"
    /// Medium radius (0.375rem)
    case md = "md"
    /// Large radius (0.5rem)
    case lg = "lg"
    /// Extra large radius (0.75rem)
    case xl = "xl"
    /// 2x large radius (1rem)
    case xl2 = "2xl"
    /// 3x large radius (1.5rem)
    case xl3 = "3xl"
    /// Full radius (9999px, circular)
    case full = "full"
}

/// Defines styles for borders and outlines.
///
/// Provides options for solid, dashed, and other border appearances.
///
/// ## Example
/// ```swift
/// Stack()
///   .border(width: 1, style: .dashed, color: .gray(._300))
/// ```
public enum BorderStyle: String {
    /// Solid line border
    case solid = "solid"
    /// Dashed line border
    case dashed = "dashed"
    /// Dotted line border
    case dotted = "dotted"
    /// Double line border
    case double = "double"
    /// Hidden border (none)
    case hidden = "hidden"
    /// No border (none)
    case none = "none"
    /// Divider style for child elements
    case divide = "divide"
}

/// Specifies sizes for box shadows.
///
/// Defines shadow sizes from none to extra-large.
///
/// ## Example
/// ```swift
/// Stack(classes: ["card"])
///   .shadow(size: .lg, color: .gray(._300, opacity: 0.5))
/// ```
public enum ShadowSize: String {
    /// No shadow
    case none = "none"
    /// Extra small shadow (2xs)
    case xs2 = "2xs"
    /// Extra small shadow (xs)
    case xs = "xs"
    /// Small shadow (sm)
    case sm = "sm"
    /// Medium shadow (default)
    case md = "md"
    /// Large shadow (lg)
    case lg = "lg"
    /// Extra large shadow (xl)
    case xl = "xl"
    /// 2x large shadow (2xl)
    case xl2 = "2xl"
}

extension Element {
    /// Applies border styling to the element with specified attributes.
    ///
    /// Adds borders with custom width, style, and color to specified edges of an element.
    ///
    /// ## Example
    /// ```swift
    /// Stack()
    ///   .border(width: 2, at: .bottom, color: .blue(._500))
    ///   .border(width: 1, at: .horizontal, color: .gray(._200), on: .hover)
    /// ```
    public func border(
        of width: Int? = nil,
        at edges: Edge...,
        style: BorderStyle? = nil,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> Element {
        let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
        var baseClasses: [String] = []

        // Handle width
        if let width = width {
            if style == .divide {
                for edge in effectiveEdges {
                    let edgePrefix =
                        edge == .horizontal ? "x" : edge == .vertical ? "y" : ""
                    if !edgePrefix.isEmpty {
                        baseClasses.append("divide-\(edgePrefix)-\(width)")
                    }
                }
            } else {
                baseClasses.append(
                    contentsOf: effectiveEdges.map { edge in
                        let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
                        return "border\(edgePrefix)\(width != 0 ? "-\(width)" : "")"
                    }
                )
            }
        }

        // Add edge-specific border classes when color is specified and width is nil
        if color != nil && width == nil {
            baseClasses.append(
                contentsOf: effectiveEdges.map { edge in
                    let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
                    return "border\(edgePrefix)"
                }
            )
        }

        // Handle style
        if let styleValue = style, style != .divide {
            baseClasses.append(
                contentsOf: effectiveEdges.map { edge in
                    let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
                    return "border\(edgePrefix)-\(styleValue.rawValue)"
                }
            )
        }

        // Handle color
        if let colorValue = color?.rawValue {
            baseClasses.append("border-\(colorValue)")
        }

        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }

    /// Applies border radius to the element.
    ///
    /// Creates rounded corners with specified size and edge placement.
    ///
    /// ## Example
    /// ```swift
    /// Button() { "Sign Up" }
    ///   .rounded(.full)
    ///
    /// Input(name: "search")
    ///   .rounded(.lg, .left)
    /// ```
    public func rounded(
        _ size: RadiusSize,
        _ edge: RadiusSide = .all,
        on modifiers: Modifier...
    ) -> Element {
        let sidePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
        let baseClasses = ["rounded\(sidePrefix)-\(size.rawValue)"]
        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }

    /// Applies outline styling to the element.
    ///
    /// Adds an outline with specified width, style, and color around the element.
    ///
    /// ## Example
    /// ```swift
    /// Button() { "Submit" }
    ///   .outline(width: 2, style: .solid, color: .blue(._500), on: .focus)
    /// ```
    public func outline(
        of width: Int? = nil,
        style: BorderStyle? = nil,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> Element {
        var baseClasses: [String] = []
        if let widthValue = width { baseClasses.append("outline-\(widthValue)") }
        if let styleValue = style, style != .divide {
            baseClasses.append("outline-\(styleValue.rawValue)")
        }
        if let colorValue = color?.rawValue {
            baseClasses.append("outline-\(colorValue)")
        }

        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }

    /// Applies shadow styling to the element.
    ///
    /// Adds a box shadow with specified size and optional color.
    ///
    /// ## Example
    /// ```swift
    /// Stack(classes: ["card"]) {
    ///   Heading(.title) { "Card Title" }
    ///   Text { "Card content" }
    /// }
    /// .shadow(of: .md)
    /// .shadow(of: .xl, on: .hover)
    /// ```
    public func shadow(
        color: Color? = nil,
        radius: ShadowSize,
        on modifiers: Modifier...
    ) -> Element {
        var baseClasses: [String] = ["shadow-\(radius.rawValue)"]
        if let colorValue = color?.rawValue {
            baseClasses.append("shadow-\(colorValue)")
        }

        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }

    /// Applies a focus ring around the element.
    ///
    /// Adds a ring with specified size and color, useful for highlighting interactive elements.
    ///
    /// ## Example
    /// ```swift
    /// Button() { "Click Me" }
    ///   .ring(of: 2, color: .blue(._500), on: .focus)
    /// ```
    public func ring(
        of size: Int = 1,
        color: Color? = nil,
        on modifiers: Modifier...
    ) -> Element {
        var baseClasses: [String] = ["ring-\(size)"]
        if let colorValue = color?.rawValue {
            baseClasses.append("ring-\(colorValue)")
        }

        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }
}
