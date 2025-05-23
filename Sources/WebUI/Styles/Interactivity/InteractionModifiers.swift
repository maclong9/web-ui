import Foundation

/// Provides support for interactive states and states modifiers in the WebUI framework.
///
/// This extension adds support for additional modifiers like hover, focus, and other
/// interactive states to the ResponsiveBuilder to allow styling based on element state.

extension ResponsiveBuilder {
    /// Applies styles when the element is hovered.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func hover(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .hover
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has keyboard focus.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func focus(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .focus
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element is being actively pressed or clicked.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func active(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .active
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles to input placeholders within the element.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func placeholder(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .placeholder
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when dark mode is active.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func dark(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .dark
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles to the first child element.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func first(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .first
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles to the last child element.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func last(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .last
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element is disabled.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func disabled(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .disabled
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the user prefers reduced motion.
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func motionReduce(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .motionReduce
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-busy="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaBusy(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaBusy
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-checked="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaChecked(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaChecked
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-disabled="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaDisabled(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaDisabled
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-expanded="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaExpanded(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaExpanded
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-hidden="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaHidden(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaHidden
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-pressed="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaPressed(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaPressed
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-readonly="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaReadonly(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaReadonly
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-required="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaRequired(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaRequired
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles when the element has aria-selected="true".
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func ariaSelected(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .ariaSelected
        modifications(self)
        applyBreakpoint()
        return self
    }
}

// MARK: - Responsive DSL Functions

/// Creates a hover state responsive modification.
///
/// - Parameter content: A closure containing style modifications for hover state.
/// - Returns: A responsive modification for the hover state.
public func hover(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .hover, styleModification: content())
}

/// Creates a focus state responsive modification.
///
/// - Parameter content: A closure containing style modifications for focus state.
/// - Returns: A responsive modification for the focus state.
public func focus(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .focus, styleModification: content())
}

/// Creates an active state responsive modification.
///
/// - Parameter content: A closure containing style modifications for active state.
/// - Returns: A responsive modification for the active state.
public func active(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .active, styleModification: content())
}

/// Creates a placeholder responsive modification.
///
/// - Parameter content: A closure containing style modifications for placeholder text.
/// - Returns: A responsive modification for placeholder text.
public func placeholder(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .placeholder, styleModification: content())
}

/// Creates a dark mode responsive modification.
///
/// - Parameter content: A closure containing style modifications for dark mode.
/// - Returns: A responsive modification for dark mode.
public func dark(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .dark, styleModification: content())
}

/// Creates a first-child responsive modification.
///
/// - Parameter content: A closure containing style modifications for first child elements.
/// - Returns: A responsive modification for first child elements.
public func first(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .first, styleModification: content())
}

/// Creates a last-child responsive modification.
///
/// - Parameter content: A closure containing style modifications for last child elements.
/// - Returns: A responsive modification for last child elements.
public func last(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .last, styleModification: content())
}

/// Creates a disabled state responsive modification.
///
/// - Parameter content: A closure containing style modifications for disabled state.
/// - Returns: A responsive modification for the disabled state.
public func disabled(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .disabled, styleModification: content())
}

/// Creates a motion-reduce responsive modification.
///
/// - Parameter content: A closure containing style modifications for when users prefer reduced motion.
/// - Returns: A responsive modification for reduced motion preferences.
public func motionReduce(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .motionReduce, styleModification: content())
}

/// Creates an aria-busy responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-busy="true".
/// - Returns: A responsive modification for the aria-busy state.
public func ariaBusy(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaBusy, styleModification: content())
}

/// Creates an aria-checked responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-checked="true".
/// - Returns: A responsive modification for the aria-checked state.
public func ariaChecked(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaChecked, styleModification: content())
}

/// Creates an aria-disabled responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-disabled="true".
/// - Returns: A responsive modification for the aria-disabled state.
public func ariaDisabled(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaDisabled, styleModification: content())
}

/// Creates an aria-expanded responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-expanded="true".
/// - Returns: A responsive modification for the aria-expanded state.
public func ariaExpanded(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaExpanded, styleModification: content())
}

/// Creates an aria-hidden responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-hidden="true".
/// - Returns: A responsive modification for the aria-hidden state.
public func ariaHidden(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaHidden, styleModification: content())
}

/// Creates an aria-pressed responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-pressed="true".
/// - Returns: A responsive modification for the aria-pressed state.
public func ariaPressed(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaPressed, styleModification: content())
}

/// Creates an aria-readonly responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-readonly="true".
/// - Returns: A responsive modification for the aria-readonly state.
public func ariaReadonly(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaReadonly, styleModification: content())
}

/// Creates an aria-required responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-required="true".
/// - Returns: A responsive modification for the aria-required state.
public func ariaRequired(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaRequired, styleModification: content())
}

/// Creates an aria-selected responsive modification.
///
/// - Parameter content: A closure containing style modifications for aria-selected="true".
/// - Returns: A responsive modification for the aria-selected state.
public func ariaSelected(@ResponsiveStyleBuilder content: () -> ResponsiveModification) -> ResponsiveModification {
    BreakpointModification(breakpoint: .ariaSelected, styleModification: content())
}
