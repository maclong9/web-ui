/// Specifies sizes for box shadows.
///
/// Defines shadow sizes from none to extra-large.
///
/// ## Example
/// ```swift
/// Stack(classes: ["card"])
///   .shadow(size: .lg, color: .gray(._300, opacity: 0.5))
/// ```
public enum ShadowSize: String {
  /// No shadow
  case none = "none"
  /// Extra small shadow (2xs)
  case xs2 = "2xs"
  /// Extra small shadow (xs)
  case xs = "xs"
  /// Small shadow (sm)
  case sm = "sm"
  /// Medium shadow (default)
  case md = "md"
  /// Large shadow (lg)
  case lg = "lg"
  /// Extra large shadow (xl)
  case xl = "xl"
  /// 2x large shadow (2xl)
  case xl2 = "2xl"
}
