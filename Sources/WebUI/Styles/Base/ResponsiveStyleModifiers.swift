import Foundation

/// Provides the implementation for breakpoint modifiers in the responsive DSL.
///
/// These functions are available in the context of a responsive closure, allowing
/// for a more natural, SwiftUI-like syntax without requiring `$0` references.
public struct BreakpointModification: ResponsiveModification {
    private let breakpoint: Modifier
    private let styleModification: ResponsiveModification
    
    init(breakpoint: Modifier, styleModification: ResponsiveModification) {
        self.breakpoint = breakpoint
        self.styleModification = styleModification
    }
    
    public func apply(to builder: ResponsiveBuilder) {
        switch breakpoint {
        case .xs:
            builder.xs { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        case .sm:
            builder.sm { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        case .md:
            builder.md { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        case .lg:
            builder.lg { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        case .xl:
            builder.xl { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        case .xl2:
            builder.xl2 { innerBuilder in
                styleModification.apply(to: innerBuilder)
            }
        default:
            // Other modifiers like .hover, .focus, etc. are not breakpoints
            // They would be handled separately if needed
            break
        }
    }
}

/// Represents a style modification in the responsive DSL.
public struct StyleModification: ResponsiveModification {
    private let modification: (ResponsiveBuilder) -> Void
    
    init(_ modification: @escaping (ResponsiveBuilder) -> Void) {
        self.modification = modification
    }
    
    public func apply(to builder: ResponsiveBuilder) {
        modification(builder)
    }
}

// MARK: - Breakpoint Functions

/// Creates an extra-small breakpoint (480px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the extra-small breakpoint.
public func xs(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xs, styleModification: content())
}

/// Creates a small breakpoint (640px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the small breakpoint.
public func sm(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .sm, styleModification: content())
}

/// Creates a medium breakpoint (768px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the medium breakpoint.
public func md(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .md, styleModification: content())
}

/// Creates a large breakpoint (1024px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the large breakpoint.
public func lg(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .lg, styleModification: content())
}

/// Creates an extra-large breakpoint (1280px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the extra-large breakpoint.
public func xl(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xl, styleModification: content())
}

/// Creates a 2x extra-large breakpoint (1536px+) responsive modification.
///
/// - Parameter content: A closure containing style modifications for this breakpoint.
/// - Returns: A responsive modification for the 2x extra-large breakpoint.
public func xl2(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xl2, styleModification: content())
}

// MARK: - Style Modification Functions

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
    StyleModification { builder in
        builder.font(
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
    }
}

/// Applies background color styling in the responsive context.
///
/// - Parameter color: The background color.
/// - Returns: A responsive modification for background color.
public func background(color: Color) -> ResponsiveModification {
    StyleModification { builder in
        builder.background(color: color)
    }
}

/// Applies padding styling in the responsive context.
///
/// - Parameters:
///   - length: The padding value.
///   - edges: The edges to apply padding to.
/// - Returns: A responsive modification for padding.
public func padding(of length: Int? = 4, at edges: Edge...) -> ResponsiveModification {
    StyleModification { builder in
        if edges.isEmpty {
            builder.padding(of: length)
        } else {
            for edge in edges {
                builder.padding(of: length, at: edge)
            }
        }
    }
}

/// Applies margin styling in the responsive context.
///
/// - Parameters:
///   - length: The margin value.
///   - edges: The edges to apply margin to.
///   - auto: Whether to use automatic margins.
/// - Returns: A responsive modification for margins.
public func margins(of length: Int? = 4, at edges: Edge..., auto: Bool = false) -> ResponsiveModification {
    StyleModification { builder in
        if edges.isEmpty {
            builder.margins(of: length, auto: auto)
        } else {
            for edge in edges {
                builder.margins(of: length, at: edge, auto: auto)
            }
        }
    }
}

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
    StyleModification { builder in
        if edges.isEmpty {
            builder.border(of: width, style: style, color: color)
        } else {
            for edge in edges {
                builder.border(of: width, at: edge, style: style, color: color)
            }
        }
    }
}

/// Applies opacity styling in the responsive context.
///
/// - Parameter value: The opacity value (0-100).
/// - Returns: A responsive modification for opacity.
public func opacity(_ value: Int) -> ResponsiveModification {
    StyleModification { builder in
        builder.opacity(value)
    }
}

