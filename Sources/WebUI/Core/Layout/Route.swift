/// Represents a navigational route within the layout.
public struct Route {
  let label: String
  let path: String
  let newTab: Bool

  /// Creates a new `Route`.
  ///
  /// - Parameters:
  ///   - label: The display label for the route.
  ///   - path: The URL path for the route.
  ///   - newTab: Whether the URL should open in a new tab.
  public init(label: String, path: String, newTab: Bool = false) {
    self.label = label
    self.path = path
    self.newTab = newTab
  }
}
