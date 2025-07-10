/// Defines attributes for controlling JavaScript script loading behavior.
///
/// These attributes help optimize loading performance by controlling when scripts are loaded and executed.
public enum ScriptAttribute: String {
  /// Defers downloading and execution of the script until after the page has been parsed.
  ///
  /// - Note: Scripts with the `defer` attribute will execute in the order they appear in the document.
  case `defer`

  /// Causes the script to download in parallel and execute as soon as it's available.
  ///
  /// - Note: Scripts with the `async` attribute may execute in any order and should not depend on other scripts.
  case async
}
