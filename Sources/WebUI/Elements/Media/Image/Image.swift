import Foundation

/// Creates HTML image elements for displaying graphical content.
///
/// Represents an image that can be embedded in a webpage, with support for accessibility
/// descriptions and sizing information. Images are fundamental for illustrating content
/// and enhancing visual communication.
///
/// ## Example
/// ```swift
/// Image(
///   source: "logo.png",
///   description: "Company Logo",
///   type: .png,
///   size: MediaSize(width: 100, height: 100)
/// )
/// ```
public final class Image: Element {
    /// Creates a new HTML image element.
    ///
    /// - Parameters:
    ///   - source: The image source URL or path.
    ///   - description: The alt text for the image for accessibility and SEO.
    ///   - type: The MIME type of the image, optional.
    ///   - size: The size of the image in pixels, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the image.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when alt text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the image.
    public init(
        source: String,
        description: String,
        type: ImageType? = nil,
        size: MediaSize? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        var attributes: [String] = ["src=\"\(source)\"", "alt=\"\(description)\""]
        if let type = type { attributes.append("type=\"\(type.rawValue)\"") }
        if let size = size {
            if let width = size.width { attributes.append("width=\"\(width)\"") }
            if let height = size.height { attributes.append("height=\"\(height)\"") }
        }
        super.init(
            tag: "img",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: attributes
        )
    }
}
