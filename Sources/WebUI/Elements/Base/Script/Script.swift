/// Represents a JavaScript script with its source and optional loading attribute.
///
/// Used to define scripts that should be included in the HTML document.
///
/// - Example:
///   ```swift
///   let mainScript = Script(src: "/js/main.js", attribute: .defer)
///   ```
public struct Script: Element {
  let src: String?
  let attribute: ScriptAttribute?
  let placement: ScriptPlacement
  let content: () -> String

  public init(
    src: String? = nil,
    attribute: ScriptAttribute? = nil,
    placement: ScriptPlacement = .body,
    content: @escaping () -> String = { "" }
  ) {
    self.src = src
    self.attribute = attribute
    self.placement = placement
    self.content = content
  }

  public var body: some Markup {
    MarkupString(content: buildMarkupTag())
  }

  private func buildMarkupTag() -> String {
    var additional: [String] = []
    if let attribute,
      let attributeAttr = Attribute.bool(attribute.rawValue, true)
    {
      additional.append(attributeAttr)
    }
    if let src, let srcAttr = Attribute.string("src", src) {
      additional.append(srcAttr)
    }
    let attributes = AttributeBuilder.buildAttributes(
      additional: additional
    )

    return AttributeBuilder.buildMarkupTag(
      "script", attributes: attributes, content: content())
  }
}
