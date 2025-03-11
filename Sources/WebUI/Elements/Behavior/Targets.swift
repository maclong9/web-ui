public enum StyleProperty {
  /// The text color of the element.
  case color
  /// The background color of the element.
  case backgroundColor
  /// The display type of the element (e.g., block, inline).
  case display
  /// The visibility of the element (e.g., visible, hidden).
  case visibility
  /// The font size of the element (e.g., 16px).
  case fontSize
  /// A custom style property specified by a string
  case custom(String)

  /// Returns the raw JavaScript property name.
  public var rawValue: String {
    switch self {
      case .color: return "color"
      case .backgroundColor: return "backgroundColor"
      case .display: return "display"
      case .visibility: return "visibility"
      case .fontSize: return "fontSize"
      case .custom(let value): return value
    }
  }
}

/// Represents common HTML attributes for JavaScript manipulation.
public enum AttributeName {
  /// Indicates whether an element is disabled (e.g., for form inputs).
  case disabled
  /// Hides an element from view and layout.
  case hidden
  /// A custom data attribute (e.g., data-id).
  case data(String)
  /// Specifies the source URL for media elements (e.g., img, video).
  case src
  /// Provides alternative text for images.
  case alt
  /// A custom attribute specified by a string.
  case custom(String)

  /// Returns the raw HTML attribute name.
  public var rawValue: String {
    switch self {
      case .disabled: return "disabled"
      case .hidden: return "hidden"
      case .data(let value): return "data-\(value)"
      case .src: return "src"
      case .alt: return "alt"
      case .custom(let value): return value
    }
  }
}
