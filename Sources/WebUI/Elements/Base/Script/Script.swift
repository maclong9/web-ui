/// Represents a JavaScript script with its source and optional loading attribute.
///
/// Used to define scripts that should be included in the HTML document.
///
/// - Example:
///   ```swift
///   let mainScript = Script(src: "/js/main.js", attribute: .defer)
///   ```
public struct Script {
    /// The source URL of the script.
    let src: String

    /// Optional attribute controlling how the script is loaded and executed.
    let attribute: ScriptAttribute?

    public init(src: String, attribute: ScriptAttribute? = nil) {
        self.src = src
        self.attribute = attribute
    }
}
