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
public enum Modifier: String {
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

    public var rawValue: String {
        switch self {
        case .xs, .sm, .md, .lg, .xl, .hover, .focus, .active, .placeholder, .dark:
            return "\(self):"
        case .xl2:
            return "2xl:"
        }
    }
}

/// Represents edge options for spacing and positioning.
///
/// Used for margins, padding, and positioning insets with context-specific prefixes.
/// Each case corresponds to a specific edge or set of edges that styling can be applied to,
/// providing fine-grained control over layout spacing.
///
/// ## Example
/// ```swift
/// Stack()
///   .padding(.horizontal, length: 4)  // Adds padding to left and right sides
///   .margins(.top, length: 2)        // Adds margin to just the top edge
/// ```
public enum Edge: String {
    /// Applies to all edges (top, right, bottom, and left).
    ///
    /// Use when you want uniform spacing on all sides of an element.
    case all = ""

    /// Applies to the top edge only.
    ///
    /// Use when you need to control spacing above an element.
    case top = "t"

    /// Applies to the leading (left) edge only.
    ///
    /// Use when you need to control spacing to the left of an element.
    case leading = "l"

    /// Applies to the trailing (right) edge only.
    ///
    /// Use when you need to control spacing to the right of an element.
    case trailing = "r"

    /// Applies to the bottom edge only.
    ///
    /// Use when you need to control spacing below an element.
    case bottom = "b"

    /// Applies to both leading and trailing edges (horizontal axis).
    ///
    /// Use when you want equal spacing on both left and right sides.
    case horizontal = "x"

    /// Applies to both top and bottom edges (vertical axis).
    ///
    /// Use when you want equal spacing on both top and bottom sides.
    case vertical = "y"
}

/// Defines axes for applying overflow, scroll, or spacing behavior.
///
/// Represents the direction(s) in which various layout rules are applied,
/// such as overflow handling, scroll behavior, or spacing between child elements.
///
/// ## Example
/// ```swift
/// Stack()
///   .overflow(.hidden, axis: .x)  // Hide horizontal overflow only
///   .spacing(.y, length: 4)      // Add vertical spacing between children
/// ```
public enum Axis: String {
    /// Applies to the horizontal (x) axis only.
    ///
    /// Use when you need to control behavior along the left-right direction.
    case horizontal = "x"

    /// Applies to the vertical (y) axis only.
    ///
    /// Use when you need to control behavior along the top-bottom direction.
    case vertical = "y"

    /// Applies to both horizontal and vertical axes simultaneously.
    ///
    /// Use when you need to apply the same behavior in both directions.
    case both = ""
}

/// Generates CSS classes with combined modifiers.
///
/// Combines a list of base classes with modifiers (e.g., `.hover`, `.xl`) to produce
/// classes like `hover:xl:class`. If no modifiers are provided, returns the base classes unchanged.
/// This is a core utility function used by style extension methods to support responsive
/// and state-based styling.
///
/// - Parameters:
///   - baseClasses: The base CSS classes (e.g., `["overflow-x-hidden"]`).
///   - modifiers: Zero or more modifiers to apply (e.g., `[.hover, .xl]`).
/// - Returns: An array of CSS classes with modifiers applied (e.g., `["hover:xl:overflow-x-hidden"]`).
///
/// ## Example
/// ```swift
/// // Without modifiers
/// let classes1 = combineClasses(["bg-blue-500"], withModifiers: [])
/// // Returns: ["bg-blue-500"]
///
/// // With a single modifier
/// let classes2 = combineClasses(["bg-blue-700"], withModifiers: [.hover])
/// // Returns: ["hover:bg-blue-700"]
///
/// // With multiple modifiers and classes
/// let classes3 = combineClasses(["text-lg", "font-bold"], withModifiers: [.md, .dark])
/// // Returns: ["md:dark:text-lg", "md:dark:font-bold"]
/// ```
public func combineClasses(_ baseClasses: [String], withModifiers modifiers: [Modifier]) -> [String] {
    if modifiers.isEmpty {
        return baseClasses
    }
    let modifierPrefix = modifiers.map { $0.rawValue }.joined()
    return baseClasses.map { "\(modifierPrefix)\($0)" }
}

/// Represents a color value for styling HTML elements.
///
/// Defines a comprehensive palette of colors with standardized shades, optional opacity levels,
/// and a custom option for arbitrary values. These colors map directly to Tailwind CSS
/// color classes when applied to elements.
///
/// ## Example
/// ```swift
/// Button(type: .submit) { "Save" }
///   .background(color: .blue(.500))
///   .font(color: .white)
/// ```
public enum Color {
    /// A slate gray color with varying intensity shades and optional opacity.
    ///
    /// A cool gray with subtle blue undertones.
    case slate(Shade, opacity: Double? = nil)

    /// A neutral gray color with varying intensity shades and optional opacity.
    ///
    /// A pure, balanced gray without strong undertones.
    case gray(Shade, opacity: Double? = nil)

