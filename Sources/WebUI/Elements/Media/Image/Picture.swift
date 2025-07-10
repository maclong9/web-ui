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
public struct Picture: Element {
  private let sources: [(src: String, type: ImageType?)]
  private let description: String
  private let size: MediaSize?
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?

  /// Creates a new HTML picture element.
  ///
  /// - Parameters:
  ///   - sources: Array of tuples containing source URL and optional image MIME type.
  ///   - description: Alt text for accessibility.
  ///   - size: Picture size dimensions, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of stylesheet classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// ## Example
  /// ```swift
  /// Picture(
  ///     sources: [
  ///         (src: "/images/photo.webp", type: .webp),
  ///         (src: "/images/photo.jpg", type: .jpeg)
  ///     ],
  ///     description: "Mountain landscape",
  ///     size: MediaSize(width: 800, height: 600)
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

    var content = ""

    // Add source elements
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
        isSelfClosing: true
      )
    }

    // Add fallback image
    content += Image(
      source: sources.first?.src ?? "",
      description: description,
      size: size,
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data
    ).render()

    return AttributeBuilder.buildMarkupTag(
      "picture", attributes: attributes, content: content)
  }
}
