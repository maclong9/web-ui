import Foundation

/// Helper functions to create Elements with proper styling
/// This approach works with WebUI's native Element constructors

public struct ElementBuilder {
    /// Creates a Button with component styling
    public static func button(
        _ title: String,
        type: ButtonType? = nil,
        disabled: Bool = false,
        classes: [String] = [],
        data: [String: String] = [:],
        onClick: String? = nil
    ) -> Button {
        return Button(
            title,
            type: type,
            onClick: disabled ? nil : onClick,
            classes: classes.isEmpty ? nil : classes,
            data: data.isEmpty ? nil : data
        )
    }
    
    /// Creates an Input with component styling
    public static func input(
        name: String,
        type: InputType? = nil,
        value: String? = nil,
        placeholder: String? = nil,
        required: Bool = false,
        disabled: Bool = false,
        classes: [String] = [],
        data: [String: String] = [:]
    ) -> Input {
        return Input(
            name: name,
            type: type,
            value: value,
            placeholder: placeholder,
            required: required ? true : nil,
            classes: classes.isEmpty ? nil : classes,
            data: data.isEmpty ? nil : data
        )
    }
    
    /// Creates a Section with component styling
    public static func section(
        classes: [String] = [],
        role: AriaRole? = nil,
        data: [String: String] = [:],
        @MarkupBuilder content: @escaping MarkupContentBuilder
    ) -> Section {
        return Section(
            classes: classes.isEmpty ? nil : classes,
            role: role,
            data: data.isEmpty ? nil : data,
            content: content
        )
    }
    
    /// Creates a Text with component styling
    public static func text(
        _ content: String,
        classes: [String] = []
    ) -> Text {
        return Text(
            content,
            classes: classes.isEmpty ? nil : classes
        )
    }
}