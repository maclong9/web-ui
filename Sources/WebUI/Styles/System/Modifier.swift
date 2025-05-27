/// Represents CSS modifiers that apply styles under specific conditions, such as hover or focus states.
///
/// This enum maps to Tailwind CSS prefixes like `hover:` and `focus:`, enabling conditional styling
/// when used with `Element` methods like `opacity` or `background()`. It also contains
/// breakpoint modifiers for applying styles to specific screen sizes in responsive designs.
///
/// Modifiers can be combined with any styling method to create responsive or interactive designs
/// without writing custom media queries or JavaScript.
///
/// - Note: You do not need to redefine all styles on each modifier, just the ones that change.
///
/// ## Example
/// ```swift
/// Button() { "Click me" }
///   .background(color: .blue(._500))
///   .background(color: .blue(._600), on: .hover)
///   .font(color: .white)
///   .font(size: .lg, on: .md)  // Larger text on medium screens and up
/// ```
public enum Modifier: String, Sendable {
    /// Extra small breakpoint modifier applying styles at 480px min-width and above.
    ///
    /// Use for small mobile device specific styles.
    case xs

    /// Small breakpoint modifier applying styles at 640px min-width and above.
    ///
    /// Use for larger mobile device specific styles.
    case sm

    /// Medium breakpoint modifier applying styles at 768px min-width and above.
    ///
    /// Use for tablet and small desktop specific styles.
    case md

    /// Large breakpoint modifier applying styles at 1024px min-width and above.
    ///
    /// Use for desktop specific styles.
    case lg

    /// Extra-large breakpoint modifier applying styles at 1280px min-width and above.
    ///
    /// Use for larger desktop specific styles.
    case xl

    /// 2x extra-large breakpoint modifier applying styles at 1536px min-width and above.
    ///
    /// Use for very large desktop and ultrawide monitor specific styles.
    case xl2 = "2xl"

    /// Applies the style when the element is hovered over with a mouse pointer.
    ///
    /// Use to create interactive hover effects and highlight interactive elements.
    case hover

    /// Applies the style when the element has keyboard focus.
    ///
    /// Use for accessibility to highlight the currently focused element.
    case focus

    /// Applies the style when the element is actively being pressed or clicked.
    ///
    /// Use to provide visual feedback during interaction.
    case active

    /// Applies the style to input placeholders within the element.
    ///
    /// Use to style placeholder text in input fields and text areas.
    case placeholder

    /// Applies styles only when dark mode is active.
    ///
    /// Use to create dark theme variants of your UI elements.
    case dark

    /// Applies the style to the first child element.
    ///
    /// Use to style the first item in a list or container.
    case first

    /// Applies the style to the last child element.
    ///
    /// Use to style the last item in a list or container.
    case last

    /// Applies the style when the element is disabled.
    ///
    /// Use to provide visual feedback for disabled form elements and controls.
    case disabled

    /// Applies the style when the user prefers reduced motion.
    ///
    /// Use to create alternative animations or transitions for users who prefer reduced motion.
    case motionReduce = "motion-reduce"

    /// Applies the style when the element has aria-busy="true".
    ///
    /// Use to style elements that are in a busy or loading state.
    case ariaBusy = "aria-busy"

    /// Applies the style when the element has aria-checked="true".
    ///
    /// Use to style elements that represent a checked state, like checkboxes.
    case ariaChecked = "aria-checked"

    /// Applies the style when the element has aria-disabled="true".
    ///
    /// Use to style elements that are disabled via ARIA attributes.
    case ariaDisabled = "aria-disabled"

    /// Applies the style when the element has aria-expanded="true".
    ///
    /// Use to style elements that can be expanded, like accordions or dropdowns.
    case ariaExpanded = "aria-expanded"

    /// Applies the style when the element has aria-hidden="true".
    ///
    /// Use to style elements that are hidden from screen readers.
    case ariaHidden = "aria-hidden"

    /// Applies the style when the element has aria-pressed="true".
    ///
    /// Use to style elements that represent a pressed state, like toggle buttons.
    case ariaPressed = "aria-pressed"

    /// Applies the style when the element has aria-readonly="true".
    ///
    /// Use to style elements that are in a read-only state.
    case ariaReadonly = "aria-readonly"

    /// Applies the style when the element has aria-required="true".
    ///
    /// Use to style elements that are required, like form inputs.
    case ariaRequired = "aria-required"

    /// Applies the style when the element has aria-selected="true".
    ///
    /// Use to style elements that are in a selected state, like tabs or menu items.
    case ariaSelected = "aria-selected"

    public var rawValue: String {
        switch self {
            case .xs, .sm, .md, .lg, .xl, .hover, .focus, .active, .placeholder,
                .dark,
                .first, .last, .disabled:
                return "\(self):"
            case .xl2:
                return "2xl:"
            case .motionReduce:
                return "motion-reduce:"
            case .ariaBusy:
                return "aria-busy:"
            case .ariaChecked:
                return "aria-checked:"
            case .ariaDisabled:
                return "aria-disabled:"
            case .ariaExpanded:
                return "aria-expanded:"
            case .ariaHidden:
                return "aria-hidden:"
            case .ariaPressed:
                return "aria-pressed:"
            case .ariaReadonly:
                return "aria-readonly:"
            case .ariaRequired:
                return "aria-required:"
            case .ariaSelected:
                return "aria-selected:"
        }
    }
}
