extension Element {
  /// Applies transformation styling to the element.
  ///
  /// Adds classes for scaling, rotating, translating, and skewing, optionally scoped to a breakpoint.
  ///
  /// - Parameters:
  ///   - scale: Sets the scale factor for both axes.
  ///   - scaleX: Sets the scale factor for the x-axis.
  ///   - scaleY: Sets the scale factor for the y-axis.
  ///   - rotate: Specifies the rotation angle in degrees.
  ///   - translateX: Sets the horizontal translation distance.
  ///   - translateY: Sets the vertical translation distance.
  ///   - skewX: Specifies the x-axis skew angle.
  ///   - skewY: Specifies the y-axis skew angle.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated transform classes.
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
