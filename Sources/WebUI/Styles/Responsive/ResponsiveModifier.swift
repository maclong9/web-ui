import Foundation

/// Provides a block-based responsive design API for WebUI elements.
///
/// The on modifier allows developers to define responsive styles
/// across different breakpoints in a single, concise block, creating cleaner
/// and more maintainable code for responsive designs.
///
/// ## Example
/// ```swift
/// Text { "Responsive Content" }
///   .font(size: .sm)
///   .background(color: .neutral(._500))
///   .on {
///     md {
///       font(size: .lg)
///       background(color: .neutral(._700))
///       padding(of: 4)
///     }
///     lg {
///       font(size: .xl)
///       background(color: .neutral(._900))
///       font(alignment: .center)
///     }
///   }
/// ```
extension Element {
  /// Applies responsive styling across different breakpoints with a declarative syntax.
  ///
  /// This method provides a clean, declarative way to define styles for multiple
  /// breakpoints in a single block, improving code readability and maintainability.
  ///
  /// - Parameter content: A closure defining responsive style configurations using the result builder.
  /// - Returns: An element with responsive styles applied.
  ///
  /// ## Example
  /// ```swift
  /// Button { "Submit" }
  ///   .background(color: .blue(._500))
  ///   .on {
  ///     sm {
  ///       padding(of: 2)
  ///       font(size: .sm)
  ///     }
  ///     md {
  ///       padding(of: 4)
  ///       font(size: .base)
  ///     }
  ///     lg {
  ///       padding(of: 6)
  ///       font(size: .lg)
  ///     }
  ///   }
  /// ```
  public func on(@ResponsiveStyleBuilder _ content: () -> ResponsiveModification) -> some Markup {
    let builder = ResponsiveBuilder(element: self)
    let modification = content()
    modification.apply(to: builder)
    return MarkupString(content: builder.element.render())
  }
}

extension Markup {
  /// Applies responsive styling across different breakpoints with a declarative syntax.
  ///
  /// This method provides a clean, declarative way to define styles for multiple
  /// breakpoints in a single block, improving code readability and maintainability.
  ///
  /// - Parameter content: A closure defining responsive style configurations using the result builder.
  /// - Returns: A markup element with responsive styles applied.
  public func on(@ResponsiveStyleBuilder _ content: () -> ResponsiveModification) -> AnyMarkup {
    // Wrap Markup in an Element to use responsive functionality
    let elementWrapper = MarkupElementWrapper(self)
    let builder = ResponsiveBuilder(element: elementWrapper)
    let modification = content()
    modification.apply(to: builder)
    return AnyMarkup(MarkupString(content: builder.element.render()))
  }
}

/// A wrapper that converts Markup to Element for responsive functionality
private struct MarkupElementWrapper<Content: Markup>: Element {
  private let content: Content

  init(_ content: Content) {
    self.content = content
  }

  var body: Content {
    content
  }
}

/// Builds responsive style configurations for elements across different breakpoints.
///
/// `ResponsiveBuilder` provides a fluent, method-chaining API for applying style
/// modifications at specific screen sizes. Each method represents a breakpoint
/// and accepts a closure where style modifications can be defined.
///
/// This class is not typically created directly, but instead used through the
/// `Element.on(_:)` method.
public class ResponsiveBuilder {
  /// The current element being modified
  var element: any Element
  /// Keep track of responsive styles for each breakpoint/modifier combination
  internal var pendingClasses: [String] = []
  /// The current stack of active modifiers
  internal var currentModifiers: [Modifier] = []

  /// Creates a new responsive builder for the given element.
  ///
  /// - Parameter element: The element to apply responsive styles to.
  init(element: any Element) {
    self.element = element
  }

  /// Applies styles for one or more modifiers (breakpoints or states).
  ///
  /// - Parameters:
  ///   - modifiers: One or more modifiers to apply (e.g., .hover, .dark, .md).
  ///   - modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func modifiers(_ modifiers: Modifier..., modifications: (ResponsiveBuilder) -> Void)
    -> ResponsiveBuilder
  {
    currentModifiers.append(contentsOf: modifiers)
    modifications(self)
    applyModifiers()
    currentModifiers.removeLast(modifiers.count)
    return self
  }

