import Foundation

/// Provides common styling utilities for HTML elements
public enum ElementStyling {
  /// Applies stylesheet classes to HTML content
  ///
  /// - Parameters:
  ///   - content: The HTML content to apply classes to
  ///   - classes: The stylesheet classes to apply
  /// - Returns: Markup content with classes applied
  public static func applyClasses<T: Markup>(_ content: T, classes: [String])
    -> some Markup
  {
    content.addingClasses(classes)
  }

  /// Combines base classes with modifier classes
  ///
  /// - Parameters:
  ///   - baseClasses: The base stylesheet classes
  ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
  /// - Returns: Combined array of stylesheet classes
  public static func combineClasses(
    _ baseClasses: [String], withModifiers modifiers: [Modifier]
  ) -> [String] {
    guard !modifiers.isEmpty else {
      return baseClasses
    }

    let modifierPrefix = modifiers.map { $0.rawValue }.joined()
    return baseClasses.map { "\(modifierPrefix)\($0)" }
  }
}

/// Extension to provide styling helpers for HTML protocol
extension Markup {
  /// Adds stylesheet classes to an HTML element
  ///
  /// - Parameter classNames: The stylesheet class names to add
  /// - Returns: Markup with the classes applied
  public func addClass(_ classNames: String...) -> some Markup {
    addingClasses(classNames)
  }

  /// Adds stylesheet classes to an HTML element
  ///
  /// - Parameter classNames: The stylesheet class names to add
  /// - Returns: Markup with the classes applied
  public func addClasses(_ classNames: [String]) -> some Markup {
    addingClasses(classNames)
  }

  /// Applies a style with modifier to the element
  ///
  /// - Parameters:
  ///   - baseClasses: The base stylesheet classes to apply
  ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
  /// - Returns: Markup with the styled classes applied
  public func applyStyle(baseClasses: [String], modifiers: [Modifier] = [])
    -> some Markup
  {
    let classes = ElementStyling.combineClasses(
      baseClasses, withModifiers: modifiers)
    return addingClasses(classes)
  }

  /// Conditionally applies a modifier based on a boolean condition
  ///
  /// This provides SwiftUI-style conditional modification syntax.
  ///
  /// - Parameters:
  ///   - condition: Boolean condition that determines whether to apply the modifier
  ///   - modifier: Closure that applies styling when condition is true
  /// - Returns: Markup with conditional styling applied
  ///
  /// ## Example
  /// ```swift
  /// Text("Hello, world!")
  ///     .if(isHighlighted) { $0.background(color: .yellow) }
  ///     .if(isLarge) { $0.font(size: .xl) }
  /// ```
  public func `if`<T: Markup>(_ condition: Bool, _ modifier: (Self) -> T) -> AnyMarkup {
    if condition {
      return AnyMarkup(modifier(self))
    } else {
      return AnyMarkup(self)
    }
  }
}
