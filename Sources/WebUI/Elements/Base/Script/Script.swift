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
    let contentBuilder: HTMLContentBuilder

    public init(
        src: String? = nil,
        attribute: ScriptAttribute? = nil,
        placement: ScriptPlacement = .body,
        @HTMLBuilder content: @escaping HTMLContentBuilder = { [] }
    ) {
        self.src = src
        self.attribute = attribute
        self.placement = placement
        self.contentBuilder = content
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var additional: [String] = []
        if let src, let srcAttr = Attribute.string("src", src) {
            additional.append(srcAttr)
        }
        if let attribute, let attributeAttr = Attribute.string(attribute.rawValue, attribute.rawValue) {
            additional.append(attributeAttr)
        }
        let attributes = AttributeBuilder.buildAttributes(
            additional: additional
        )
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.renderTag("script", attributes: attributes, content: content)
    }
}