  /// Applies styles for an array of modifiers (breakpoints or states).
  ///
  /// - Parameters:
  ///   - modifiers: Array of modifiers to apply (e.g., [.hover, .dark]).
  ///   - modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func modifiers(_ modifiers: [Modifier], modifications: (ResponsiveBuilder) -> Void)
    -> ResponsiveBuilder
  {
    currentModifiers.append(contentsOf: modifiers)
    modifications(self)
    applyModifiers()
    currentModifiers.removeLast(modifiers.count)
    return self
  }

  /// Applies styles at the extra-small breakpoint (480px+).
  @discardableResult
  public func xs(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.xs, modifications: modifications)
  }

  /// Applies styles at the small breakpoint (640px+).
  @discardableResult
  public func sm(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.sm, modifications: modifications)
  }

  /// Applies styles at the medium breakpoint (768px+).
  @discardableResult
  public func md(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.md, modifications: modifications)
  }

  /// Applies styles at the large breakpoint (1024px+).
  @discardableResult
  public func lg(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.lg, modifications: modifications)
  }

  /// Applies styles at the extra-large breakpoint (1280px+).
  @discardableResult
  public func xl(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.xl, modifications: modifications)
  }

  /// Applies styles at the 2x-extra-large breakpoint (1536px+).
  @discardableResult
  public func xl2(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    modifiers(.xl2, modifications: modifications)
  }

  /// Creates a hover state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the hover state.
  /// - Returns: A responsive modification for the hover state.
  public func hover(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .hover, styleModification: content())
  }

  /// Creates a focus state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the focus state.
  /// - Returns: A responsive modification for the focus state.
  public func focus(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .focus, styleModification: content())
  }

  /// Creates an active state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the active state.
  /// - Returns: A responsive modification for the active state.
  public func active(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .active, styleModification: content())
  }

  /// Creates a placeholder responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for placeholder text.
  /// - Returns: A responsive modification for placeholder styling.
  public func placeholder(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .placeholder, styleModification: content())
  }

  /// Creates a dark mode responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for dark mode.
  /// - Returns: A responsive modification for dark mode styling.
  public func dark(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .dark, styleModification: content())
  }

  /// Creates a first child responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the first child element.
  /// - Returns: A responsive modification for first child styling.
  public func first(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .first, styleModification: content())
  }

  /// Creates a last child responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the last child element.
  /// - Returns: A responsive modification for last child styling.
  public func last(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .last, styleModification: content())
  }

  /// Creates a disabled state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for the disabled state.
  /// - Returns: A responsive modification for disabled state styling.
  public func disabled(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .disabled, styleModification: content())
  }

  /// Creates a reduced motion responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for reduced motion preference.
  /// - Returns: A responsive modification for reduced motion styling.
  public func motionReduce(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .motionReduce, styleModification: content())
  }

  // MARK: - ARIA State Functions

  /// Creates an ARIA busy state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA busy state.
  /// - Returns: A responsive modification for ARIA busy state styling.
  public func ariaBusy(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaBusy, styleModification: content())
  }

  /// Creates an ARIA checked state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA checked state.
  /// - Returns: A responsive modification for ARIA checked state styling.
  public func ariaChecked(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaChecked, styleModification: content())
  }

  /// Creates an ARIA disabled state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA disabled state.
  /// - Returns: A responsive modification for ARIA disabled state styling.
  public func ariaDisabled(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaDisabled, styleModification: content())
  }

  /// Creates an ARIA expanded state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA expanded state.
  /// - Returns: A responsive modification for ARIA expanded state styling.
  public func ariaExpanded(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaExpanded, styleModification: content())
  }

  /// Creates an ARIA hidden state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA hidden state.
  /// - Returns: A responsive modification for ARIA hidden state styling.
  public func ariaHidden(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaHidden, styleModification: content())
  }

  /// Creates an ARIA pressed state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA pressed state.
  /// - Returns: A responsive modification for ARIA pressed state styling.
  public func ariaPressed(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaPressed, styleModification: content())
  }

  /// Creates an ARIA readonly state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA readonly state.
  /// - Returns: A responsive modification for ARIA readonly state styling.
  public func ariaReadonly(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaReadonly, styleModification: content())
  }

  /// Creates an ARIA required state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA required state.
  /// - Returns: A responsive modification for ARIA required state styling.
  public func ariaRequired(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaRequired, styleModification: content())
  }

  /// Creates an ARIA selected state responsive modification.
  ///
  /// - Parameter content: A closure containing style modifications for ARIA selected state.
  /// - Returns: A responsive modification for ARIA selected state styling.
  public func ariaSelected(@ResponsiveStyleBuilder content: () -> ResponsiveModification)
    -> ResponsiveModification
  {
    BreakpointModification(breakpoint: .ariaSelected, styleModification: content())
  }

  /// A concrete wrapper that preserves Element conformance
  private struct AnyElement: Element {
    private let base: any Element

    init(_ base: any Element) {
      self.base = base
    }

    var body: MarkupString {
      MarkupString(content: base.render())
    }
  }

  /// Wrapper to convert HTML back to Element
  private struct ElementWrapper<T: Markup>: Element {
    private let htmlContent: T

    init(_ htmlContent: T) {
      self.htmlContent = htmlContent
    }

    var body: MarkupString {
      MarkupString(content: htmlContent.render())
    }
  }

  internal func applyModifiers() {
    guard !currentModifiers.isEmpty else { return }

    let modifierPrefix = currentModifiers.map { $0.rawValue }.joined()
    let responsiveClasses = pendingClasses.map { "\(modifierPrefix)\($0)" }

    let wrapped = AnyElement(self.element)
    let styledModifier = StyleModifierWithDeduplication(
      content: wrapped, classes: responsiveClasses)
    self.element = ElementWrapper(styledModifier)

    pendingClasses = []
  }

  /// Add a class to the pending list of classes
  public func addClass(_ className: String) {
    pendingClasses.append(className)
  }
}

