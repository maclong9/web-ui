import Foundation

/// Creates HTML time elements for representing dates and times.
///
/// Represents a specific date, time, or duration in a machine-readable format that benefits both
/// users and automated processes. The time element improves accessibility, enables precise time
/// interpretation across different locales, and provides semantic meaning to temporal data.
/// The required `datetime` attribute contains the machine-readable timestamp while the element's
/// content displays a human-friendly representation.
///
/// ## Example
/// ```swift
/// Time(datetime: "2023-12-25T00:00:00Z") { "Christmas Day" }
/// // Renders: <time datetime="2023-12-25T00:00:00Z">Christmas Day</time>
/// ```
public final class Time: Element {
    private let datetime: String

    /// Creates a new HTML time element.
    ///
    /// - Parameters:
    ///   - datetime: The machine-readable timestamp in a valid format (ISO 8601 recommended).
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the time element.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the time element.
    ///   - content: Closure providing the human-readable representation of the time.
    ///
    /// ## Example
    /// ```swift
    /// Time(
    ///   datetime: "PT2H30M",
    ///   classes: ["duration"]
    /// ) {
    ///   "2 hours and 30 minutes"
    /// }
    /// ```
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
