import Foundation

/// A protocol for building reusable HTML components with a SwiftUI-like pattern.
///
/// The `Element` protocol extends `HTML` to provide a body property that follows
/// the SwiftUI pattern for building declarative user interfaces. Elements define
/// their content through the `body` property, making it easy to compose complex
/// layouts from simple, reusable components.
///
/// ## Example
/// ```swift
/// struct Card: Element {
///   var title: String
///   var body: some HTML {
///     Stack {
///       Text { title }
///     }
///   }
/// }
/// ```
public protocol Element: HTML {
    /// The content and structure of this element.
    ///
    /// The `body` property defines the element's layout and content hierarchy.
    /// This pattern mirrors SwiftUI's declarative syntax, making the code more
    /// intuitive and maintainable.
    ///
    /// - Returns: A composition of HTML elements that make up this component.
    var body: Body { get }
}

// MARK: - Default Implementations

extension Element {
    /// Default implementation that renders the body content.
    public func render() -> String {
        body.render()
    }
}

// MARK: - Common Element Types

/// A container that wraps arbitrary HTML content.
public struct HTMLContainer<Content: HTML>: Element {
    private let content: Content

    public init(_ content: Content) {
        self.content = content
    }

    public var body: Content {
        content
    }
    
    public typealias Body = Content
}
