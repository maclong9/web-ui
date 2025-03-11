/// Represents common DOM events for triggering JavaScript actions.
public enum Action {
  /// Triggered when the element is clicked.
  case click
  /// Triggered when the mouse enters the element.
  case mouseenter
  /// Triggered when the mouse leaves the element.
  case mouseleave
  /// Triggered when the element gains focus.
  case focus
  /// Triggered when the element loses focus.
  case blur
  /// A custom event specified by a string.
  case custom(String)

  /// Returns the raw JavaScript event name.
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
