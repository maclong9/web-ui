import Foundation

/// Generates an HTML time element.
///
/// Used to represent a specific date, time, or duration in a machine-readable format.
/// The datetime attribute provides the machine-readable value while the content
/// can be a human-friendly representation.
public final class Time: Element {
    private let datetime: String

    /// Creates a new time element.
    public init(
        datetime: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.datetime = datetime
        let customAttributes = [
            Attribute.string("datetime", datetime)
        ].compactMap { $0 }
        super.init(
            tag: "time",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: customAttributes.isEmpty ? nil : customAttributes,
            content: content
        )
    }
}
