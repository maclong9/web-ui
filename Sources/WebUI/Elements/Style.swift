extension Element {
  func font(
    weight: Weight? = nil,
    size: Size? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil
  ) -> Element {
    let updatedClasses: [String] =
      (self.classes ?? [])
      + [
        weight?.rawValue,
        size?.rawValue,
        alignment?.rawValue,
        tracking?.rawValue,
        leading?.rawValue,
        decoration?.rawValue,
      ].compactMap { $0 }

    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
