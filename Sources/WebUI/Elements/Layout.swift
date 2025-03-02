/// Represents a header section, usually reserved for titles, navigation and key information.
///
/// The `Header` class generates an HTML `<header>` element
///
/// - SeeAlso: `Main` and `Footer` for layout classes
public class Header: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, content: content)
  }
}

/// Represents a navigation section for links.
///
/// The `Navigation` class generates an HTML `<nav>` element
public class Navigation: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, content: content)
  }
}

/// Represents a main section, this is where the main content of the page will go
///
/// The `Main` class generates an HTML `<main>` element
///
/// - SeeAlso: `Header` and `Footer` for other Layout classes
public class Main: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "main", id: id, classes: classes, role: role, content: content)
  }
}

/// Represents a header section, usually reserved for titles, navigation and key information.
///
/// The `Footer` class generates an HTML `<footer>` element
///
/// - SeeAlso: `Header` and `Main` for layout classes
public class Footer: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "footer", id: id, classes: classes, role: role, content: content)
  }
}
