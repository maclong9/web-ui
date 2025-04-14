/// Generates an HTML header element.
///
/// Contains introductory content or navigation links.
public final class Header: Element {
  /// Creates a new HTML header element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing header content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML navigation element.
///
/// Provides a set of navigational links.
public final class Navigation: Element {
  /// Creates a new HTML navigation element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing navigation content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "nav", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML aside element.
///
/// Holds content tangentially related to the main content.
public final class Aside: Element {
  /// Creates a new HTML aside element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing aside content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "aside", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML main element.
///
/// Contains the primary, unique content of a page.
public final class Main: Element {
  /// Creates a new HTML main element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing main content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "main", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML footer element.
///
/// Holds author info, copyright, or related links.
public final class Footer: Element {
  /// Creates a new HTML footer element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing footer content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "footer", config: config, isSelfClosing: false, content: content)
  }
}
