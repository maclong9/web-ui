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
public struct Image: Element {
    private let source: String
    private let description: String
    private let type: ImageType?
    private let size: MediaSize?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?

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
        self.source = source
        self.description = description
        self.type = type
        self.size = size
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        if let srcAttr = Attribute.string("src", source) {
            attributes.insert(srcAttr, at: 0)
        }
        if let altAttr = Attribute.string("alt", description) {
            attributes.insert(altAttr, at: 1)
        }
        if let type, let typeAttr = Attribute.string("type", type.rawValue) {
            attributes.append(typeAttr)
        }
        if let size = size {
            if let width = size.width,
                let widthAttr = Attribute.string("width", "\(width)")
            {
                attributes.append(widthAttr)
            }
            if let height = size.height,
                let heightAttr = Attribute.string("height", "\(height)")
            {
                attributes.append(heightAttr)
            }
        }
        return AttributeBuilder.renderTag(
            "img", attributes: attributes, isSelfClosing: true)
    }
}
