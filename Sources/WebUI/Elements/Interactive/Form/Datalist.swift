import Foundation

/// Creates an HTML datalist element containing predefined options for autocomplete.
///
/// Datalist provides autocomplete suggestions for input elements. Unlike select elements,
/// datalists allow users to enter custom values while providing helpful suggestions.
public struct Datalist: Element {
    private let id: String
    private let options: [String]

    /// Creates a new datalist with predefined options.
    ///
    /// - Parameters:
    ///   - id: Unique identifier referenced by input element's list attribute.
    ///   - options: Array of suggestion values to display.
    ///
    /// ## Example
    /// ```swift
    /// Input(name: "country", list: "countries")
    /// Datalist(id: "countries", options: ["France", "Germany", "Spain"])
    /// ```
    public init(id: String, options: [String]) {
        self.id = id
        self.options = options
    }

    public var body: some Markup {
        MarkupString(content: buildMarkupTag())
    }

    private func buildMarkupTag() -> String {
        let idAttr = Attribute.string("id", id) ?? ""
        let optionsHTML = options.map { option in
            let valueAttr = Attribute.string("value", option) ?? ""
            return "<option \(valueAttr)>"
        }.joined()

        return "<datalist \(idAttr)>\(optionsHTML)</datalist>"
    }
}
