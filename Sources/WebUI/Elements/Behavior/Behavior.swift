import Foundation

/// Defines possible DOM manipulation tasks for the script method.
enum Task {
  /// Logs the targeted DOM element to the console.
  case log
  /// Adds a class or attribute to the targeted DOM element.
  case add
  /// Removes a class, or attribute from the targeted DOM element.
  case remove
  /// Toggles a class, or attribute on the targeted DOM element.
  case toggle
}

extension Element {
  /// Adds a JavaScript script to the element for DOM manipulation.
  ///
  /// Creates a new `Element` with the original content plus a `<script>` tag containing
  /// JavaScript to manipulate the DOM. When an `action` is provided, the manipulation
  /// is wrapped in an event listener; otherwise, it executes immediately.
  ///
  /// - Parameters:
  ///   - task: The DOM manipulation task to perform (log, add, remove, or toggle).
  ///   - select: Optional CSS selector or ID to target; defaults to targeting this element.
  ///   - className: Class name to manipulate
  ///   - attribute: Attribute to manipulate
  ///   - value: Value for the action.
  ///   - action: DOM event to trigger the manipulation; nil for immediate execution.
  /// - Returns: New Element with original content and script.
  func script(
    _ task: Task,
    select: String? = nil,
    className: String? = nil,
    attribute: AttributeName? = nil,
    value: String? = nil,
    on action: Action? = nil
  ) -> Element {
    // Validate input
    guard task == .log || className != nil || attribute != nil else { return self }
    let requiresValue = attribute != nil || (className != nil && task != .remove)
    guard task == .log || !requiresValue || value != nil else { return self }

    // Setup
    let elementId = self.id ?? "gen\(UUID().uuidString.replacingOccurrences(of: "-", with: "").dropFirst(28))"
    let selector = select.map { $0.hasPrefix("#") || $0.hasPrefix(".") ? $0 : "#\($0)" } ?? "#\(elementId)"
    let elementRef = "document.querySelector('\(selector)')"

    // Generate manipulation based on task
    let manipulation: String
    switch task {
      case .log:
        manipulation = "console.log('\(elementId):', '\(value ?? "")');"
      case .toggle:
        switch (className, attribute) {
          case (className, nil):
            manipulation = "\(elementRef).classList.toggle('\(value!)');"
          case (nil, let attribute?):
            let attrName = attribute.rawValue
            manipulation =
              "\(elementRef).hasAttribute('\(attrName)') ? \(elementRef).removeAttribute('\(attrName)') : \(elementRef).setAttribute('\(attrName)', '\(value!)');"
          default:
            return self
        }

      case .add:
        switch (className, attribute) {
          case (className, nil):
            manipulation = "\(elementRef).classList.add('\(value!)');"
          case (nil, let attribute?):
            manipulation = "\(elementRef).setAttribute('\(attribute.rawValue)', '\(value!)');"
          default:
            return self
        }

      case .remove:
        switch (className, attribute) {
          case (let className?, nil):
            manipulation = "\(elementRef).classList.remove('\(className)');"
          case (nil, let attribute?):
            manipulation = "\(elementRef).removeAttribute('\(attribute.rawValue)');"
          default:
            return self
        }
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
