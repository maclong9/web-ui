import Foundation

/// A protocol for building reusable markup components with a SwiftUI-like pattern.
///
/// The `Element` protocol extends `Markup` to provide a body property that
/// follows the SwiftUI pattern for building declarative user interfaces.
/// Elements define their content through the `body` property, making it easy
/// to compose complex layouts from simple, reusable components.
///
/// ## Example
/// ```swift
/// struct Card: Element {
///   var title: String
///   var body: some Markup {
///     Stack {
///       Text { title }
///     }
///   }
/// }
/// ```
public protocol Element: Markup {
    /// The content and structure of this element.
    ///
    /// The `body` property defines the element's layout and content hierarchy.
    /// This pattern mirrors SwiftUI's declarative syntax, making the code more
    /// intuitive and maintainable.
    ///
    /// - Returns: A composition of markup elements that make up this component.
    var body: Body { get }
}
