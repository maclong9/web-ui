/// Creates an HTML image element.
/// This renders an `<img>` tag, used to embed an image in the document.
public class Image: Element {
  let src: String
  let alt: String?
  let width: Int?
  let height: Int?

  init(
    src: String,
    alt: String? = nil,
    width: Int? = nil,
    height: Int? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil
  ) {
    self.src = src
    self.alt = alt
    self.width = width
    self.height = height
    super.init(tag: "img", id: id, classes: classes, role: role)
  }

  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", src),
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

/// Creates an HTML video element.
/// This renders a `<video>` tag, used to embed video content with optional playback controls.
public class Video: Element {
  let src: String?
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  init(
    src: String? = nil,
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.src = src
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "video", id: id, classes: classes, role: role, content: content)
  }

  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", src),
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

/// Creates an HTML audio element.
/// This renders an `<audio>` tag, used to embed audio content with optional playback controls.
public class Audio: Element {
  let src: String?
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  init(
    src: String? = nil,
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.src = src
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "audio", id: id, classes: classes, role: role, content: content)
  }

  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("src", src),
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
