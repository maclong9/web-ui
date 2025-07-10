/// Defines overflow behavior options.
///
/// Specifies how content exceeding an element's bounds is handled.
///
/// ## Example
/// ```swift
/// Stack() {
///   // Long content that might overflow
///   Text { "This is a long text that might overflow its container..." }
/// }
/// .overflow(.hidden)
/// ```
public enum OverflowType: String {
  /// Automatically adds scrollbars when content overflows.
  case auto
  /// Clips overflowing content and hides it.
  case hidden
  /// Displays overflowing content without clipping.
  case visible
  /// Always adds scrollbars, even if content fits.
  case scroll
}

// Implementation has been moved to OverflowStyleOperation.swift
