/// An interface that any entity must follow to be able to generate HTML content.
/// It requires the entity to have a `render()` method that outputs the HTML as a string.
public protocol HTML {
  func render() -> String
}
