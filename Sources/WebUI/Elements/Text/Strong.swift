import Foundation

/// Generates an HTML strong importance element.
///
/// To be used for drawing strong attention to text within another body of text.
public final class Strong: Element {
    /// Creates a new strong element.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "strong",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
