/// Generates an HTML progress element to display task completion status.
///
/// The progress element visually represents the completion state of a task or process,
/// such as a file download, form submission, or data processing operation. It provides
/// users with visual feedback about ongoing operations.
///
/// ## Example
/// ```swift
/// Progress(value: 75, max: 100)
/// // Renders: <progress value="75" max="100"></progress>
/// ```
public final class Progress: Element {
  let value: Double?
  let max: Double?

  /// Creates a new HTML progress element.
  ///
  /// - Parameters:
  ///   - value: Current progress value between 0 and max, optional. When omitted, the progress bar shows an indeterminate state.
  ///   - max: Maximum progress value (100% completion point), optional. Defaults to 100 when omitted.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames for styling the progress bar.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers (e.g., "Download progress").
  ///   - data: Dictionary of `data-*` attributes for storing element-relevant data.
  ///
  /// ## Example
  /// ```swift
  /// // Determinate progress bar showing 30% completion
  /// Progress(value: 30, max: 100, id: "download-progress", label: "Download progress")
  ///
  /// // Indeterminate progress bar (activity indicator)
  /// Progress(id: "loading-indicator", label: "Loading content")
  /// ```
  public init(
    value: Double? = nil,
    max: Double? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.value = value
    self.max = max
    let customAttributes = [
      Attribute.string("value", value?.description),
      Attribute.string("max", max?.description),
    ].compactMap { $0 }
    super.init(
      tag: "progress",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}
