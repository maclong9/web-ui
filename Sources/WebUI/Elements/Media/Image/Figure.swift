/// Generates an HTML figure element with a picture and figcaption.
/// Styles and attributes applied to this element are passed to the nested Picture element,
/// which further passes them to its nested Image element.
///
/// ## Example
/// ```swift
/// Figure(
///   sources: [
///     ("chart.webp", .webp),
///     ("chart.png", .png)
///   ],
///   description: "Annual revenue growth chart"
/// )
/// ```
public final class Figure: Element {
    let sources: [(src: String, type: ImageType?)]
    let description: String
    let size: MediaSize?

    /// Creates a new HTML figure element containing a picture and figcaption.
    ///
    /// - Parameters:
    ///   - sources: Array of tuples containing source URL and optional image MIME type.
    ///   - description: Text for the figcaption and alt text for accessibility.
    ///   - size: Picture size dimensions, optional.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///
    /// All style attributes (id, classes, role, label, data) are passed to the nested Picture element
    /// and ultimately to the Image element, ensuring proper styling throughout the hierarchy.
    ///
    /// ## Example
    /// ```swift
    /// Figure(
    ///   sources: [
    ///     ("product.webp", .webp),
    ///     ("product.jpg", .jpeg)
    ///   ],
    ///   description: "Product XYZ with special features",
    ///   classes: ["product-figure", "bordered"]
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
            tag: "figure",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: {
                Picture(
                    sources: sources,
                    description: description,
                    size: size,
                    id: id,
                    classes: classes,
                    role: role,
                    label: label,
                    data: data
                )
                Element(
                    tag: "figcaption",
                    content: { description }
                )
            }
        )
    }
}
