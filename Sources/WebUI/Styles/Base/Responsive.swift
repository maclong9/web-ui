import Foundation

/// Provides a block-based responsive design API for WebUI elements.
///
/// The responsive modifier allows developers to define responsive styles
/// across different breakpoints in a single, concise block, creating cleaner
/// and more maintainable code for responsive designs.
///
/// ## Example
/// ```swift
/// Text { "Responsive Content" }
///   .font(size: .sm)
///   .background(color: .neutral(._500))
///   .responsive {
///     $0.md {
///       $0.font(size: .lg)
///       $0.background(color: .neutral(._700))
///       $0.padding(of: 4)
///     }
///     $0.lg {
///       $0.font(size: .xl)
///       $0.background(color: .neutral(._900))
///       $0.font(alignment: .center)
///     }
///   }
/// ```
extension Element {
  /// Applies responsive styling across different breakpoints.
  ///
  /// This method provides a clean, declarative way to define styles for multiple
  /// breakpoints in a single block, improving code readability and maintainability
  /// compared to chaining multiple individual responsive modifiers.
  ///
  /// The configuration closure accepts a `ResponsiveBuilder` that provides methods
  /// for each breakpoint (e.g., `.md`, `.lg`). Within each breakpoint block, you can
  /// apply multiple style modifications that will only be applied at that breakpoint.
  ///
  /// - Parameter configuration: A closure defining responsive style configurations.
  /// - Returns: An element with responsive styles applied.
  ///
  /// ## Example
  /// ```swift
  /// Button { "Submit" }
  ///   .background(color: .blue(._500))
  ///   .responsive {
  ///     $0.sm {
  ///       $0.padding(of: 2)
  ///       $0.font(size: .sm)
  ///     }
  ///     $0.md {
  ///       $0.padding(of: 4)
  ///       $0.font(size: .base)
  ///     }
  ///     $0.lg {
  ///       $0.padding(of: 6)
  ///       $0.font(size: .lg)
  ///     }
  ///   }
  /// ```
  public func responsive(_ configuration: (ResponsiveBuilder) -> Void) -> Element {
    let builder = ResponsiveBuilder(element: self)
    configuration(builder)
    return builder.element
  }
}

/// Builds responsive style configurations for elements across different breakpoints.
///
/// `ResponsiveBuilder` provides a fluent, method-chaining API for applying style
/// modifications at specific screen sizes. Each method represents a breakpoint
/// and accepts a closure where style modifications can be defined.
///
/// This class is not typically created directly, but instead used through the
/// `Element.responsive(_:)` method.
public class ResponsiveBuilder {
  /// The current element being modified
  var element: Element
  /// Keep track of responsive styles for each breakpoint
  private var pendingClasses: [String] = []
  /// The current breakpoint being modified
  private var currentBreakpoint: Modifier?

  /// Creates a new responsive builder for the given element.
  ///
  /// - Parameter element: The element to apply responsive styles to.
  init(element: Element) {
    self.element = element
  }