    /// A cool-toned gray color with varying intensity shades and optional opacity.
    ///
    /// A bluish-gray resembling zinc metal.
    case zinc(Shade, opacity: Double? = nil)

    /// A balanced neutral color with varying intensity shades and optional opacity.
    ///
    /// A truly neutral gray without warm or cool undertones.
    case neutral(Shade, opacity: Double? = nil)

    /// A warm-toned stone color with varying intensity shades and optional opacity.
    ///
    /// A brownish-gray resembling natural stone.
    case stone(Shade, opacity: Double? = nil)

    /// A vibrant red color with varying intensity shades and optional opacity.
    ///
    /// A pure red that stands out for attention, warnings, and errors.
    case red(Shade, opacity: Double? = nil)

    /// A bright orange color with varying intensity shades and optional opacity.
    ///
    /// A warm, energetic color between red and yellow.
    case orange(Shade, opacity: Double? = nil)

    /// A rich amber color with varying intensity shades and optional opacity.
    ///
    /// A golden yellow-orange resembling amber gemstones.
    case amber(Shade, opacity: Double? = nil)

    /// A sunny yellow color with varying intensity shades and optional opacity.
    ///
    /// A bright, attention-grabbing primary color.
    case yellow(Shade, opacity: Double? = nil)

    /// A fresh lime color with varying intensity shades and optional opacity.
    ///
    /// A vibrant yellowish-green color.
    case lime(Shade, opacity: Double? = nil)

    /// A lush green color with varying intensity shades and optional opacity.
    ///
    /// A balanced green suitable for success states and environmental themes.
    case green(Shade, opacity: Double? = nil)

    /// A deep emerald color with varying intensity shades and optional opacity.
    ///
    /// A rich green with blue undertones resembling emerald gemstones.
    case emerald(Shade, opacity: Double? = nil)

    /// A teal blue-green color with varying intensity shades and optional opacity.
    ///
    /// A balanced blue-green color with elegant properties.
    case teal(Shade, opacity: Double? = nil)

    /// A bright cyan color with varying intensity shades and optional opacity.
    ///
    /// A vivid blue-green color with high visibility.
    case cyan(Shade, opacity: Double? = nil)

    /// A soft sky blue color with varying intensity shades and optional opacity.
    ///
    /// A light blue resembling a clear sky.
    case sky(Shade, opacity: Double? = nil)

    /// A classic blue color with varying intensity shades and optional opacity.
    ///
    /// A primary blue suitable for interfaces, links, and buttons.
    case blue(Shade, opacity: Double? = nil)

    /// A rich indigo color with varying intensity shades and optional opacity.
    ///
    /// A deep blue-purple resembling indigo dye.
    case indigo(Shade, opacity: Double? = nil)

    /// A vibrant violet color with varying intensity shades and optional opacity.
    ///
    /// A bright purple with strong blue undertones.
    case violet(Shade, opacity: Double? = nil)

    /// A deep purple color with varying intensity shades and optional opacity.
    ///
    /// A rich mixture of red and blue with royal connotations.
    case purple(Shade, opacity: Double? = nil)

    /// A bold fuchsia color with varying intensity shades and optional opacity.
    ///
    /// A vivid purple-red color with high contrast.
    case fuchsia(Shade, opacity: Double? = nil)

    /// A soft pink color with varying intensity shades and optional opacity.
    ///
    /// A light red with warm, gentle appearance.
    case pink(Shade, opacity: Double? = nil)

    /// A warm rose color with varying intensity shades and optional opacity.
    ///
    /// A deep pink resembling rose flowers.
    case rose(Shade, opacity: Double? = nil)

    /// A custom color defined by a raw CSS value with optional opacity.
    ///
    /// Allows using arbitrary color values not included in the standard palette.
    ///
    /// - Parameters:
    ///   - String: A valid CSS color value (hex, RGB, HSL, or named color).
    ///   - opacity: Optional opacity value between 0 and 1.
    ///
    ///
    /// ## Example
    /// ```swift
    /// Color.custom("#00aabb")
    /// Color.custom("rgb(100, 150, 200)", opacity: 0.5)
    /// ```
    case custom(String, opacity: Double? = nil)

    /// Defines shade intensity for colors in a consistent scale.
    ///
    /// Specifies a standardized range of shades from lightest (50) to darkest (950),
    /// providing fine-grained control over color intensity. The scale follows a
    /// consistent progression where lower numbers are lighter and higher numbers are darker.
    ///
    ///
    /// ## Example
    /// ```swift
    /// // Light blue background with dark blue text
    /// Stack()
    ///   .background(color: .blue(._100))
    ///   .font(color: .blue(._800))
    /// ```
    public enum Shade: Int {
        /// The lightest shade (50), typically a very faint tint.
        ///
        /// Best used for subtle backgrounds, hover states on light themes, or decorative elements.
        case _50 = 50

        /// A light shade (100), slightly more pronounced than 50.
        ///
        /// Suitable for light backgrounds, hover states, or highlighting selected items.
        case _100 = 100

