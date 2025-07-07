/// Convenience type aliases for common list patterns

/// Convenience typealias for an unordered list
public typealias UnorderedList = List

/// Convenience typealias for an ordered list
public typealias OrderedList = List

/// Convenience typealias for a list item
public typealias ListItem = Item

extension List {
    /// Creates an unordered list (ul)
    public init(
        style: ListStyle = .none,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @MarkupBuilder content: @escaping MarkupContentBuilder
    ) {
        self.init(
            type: .unordered,
            style: style,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

extension OrderedList {
    /// Creates an ordered list (ol)
    public static func ordered(
        style: ListStyle = .none,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @MarkupBuilder content: @escaping MarkupContentBuilder
    ) -> List {
        return List(
            type: .ordered,
            style: style,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}