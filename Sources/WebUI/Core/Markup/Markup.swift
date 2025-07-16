import Foundation

/// Represents a markup component or element.
///
/// The `Markup` protocol is the foundation for all markup elements in WebUI. It
/// defines how components describe their structure and content.
///
/// Elements conforming to Markup can be composed together to create complex
/// layouts while maintaining a declarative syntax. The protocol handles both
/// primitive markup string content and composite element structures.
///
/// ## Example
/// ```swift
/// struct CustomCard: Element {
///     var title: String
///     var content: String
///
///     var body: some Markup {
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
public protocol Markup {
    /// The type of markup content this component produces.
    associatedtype Body: Markup

    /// The content and structure of this markup component.
    ///
    /// The `body` property defines the component's layout and content
    /// hierarchy.  This pattern mirrors SwiftUI's declarative syntax, making
    /// the code more intuitive and maintainable.
    ///
    /// - Returns: A composition of markup elements that make up this component.
    var body: Body { get }

    /// Renders the markup component to its string representation.
    ///
    /// This method converts the markup component into its final markup string representation
    /// for output to files or responses.
    ///
    /// - Returns: The rendered markup string.
    func render() -> String
}

/// A type-erased markup component.
///
/// `AnyMarkup` wraps any Markup-conforming type, allowing for type erasure in
/// heterogeneous collections or when specific type information isn't needed.
public struct AnyMarkup: Markup {
    private let wrapped: any Markup
    private let renderClosure: () -> String

    public init<T: Markup>(_ markup: T) {
        self.wrapped = markup
        self.renderClosure = { markup.render() }
    }

    public var body: AnyMarkup {
        self
    }

    public func render() -> String {
        renderClosure()
    }
}

/// Primitive markup string content.
///
/// Used internally to represent raw markup string content within the markup hierarchy.
public struct MarkupString: Markup {
    let content: String

    public var body: MarkupString {
        self
    }

    public func render() -> String {
        content
    }

    public init(content: String) {
        self.content = content
    }
}

// String extension that conforms to Markup is in Utilities/String.swift

// MARK: - Default Implementations

extension Markup {
    /// Default render implementation that delegates to the body.
    public func render() -> String {
        body.render()
    }

    /// Adds stylesheet classes to a markup element
    ///
    /// - Parameter classes: The stylesheet classes to add
    /// - Returns: A container with the markup content and additional classes
    public func addingClasses(_ classes: [String]) -> some Markup {
        MarkupClassContainer(content: self, classes: classes)
    }
}

/// A container that adds stylesheet classes to markup content
public struct MarkupClassContainer<Content: Markup>: Markup {
    private let content: Content
    private let classes: [String]

    public init(content: Content, classes: [String]) {
        self.content = content
        self.classes = classes
    }

    public var body: MarkupString {
        MarkupString(content: renderWithClasses())
    }

    private func renderWithClasses() -> String {
        // Get the rendered content
        let renderedContent = content.render()

        // If there are no classes to add, return the content as is
        if classes.isEmpty {
            return renderedContent
        }

        // Check if content starts with a markup tag
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
