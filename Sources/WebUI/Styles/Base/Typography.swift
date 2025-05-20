/// Represents different font sizes for typography styling.
///
/// Provides a consistent typographic scale from extra small to very large sizes,
/// mapping to predefined CSS classes. The scale follows a progressive pattern
/// where larger numbers indicate proportionally larger text sizes.
///
/// ## Example
/// ```swift
/// Heading(.one) { "Page Title" }
///   .font(size: .xl3)
///
/// Text { "Small print" }
///   .font(size: .xs)
/// ```
public enum TextSize: String {
    /// Represents an extra-small font size (0.75rem/12px)
    ///
    /// Suitable for footnotes, legal text, or fine print.
    case xs
    /// Represents a small font size (0.875rem/14px)
    ///
    /// Good for secondary text, captions, or less important information.
    case sm
    /// Represents the base (default) font size (1rem/16px)
    ///
    /// The standard text size for body copy and general content.
    case base
    /// Represents a large font size (1.125rem/18px)
    ///
    /// Useful for emphasizing text or small headings.
    case lg
    /// Represents an extra-large font size (1.25rem/20px)
    ///
    /// Good for subheadings or important text sections.
    case xl
    /// Represents a 2x extra-large font size (1.5rem/24px)
    ///
    /// Suitable for medium headings or section titles.
    case xl2
    /// Represents a 3x extra-large font size (1.875rem/30px)
    ///
    /// Effective for major section headings.
    case xl3
    /// Represents a 4x extra-large font size (2.25rem/36px)
    ///
    /// Strong visual impact for important headings.
    case xl4
    /// Represents a 5x extra-large font size (3rem/48px)
    ///
    /// Suitable for page titles or major section headers.
    case xl5
    /// Represents a 6x extra-large font size (3.75rem/60px)
    ///
    /// Prominent display text for key headlines.
    case xl6
    /// Represents a 7x extra-large font size (4.5rem/72px)
    ///
    /// Very large display text for hero sections.
    case xl7
    /// Represents a 8x extra-large font size (6rem/96px)
    ///
    /// Extra large display text for dramatic headlines.
    case xl8
    /// Represents a 9x extra-large font size (8rem/128px)
    ///
    /// The largest size, for maximum impact headlines.
    case xl9

    public var className: String {
        let raw = String(describing: self)
        if raw.hasPrefix("xl"), let number = raw.dropFirst(2).first {
            return "text-\(number)xl"
        }
        return "text-\(raw)"
    }
}

/// Text alignment options for positioning text horizontally.
///
/// Controls how text is aligned within its container element.
///
/// ## Example
/// ```swift
/// Text { "Centered Heading" }
///   .font(alignment: .center)
/// ```
public enum Alignment: String {
    /// Aligns text to the left edge of the container.
    case left
    /// Centers text horizontally within the container.
    case center
    /// Aligns text to the right edge of the container.
    case right

    /// The corresponding CSS class name for this alignment.
    var className: String { "text-\(rawValue)" }
}

/// Font weight options for controlling text thickness.
///
/// Provides a range of weights from extremely thin to extra bold,
/// allowing precise control over text emphasis and visual hierarchy.
///
/// ## Example
/// ```swift
/// Text { "Important note" }
///   .font(weight: .bold)
/// ```
public enum Weight: String {
    /// Extremely thin text (100).
    case thin
    /// Very light text (200).
    case extralight
    /// Light text (300).
    case light
    /// Regular/normal text weight (400).
    case normal
    /// Medium weight text (500).
    case medium
    /// Semi-bold text (600).
    case semibold
    /// Bold text (700).
    case bold
    /// Extra bold text (800).
    case extrabold
    /// Extremely bold/black text (900).
    case black

    /// The corresponding CSS class name for this font weight.
    var className: String { "font-\(rawValue)" }
}

/// Letter spacing options for controlling character spacing.
///
/// Controls the amount of space between characters (tracking),
/// enhancing readability or creating stylistic effects.
///
/// ## Example
/// ```swift
/// Heading(.one) { "Spaced Title" }
///   .font(tracking: .wide)
/// ```
public enum Tracking: String {
    /// Very tight letter spacing (reduced space between characters).
    case tighter
    /// Tight letter spacing (slightly reduced space).
    case tight
    /// Default letter spacing.
    case normal
    /// Wide letter spacing (increased space).
    case wide
    /// Wider letter spacing (more increased space).
    case wider
    /// Maximum letter spacing (greatest increase in space).
    case widest

