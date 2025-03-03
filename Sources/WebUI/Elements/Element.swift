public class Element: HTML {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  private let contentBuilder: () -> [any HTML]

  var content: [any HTML] {
    contentBuilder()
  }

  init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.contentBuilder = content
  }

  public func render() -> String {
    let attributes = [
      id.map { "id=\"\($0)\"" },
      classes?.isEmpty == false ? "class=\"\(classes!.joined(separator: " "))\"" : nil,
      role.map { "role=\"\($0)\"" },
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
