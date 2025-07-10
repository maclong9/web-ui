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
  ///   - classes: An array of stylesheet classnames.
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

  public var body: some Markup {
    MarkupString(content: buildMarkupTag())
  }

  private func buildMarkupTag() -> String {
    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data
    )

    let pictureElement = renderPictureElement()
    let figcaptionElement = AttributeBuilder.buildMarkupTag(
      "figcaption", attributes: [], content: description)
    return AttributeBuilder.buildMarkupTag(
      "figure", attributes: attributes,
      content: pictureElement + figcaptionElement)
  }

  private func renderPictureElement() -> String {
    var content = ""
    for source in sources {
      var sourceAttributes: [String] = []
      if let type = source.type,
        let typeAttr = Attribute.string("type", type.rawValue)
      {
        sourceAttributes.append(typeAttr)
      }
      if let srcsetAttr = Attribute.string("srcset", source.src) {
        sourceAttributes.append(srcsetAttr)
      }
      content += AttributeBuilder.buildMarkupTag(
        "source",
        attributes: sourceAttributes,
        hasNoClosingTag: true
      )
    }

    var imgAttributes: [String] = []
    if let srcAttr = Attribute.string("src", sources.first?.src ?? "") {
      imgAttributes.append(srcAttr)
    }
    if let altAttr = Attribute.string("alt", description) {
      imgAttributes.append(altAttr)
    }

    if let size = size {
      if let width = size.width,
        let widthAttr = Attribute.string("width", "\(width)")
      {
        imgAttributes.append(widthAttr)
      }
      if let height = size.height,
        let heightAttr = Attribute.string("height", "\(height)")
      {
        imgAttributes.append(heightAttr)
      }
    }

    content += AttributeBuilder.buildMarkupTag(
      "img", attributes: imgAttributes, isSelfClosing: true)
    return AttributeBuilder.buildMarkupTag(
      "picture", attributes: [], content: content)
  }
}
