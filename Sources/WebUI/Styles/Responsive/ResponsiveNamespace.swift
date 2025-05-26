import Foundation

/// A namespace that provides clean access to styling functions within responsive contexts
/// without name collisions with HTML element instance methods.
///
/// ## Problem
/// Swift has difficulty resolving function calls in responsive contexts due to namespace
/// collision between:
/// - HTML instance methods like `.font(..., on modifiers: Modifier...)`  
/// - Global functions like `font(...) -> ResponsiveModification`
///
/// ## Solution
/// This namespace provides unambiguous access to all styling functions in responsive contexts.
/// Use `ResponsiveStyle.font(...)` or the shorter `S.font(...)` alias.
///
/// ## Usage
/// ```swift
/// // In Document context - works fine without prefix
/// struct MyDocument: Document {
///     var body: some HTML {
///         Text { "Hello" }
///             .on {
///                 md { font(color: .blue(._500)) }  // Works fine
///             }
///     }
/// }
///
/// // In Element context - use namespace to avoid collision
/// struct MyElement: Element {
///     var body: some HTML {
///         Text { "Hello" }
///             .on {
///                 md { S.font(color: .blue(._500)) }  // Use S. prefix
///                 lg { ResponsiveStyle.font(size: .xl) }  // Or full name
///             }
///     }
/// }
/// ```
///
/// ## Available Functions
/// All styling operations are available through this namespace:
/// - Typography: `font()`, text styling
/// - Layout: `margins()`, `padding()`, `flex()`, `grid()`
/// - Appearance: `background()`, `opacity()`, `shadow()`
/// - Borders: `border()`, `rounded()`, `outline()`, `ring()`
/// - Interactive: `cursor()`, `transition()`, `transform()`
/// - Positioning: `position()`, `zIndex()`, `overflow()`
/// - Sizing: `size()`, `frame()`, `aspectRatio()`
/// - Display: `display()`, `hidden()`
/// - Scroll: `scroll()`
public enum ResponsiveStyle {
    
    // MARK: - Typography
    
