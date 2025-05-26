import Foundation

/// Represents an HTML component or element.
///
/// The `HTML` protocol is the foundation for all HTML elements in WebUI. It
/// defines how components describe their structure and content.
///
/// Elements conforming to HTML can be composed together to create complex
/// layouts while maintaining a declarative syntax. The protocol handles both
/// primitive HTML string content and composite element structures.
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
    /// The `body` property defines the component's layout and content
    /// hierarchy.  This pattern mirrors SwiftUI's declarative syntax, making
    /// the code more intuitive and maintainable.
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
public struct HTMLString: HTML {
    let content: String

    public var body: HTMLString {
        self
    }

    public func render() -> String {
        content
    }

    public init(content: String) {
        self.content = content
    }
}

// String extension that conforms to HTML is in Utilities/String.swift

// MARK: - Default Implementations

extension HTML {
    /// Default render implementation that delegates to the body.
    public func render() -> String {
        body.render()
    }

    /// Adds CSS classes to an HTML element
    ///
    /// - Parameter classes: The CSS classes to add
    /// - Returns: A container with the HTML content and additional classes
    public func addingClasses(_ classes: [String]) -> some HTML {
        HTMLClassContainer(content: self, classes: classes)
    }
}

/// A container that adds CSS classes to HTML content
public struct HTMLClassContainer<Content: HTML>: HTML {
    private let content: Content
    private let classes: [String]

    public init(content: Content, classes: [String]) {
        self.content = content
        self.classes = classes
    }

    public var body: HTMLString {
        HTMLString(content: renderWithClasses())
    }

    private func renderWithClasses() -> String {
        // Get the rendered content
        let renderedContent = content.render()

        // If there are no classes to add, return the content as is
        if classes.isEmpty {
            return renderedContent
        }

        // Check if content starts with an HTML tag
        guard
            let tagRange = renderedContent.range(
                of: "<[^>]+>", options: .regularExpression)
        else {
            // If not, wrap the content in a span with the classes
            return
                "<span class=\"\(classes.joined(separator: " "))\">\(renderedContent)</span>"
        }

        // Extract the tag
        let tag = renderedContent[tagRange]

        // Check if the tag already has a class attribute
        if tag.contains(" class=\"") {
            // Extract existing classes using string manipulation
            let tagString = String(tag)

            guard let classStart = tagString.range(of: " class=\""),
                let classEnd = tagString.range(
                    of: "\"", range: classStart.upperBound..<tagString.endIndex)
            else {
                return renderedContent
            }

            let existingClasses = String(
                tagString[classStart.upperBound..<classEnd.lowerBound])
            let allClasses =
                existingClasses.isEmpty
                ? classes.joined(separator: " ")
                : "\(existingClasses) \(classes.joined(separator: " "))"

            let modifiedTag = tagString.replacingCharacters(
                in: classStart.upperBound..<classEnd.lowerBound,
                with: allClasses
            )

            return renderedContent.replacingCharacters(
                in: tagRange, with: modifiedTag)
        } else {
            // Insert a class attribute before the closing >
            let modifiedTag = String(tag).replacingOccurrences(
                of: ">$",
                with: " class=\"\(classes.joined(separator: " "))\">",
                options: .regularExpression
            )

            return renderedContent.replacingCharacters(
                in: tagRange, with: modifiedTag)
        }
    }
}
