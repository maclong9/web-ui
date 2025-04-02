// Represents image size by width and height
public struct ImageSize {
  let width: Int?
  let height: Int?
}

/// Generates an HTML figure element containing a picture with optional sources and caption.
public final class Figure: Element {
  let picture: Image
  let caption: String?

  /// Creates a new HTML figure element wrapping a picture with multiple sources.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - sources: Array of URLs or paths to image files (first valid source is used by browser).
  ///   - description: Alt text for accessibility on the fallback image.
  ///   - caption: Text for the optional `<figcaption>`, nil if omitted.
  ///   - size: Image size dimensions, optional.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    source: String,
    description: String,
    caption: String? = nil,
    size: ImageSize? = nil
  ) {
    self.picture = Image(
      source: source,
      description: description,
      size: size
    )
    self.caption = caption
    super.init(tag: "figure", id: id, classes: classes, role: role)
  }

  /// Renders the figure as an HTML string with picture and optional caption.
  ///
  /// - Returns: Complete `<figure>` tag string containing a `<picture>` and optional `<figcaption>`.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let captionString = caption.map { "<figcaption>\($0)</figcaption>" } ?? ""
    return "<\(tag)\(attributesString)>\(picture.render())\(captionString)</\(tag)>"
  }
}

/// Generates an HTML image element.
public final class Image: Element {
  let source: String
  let description: String
  let size: ImageSize?

  /// Creates a new HTML image element.
  ///
  /// - Parameters:
  ///   - url: URL or path to the image file.
  ///   - description: Alt text for accessibility.
  ///   - size: Image size dimensions, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  public init(
    source: String,
    description: String,
    size: ImageSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil
  ) {
    self.source = source
    self.description = description
    self.size = size
    super.init(tag: "img", id: id, classes: classes, role: role)
  }

  /// Renders an `<img>` HTML string.
  ///
  /// - Returns: A string containing the full `<img>` tag.
  public override func render() -> String {
    let attributes = [
      attribute("src", source),
      attribute("alt", description),
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("role", role?.rawValue),
      size?.width != nil ? "width=\"\(size!.width!)\"" : nil,
      size?.height != nil ? "height=\"\(size!.height!)\"" : nil,
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    return "<\(tag) \(attributes)>"
  }
}

/// Generates an HTML video element with multiple source tags.
public final class Video: Element {
  let sourceURLs: [String]
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?
  let size: ImageSize?

  /// Creates a new HTML video element with embedded sources.
  ///
  /// - Parameters:
  ///   - sources: Array of URLs or paths to video files (first valid source is used by browser).
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats video playback if true, optional.
  ///   - size: Video size dimensions, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    size: ImageSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    self.size = size
    super.init(tag: "video", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the video as an HTML string with multiple source tags.
  ///
  /// - Returns: Complete `<video>` tag string including `<source>` tags and optional fallback content.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
      attribute("width", size?.width.map { String($0) }),
      attribute("height", size?.height.map { String($0) }),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let sourceTags = sourceURLs.map { "<source src=\"\($0)\">" }.joined()
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(sourceTags)\(contentString)</\(tag)>"
  }
}

/// Generates an HTML audio element with multiple source tags.
public final class Audio: Element {
  let sourceURLs: [String]
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates a new HTML audio element with embedded sources.
  ///
  /// - Parameters:
  ///   - sources: Array of URLs or paths to audio files (first valid source is used by browser).
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats audio playback if true, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "audio", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the audio as an HTML string with multiple source tags.
  ///
  /// - Returns: Complete `<audio>` tag string including `<source>` tags and optional fallback content.
  /// - Complexity: O(n + m) where n is the number of attributes and m is the number of child elements plus sources.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let sourceTags = sourceURLs.map { "<source src=\"\($0)\">" }.joined()
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(sourceTags)\(contentString)</\(tag)>"
  }
}