    /// Typography styling for responsive contexts
    public static func font(
        size: TextSize? = nil,
        weight: Weight? = nil,
        alignment: Alignment? = nil,
        tracking: Tracking? = nil,
        leading: Leading? = nil,
        decoration: Decoration? = nil,
        wrapping: Wrapping? = nil,
        color: Color? = nil,
        family: String? = nil
    ) -> ResponsiveModification {
        let params = FontStyleOperation.Parameters(
            size: size,
            weight: weight,
            alignment: alignment,
            tracking: tracking,
            leading: leading,
            decoration: decoration,
            wrapping: wrapping,
            color: color,
            family: family
        )
        
        return FontStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Background
    
    /// Background styling for responsive contexts
    public static func background(color: Color) -> ResponsiveModification {
        let params = BackgroundStyleOperation.Parameters(color: color)
        return BackgroundStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Opacity
    
    /// Opacity styling for responsive contexts
    public static func opacity(_ value: Int) -> ResponsiveModification {
        let params = OpacityStyleOperation.Parameters(value: value)
        return OpacityStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Border
    
    /// Border styling for responsive contexts
    public static func border(
        of width: Int? = 1,
        at edges: Edge...,
        style: BorderStyle? = nil,
        color: Color? = nil
    ) -> ResponsiveModification {
        let params = BorderStyleOperation.Parameters(
            width: width,
            edges: edges,
            style: style,
            color: color
        )
        
        return BorderStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Border Radius
    
    /// Border radius styling for responsive contexts
    public static func rounded(
        _ size: RadiusSize? = .md,
        _ sides: RadiusSide...
    ) -> ResponsiveModification {
        let params = BorderRadiusStyleOperation.Parameters(
            size: size,
            sides: sides
        )
        
        return BorderRadiusStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Outline
    
    /// Outline styling for responsive contexts
    public static func outline(
        of width: Int? = nil,
        style: BorderStyle? = nil,
        color: Color? = nil,
        offset: Int? = nil
    ) -> ResponsiveModification {
        let params = OutlineStyleOperation.Parameters(
            width: width,
            style: style,
            color: color,
            offset: offset
        )
        
        return OutlineStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Ring
    
    /// Ring styling for responsive contexts
    public static func ring(
        of size: Int = 1,
        color: Color? = nil
    ) -> ResponsiveModification {
        let params = RingStyleOperation.Parameters(
            size: size,
            color: color
        )
        
        return RingStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Shadow
    
    /// Shadow styling for responsive contexts
    public static func shadow(
        of size: ShadowSize? = .md,
        color: Color? = nil
    ) -> ResponsiveModification {
        let params = ShadowStyleOperation.Parameters(
            size: size,
            color: color
        )
        
        return ShadowStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Transform
    
    /// Transform styling for responsive contexts
    public static func transform(
        scale: (x: Int?, y: Int?)? = nil,
        rotate: Int? = nil,
        translate: (x: Int?, y: Int?)? = nil,
        skew: (x: Int?, y: Int?)? = nil
    ) -> ResponsiveModification {
        let params = TransformStyleOperation.Parameters(
            scale: scale,
            rotate: rotate,
            translate: translate,
            skew: skew
        )
        
        return TransformStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Transition
    
    /// Transition styling for responsive contexts
    public static func transition(
        of property: TransitionProperty? = nil,
        for duration: Int? = nil,
        easing: Easing? = nil,
        delay: Int? = nil
    ) -> ResponsiveModification {
        let params = TransitionStyleOperation.Parameters(
            property: property,
            duration: duration,
            easing: easing,
            delay: delay
        )
        
        return TransitionStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Cursor
    
    /// Cursor styling for responsive contexts
    public static func cursor(_ type: CursorType) -> ResponsiveModification {
        let params = CursorStyleOperation.Parameters(type: type)
        return CursorStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Display
    
    /// Display styling for responsive contexts
    public static func display(_ type: DisplayType) -> ResponsiveModification {
        let params = DisplayStyleOperation.Parameters(type: type)
        return DisplayStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Visibility
    
    /// Visibility styling for responsive contexts
    public static func hidden(_ isHidden: Bool = true) -> ResponsiveModification {
        let params = VisibilityStyleOperation.Parameters(isHidden: isHidden)
        return VisibilityStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Margins
    
    /// Margins styling for responsive contexts
    public static func margins(
        of length: Int? = 4,
        at edges: Edge...,
        auto: Bool = false
    ) -> ResponsiveModification {
        let params = MarginsStyleOperation.Parameters(
            length: length,
            edges: edges,
            auto: auto
        )
        
        return MarginsStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Padding
    
    /// Padding styling for responsive contexts
    public static func padding(
        of length: Int? = 4,
        at edges: Edge...
    ) -> ResponsiveModification {
        let params = PaddingStyleOperation.Parameters(
            length: length,
            edges: edges
        )
        
        return PaddingStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Overflow
    
    /// Overflow styling for responsive contexts
    public static func overflow(
        _ type: OverflowType,
        axis: Axis = .both
    ) -> ResponsiveModification {
        let params = OverflowStyleOperation.Parameters(
            type: type,
            axis: axis
        )
        
        return OverflowStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Position
    
    /// Position styling for responsive contexts
    public static func position(
        _ type: PositionType? = nil,
        at edges: Edge...,
        offset length: Int? = nil
    ) -> ResponsiveModification {
        let params = PositionStyleOperation.Parameters(
            type: type,
            edges: edges,
            offset: length
        )
        
        return PositionStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Z-Index
    
    /// Z-Index styling for responsive contexts
    public static func zIndex(_ value: Int) -> ResponsiveModification {
        let params = ZIndexStyleOperation.Parameters(value: value)
        return ZIndexStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Scroll
    
    /// Scroll styling for responsive contexts
    public static func scroll(
        behavior: ScrollBehavior? = nil,
        margin: (value: Int, edges: [Edge])? = nil,
        padding: (value: Int, edges: [Edge])? = nil,
        snapAlign: ScrollSnapAlign? = nil,
        snapStop: ScrollSnapStop? = nil,
        snapType: ScrollSnapType? = nil
    ) -> ResponsiveModification {
        let params = ScrollStyleOperation.Parameters(
            behavior: behavior,
            margin: margin,
            padding: padding,
            snapAlign: snapAlign,
            snapStop: snapStop,
            snapType: snapType
        )
        
        return ScrollStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Flex
    
    /// Flex styling for responsive contexts
    public static func flex(
        direction: FlexDirection? = nil,
        justify: FlexJustify? = nil,
        align: FlexAlign? = nil,
        grow: FlexGrow? = nil
    ) -> ResponsiveModification {
        let params = FlexStyleOperation.Parameters(
            direction: direction,
            justify: justify,
            align: align,
            grow: grow
        )
        
        return FlexStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Grid
    
    /// Grid styling for responsive contexts
    public static func grid(
        columns: Int? = nil,
        rows: Int? = nil,
        flow: GridFlow? = nil,
        columnSpan: Int? = nil,
        rowSpan: Int? = nil
    ) -> ResponsiveModification {
        let params = GridStyleOperation.Parameters(
            columns: columns,
            rows: rows,
            flow: flow,
            columnSpan: columnSpan,
            rowSpan: rowSpan
        )
        
        return GridStyleOperation.shared.asModification(params: params)
    }
    
    // MARK: - Sizing
    
    /// Size styling for responsive contexts
    public static func size(_ value: SizingValue) -> ResponsiveModification {
        let params = SizingStyleOperation.SizeParameters(value: value)
        return StyleModification { builder in
            let classes = SizingStyleOperation.shared.applySizeClasses(params: params)
            for className in classes {
                builder.addClass(className)
            }
        }
    }
    
    /// Frame styling for responsive contexts
    public static func frame(
        width: SizingValue? = nil,
        height: SizingValue? = nil,
        minWidth: SizingValue? = nil,
        maxWidth: SizingValue? = nil,
        minHeight: SizingValue? = nil,
        maxHeight: SizingValue? = nil
    ) -> ResponsiveModification {
        let params = SizingStyleOperation.FrameParameters(
            width: width,
            height: height,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight
        )
        return StyleModification { builder in
            let classes = SizingStyleOperation.shared.applyClasses(params: params)
            for className in classes {
                builder.addClass(className)
            }
        }
    }
    
    /// Aspect ratio styling for responsive contexts
    public static func aspectRatio() -> ResponsiveModification {
        let params = SizingStyleOperation.AspectRatioParameters(isSquare: true)
        return StyleModification { builder in
            let classes = SizingStyleOperation.shared.applyAspectRatioClasses(params: params)
            for className in classes {
                builder.addClass(className)
            }
        }
    }
    
    /// Video aspect ratio styling for responsive contexts
    public static func aspectRatioVideo() -> ResponsiveModification {
        let params = SizingStyleOperation.AspectRatioParameters(isVideo: true)
        return StyleModification { builder in
            let classes = SizingStyleOperation.shared.applyAspectRatioClasses(params: params)
            for className in classes {
                builder.addClass(className)
            }
        }
    }
}

// MARK: - Convenience Alias

/// Convenience alias for shorter syntax in responsive contexts
/// Allows using `S.font(...)` instead of `ResponsiveStyle.font(...)`
public typealias S = ResponsiveStyle