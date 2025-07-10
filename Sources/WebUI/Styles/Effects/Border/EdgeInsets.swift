import Foundation

/// Represents edge-based insets for margin and padding styling.
///
/// Allows specifying different values for each edge (top, leading, bottom, trailing),
/// or for horizontal/vertical axes, similar to SwiftUI's `EdgeInsets`.
///
/// ## Example
/// ```swift
/// Stack()
///   .padding(EdgeInsets(vertical: 2, horizontal: 4))
///   .margins(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
/// ```
public struct EdgeInsets: Sendable, Equatable {
  /// The inset for the top edge.
  public let top: Int
  /// The inset for the leading (left) edge.
  public let leading: Int
  /// The inset for the bottom edge.
  public let bottom: Int
  /// The inset for the trailing (right) edge.
  public let trailing: Int

  /// Creates edge insets with individual values for each edge.
  ///
  /// - Parameters:
  ///   - top: The inset for the top edge.
  ///   - leading: The inset for the leading (left) edge.
  ///   - bottom: The inset for the bottom edge.
  ///   - trailing: The inset for the trailing (right) edge.
  public init(top: Int, leading: Int, bottom: Int, trailing: Int) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  /// Creates edge insets with the same value for all edges.
  ///
  /// - Parameter value: The inset value for all edges.
  public init(_ value: Int) {
    self.init(top: value, leading: value, bottom: value, trailing: value)
  }

  /// Creates edge insets with vertical and horizontal values.
  ///
  /// - Parameters:
  ///   - vertical: The inset for top and bottom edges.
  ///   - horizontal: The inset for leading and trailing edges.
  public init(vertical: Int, horizontal: Int) {
    self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
  }

  /// Returns true if all insets are equal.
  public var isUniform: Bool {
    top == leading && leading == bottom && bottom == trailing
  }

  /// Returns true if all insets are zero.
  public var isZero: Bool {
    top == 0 && leading == 0 && bottom == 0 && trailing == 0
  }
}

// MARK: - Margin and Padding Style API

extension Markup {
  /// Applies margin styling to the element using edge insets.
  ///
  /// - Parameters:
  ///   - insets: The edge insets to apply as margins.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: Markup with updated margin classes.
  ///
  /// ## Example
  /// ```swift
  /// Stack().margins(EdgeInsets(vertical: 2, horizontal: 4))
  /// ```
  public func margins(
    _ insets: EdgeInsets,
    on modifiers: Modifier...
  ) -> some Markup {
    let classes = EdgeInsets.marginClasses(from: insets)
    let newClasses = StyleUtilities.combineClasses(classes, withModifiers: modifiers)
    return StyleModifier(content: self, classes: newClasses)
  }

  /// Applies padding styling to the element using edge insets.
  ///
  /// - Parameters:
  ///   - insets: The edge insets to apply as padding.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: Markup with updated padding classes.
  ///
  /// ## Example
  /// ```swift
  /// Stack().padding(EdgeInsets(top: 2, leading: 1, bottom: 2, trailing: 1))
  /// ```
  public func padding(
    _ insets: EdgeInsets,
    on modifiers: Modifier...
  ) -> some Markup {
    let classes = EdgeInsets.paddingClasses(from: insets)
    let newClasses = StyleUtilities.combineClasses(classes, withModifiers: modifiers)
    return StyleModifier(content: self, classes: newClasses)
  }
}

extension EdgeInsets {
  /// Generates Tailwind CSS margin classes from edge insets.
  ///
  /// - Parameter insets: The edge insets.
  /// - Returns: An array of margin class strings.
  public static func marginClasses(from insets: EdgeInsets) -> [String] {
    var classes: [String] = []
    if insets.isUniform {
      if insets.top != 0 { classes.append("m-\(insets.top)") }
    } else {
      if insets.top != 0 { classes.append("mt-\(insets.top)") }
      if insets.leading != 0 { classes.append("ml-\(insets.leading)") }
      if insets.bottom != 0 { classes.append("mb-\(insets.bottom)") }
      if insets.trailing != 0 { classes.append("mr-\(insets.trailing)") }
    }
    return classes
  }

  /// Generates Tailwind CSS padding classes from edge insets.
  ///
  /// - Parameter insets: The edge insets.
  /// - Returns: An array of padding class strings.
  public static func paddingClasses(from insets: EdgeInsets) -> [String] {
    var classes: [String] = []
    if insets.isUniform {
      if insets.top != 0 { classes.append("p-\(insets.top)") }
    } else {
      if insets.top != 0 { classes.append("pt-\(insets.top)") }
      if insets.leading != 0 { classes.append("pl-\(insets.leading)") }
      if insets.bottom != 0 { classes.append("pb-\(insets.bottom)") }
      if insets.trailing != 0 { classes.append("pr-\(insets.trailing)") }
    }
    return classes
  }
}
