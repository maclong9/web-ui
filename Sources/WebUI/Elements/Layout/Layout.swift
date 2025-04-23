/// Generates an HTML header element.
///
/// Contains introductory content or navigation links.
public final class Header: Element {
  /// Creates a new HTML header element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing header content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML navigation element.
///
/// Contains a set of navigational links.
public final class Navigation: Element {
  /// Creates a new HTML navigation element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing navigation content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "nav", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML aside element.
///
/// Holds content tangentially related to the main content.
public final class Aside: Element {
  /// Creates a new HTML aside element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing aside content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "aside", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML main element.
///
/// Contains the primary, unique content of a page.
public final class Main: Element {
  /// Creates a new HTML main element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing main content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "main", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML footer element.
///
/// Holds author info, copyright, or related links.
public final class Footer: Element {
  /// Creates a new HTML footer element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing footer content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "footer", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}