        /// A subtle shade (200), often used for backgrounds or hover states.
        ///
        /// Good for secondary backgrounds, alternating rows, or light borders.
        case _200 = 200

        /// A moderate shade (300), suitable for borders or accents.
        ///
        /// Effective for dividers, borders, or subtle accent elements.
        case _300 = 300

        /// A balanced shade (400), often used for text or UI elements.
        ///
        /// Works well for secondary text, icons, or medium-emphasis UI elements.
        case _400 = 400

        /// A medium shade (500), commonly the default for a color family.
        ///
        /// The standard intensity, ideal for primary UI elements like buttons or indicators.
        case _500 = 500

        /// A slightly darker shade (600), good for emphasis.
        ///
        /// Useful for hover states on colored elements or medium-emphasis text.
        case _600 = 600

        /// A dark shade (700), often used for active states.
        ///
        /// Effective for active states, pressed buttons, or high-emphasis UI elements.
        case _700 = 700

        /// A very dark shade (800), suitable for strong contrast.
        ///
        /// Good for high-contrast text on light backgrounds or dark UI elements.
        case _800 = 800

        /// An almost black shade (900), often for deep backgrounds.
        ///
        /// Excellent for very dark backgrounds or high-contrast text elements.
        case _900 = 900

        /// The darkest shade (950), nearly black with a hint of color.
        ///
        /// The darkest variant, useful for the most intense applications of a color.
        case _950 = 950
    }

    /// Provides the raw CSS class value for the color and opacity.
    ///
    /// Generates the appropriate string value for use in CSS class names,
    /// including opacity formatting when specified.
    ///
    /// - Returns: A string representing the color in CSS class format.
    ///
    ///
    /// ## Example
    /// ```swift
    /// let color = Color.blue(._500, opacity: 0.75)
    /// let value = color.rawValue // Returns "blue-500/75"
    /// ```
    public var rawValue: String {
        func formatOpacity(_ opacity: Double?) -> String {
            guard let opacity = opacity, (0...1).contains(opacity) else { return "" }
            return "/\(Int(opacity * 100))"
        }

        switch self {
        case .slate(let shade, let opacity):
            return "slate-\(shade.rawValue)\(formatOpacity(opacity))"
        case .gray(let shade, let opacity):
            return "gray-\(shade.rawValue)\(formatOpacity(opacity))"
        case .zinc(let shade, let opacity):
            return "zinc-\(shade.rawValue)\(formatOpacity(opacity))"
        case .neutral(let shade, let opacity):
            return "neutral-\(shade.rawValue)\(formatOpacity(opacity))"
        case .stone(let shade, let opacity):
            return "stone-\(shade.rawValue)\(formatOpacity(opacity))"
        case .red(let shade, let opacity):
            return "red-\(shade.rawValue)\(formatOpacity(opacity))"
        case .orange(let shade, let opacity):
            return "orange-\(shade.rawValue)\(formatOpacity(opacity))"
        case .amber(let shade, let opacity):
            return "amber-\(shade.rawValue)\(formatOpacity(opacity))"
        case .yellow(let shade, let opacity):
            return "yellow-\(shade.rawValue)\(formatOpacity(opacity))"
        case .lime(let shade, let opacity):
            return "lime-\(shade.rawValue)\(formatOpacity(opacity))"
        case .green(let shade, let opacity):
            return "green-\(shade.rawValue)\(formatOpacity(opacity))"
        case .emerald(let shade, let opacity):
            return "emerald-\(shade.rawValue)\(formatOpacity(opacity))"
        case .teal(let shade, let opacity):
            return "teal-\(shade.rawValue)\(formatOpacity(opacity))"
        case .cyan(let shade, let opacity):
            return "cyan-\(shade.rawValue)\(formatOpacity(opacity))"
        case .sky(let shade, let opacity):
            return "sky-\(shade.rawValue)\(formatOpacity(opacity))"
        case .blue(let shade, let opacity):
            return "blue-\(shade.rawValue)\(formatOpacity(opacity))"
        case .indigo(let shade, let opacity):
            return "indigo-\(shade.rawValue)\(formatOpacity(opacity))"
        case .violet(let shade, let opacity):
            return "violet-\(shade.rawValue)\(formatOpacity(opacity))"
        case .purple(let shade, let opacity):
            return "purple-\(shade.rawValue)\(formatOpacity(opacity))"
        case .fuchsia(let shade, let opacity):
            return "fuchsia-\(shade.rawValue)\(formatOpacity(opacity))"
        case .pink(let shade, let opacity):
            return "pink-\(shade.rawValue)\(formatOpacity(opacity))"
        case .rose(let shade, let opacity):
            return "rose-\(shade.rawValue)\(formatOpacity(opacity))"
        case .custom(let value, let opacity):
            let opacityStr = formatOpacity(opacity)
            return "[\(value)]\(opacityStr)"
        }
    }
}
