import Foundation

/// Defines DOM manipulation tasks for scripting.
enum Task {
  /// Logs the targeted element to the console.
  case log
  /// Adds a class or attribute to the targeted element.
  case add
  /// Removes a class or attribute from the targeted element.
  case remove
  /// Toggles a class or attribute on the targeted element.
  case toggle
}

extension Element {
  /// Creates a `<script>` element for DOM manipulation.
  ///
  /// Appends a JavaScript script to manipulate the DOM either immediately or on an event.
  /// - Parameters:
  ///   - task: The DOM manipulation task to perform.
  ///   - select: CSS selector or ID targeting the element, defaults to current element.
  ///   - className: Class name to manipulate, if applicable.
  ///   - attribute: Attribute name to manipulate, if applicable.
  ///   - value: Value to apply in manipulation, if required.
  ///   - action: Event triggering the manipulation, nil for immediate execution.
  /// - Returns: New element with the script appended.
  func script(
    _ task: Task,
    select: String? = nil,
    className: String? = nil,
    attribute: AttributeName? = nil,
    value: String? = nil,
    on action: Action? = nil
  ) -> Element {
    guard isValidTask(task, className: className, attribute: attribute, value: value) else { return self }

    let elementId = self.id ?? "gen\(UUID().uuidString.dropFirst(28).replacingOccurrences(of: "-", with: ""))"
    let selector = select?.prefixedSelector ?? "#\(elementId)"
    let elementRef = "document.querySelector('\(selector)')"

    let manipulation = buildManipulation(
      task: task,
      elementRef: elementRef,
      className: className,
      attribute: attribute,
      value: value,
      elementId: elementId
    )

    let jsCode =
      action.map { event in
        """
        let el = \(elementRef);
        el.addEventListener('\(event.rawValue)', () => { \(manipulation) });
        """
      } ?? manipulation

    return makeElement(with: jsCode, elementId: elementId)
  }

  /// Validates if the task configuration is executable.
  ///
  /// Checks if the task has required parameters for execution.
  /// - Parameters:
  ///   - task: The DOM manipulation task.
  ///   - className: Optional class name for manipulation.
  ///   - attribute: Optional attribute for manipulation.
  ///   - value: Optional value for manipulation.
  /// - Returns: True if the task is valid, false otherwise.
  private func isValidTask(_ task: Task, className: String?, attribute: AttributeName?, value: String?) -> Bool {
    guard task == .log || className != nil || attribute != nil else { return false }
    let requiresValue = attribute != nil || (className != nil && task != .remove)
    return task == .log || !requiresValue || value != nil
  }

  /// Constructs JavaScript code for DOM manipulation.
  ///
  /// Builds the manipulation string based on the task type.
  /// - Parameters:
  ///   - task: The DOM manipulation task.
  ///   - elementRef: JavaScript reference to the target element.
  ///   - className: Optional class name to manipulate.
  ///   - attribute: Optional attribute to manipulate.
  ///   - value: Optional value for manipulation.
  ///   - elementId: ID of the target element.
  /// - Returns: JavaScript string for the manipulation.
  private func buildManipulation(
    task: Task,
    elementRef: String,
    className: String?,
    attribute: AttributeName?,
    value: String?,
    elementId: String
  ) -> String {
    switch task {
      case .log:
        return "console.log('\(elementId):', '\(value ?? "")');"
      case .toggle:
        return toggleManipulation(elementRef, className: className, attribute: attribute, value: value!)
      case .add:
        return addManipulation(elementRef, className: className, attribute: attribute, value: value!)
      case .remove:
        return removeManipulation(elementRef, className: className, attribute: attribute)
    }
  }

  /// Builds toggle manipulation JavaScript code.
  ///
  /// Creates code to toggle a class or attribute.
  /// - Parameters:
  ///   - elementRef: JavaScript reference to the target element.
  ///   - className: Optional class name to toggle.
  ///   - attribute: Optional attribute to toggle.
  ///   - value: Value to set when toggling on.
  /// - Returns: JavaScript string for toggling.
  private func toggleManipulation(_ ref: String, className: String?, attribute: AttributeName?, value: String) -> String
  {
    if let className { return "\(ref).classList.toggle('\(value)');" }
    if let attr = attribute {
      let name = attr.rawValue
      return
        "\(ref).hasAttribute('\(name)') ? \(ref).removeAttribute('\(name)') : \(ref).setAttribute('\(name)', '\(value)');"
    }
    return ""
  }

  /// Builds add manipulation JavaScript code.
  ///
  /// Creates code to add a class or attribute.
  /// - Parameters:
  ///   - elementRef: JavaScript reference to the target element.
  ///   - className: Optional class name to add.
  ///   - attribute: Optional attribute to add.
  ///   - value: Value to set for the addition.
  /// - Returns: JavaScript string for adding.
  private func addManipulation(_ ref: String, className: String?, attribute: AttributeName?, value: String) -> String {
    if let className { return "\(ref).classList.add('\(value)');" }
    if let attr = attribute { return "\(ref).setAttribute('\(attr.rawValue)', '\(value)');" }
    return ""
  }

  /// Builds remove manipulation JavaScript code.
  ///
  /// Creates code to remove a class or attribute.
  /// - Parameters:
  ///   - elementRef: JavaScript reference to the target element.
  ///   - className: Optional class name to remove.
  ///   - attribute: Optional attribute to remove.
  /// - Returns: JavaScript string for removing.
  private func removeManipulation(_ ref: String, className: String?, attribute: AttributeName?) -> String {
    if let className { return "\(ref).classList.remove('\(className)');" }
    if let attr = attribute { return "\(ref).removeAttribute('\(attr.rawValue)');" }
    return ""
  }

  /// Creates a new element with embedded JavaScript.
  ///
  /// Constructs an element retaining original content and adding a script.
  /// - Parameters:
  ///   - jsCode: JavaScript code to embed.
  ///   - elementId: ID for the new element.
  /// - Returns: New element with script included.
  private func makeElement(with jsCode: String, elementId: String) -> Element {
    Element(tag: self.tag, id: elementId, classes: self.classes, role: self.role) {
      if let content = self.contentBuilder() { for item in content { item } }
      "<script>\(jsCode)</script>"
    }
  }
}

private extension String {
  /// CSS selector with ensured prefix.
  ///
  /// Ensures the selector starts with '#' or '.' if not already present.
  var prefixedSelector: String {
    hasPrefix("#") || hasPrefix(".") ? self : "#\(self)"
  }
}