  /// Applies styles at the extra-small breakpoint (480px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func xs(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .xs
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies styles at the small breakpoint (640px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func sm(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .sm
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies styles at the medium breakpoint (768px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func md(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .md
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies styles at the large breakpoint (1024px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func lg(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .lg
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies styles at the extra-large breakpoint (1280px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func xl(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .xl
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies styles at the 2x-extra-large breakpoint (1536px+).
  ///
  /// - Parameter modifications: A closure containing style modifications.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func xl2(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
    currentBreakpoint = .xl2
    modifications(self)
    applyBreakpoint()
    return self
  }

  /// Applies the breakpoint prefix to all pending classes and add them to the element
  private func applyBreakpoint() {
    guard let breakpoint = currentBreakpoint else { return }
    
    // Apply the breakpoint prefix to all pending classes
    let responsiveClasses = pendingClasses.map {
      // Handle duplication for flex-*, justify-*, items-*
      if $0.starts(with: "flex-") || $0.starts(with: "justify-") || $0.starts(with: "items-") || $0.starts(with: "grid-") {
        return "\(breakpoint.rawValue)\($0)"
      } else if $0 == "flex" || $0 == "grid" {
        return "\(breakpoint.rawValue)\($0)"
      } else {
        return "\(breakpoint.rawValue)\($0)"
      }
    }

    // Add the responsive classes to the element
    self.element = Element(
      tag: self.element.tag,
      id: self.element.id,
      classes: (self.element.classes ?? []) + responsiveClasses,
      role: self.element.role,
      label: self.element.label,
      data: self.element.data,
      isSelfClosing: self.element.isSelfClosing,
      customAttributes: self.element.customAttributes,
      content: self.element.contentBuilder
    )

    // Clear pending classes for the next breakpoint
    pendingClasses = []
    currentBreakpoint = nil
  }

  /// Add a class to the pending list of classes
  private func addClass(_ className: String) {
    pendingClasses.append(className)
  }
}

// Font styling methods
extension ResponsiveBuilder {
  @discardableResult
  public func font(
    size: TextSize? = nil,
    weight: Weight? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil,
    wrapping: Wrapping? = nil,
    color: Color? = nil,
    family: String? = nil
  ) -> ResponsiveBuilder {
    if let size = size { addClass(size.className) }
    if let weight = weight { addClass(weight.className) }
    if let alignment = alignment { addClass(alignment.className) }
    if let tracking = tracking { addClass(tracking.className) }
    if let leading = leading { addClass(leading.className) }
    if let decoration = decoration { addClass(decoration.className) }
    if let wrapping = wrapping { addClass(wrapping.className) }
    if let color = color { addClass("text-\(color.rawValue)") }
    if let family = family { addClass("font-[\(family)]") }
    return self
  }

  @discardableResult
  public func background(color: Color) -> ResponsiveBuilder {
    addClass("bg-\(color.rawValue)")
    return self
  }

  @discardableResult
  public func padding(of length: Int? = 4, at edges: Edge...) -> ResponsiveBuilder {
    let edgesList = edges.isEmpty ? [Edge.all] : edges
    for edge in edgesList {
      guard let length = length else { continue }
      let prefix = edge == .all ? "p" : "p\(edge.rawValue)"
      addClass("\(prefix)-\(length)")
    }
    return self
  }

  @discardableResult
  public func margins(of length: Int? = 4, at edges: Edge..., auto: Bool = false) -> ResponsiveBuilder {
    let edgesList = edges.isEmpty ? [Edge.all] : edges
    for edge in edgesList {
      let prefix = edge == .all ? "m" : "m\(edge.rawValue)"
      if auto {
        addClass("\(prefix)-auto")
      } else if let length = length {
        addClass("\(prefix)-\(length)")
      }
    }
    return self
  }

  @discardableResult
  public func border(of width: Int? = 1, at edges: Edge..., style: BorderStyle? = nil, color: Color? = nil) -> ResponsiveBuilder {
    let edgesList = edges.isEmpty ? [Edge.all] : edges

    for edge in edgesList {
      if let style = style, style == .divide {
        if let width = width {
          let divideClass = edge == .horizontal ? "divide-x-\(width)" : "divide-y-\(width)"
          addClass(divideClass)
        }
      } else {
        let prefix = edge == .all ? "border" : "border-\(edge.rawValue)"
        if let width = width {
          addClass("\(prefix)-\(width)")
        } else {
          addClass(prefix)
        }
      }
    }

    if let style = style, style != .divide {
      addClass("border-\(style.rawValue)")
    }

    if let color = color {
      addClass("border-\(color.rawValue)")
    }

    return self
  }

  @discardableResult
  public func opacity(_ value: Int) -> ResponsiveBuilder {
    addClass("opacity-\(value)")
    return self
  }

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

  @discardableResult
  public func flex(
    direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil,
    grow: Grow? = nil
  ) -> ResponsiveBuilder {
    addClass("flex")
    if let direction = direction { addClass("flex-\(direction.rawValue)") }
    if let justify = justify { addClass("justify-\(justify.rawValue)") }
    if let align = align { addClass("items-\(align.rawValue)") }
    if let grow = grow { addClass("flex-\(grow.rawValue)") }
    return self
  }

  @discardableResult
  public func grid(
    columns: Int? = nil,
    rows: Int? = nil,
    justify: Justify? = nil,
    align: Align? = nil
  ) -> ResponsiveBuilder {
    if columns == nil && rows == nil && justify == nil && align == nil {
      addClass("grid")
    } else {
      if let columns = columns { addClass("grid-cols-\(columns)") }
      if let rows = rows { addClass("grid-rows-\(rows)") }
      if let justify = justify { addClass("justify-\(justify.rawValue)") }
      if let align = align { addClass("items-\(align.rawValue)") }
    }
    return self
  }

  @discardableResult
  public func position(_ type: PositionType? = nil, at edges: Edge..., offset: Int? = nil) -> ResponsiveBuilder {
    if let type = type {
      addClass(type.rawValue)
    }

    for edge in edges {
      if let offset = offset {
        let prefix = edge == .horizontal ? "inset-x" : (edge == .vertical ? "inset-y" : edge.rawValue)
        let className =
          prefix == "t" ? "top-\(offset)" : prefix == "b" ? "bottom-\(offset)" : prefix == "l" ? "left-\(offset)" : prefix == "r" ? "right-\(offset)" : "\(prefix)-\(offset)"
        addClass(className)
      }
    }
    return self
  }

  @discardableResult
  public func overflow(_ type: OverflowType, axis: Axis = .both) -> ResponsiveBuilder {
    let className = axis == .both ? "overflow-\(type.rawValue)" : "overflow-\(axis.rawValue)-\(type.rawValue)"
    addClass(className)
    return self
  }

  @discardableResult
  public func hidden(_ isHidden: Bool = true) -> ResponsiveBuilder {
    if isHidden {
      addClass("hidden")
    }
    return self
  }

  @discardableResult
  public func rounded(_ size: RadiusSize? = .md, _ sides: RadiusSide...) -> ResponsiveBuilder {
    if sides.isEmpty {
      addClass("rounded\(size != nil ? "-\(size!.rawValue)" : "")")
    } else {
      for side in sides {
        addClass("rounded-\(side.rawValue)\(size != nil ? "-\(size!.rawValue)" : "")")
      }
    }
    return self
  }
}
