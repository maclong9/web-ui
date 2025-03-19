/// Generates an HTML image element.
public class Image: Element {
  let source: String
  let description: String
  let width: Int?
  let height: Int?

  /// Creates a new HTML image.
  ///
  /// - Parameters:
  ///   - source: URL or path to the image.
  ///   - description: Alt text for accessibility.
  ///   - width: Image width in pixels, optional.
  ///   - height: Image height in pixels, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  public init(
    source: String,
    description: String,
    width: Int? = nil,
    height: Int? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil
  ) {
    self.source = source
    self.description = description
    self.width = width
    self.height = height
    super.init(tag: "img", id: id, classes: classes, role: role)
  }

  /// Renders the image as an HTML string.
  ///
  /// - Returns: Complete self-closing `<img>` tag string.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", source),
      attribute("alt", description),
      attribute("width", width?.description),
      attribute("height", height?.description),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    return "<\(tag) \(attributes)>"
  }
}

/// Generates an HTML video element.
public class Video: Element {
  let source: String
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates a new HTML video.
  ///
  /// - Parameters:
  ///   - source: URL or path to the video.
  ///   - controls: Shows playback controls if true, optional.
  ///   - autoplay: Starts playback automatically if true, optional.
  ///   - loop: Loops video if true, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing fallback content, defaults to empty.
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

  /// Renders the video as an HTML string.
  ///
  /// - Returns: Complete `<video>` tag string with attributes and content.
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

/// Generates an HTML audio element.
public class Audio: Element {
  let source: String
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates a new HTML audio element.
  ///
  /// - Parameters:
  ///   - source: URL or path to the audio.
  ///   - controls: Shows playback controls if true, optional.
  ///   - autoplay: Starts playback automatically if true, optional.
  ///   - loop: Loops audio if true, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing fallback content, defaults to empty.
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

  /// Renders the audio as an HTML string.
  ///
  /// - Returns: Complete `<audio>` tag string with attributes and content.
  /// - Complexity: O(n + m) where n is attributes and m is child elements.
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