/// A smart style modifier that deduplicates redundant classes
struct StyleModifierWithDeduplication<T: Markup>: Markup {
  private let content: T
  private let classes: [String]

  init(content: T, classes: [String]) {
    self.content = content
    self.classes = classes
  }

  /// Removes redundant modifier classes when the same property exists in base
  private func filterRedundantModifierClasses(_ modifierClasses: [String])
    -> [String]
  {
    // Get base classes by rendering the content first
    let baseContent = content.render()
    let baseClasses = extractClassesFromHTML(baseContent)

    return modifierClasses.filter { modifierClass in
      guard let colonIndex = modifierClass.firstIndex(of: ":") else {
        return true  // Not a modifier class, keep it
      }

      let baseClass = String(
        modifierClass[modifierClass.index(after: colonIndex)...])

      // Remove redundant transition property declarations
      if baseClass.hasPrefix("transition-")
        && !baseClass.hasPrefix("transition-duration")
        && !baseClass.hasPrefix("transition-delay")
        && !baseClass.hasPrefix("transition-timing")
      {
        return !baseClasses.contains(baseClass)
      }

      // Keep all other modifier classes
      return true
    }
  }

  /// Extracts classes from HTML class attribute
  private func extractClassesFromHTML(_ html: String) -> Set<String> {
    let pattern = #"class="([^"]*)"#
    guard let regex = try? NSRegularExpression(pattern: pattern),
      let match = regex.firstMatch(
        in: html, range: NSRange(html.startIndex..., in: html)),
      let range = Range(match.range(at: 1), in: html)
    else {
      return Set()
    }

    let classString = String(html[range])
    return Set(classString.split(separator: " ").map(String.init))
  }

  var body: some Markup {
    let filteredClasses = filterRedundantModifierClasses(classes)
    return content.addingClasses(filteredClasses)
  }
}

// Font styling methods
extension ResponsiveBuilder {
  @discardableResult
  public func size(_ value: Int) -> ResponsiveBuilder {
    addClass("size-\(value)")
    return self
  }

  @discardableResult
  public func frame(
    width: Int? = nil,
    height: Int? = nil,
    minWidth: Int? = nil,
    maxWidth: Int? = nil,
    minHeight: Int? = nil,
    maxHeight: Int? = nil
  ) -> ResponsiveBuilder {
    if let width = width { addClass("w-\(width)") }
    if let height = height { addClass("h-\(height)") }
    if let minWidth = minWidth { addClass("min-w-\(minWidth)") }
    if let maxWidth = maxWidth { addClass("max-w-\(maxWidth)") }
    if let minHeight = minHeight { addClass("min-h-\(minHeight)") }
    if let maxHeight = maxHeight { addClass("max-h-\(maxHeight)") }
    return self
  }
}
