import Foundation

/// Represents an HTML component or element.
///
/// The `HTML` protocol is the foundation for all HTML elements in WebUI. It defines
/// how components describe their structure and content.
///
/// Elements conforming to HTML can be composed together to create complex layouts
/// while maintaining a declarative syntax. The protocol handles both primitive HTML
/// string content and composite element structures.
///
/// ## Example
/// ```swift
/// struct CustomCard: Element {
///     var title: String
///     var content: String
///
///     var body: some HTML {
///         Stack {
///             Heading(.title) { title }
///             Text { content }
///         }
///         .padding(.medium)
///         .backgroundColor(.white)
///         .rounded(.md)
///     }
/// }
/// ```
public protocol HTML {
    /// The type of HTML content this component produces.
    associatedtype Body: HTML

    /// The content and structure of this HTML component.
    ///
    /// The `body` property defines the component's layout and content hierarchy.
    /// This pattern mirrors SwiftUI's declarative syntax, making the code more
    /// intuitive and maintainable.
    ///
    /// - Returns: A composition of HTML elements that make up this component.
    var body: Body { get }

    /// Renders the HTML component to its string representation.
    ///
    /// This method converts the HTML component into its final HTML string representation
    /// for output to files or HTTP responses.
    ///
    /// - Returns: The rendered HTML string.
    func render() -> String
}

/// A type-erased HTML component.
///
/// `AnyHTML` wraps any HTML-conforming type, allowing for type erasure in
/// heterogeneous collections or when specific type information isn't needed.
public struct AnyHTML: HTML {
    private let wrapped: any HTML
    private let renderClosure: () -> String

    public init<T: HTML>(_ html: T) {
        self.wrapped = html
        self.renderClosure = { html.render() }
    }

    public var body: AnyHTML {
        self
    }

    public func render() -> String {
        renderClosure()
    }
}

/// Primitive HTML string content.
///
/// Used internally to represent raw HTML string content within the HTML hierarchy.
internal struct HTMLString: HTML {
    let content: String

    var body: HTMLString {
        self
    }

    func render() -> String {
        content
    }
}

// String extension that conforms to HTML is in Utilities/String.swift

// MARK: - Default Implementations

public extension HTML {
    /// Default render implementation that delegates to the body.
    func render() -> String {
        body.render()
    }
}

// MARK: - Legacy Support

extension HTML {
    /// Converts the HTML to its string representation for rendering.
    ///
    /// This method provides backward compatibility with existing code
    /// that uses toString() instead of render().
    internal func toString() -> String {
        render()
    }
}