/// Applies size styling in the responsive context.
///
/// - Parameter value: The size value.
/// - Returns: A responsive modification for size.
public func size(_ value: Int) -> ResponsiveModification {
    StyleModification { builder in
        builder.size(value)
    }
}

/// Applies frame sizing in the responsive context.
///
/// - Parameters:
///   - width: The width value.
///   - height: The height value.
///   - minWidth: The minimum width value.
///   - maxWidth: The maximum width value.
///   - minHeight: The minimum height value.
///   - maxHeight: The maximum height value.
/// - Returns: A responsive modification for frame dimensions.
public func frame(
    width: Int? = nil,
    height: Int? = nil,
    minWidth: Int? = nil,
    maxWidth: Int? = nil,
    minHeight: Int? = nil,
    maxHeight: Int? = nil
) -> ResponsiveModification {
    StyleModification { builder in
        builder.frame(
            width: width,
            height: height,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight
        )
    }
}

/// Applies flex layout styling in the responsive context.
///
/// - Parameters:
///   - direction: The flex direction.
///   - justify: The justification type.
///   - align: The alignment type.
///   - grow: The flex grow value.
/// - Returns: A responsive modification for flex layout.
public func flex(
    direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil,
    grow: Grow? = nil
) -> ResponsiveModification {
    StyleModification { builder in
        builder.addClass("flex")
        if let direction = direction { builder.addClass(direction.rawValue) }
        if let justify = justify { builder.addClass(justify.rawValue) }
        if let align = align { builder.addClass(align.rawValue) }
        if let grow = grow { builder.addClass("flex-\(grow.rawValue)") }
    }
}

/// Applies grid layout styling in the responsive context.
///
/// - Parameters:
///   - columns: The number of grid columns.
///   - rows: The number of grid rows.
///   - justify: The justification type.
///   - align: The alignment type.
/// - Returns: A responsive modification for grid layout.
public func grid(
    columns: Int? = nil,
    rows: Int? = nil,
    justify: Justify? = nil,
    align: Align? = nil
) -> ResponsiveModification {
    StyleModification { builder in
        builder.addClass("grid")
        if let columns = columns { builder.addClass("grid-cols-\(columns)") }
        if let rows = rows { builder.addClass("grid-rows-\(rows)") }
        if let justify = justify { builder.addClass(justify.rawValue) }
        if let align = align { builder.addClass(align.rawValue) }
    }
}

/// Applies positioning styling in the responsive context.
///
/// - Parameters:
///   - type: The position type.
///   - edges: The edges to position.
///   - offset: The position offset value.
/// - Returns: A responsive modification for positioning.
public func position(
    _ type: PositionType? = nil,
    at edges: Edge...,
    offset: Int? = nil
) -> ResponsiveModification {
    StyleModification { builder in
        if edges.isEmpty {
            if let type = type {
                builder.position(type)
            }
            if let offset = offset {
                builder.position(nil, at: .all, offset: offset)
            }
        } else {
            for edge in edges {
                builder.position(type, at: edge, offset: offset)
            }
        }
    }
}

/// Applies overflow styling in the responsive context.
///
/// - Parameters:
///   - type: The overflow type.
///   - axis: The axis to apply overflow to.
/// - Returns: A responsive modification for overflow.
public func overflow(
    _ type: OverflowType,
    axis: Axis = .both
) -> ResponsiveModification {
    StyleModification { builder in
        builder.overflow(type, axis: axis)
    }
}

/// Applies visibility styling in the responsive context.
///
/// - Parameter isHidden: Whether the element should be hidden.
/// - Returns: A responsive modification for visibility.
public func hidden(
    _ isHidden: Bool = true
) -> ResponsiveModification {
    StyleModification { builder in
        builder.hidden(isHidden)
    }
}

/// Applies border radius styling in the responsive context.
///
/// - Parameters:
///   - size: The radius size.
///   - sides: The sides to apply the radius to.
/// - Returns: A responsive modification for border radius.
public func rounded(
    _ size: RadiusSize? = .md,
    _ sides: RadiusSide...
) -> ResponsiveModification {
    StyleModification { builder in
        if sides.isEmpty {
            builder.rounded(size ?? .md)
        } else {
            for side in sides {
                builder.rounded(size ?? .md, side)
            }
        }
    }
}