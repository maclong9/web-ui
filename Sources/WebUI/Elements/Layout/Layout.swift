/// Generates an HTML header element for page or section headers.
///
/// The `Header` element represents a container for introductory content or a set of navigational links 
/// at the beginning of a section or page. Typically contains elements like site logos, navigation menus, 
/// and search forms.
///
/// - Example:
///   ```swift
///   Header {
///     Heading(.one) { "Site Title" }
///     Navigation {
///       Link(to: "/home") { "Home" }
///       Link(to: "/about") { "About" }
///     }
///   }
///   ```
public final class Header: Element {
  /// Creates a new HTML header element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the header.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the header.
  ///   - content: Closure providing header content like headings, navigation, and logos.
  ///
  /// - Example:
  ///   ```swift
  ///   Header(id: "main-header", classes: ["site-header", "sticky"]) {
  ///     Heading(.one) { "My Website" }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "header", id: id, classes: classes, role: role, label: label, data: data,
      content: content)
  }
}

/// Generates an HTML navigation element for site navigation.
///
/// The `Navigation` element represents a section of a page intended to contain navigation
/// links to other pages or parts within the current page. It helps screen readers and
/// other assistive technologies identify the main navigation structure of the website.
///
/// - Example:
///   ```swift
///   Navigation(classes: ["main-nav"]) {
///     List {
///       Item { Link(to: "/") { "Home" } }
///       Item { Link(to: "/products") { "Products" } }
///       Item { Link(to: "/contact") { "Contact" } }
///     }
///   }
///   ```
public final class Navigation: Element {
  /// Creates a new HTML navigation element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the navigation container.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose (e.g., "Main Navigation").
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to navigation.
  ///   - content: Closure providing navigation content, typically links or lists of links.
  ///
  /// - Example:
  ///   ```swift
  ///   Navigation(id: "main-nav", label: "Main Navigation") {
  ///     Link(to: "/home") { "Home" }
  ///     Link(to: "/about") { "About Us" }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "nav", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML aside element for tangentially related content.
///
/// The `Aside` element represents a section of content that is indirectly related to the
/// main content but could be considered separate. Asides are typically displayed as
/// sidebars or call-out boxes, containing content like related articles, glossary terms,
/// advertisements, or author biographies.
///
/// - Example:
///   ```swift
///   Aside(classes: ["sidebar"]) {
///     Heading(.two) { "Related Articles" }
///     List {
///       Item { Link(to: "/article1") { "Article 1" } }
///       Item { Link(to: "/article2") { "Article 2" } }
///     }
///   }
///   ```
public final class Aside: Element {
  /// Creates a new HTML aside element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the aside container.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose (e.g., "Related Content").
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the aside.
  ///   - content: Closure providing aside content, such as related links, footnotes, or supplementary information.
  ///
  /// - Example:
  ///   ```swift
  ///   Aside(id: "glossary", classes: ["note", "bordered"], label: "Term Definition") {
  ///     Heading(.three) { "Definition" }
  ///     Text { "A detailed explanation of the term..." }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "aside", id: id, classes: classes, role: role, label: label, data: data, content: content
    )
  }
}

/// Generates an HTML main element for the primary content of a page.
///
/// The `Main` element represents the dominant content of the document body. It contains content
/// that is directly related to or expands upon the central topic of the document. Each page
/// should have only one `main` element, which helps assistive technologies navigate to the
/// primary content.
///
/// - Example:
///   ```swift
///   Main {
///     Heading(.one) { "Welcome to Our Website" }
///     Text { "This is the main content of our homepage." }
///     Article {
///       // Article content
///     }
///   }
///   ```
public final class Main: Element {
  /// Creates a new HTML main element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the main content area.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose (e.g., "Main Content").
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the main content.
  ///   - content: Closure providing the primary content of the page, typically including articles, sections, and other content elements.
  ///
  /// - Example:
  ///   ```swift
  ///   Main(id: "content", classes: ["container"]) {
  ///     Section {
  ///       Heading(.one) { "About Us" }
  ///       Text { "Learn more about our company history..." }
  ///     }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "main", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}

/// Generates an HTML footer element for page or section footers.
///
/// The `Footer` element represents a footer for its nearest sectioning content or sectioning root
/// element. A footer typically contains information about the author, copyright data, related links,
/// legal information, and other metadata that appears at the end of a document or section.
///
/// - Example:
///   ```swift
///   Footer {
///     Text { "© 2023 My Company. All rights reserved." }
///     Link(to: "/privacy") { "Privacy Policy" }
///     Link(to: "/terms") { "Terms of Service" }
///   }
///   ```
public final class Footer: Element {
  /// Creates a new HTML footer element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the footer.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose (e.g., "Page Footer").
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the footer.
  ///   - content: Closure providing footer content, such as copyright notices, contact information, and secondary navigation.
  ///
  /// - Example:
  ///   ```swift
  ///   Footer(id: "site-footer", classes: ["footer", "bg-dark"]) {
  ///     Stack(classes: ["footer-links"]) {
  ///       Link(to: "/about") { "About" }
  ///       Link(to: "/contact") { "Contact" }
  ///     }
  ///     Text { "© \(Date().formattedYear()) My Company" }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "footer", id: id, classes: classes, role: role, label: label, data: data,
      content: content)
  }
}
