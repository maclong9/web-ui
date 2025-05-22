import Foundation

/// Registry for all style operations in the WebUI framework
///
/// Provides a central point of access for all style operations,
/// ensuring that they are properly initialized and shared across the framework.
/// This enables a consistent styling system across both direct Element styling
/// and the Declaritive responsive syntax.
public enum StyleRegistry {
    // Border styles
    public static let border = BorderStyleOperation.shared

    // Border radius styles
    public static let borderRadius = BorderRadiusStyleOperation.shared

    // Margin styles
    public static let margins = MarginsStyleOperation.shared

    // Padding styles
    public static let padding = PaddingStyleOperation.shared

    // Spacing styles
    public static let spacing = SpacingStyleOperation.shared

    // Background styles
    public static let background = BackgroundStyleOperation.shared

    // Opacity styles
    public static let opacity = OpacityStyleOperation.shared

    // Font styles
    public static let font = FontStyleOperation.shared

    // Display styles
    public static let display = DisplayStyleOperation.shared

    // Position styles
    public static let position = PositionStyleOperation.shared

    // ZIndex styles
    public static let zIndex = ZIndexStyleOperation.shared

    // Overflow styles
    public static let overflow = OverflowStyleOperation.shared

    // Cursor styles
    public static let cursor = CursorStyleOperation.shared

    // Transform styles
    public static let transform = TransformStyleOperation.shared

    // Transition styles
    public static let transition = TransitionStyleOperation.shared

    // Scroll styles
    public static let scroll = ScrollStyleOperation.shared

    // Sizing styles
    public static let sizing = SizingStyleOperation.shared

    /// Initializes all style operations
    ///
    /// This method should be called during the framework initialization
    /// to ensure that all style operations are properly initialized for
    /// use with both Element methods and Declarative syntax.
    public static func initialize() {
        // The singleton pattern ensures that operations are only initialized once
        // This method exists for explicit initialization if needed
        _ = border
        _ = borderRadius
        _ = margins
        _ = padding
        _ = spacing
        _ = background
        _ = opacity
        _ = font
        _ = display
        _ = position
        _ = zIndex
        _ = overflow
        _ = cursor
        _ = transform
        _ = transition
        _ = scroll
        _ = sizing
    }

    /// Registers a custom style operation
    ///
    /// This method allows for registering custom style operations
    /// from outside the core framework, making them available for both
    /// direct Element styling and declaritive responsive syntax.
    ///
    /// - Parameters:
    ///   - name: The name of the custom style operation
    ///   - operation: The style operation to register
    public static func register<T: StyleOperation>(name: String, operation: T) {
        // In a more complex implementation, this could store operations in a dictionary
        // For now, this is a placeholder for future extensibility
    }
}
