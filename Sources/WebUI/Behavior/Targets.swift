/// Defines CSS style properties for JavaScript manipulation.
public enum StyleProperty {
  /// Text color of an element.
  case color
  /// Background color of an element.
  case backgroundColor
  /// Display type of an element.
  case display
  /// Visibility of an element.
  case visibility
  /// Font size of an element.
  case fontSize
  /// Custom style property with a specified name.
  case custom(String)

  /// Provides the raw JavaScript property name.
  ///
  /// - Returns: String representing the property name.
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

/// Defines common HTML attributes for JavaScript manipulation.
public enum AttributeName {
  /// Indicates if an element is disabled.
  case disabled
  /// Hides an element from view and layout.
  case hidden
  /// Custom data attribute with a specified name.
  case data(String)
  /// Source URL for media elements.
  case src
  /// Alternative text for images.
  case alt
  /// Custom attribute with a specified name.
  case custom(String)

  /// Provides the raw HTML attribute name.
  ///
  /// - Returns: String representing the attribute name.
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
