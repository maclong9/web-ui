import Foundation

/// Provides the implementation for breakpoint and interactive state modifiers in the responsive DSL.
///
/// These functions are available in the context of a responsive closure, allowing
/// for a more natural, SwiftUI-like syntax without requiring `$0` references.
/// Supports a single modifier (legacy, for compatibility)
public struct BreakpointModification: ResponsiveModification {
    private let breakpoint: Modifier
    private let styleModification: ResponsiveModification

    init(breakpoint: Modifier, styleModification: ResponsiveModification) {
        self.breakpoint = breakpoint
        self.styleModification = styleModification
    }

    public func apply(to builder: ResponsiveBuilder) {
        builder.modifiers(breakpoint) { innerBuilder in
            styleModification.apply(to: innerBuilder)
        }
    }
}

/// Supports multiple modifiers (e.g. hover, dark)
public struct MultiModifierModification: ResponsiveModification {
    private let modifiers: [Modifier]
    private let styleModification: ResponsiveModification

    init(modifiers: [Modifier], styleModification: ResponsiveModification) {
        self.modifiers = modifiers
        self.styleModification = styleModification
    }

    public func apply(to builder: ResponsiveBuilder) {
        builder.modifiers(
            modifiers,
            modifications: { innerBuilder in
                styleModification.apply(to: innerBuilder)
            })
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
// Note: Interactive state functions like hover, focus, etc. are defined in InteractionModifiers.swift

/// Creates an extra-small breakpoint (480px+) responsive modification.
public func xs(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xs, styleModification: content())
}
/// Creates a small breakpoint (640px+) responsive modification.
public func sm(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .sm, styleModification: content())
}
/// Creates a medium breakpoint (768px+) responsive modification.
public func md(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .md, styleModification: content())
}
/// Creates a large breakpoint (1024px+) responsive modification.
public func lg(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .lg, styleModification: content())
}
/// Creates an extra-large breakpoint (1280px+) responsive modification.
public func xl(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xl, styleModification: content())
}
/// Creates a 2x extra-large breakpoint (1536px+) responsive modification.
public func xl2(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .xl2, styleModification: content())
}

/// Creates a multi-modifier responsive modification (e.g. hover, dark).
public func modifiers(_ modifiers: Modifier..., @ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
{
    MultiModifierModification(modifiers: modifiers, styleModification: content())
}

// MARK: - Tuple Syntax Support Functions

/// Creates a two-modifier responsive modification for tuple syntax.
public func modifiers(
    _ modifier1: Modifier, _ modifier2: Modifier, @ResponsiveStyleBuilder content: () -> ResponsiveModification
) -> ResponsiveModification {
    MultiModifierModification(modifiers: [modifier1, modifier2], styleModification: content())
}

/// Creates a three-modifier responsive modification for tuple syntax.
public func modifiers(
    _ modifier1: Modifier, _ modifier2: Modifier, _ modifier3: Modifier,
    @ResponsiveStyleBuilder content: () -> ResponsiveModification
) -> ResponsiveModification {
    MultiModifierModification(modifiers: [modifier1, modifier2, modifier3], styleModification: content())
}

/// Creates a four-modifier responsive modification for tuple syntax.
public func modifiers(
    _ modifier1: Modifier, _ modifier2: Modifier, _ modifier3: Modifier, _ modifier4: Modifier,
    @ResponsiveStyleBuilder content: () -> ResponsiveModification
) -> ResponsiveModification {
    MultiModifierModification(modifiers: [modifier1, modifier2, modifier3, modifier4], styleModification: content())
}

// MARK: - Comma-Separated Modifier Syntax Support

/// Custom operator for combining modifiers with comma-like syntax
infix operator <&> : MultiplicationPrecedence

/// Represents a collection of modifiers that can be combined using comma-like syntax.
public struct ModifierGroup {
    let modifiers: [Modifier]

    init(_ modifiers: [Modifier]) {
        self.modifiers = modifiers
    }

    /// Creates a responsive modification with the combined modifiers.
    public func callAsFunction(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification
    {
        MultiModifierModification(modifiers: modifiers, styleModification: content())
    }
}

/// Combines two modifiers using the <&> operator.
public func <&> (_ lhs: Modifier, _ rhs: Modifier) -> ModifierGroup {
    ModifierGroup([lhs, rhs])
}

/// Combines a modifier group with another modifier using the <&> operator.
public func <&> (_ lhs: ModifierGroup, _ rhs: Modifier) -> ModifierGroup {
    ModifierGroup(lhs.modifiers + [rhs])
}

/// Combines a modifier with a modifier group using the <&> operator.
public func <&> (_ lhs: Modifier, _ rhs: ModifierGroup) -> ModifierGroup {
    ModifierGroup([lhs] + rhs.modifiers)
}

/// Combines two modifier groups using the <&> operator.
public func <&> (_ lhs: ModifierGroup, _ rhs: ModifierGroup) -> ModifierGroup {
    ModifierGroup(lhs.modifiers + rhs.modifiers)
}
