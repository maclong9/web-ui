import Foundation

/// Generates an HTML pre element
///
/// To be used for rendering preformatted text such as groups of code elements.
public final class Preformatted: Element {
    /// Creates a new preformatted element.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "pre",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
