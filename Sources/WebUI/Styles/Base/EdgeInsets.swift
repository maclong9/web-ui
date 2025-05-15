import Foundation

/// Represents inset values for the four edges of an element.
///
/// This structure provides a convenient way to specify different spacing values
/// for each edge of an element when applying padding, margins, or other edge-based styling.
///
/// ## Example
/// ```swift
/// Button() { "Save" }
///   .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
///   .margins(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
/// ```
public struct EdgeInsets {
  /// The inset value for the top edge.
  public let top: Int

  /// The inset value for the leading (left) edge.
  public let leading: Int

  /// The inset value for the bottom edge.
  public let bottom: Int

  /// The inset value for the trailing (right) edge.
  public let trailing: Int

  /// Creates an EdgeInsets instance with specified values for each edge.
  ///
  /// - Parameters:
  ///   - top: The inset value for the top edge.
  ///   - leading: The inset value for the leading (left) edge.
  ///   - bottom: The inset value for the bottom edge.
  ///   - trailing: The inset value for the trailing (right) edge.
  ///
  /// ## Example
  /// ```swift
  /// // Card with different padding on each edge
  /// Stack() {
  ///   Text { "Card content with custom padding" }
  /// }
  /// .padding(EdgeInsets(top: 4, leading: 6, bottom: 8, trailing: 6))
  /// ```
  public init(top: Int, leading: Int, bottom: Int, trailing: Int) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  /// Creates an EdgeInsets instance with the same value for all edges.
  ///
  /// - Parameter value: The inset value to apply to all edges.
  ///
  /// ## Example
  /// ```swift
  /// // Uniform margins all around
  /// Button() { "Save" }
  ///   .margins(EdgeInsets(all: 4))
  /// ```
  public init(all value: Int) {
    self.top = value
    self.leading = value
    self.bottom = value
    self.trailing = value
  }

  /// Creates an EdgeInsets instance with separate values for vertical and horizontal edges.
  ///
  /// - Parameters:
  ///   - vertical: The inset value for top and bottom edges.
  ///   - horizontal: The inset value for leading and trailing edges.
  ///
  /// ## Example
  /// ```swift
  /// // Different padding for vertical and horizontal edges
  /// Stack() {
  ///   Text { "Content with more horizontal than vertical padding" }
  /// }
  /// .padding(EdgeInsets(vertical: 2, horizontal: 6))
  /// ```
  public init(vertical: Int, horizontal: Int) {
    self.top = vertical
    self.leading = horizontal
    self.bottom = vertical
    self.trailing = horizontal
  }
}

