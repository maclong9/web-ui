import Foundation

extension Element {
  /// Adds a JavaScript script to the element for DOM manipulation.
  ///
  /// Creates a new `Element` with the original content plus a `<script>` tag containing
  /// JavaScript to manipulate the DOM. When an `action` is provided, the manipulation
  /// is wrapped in an event listener; otherwise, it executes immediately.
  ///
  /// - Note: Only one action (`toggle`, `add`, or `remove`) should be true. Priority is:
  ///   1. toggle, 2. add, 3. remove.
  ///
  /// - Parameters:
  ///   - select: Optional CSS selector or ID to target (e.g., "#el", ".class"); defaults to targeting this element.
  ///   - className: Class name to manipulate (e.g., "active").
  ///   - style: Style property to manipulate (e.g., .color).
  ///   - attribute: Attribute to manipulate (e.g., .disabled).
  ///   - toggle: Toggles the specified property if true.
  ///   - add: Adds the specified property if true.
  ///   - remove: Removes the specified property if true.
  ///   - value: Value for the action (e.g., "red" for style).
  ///   - action: DOM event to trigger the manipulation (e.g., .click); nil for immediate execution.
  /// - Returns: New Element with original content and script.
  func script(
    select: String? = nil,
    className: String? = nil,
    style: StyleProperty? = nil,
    attribute: AttributeName? = nil,
    toggle: Bool = false,
    add: Bool = false,
    remove: Bool = false,
    value: String? = nil,
    on action: Action? = nil
  ) -> Element {
    // Validate input
    guard className != nil || style != nil || attribute != nil else { return self }
    let requiresValue = style != nil || attribute != nil || (className != nil && (toggle || add))
    guard !requiresValue || value != nil else { return self }

    // Setup
    let elementId = self.id ?? "gen\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"
    let selector = select.map { $0.hasPrefix("#") || $0.hasPrefix(".") ? $0 : "#\($0)" } ?? "#\(elementId)"
    let elementRef = "document.querySelector('\(selector)')"
    let actionType = toggle ? "toggle" : add ? "add" : remove ? "remove" : ""

    // Generate manipulation
    let manipulation: String
    switch (className, style, attribute) {
      case (let className?, nil, nil):
        let valueOrClass = actionType == "remove" ? className : value!
        manipulation = "\(elementRef).classList.\(actionType)('\(valueOrClass)');"

      case (nil, let style?, nil):
        let propName = style.rawValue
        if actionType == "toggle" {
          manipulation =
            "\(elementRef).style.\(propName) = \(elementRef).style.\(propName) === '\(value!)' ? '' : '\(value!)';"
        } else if actionType == "add" {
          manipulation = "\(elementRef).style.\(propName) = '\(value!)';"
        } else {  // remove
          manipulation = "\(elementRef).style.\(propName) = '';"
        }

      case (nil, nil, let attribute?):
        let attrName = attribute.rawValue
        if actionType == "toggle" {
          manipulation =
            "\(elementRef).hasAttribute('\(attrName)') ? \(elementRef).removeAttribute('\(attrName)') : \(elementRef).setAttribute('\(attrName)', '\(value!)');"
        } else if actionType == "add" {
          manipulation = "\(elementRef).setAttribute('\(attrName)', '\(value!)');"
        } else {
          manipulation = "\(elementRef).removeAttribute('\(attrName)');"
        }

      default:
        return self
    }

    // Wrap in event listener if needed
    let jsCode =
      action.map {
        """
        let el = \(elementRef);
        el.addEventListener('\($0.rawValue)', () => {
          \(manipulation)
        });
        """
      } ?? manipulation

    // Return new element with script
    return Element(tag: self.tag, id: elementId, classes: self.classes, role: self.role) {
      if let originalContent = self.contentBuilder() {
        for item in originalContent {
          item
        }
      }
      "<script>\(jsCode)</script>"
    }
  }
}