    /// The corresponding CSS class name for this tracking value.
    var className: String { "tracking-\(rawValue)" }
}

/// Line height options for controlling vertical spacing between lines.
///
/// Adjusts the vertical spacing between lines of text, improving
/// readability or allowing for tighter or looser paragraphs.
///
/// ## Example
/// ```swift
/// Text { "This paragraph has multiple lines of text and needs good spacing for readability" }
///   .font(leading: .relaxed)
/// ```
public enum Leading: String {
    /// Extremely tight line spacing (closest lines).
    case tightest
    /// Very tight line spacing.
    case tighter
    /// Tight line spacing.
    case tight
    /// Default line spacing.
    case normal
    /// Slightly looser line spacing for improved readability.
    case relaxed
    /// Maximum line spacing for very open text layouts.
    case loose

    /// The corresponding CSS class name for this line height value.
    var className: String { "leading-\(rawValue)" }
}

/// Text decoration options for adding lines to text.
///
/// Applies visual decorations to text such as underlines, strikethroughs,
/// and various line styles for emphasis or indicating specific meaning.
///
/// ## Example
/// ```swift
/// Text { "This text is important" }
///   .font(decoration: .underline)
/// ```
public enum Decoration: String {
    /// Simple underline beneath the text.
    case underline
    /// Line above the text.
    case overline
    /// Line through the middle of the text (strikethrough).
    case lineThrough = "line-through"
    /// Double line decoration.
    case double
    /// Dotted line decoration.
    case dotted
    /// Dashed line decoration.
    case dashed
    /// Wavy line decoration.
    case wavy
    /// Remove line decoration
    case none = "no-underline"

    /// The corresponding CSS class name for this decoration.
    var className: String { "\(rawValue)" }
}

/// Text wrapping options for controlling how text flows.
///
/// Determines how text should wrap within its container, affecting
/// line breaks, overflow behavior, and overall text flow.
///
/// ## Example
/// ```swift
/// Text { "A long paragraph that needs to wrap nicely within its container" }
///   .font(wrapping: .balance)
/// ```
public enum Wrapping: String {
    /// Balances line lengths for more aesthetically pleasing paragraphs.
    case balance
    /// Optimizes line breaks for readability using advanced algorithms.
    case pretty
    /// Standard text wrapping behavior.
    case wrap
    /// Prevents text from wrapping to multiple lines.
    case nowrap

    /// The corresponding CSS class name for this wrapping behavior.
    var className: String { "text-\(rawValue)" }
}

extension Element {
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
    ) -> Element {
        var baseClasses: [String] = []
        if let size = size { baseClasses.append(size.className) }
        if let weight = weight { baseClasses.append(weight.className) }
        if let alignment = alignment { baseClasses.append(alignment.className) }
        if let tracking = tracking { baseClasses.append(tracking.className) }
        if let leading = leading { baseClasses.append(leading.className) }
        if let decoration = decoration { baseClasses.append(decoration.className) }
        if let wrapping = wrapping { baseClasses.append(wrapping.className) }
        if let color = color { baseClasses.append("text-\(color.rawValue)") }
        if let family = family { baseClasses.append("font-[\(family)]") }

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

    /// Prose size variants for article/content formatting.
    ///
    /// Defines standardized sizes for rich text content styling, useful for
    /// blog posts, articles, or other long-form content sections.
    ///
    /// ## Example
    /// ```swift
    /// Article()
    ///   .font(proseSize: .lg)
    /// ```
    public enum ProseSize: String {
        /// Small prose size for compact content layouts.
        case sm

        /// Default prose size for standard content.
        case base

        /// Large prose size for improved readability.
        case lg

        /// Extra large prose size for featured content.
        case xl

        /// Double extra large prose size for prominent content.
        case xl2 = "2xl"

        /// The corresponding Tailwind CSS class value.
        public var rawValue: String {
            "prose-\(self)"
        }
    }

    /// Prose color themes for long-form content.
    ///
    /// Defines color palettes for content styling, affecting headings,
    /// links, and other elements within long-form content.
    ///
    /// ## Example
    /// ```swift
    /// Article()
    ///   .font(proseColor: .slate)
    /// ```
    public enum ProseColor: String {
        /// Gray color theme for content.
        case gray

        /// Slate color theme for content (blueish gray).
        case slate

        /// Zinc color theme for content (neutral gray).
        case zinc

        /// Neutral color theme for content (balanced gray).
        case neutral

        /// The corresponding Tailwind CSS class value.
        public var rawValue: String {
            "prose-\(self)"
        }
    }
}
