/// Defines common DOM events for JavaScript actions.
public enum Action {
  /// Triggered when an element is clicked.
  case click
  /// Triggered when the mouse enters an element.
  case mouseenter
  /// Triggered when the mouse leaves an element.
  case mouseleave
  /// Triggered when an element gains focus.
  case focus
  /// Triggered when an element loses focus.
  case blur
  /// Custom event with a specified name.
  case custom(String)

  /// Provides the raw JavaScript event name.
  ///
  /// - Returns: String representing the event name.
  public var rawValue: String {
    switch self {
      case .click: return "click"
      case .mouseenter: return "mouseenter"
      case .mouseleave: return "mouseleave"
      case .focus: return "focus"
      case .blur: return "blur"
      case .custom(let value): return value
    }
  }
}
