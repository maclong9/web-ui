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

// Font styling is now implemented in FontStyleOperation.swift

// Background styling is now implemented in BackgroundStyleOperation.swift

// Padding styling is now implemented in PaddingStyleOperation.swift

// Margins styling is now implemented in MarginsStyleOperation.swift

// Border styling is now implemented in BorderStyleOperation.swift

// Opacity styling is now implemented in OpacityStyleOperation.swift

// Size styling is now implemented in SizingStyleOperation.swift

// Frame styling is now implemented in SizingStyleOperation.swift

// Flex styling is implemented in ResponsiveBuilder.swift

// Grid styling is implemented in ResponsiveBuilder.swift

// Position styling is now implemented in PositionStyleOperation.swift

// Overflow styling is now implemented in OverflowStyleOperation.swift

// Hidden styling is implemented in ResponsiveBuilder.swift

// Border radius styling is now implemented in BorderRadiusStyleOperation.swift
