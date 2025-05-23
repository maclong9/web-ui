import Foundation

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
public struct Figure: Element {
    private let sources: [(src: String, type: ImageType?)]
    private let description: String
    private let size: MediaSize?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    
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
        let attributes = buildAttributes()
        
        // Render the picture element with sources
        let pictureElement = renderPictureElement()
        
        // Render the figcaption element
        let figcaptionElement = "<figcaption>\(description)</figcaption>"
        
        return "<figure \(attributes.joined(separator: " "))>\(pictureElement)\(figcaptionElement)</figure>"
    }
    
    private func renderPictureElement() -> String {
        let sourceElements = sources.map { source in
            let type = source.type?.rawValue
            return "<source src=\"\(source.src)\"\(type != nil ? " type=\"\(type!)\"" : "")>"
        }.joined()
        
        // Render the img element
        let imgAttributes = [
            "src=\"\(sources[0].src)\"",
            "alt=\"\(description)\""
        ]
        
        if let size = size {
            var sizeAttributes: [String] = []
            if let width = size.width {
                sizeAttributes.append("width=\"\(width)\"")
            }
            if let height = size.height {
                sizeAttributes.append("height=\"\(height)\"")
            }
            return "<picture>\(sourceElements)<img \((imgAttributes + sizeAttributes).joined(separator: " "))></picture>"
        } else {
            return "<picture>\(sourceElements)<img \(imgAttributes.joined(separator: " "))></picture>"
        }
    }
    
    private func buildAttributes() -> [String] {
        var attributes: [String] = []
        
        if let id = id {
            attributes.append(Attribute.string("id", id)!)
        }
        
        if let classes = classes, !classes.isEmpty {
            attributes.append(Attribute.string("class", classes.joined(separator: " "))!)
        }
        
        if let role = role {
            attributes.append(Attribute.typed("role", role)!)
        }
        
        if let label = label {
            attributes.append(Attribute.string("aria-label", label)!)
        }
        
        if let data = data {
            for (key, value) in data {
                attributes.append(Attribute.string("data-\(key)", value)!)
            }
        }
        
        return attributes
    }
}