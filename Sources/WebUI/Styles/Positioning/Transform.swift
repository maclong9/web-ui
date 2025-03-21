extension Element {
  /// Applies transformation styling to the element.
  ///
  /// Adds classes for scaling, rotating, translating, and skewing, optionally scoped to a breakpoint.
  /// Transform values are provided as (x: Int?, y: Int?) tuples for individual axis control.
  /// A single integer value can be passed and will be interpreted as (x: value, y: nil).
  ///
  /// - Parameters:
  ///   - scale: Sets scale factor(s) as an optional (x: Int?, y: Int?) tuple.
  ///   - rotate: Specifies the rotation angle in degrees.
  ///   - translate: Sets translation distance(s) as an optional (x: Int?, y: Int?) tuple.
  ///   - skew: Sets skew angle(s) as an optional (x: Int?, y: Int?) tuple.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated transform classes.
  func transform(
    scale: (x: Int?, y: Int?)? = nil,
    rotate: Int? = nil,
    translate: (x: Int?, y: Int?)? = nil,
    skew: (x: Int?, y: Int?)? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = [prefix + "transform"]

    // Handle scale tuple
    if let scaleTuple = scale {
      if let x = scaleTuple.x {
        newClasses.append("\(prefix)scale-x-\(x)")
      }
      if let y = scaleTuple.y {
        newClasses.append("\(prefix)scale-y-\(y)")
      }
    }

    // Handle rotate value
    if let rotate = rotate {
      if rotate < 0 {
        newClasses.append("\(prefix)rotate-\(-rotate)")
      } else {
        newClasses.append("\(prefix)rotate-\(rotate)")
      }
    }

    // Handle translate tuple
    if let translateTuple = translate {
      if let x = translateTuple.x {
        newClasses.append(x < 0 ? "\(prefix)translate-x-\(-x)" : "\(prefix)translate-x-\(x)")
      }
      if let y = translateTuple.y {
        newClasses.append(y < 0 ? "\(prefix)translate-y-\(-y)" : "\(prefix)translate-y-\(y)")
      }
    }

    // Handle skew tuple
    if let skewTuple = skew {
      if let x = skewTuple.x {
        newClasses.append(x < 0 ? "\(prefix)skew-x-\(-x)" : "\(prefix)skew-x-\(x)")
      }
      if let y = skewTuple.y {
        newClasses.append(y < 0 ? "\(prefix)skew-y-\(-y)" : "\(prefix)skew-y-\(y)")
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
