extension Element {
  /// Applies transform styling to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - scale: Scale value for both axes (e.g., "110" for `scale-110`).
  ///   - scaleX: Scale value for x-axis (e.g., "50" for `scale-x-50`).
  ///   - scaleY: Scale value for y-axis (e.g., "150" for `scale-y-150`).
  ///   - rotate: Rotation value (e.g., "45" for `rotate-45`, "-45" for `-rotate-45`, "[45deg]" for `rotate-[45deg]`).
  ///   - translateX: Translation on x-axis (e.g., "4" for `translate-x-4`, "[-2rem]" for `translate-x-[-2rem]`).
  ///   - translateY: Translation on y-axis (e.g., "2" for `translate-y-2`).
  ///   - skewX: Skew on x-axis (e.g., "10" for `skew-x-10`).
  ///   - skewY: Skew on y-axis (e.g., "5" for `skew-y-5`).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated transform classes.
  func transform(
    scale: String? = nil,
    scaleX: String? = nil,
    scaleY: String? = nil,
    rotate: String? = nil,
    translateX: String? = nil,
    translateY: String? = nil,
    skewX: String? = nil,
    skewY: String? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = [prefix + "transform"]

    if let scale = scale {
      newClasses.append("\(prefix)scale-\(scale)")
    }
    if let scaleX = scaleX {
      newClasses.append("\(prefix)scale-x-\(scaleX)")
    }
    if let scaleY = scaleY {
      newClasses.append("\(prefix)scale-y-\(scaleY)")
    }
    if let rotate = rotate {
      if rotate.hasPrefix("[") {
        newClasses.append("\(prefix)rotate-\(rotate)")
      } else if rotate.hasPrefix("-") {
        let value = String(rotate.dropFirst())
        newClasses.append("\(prefix)-rotate-\(value)")
      } else {
        newClasses.append("\(prefix)rotate-\(rotate)")
      }
    }
    if let translateX = translateX {
      if translateX.hasPrefix("[") {
        newClasses.append("\(prefix)translate-x-\(translateX)")
      } else if translateX.hasPrefix("-") {
        let value = String(translateX.dropFirst())
        newClasses.append("\(prefix)-translate-x-\(value)")
      } else {
        newClasses.append("\(prefix)translate-x-\(translateX)")
      }
    }
    if let translateY = translateY {
      if translateY.hasPrefix("[") {
        newClasses.append("\(prefix)translate-y-\(translateY)")
      } else if translateY.hasPrefix("-") {
        let value = String(translateY.dropFirst())
        newClasses.append("\(prefix)-translate-y-\(value)")
      } else {
        newClasses.append("\(prefix)translate-y-\(translateY)")
      }
    }
    if let skewX = skewX {
      if skewX.hasPrefix("[") {
        newClasses.append("\(prefix)skew-x-\(skewX)")
      } else if skewX.hasPrefix("-") {
        let value = String(skewX.dropFirst())
        newClasses.append("\(prefix)-skew-x-\(value)")
      } else {
        newClasses.append("\(prefix)skew-x-\(skewX)")
      }
    }
    if let skewY = skewY {
      if skewY.hasPrefix("[") {
        newClasses.append("\(prefix)skew-y-\(skewY)")
      } else if skewY.hasPrefix("-") {
        let value = String(skewY.dropFirst())
        newClasses.append("\(prefix)-skew-y-\(value)")
      } else {
        newClasses.append("\(prefix)skew-y-\(skewY)")
      }
    }

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
