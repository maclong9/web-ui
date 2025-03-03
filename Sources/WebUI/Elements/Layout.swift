public class Header: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, content: content)
  }
}

public class Navigation: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, content: content)
  }
}

public class Main: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "main", id: id, classes: classes, role: role, content: content)
  }
}

public class Footer: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "footer", id: id, classes: classes, role: role, content: content)
  }
}
