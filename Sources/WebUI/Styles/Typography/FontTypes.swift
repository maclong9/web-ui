/// Represents different font sizes for typography styling.
///
/// Provides a consistent typographic scale from extra small to very large sizes,
/// mapping to predefined stylesheet classes. The scale follows a progressive pattern
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

    /// The corresponding stylesheet class name for this alignment.
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

    /// The corresponding stylesheet class name for this font weight.
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

    /// The corresponding stylesheet class name for this tracking value.
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

    /// The corresponding stylesheet class name for this line height value.
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

    /// The corresponding stylesheet class name for this decoration.
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

    /// The corresponding stylesheet class name for this wrapping behavior.
    var className: String { "text-\(rawValue)" }
}
