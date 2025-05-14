/// Defines requirements for generating HTML content.
///
/// The `HTML` protocol is the foundation of the WebUI framework, requiring entities to provide 
/// a method for rendering themselves as HTML strings. Any type that conforms to this protocol
/// can be included in the document structure.
///
/// Conforming types include individual elements (like `Button`, `Text`), strings, and container
/// elements. The protocol enables a consistent rendering approach across the entire framework.
///
/// - Example:
///   ```swift
///   struct CustomElement: HTML {
///     let content: String
///     
///     func render() -> String {
///       "<div class=\"custom\">\(content)</div>"
///     }
///   }
///   
///   let element = CustomElement(content: "Hello")
///   print(element.render()) // Outputs: <div class="custom">Hello</div>
///   ```
public protocol HTML {
  /// Renders the entity as an HTML string.
  ///
  /// This method converts the conforming type into its HTML representation. It's the central
  /// mechanism for transforming Swift objects into their corresponding HTML markup.
  ///
  /// - Returns: The complete HTML content as a string.
  ///
  /// - Note: Implementations should ensure proper HTML escaping when including user-provided content.
  func render() -> String
}
