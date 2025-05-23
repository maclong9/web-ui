/// Represents a JavaScript script with its source and optional loading attribute.
///
/// Used to define scripts that should be included in the HTML document.
///
/// - Example:
///   ```swift
///   let mainScript = Script(src: "/js/main.js", attribute: .defer)
///   ```
public struct Script: Element {
    private let src: String
    private let attribute: ScriptAttribute?

    public init(src: String, attribute: ScriptAttribute? = nil) {
        self.src = src
        self.attribute = attribute
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var additional: [String] = []
        if let srcAttr = Attribute.string("src", src) {
            additional.append(srcAttr)
        }
        if let attribute, let attr = Attribute.string(attribute.rawValue, attribute.rawValue) {
            additional.append(attr)
        }
        let attributes = AttributeBuilder.buildAttributes(
            additional: additional
        )
        return AttributeBuilder.renderTag("script", attributes: attributes)
    }
}
