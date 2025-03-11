/// Represents an HTML image element.
///
/// This class creates a self-closing `<img>` tag used to embed images in HTML documents.
/// The semantic purpose is to display visual content with optional accessibility
/// information via the `alt` attribute.
///
/// - Note: This element is void (self-closing) and cannot contain child content.
public class Image: Element {
  let source: String
  let alt: String?
  let width: Int?
  let height: Int?

  /// Creates an HTML image element with specified attributes.
  ///
  /// - Parameters:
  ///   - source: The URL or path to the image file. Required.
  ///   - alt: Text description for screen readers or when the image fails to load. Optional.
  ///   - width: Pixel width of the image. Optional.
  ///   - height: Pixel height of the image. Optional.
  ///   - id: Unique identifier for the element. Optional.
  ///   - classes: Array of CSS class names. Optional.
  ///   - role: ARIA role for accessibility. Optional.
  public init(
    source: String,
    alt: String? = nil,
    width: Int? = nil,
    height: Int? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil
  ) {
    self.source = source
    self.alt = alt
    self.width = width
    self.height = height
    super.init(tag: "img", id: id, classes: classes, role: role)
  }

  /// Renders the image element as an HTML string.
  ///
  /// - Returns: A string containing the complete `<img>` tag with all specified attributes.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", source),
      attribute("alt", alt),
      attribute("width", width?.description),
      attribute("height", height?.description),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    return "<\(tag)\(attributesString)>"
  }
}

/// Represents an HTML video element.
///
/// This class creates a `<video>` tag used to embed video content in HTML documents.
/// Semantically, it represents multimedia content with optional playback controls,
/// designed for user interaction and accessibility.
public class Video: Element {
  let source: String
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates an HTML video element with specified attributes.
  ///
  /// - Parameters:
  ///   - source: The URL or path to the video file.
  ///   - controls: If true, displays playback controls. Optional.
  ///   - autoplay: If true, starts playback automatically. Optional.
  ///   - loop: If true, loops the video indefinitely. Optional.
  ///   - id: Unique identifier for the element. Optional.
  ///   - classes: Array of CSS class names. Optional.
  ///   - role: ARIA role for accessibility. Optional.
  ///   - content: A closure building child HTML elements, defaults to empty.
  public init(
    source: String,
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.source = source
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "video", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the video element as an HTML string.
  ///
  /// - Returns: A string containing the complete `<video>` tag with attributes and content.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", source),
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}

/// Represents an HTML audio element.
///
/// This class creates an `<audio>` tag used to embed audio content in HTML documents.
/// Semantically, it represents sound content (like music or speech) with optional
/// playback controls, enhancing document accessibility and interactivity.
public class Audio: Element {
  let source: String
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates an HTML audio element with specified attributes.
  ///
  /// - Parameters:
  ///   - source: The URL or path to the audio file.
  ///   - controls: If true, displays playback controls. Optional.
  ///   - autoplay: If true, starts playback automatically. Optional.
  ///   - loop: If true, loops the audio indefinitely. Optional.
  ///   - id: Unique identifier for the element. Optional.
  ///   - classes: Array of CSS class names. Optional.
  ///   - role: ARIA role for accessibility. Optional.
  ///   - content: A closure building child HTML elements, defaults to empty.
  public init(
    source: String,
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.source = source
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "audio", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the audio element as an HTML string.
  ///
  /// - Returns: A string containing the complete `<audio>` tag with attributes and content.
  /// - Note: Complexity is O(n + m) where n is the number of attributes and m is the number of child elements.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", source),
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
