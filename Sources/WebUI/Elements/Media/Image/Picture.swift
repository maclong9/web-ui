/// Generates an HTML picture element with multiple source tags.
/// Styles and attributes applied to this element are also passed to the nested Image element.
///
/// ## Example
/// ```swift
/// Picture(
///   sources: [
///     ("banner.webp", .webp),
///     ("banner.jpg", .jpeg)
///   ],
///   description: "Website banner image"
/// )
/// ```
public final class Picture: Element {
    let sources: [(src: String, type: ImageType?)]
    let description: String
    let size: MediaSize?

    /// Creates a new HTML picture element.
    ///
    /// - Parameters:
    ///   - sources: Array of tuples containing source URL and optional image MIME type.
    ///   - description: Alt text for accessibility.
    ///   - size: Picture size dimensions, optional.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///
    /// All style attributes (id, classes, role, label, data) are passed to the nested Image element
    /// to ensure proper styling, as the Picture element itself is invisible in the rendered output.
    ///
    /// ## Example
    /// ```swift
    /// Picture(
    ///   sources: [
    ///     ("hero-large.webp", .webp),
    ///     ("hero-large.jpg", .jpeg)
    ///   ],
    ///   description: "Hero Banner",
    ///   id: "hero-image",
    ///   classes: ["responsive-image"]
    /// )
    /// ```
    public init(
        sources: [(src: String, type: ImageType?)],
        description: String,
        size: MediaSize? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.sources = sources
        self.description = description
        self.size = size
        super.init(
            tag: "picture",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: {
                for source in sources {
                    Source(src: source.src, type: source.type?.rawValue)
                }
                Image(
                    source: sources[0].src,
                    description: description,
                    size: size,
                    data: data
                )
            }
        )
    }
}
