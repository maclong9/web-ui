import Foundation

/// Creates HTML picture elements for responsive images.
///
/// Represents a container for multiple image sources, allowing browsers to choose the most appropriate
/// image format and resolution based on device capabilities. Picture elements enhance website performance
/// by optimizing image delivery based on screen size, resolution, and supported formats.
///
/// ## Example
/// ```swift
/// Picture(
///   sources: [
///     (src: "image.webp", type: .webp),
///     (src: "image.jpg", type: .jpeg)
///   ],
///   description: "A responsive image",
///   fallback: "fallback.jpg"
/// )
public final class Picture: Element {
    /// Creates a new HTML picture element.
    ///
    /// - Parameters:
    ///   - sources: Array of tuples containing source URL and image MIME type.
    ///   - description: The alt text for the image for accessibility and SEO.
    ///   - fallback: Fallback image source URL, optional.
    ///   - size: The size of the image in pixels, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the picture container.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when alt text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the picture element.
    public init(
        sources: [(src: String, type: ImageType)],
        description: String,
        fallback: String? = nil,
        size: MediaSize? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        let sourceElements = sources.map { (src, type) in
            "<source srcset=\"\(src)\" type=\"\(type.rawValue)\" />"
        }.joined()
        let imgTag: String
        if let fallback = fallback {
            imgTag = "<img src=\"\(fallback)\" alt=\"\(description)\" />"
        } else {
            imgTag = "<img alt=\"\(description)\" />"
        }
        let content: () -> [any HTML] = {
            [RawHTML(sourceElements + imgTag)]
        }
        super.init(
            tag: "picture",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
