/// Defines overflow behavior options.
///
/// Specifies how content exceeding an element's bounds is handled.
public enum OverflowType: String {
  /// Automatically adds scrollbars when content overflows.
  case auto
  /// Clips overflowing content and hides it.
  case hidden
  /// Displays overflowing content without clipping.
  case visible
  /// Always adds scrollbars, even if content fits.
  case scroll
}

extension Element {
  /// Applies overflow styling to the element.
  ///
  /// Sets how overflowing content is handled, optionally on a specific axis and with modifiers.
  ///
  /// - Parameters:
  ///   - type: Determines the overflow behavior (e.g., hidden, scroll).
  ///   - axis: Specifies the axis for overflow (defaults to both).
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated overflow classes.
  public func overflow(
    _ type: OverflowType,
    axis: Axis = .both,
    on modifiers: Modifier...
  ) -> Element {
    let axisString = axis.rawValue.isEmpty ? "" : "-\(axis.rawValue)"
    let baseClass = "overflow\(axisString)-\(type.rawValue)"

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = [baseClass]
    } else {
      newClasses = modifiers.map { modifier in
        "\(modifier.rawValue)\(baseClass)"
      }
    }

    return Element(
      tag: self.tag,
      config: ElementConfig(
        id: self.config.id,
        classes: (self.config.classes ?? []) + newClasses,
        role: self.config.role,
        label: self.config.label
      ),
      isSelfClosing: self.isSelfClosing,
      content: self.contentBuilder
    )
  }
}
