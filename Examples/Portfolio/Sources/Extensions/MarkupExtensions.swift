import Foundation
import WebUI

extension Markup {
    /// Conditionally applies a transformation to this markup
    func conditionallyApply<T: Markup>(_ condition: Bool, transform: (Self) -> T) -> AnyMarkup {
        if condition {
            return AnyMarkup(transform(self))
        } else {
            return AnyMarkup(self)
        }
    }
    
    /// Adds a data attribute to this markup
    func dataAttribute(_ name: String, value: String) -> AnyMarkup {
        // Note: Attribute modification not directly supported in current WebUI API
        return AnyMarkup(self)
    }
    
    /// Adds raw HTML content to this markup
    func rawHTML(_ content: String) -> AnyMarkup {
        AnyMarkup(Group {
            self
            RawHTML(content)
        })
    }
}

/// A wrapper for raw HTML content
struct RawHTML: Markup {
    let content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    var body: some Markup {
        EmptyMarkup().rawHTML(content)
    }
}

/// Empty markup for composition
struct EmptyMarkup: Markup {
    var body: some Markup {
        Group {
            // Empty content
        }
    }
}

/// Type-erased markup for dynamic content
struct AnyMarkup: Markup {
    private let _render: () -> String
    
    init<M: Markup>(_ markup: M) {
        self._render = { markup.render() }
    }
    
    var body: some Markup {
        self
    }
    
    func render() -> String {
        _render()
    }
}

/// ForEach helper for iterating over collections in markup
struct ForEach<Data: Collection, Content: Markup>: Markup {
    let data: Data
    let content: (Data.Element) -> Content
    
    init(_ data: Data, @MarkupBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    var body: some Markup {
        Group {
            for item in data {
                content(item)
            }
        }
    }
}

extension ForEach where Data.Element: Hashable {
    init(_ data: Data, @MarkupBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}