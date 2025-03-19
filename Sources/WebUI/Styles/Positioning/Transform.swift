extension Element {
  /// Applies transformation styling to the element.
  ///
  /// Adds classes for scaling, rotating, translating, and skewing, optionally scoped to a breakpoint.
  /// Transform values are provided as (x: Int?, y: Int?) tuples for individual axis control.
  /// A single integer value will be converted to (x: value, y: nil) internally.
  ///
  /// - Parameters:
  ///   - scale: Sets scale factor(s) as (x: Int?, y: Int?) tuple.
  ///   - rotate: Specifies the rotation angle in degrees.
  ///   - translate: Sets translation distance(s) as (x: Int?, y: Int?) tuple.
  ///   - skew: Sets skew angle(s) as (x: Int?, y: Int?) tuple.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated transform classes.
  func transform(
    scale: Any? = nil,
    rotate: Int? = nil,
    translate: Any? = nil,
    skew: Any? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = [prefix + "transform"]

    // Convert scale to tuple format
    let scaleTuple: (x: Int?, y: Int?)
    if let scale = scale {
      if let scaleValue = scale as? Int {
        scaleTuple = (x: scaleValue, y: nil as Int?)
      } else if let scaleArray = scale as? [Int?], scaleArray.count == 2 {
        scaleTuple = (x: scaleArray[0], y: scaleArray[1])
      } else if let tuple = scale as? (x: Int?, y: Int?) {
        scaleTuple = tuple
      } else {
        scaleTuple = (x: nil as Int?, y: nil as Int?)
      }

      // Add scale classes
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

    // Convert translate to tuple format
    let translateTuple: (x: Int?, y: Int?)
    if let translate = translate {
      if let translateValue = translate as? Int {
        translateTuple = (x: translateValue, y: nil as Int?)
      } else if let translateArray = translate as? [Int?], translateArray.count == 2 {
        translateTuple = (x: translateArray[0], y: translateArray[1])
      } else if let tuple = translate as? (x: Int?, y: Int?) {
        translateTuple = tuple
      } else {
        translateTuple = (x: nil as Int?, y: nil as Int?)
      }

      // Add translate classes
      if let x = translateTuple.x {
        newClasses.append(x < 0 ? "\(prefix)translate-x-\(-x)" : "\(prefix)translate-x-\(x)")
      }
      if let y = translateTuple.y {
        newClasses.append(y < 0 ? "\(prefix)translate-y-\(-y)" : "\(prefix)translate-y-\(y)")
      }
    }

    // Convert skew to tuple format
    let skewTuple: (x: Int?, y: Int?)
    if let skew = skew {
      if let skewValue = skew as? Int {
        skewTuple = (x: skewValue, y: nil as Int?)
      } else if let skewArray = skew as? [Int?], skewArray.count == 2 {
        skewTuple = (x: skewArray[0], y: skewArray[1])
      } else if let tuple = skew as? (x: Int?, y: Int?) {
        skewTuple = tuple
      } else {
        skewTuple = (x: nil as Int?, y: nil as Int?)
      }

      // Add skew classes
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