extension Element {
  /// Applies padding styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - insets: The EdgeInsets specifying padding values for each edge.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated padding classes.
  ///
  /// ## Example
  /// ```swift
  /// Button() { "Login" }
  ///   .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
  ///   .padding(EdgeInsets(vertical: 4, horizontal: 6), on: .hover)
  /// ```
  public func padding(_ insets: EdgeInsets, on modifiers: Modifier...) -> Element {
    var baseClasses: [String] = []

    // Add top padding if different from others
    baseClasses.append("pt-\(insets.top)")

    // Add leading padding
    baseClasses.append("pl-\(insets.leading)")

    // Add bottom padding
    baseClasses.append("pb-\(insets.bottom)")

    // Add trailing padding
    baseClasses.append("pr-\(insets.trailing)")

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Applies margin styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - insets: The EdgeInsets specifying margin values for each edge.
  ///   - auto: Whether to use automatic margins instead of specific lengths.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated margin classes.
  ///
  /// ## Example
  /// ```swift
  /// // Different margins for different edges
  /// Stack() {
  ///   Text { "Content with custom margins" }
  /// }
  /// .margins(EdgeInsets(top: 8, leading: 4, bottom: 2, trailing: 4))
  ///
  /// // Automatic margins for centering
  /// Button() { "Centered" }
  ///   .margins(EdgeInsets(all: 0), auto: true)
  /// ```
  public func margins(_ insets: EdgeInsets, auto: Bool = false, on modifiers: Modifier...) -> Element {
    var baseClasses: [String] = []

    if auto {
      baseClasses.append("mt-auto")
      baseClasses.append("ml-auto")
      baseClasses.append("mb-auto")
      baseClasses.append("mr-auto")
    } else {
      // Add top margin
      baseClasses.append("mt-\(insets.top)")

      // Add leading margin
      baseClasses.append("ml-\(insets.leading)")

      // Add bottom margin
      baseClasses.append("mb-\(insets.bottom)")

      // Add trailing margin
      baseClasses.append("mr-\(insets.trailing)")
    }

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Applies border width styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - insets: The EdgeInsets specifying border width values for each edge.
  ///   - style: The border style to apply.
  ///   - color: The border color to apply.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated border classes.
  ///
  /// ## Example
  /// ```swift
  /// // Card with different border widths on each side
  /// Stack() {
  ///   Text { "Card with custom borders" }
  /// }
  /// .border(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 2),
  ///         style: .solid,
  ///         color: .gray(._300))
  ///
  /// // Highlight on hover with thicker bottom border
  /// Link(to: "#") { "Hover me" }
  ///   .border(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0),
  ///           color: .blue(._500),
  ///           on: .hover)
  /// ```
  public func border(_ insets: EdgeInsets, style: BorderStyle? = nil, color: Color? = nil, on modifiers: Modifier...) -> Element {
    var baseClasses: [String] = []

    // Add top border width
    baseClasses.append("border-t-\(insets.top)")

    // Add leading border width
    baseClasses.append("border-l-\(insets.leading)")

    // Add bottom border width
    baseClasses.append("border-b-\(insets.bottom)")

    // Add trailing border width
    baseClasses.append("border-r-\(insets.trailing)")

    // Add border style if provided
    if let style = style {
      baseClasses.append("border-\(style.rawValue)")
    }

    // Add border color if provided
    if let color = color {
      baseClasses.append("border-\(color.rawValue)")
    }

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Applies position offset styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - type: The position type to apply (static, relative, absolute, fixed, sticky).
  ///   - insets: The EdgeInsets specifying position offset values for each edge.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated position classes.
  ///
  /// ## Example
  /// ```swift
  /// // Position element absolutely with custom insets
  /// Stack() {
  ///   Text { "Positioned content" }
  /// }
  /// .position(.absolute, insets: EdgeInsets(top: 2, leading: 4, bottom: 0, trailing: 0))
  ///
  /// // Sticky header with top offset
  /// Stack() {
  ///   Text { "Sticky Header" }
  /// }
  /// .position(.sticky, insets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  /// ```
  public func position(_ type: PositionType? = nil, insets: EdgeInsets, on modifiers: Modifier...) -> Element {
    var baseClasses: [String] = []

    // Add position type if provided
    if let type = type {
      baseClasses.append(type.rawValue)
    }

    // Add top position
    baseClasses.append("top-\(insets.top)")

    // Add left position (leading)
    baseClasses.append("left-\(insets.leading)")

    // Add bottom position
    baseClasses.append("bottom-\(insets.bottom)")

    // Add right position (trailing)
    baseClasses.append("right-\(insets.trailing)")

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }
}

extension ResponsiveBuilder {
  /// Applies padding styling to the element using EdgeInsets.
  ///
  /// - Parameter insets: The EdgeInsets specifying padding values for each edge.
  /// - Returns: The ResponsiveBuilder for method chaining.
  ///
  /// ## Example
  /// ```swift
  /// ResponsiveBuilder()
  ///   .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
  ///   .font(size: .lg)
  /// ```
  @discardableResult
  public func padding(_ insets: EdgeInsets) -> ResponsiveBuilder {
    padding(of: insets.top, at: .top)
    padding(of: insets.leading, at: .leading)
    padding(of: insets.bottom, at: .bottom)
    padding(of: insets.trailing, at: .trailing)
    return self
  }

  /// Applies margin styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - insets: The EdgeInsets specifying margin values for each edge.
  ///   - auto: Whether to use automatic margins instead of specific lengths.
  /// - Returns: The ResponsiveBuilder for method chaining.
  ///
  /// ## Example
  /// ```swift
  /// ResponsiveBuilder()
  ///   .margins(EdgeInsets(vertical: 2, horizontal: 4))
  ///   .background(color: .blue(._500))
  /// ```
  @discardableResult
  public func margins(_ insets: EdgeInsets, auto: Bool = false) -> ResponsiveBuilder {
    if auto {
      margins(of: nil, at: .top, auto: true)
      margins(of: nil, at: .leading, auto: true)
      margins(of: nil, at: .bottom, auto: true)
      margins(of: nil, at: .trailing, auto: true)
    } else {
      margins(of: insets.top, at: .top)
      margins(of: insets.leading, at: .leading)
      margins(of: insets.bottom, at: .bottom)
      margins(of: insets.trailing, at: .trailing)
    }
    return self
  }

  /// Applies border width styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - insets: The EdgeInsets specifying border width values for each edge.
  ///   - style: The border style to apply.
  ///   - color: The border color to apply.
  /// - Returns: The ResponsiveBuilder for method chaining.
  ///
  /// ## Example
  /// ```swift
  /// ResponsiveBuilder()
  ///   .border(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0),
  ///           style: .solid,
  ///           color: .gray(._200))
  ///   .rounded(.md)
  /// ```
  @discardableResult
  public func border(_ insets: EdgeInsets, style: BorderStyle? = nil, color: Color? = nil) -> ResponsiveBuilder {
    border(of: insets.top, at: .top)
    border(of: insets.leading, at: .leading)
    border(of: insets.bottom, at: .bottom)
    border(of: insets.trailing, at: .trailing)

    if let style = style {
      border(style: style)
    }

    if let color = color {
      border(color: color)
    }

    return self
  }

  /// Applies position offset styling to the element using EdgeInsets.
  ///
  /// - Parameters:
  ///   - type: The position type to apply (static, relative, absolute, fixed, sticky).
  ///   - insets: The EdgeInsets specifying position offset values for each edge.
  /// - Returns: The ResponsiveBuilder for method chaining.
  ///
  /// ## Example
  /// ```swift
  /// ResponsiveBuilder()
  ///   .position(.relative, insets: EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
  ///   .zIndex(10)
  /// ```
  @discardableResult
  public func position(_ type: PositionType? = nil, insets: EdgeInsets) -> ResponsiveBuilder {
    position(type, at: .top, offset: insets.top)
    position(type, at: .leading, offset: insets.leading)
    position(type, at: .bottom, offset: insets.bottom)
    position(type, at: .trailing, offset: insets.trailing)

    return self
  }
}
