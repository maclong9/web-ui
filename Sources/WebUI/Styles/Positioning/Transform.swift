extension Element {
    /// Applies transformation styling to the element.
    ///
    /// Adds classes for scaling, rotating, translating, and skewing, optionally scoped to modifiers.
    /// Transform values are provided as (x: Int?, y: Int?) tuples for individual axis control.
    ///
    /// - Parameters:
    ///   - scale: Sets scale factor(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - rotate: Specifies the rotation angle in degrees.
    ///   - translate: Sets translation distance(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - skew: Sets skew angle(s) as an optional (x: Int?, y: Int?) tuple.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated transform classes.
    public func transform(
        scale: (x: Int?, y: Int?)? = nil,
        rotate: Int? = nil,
        translate: (x: Int?, y: Int?)? = nil,
        skew: (x: Int?, y: Int?)? = nil,
        on modifiers: Modifier...
    ) -> Element {
        var baseClasses: [String] = ["transform"]

        if let scaleTuple = scale {
            if let x = scaleTuple.x { baseClasses.append("scale-x-\(x)") }
            if let y = scaleTuple.y { baseClasses.append("scale-y-\(y)") }
        }

        if let rotate = rotate {
            baseClasses.append(rotate < 0 ? "rotate-\(-rotate)" : "rotate-\(rotate)")
        }

        if let translateTuple = translate {
            if let x = translateTuple.x {
                baseClasses.append(x < 0 ? "translate-x-\(-x)" : "translate-x-\(x)")
            }
            if let y = translateTuple.y {
                baseClasses.append(y < 0 ? "translate-y-\(-y)" : "translate-y-\(y)")
            }
        }

        if let skewTuple = skew {
            if let x = skewTuple.x {
                baseClasses.append(x < 0 ? "skew-x-\(-x)" : "skew-x-\(x)")
            }
            if let y = skewTuple.y {
                baseClasses.append(y < 0 ? "skew-y-\(-y)" : "skew-y-\(y)")
            }
        }

        let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

        return Element(
            tag: self.tag,
            id: self.id,
            classes: (self.classes ?? []) + newClasses,
            role: self.role,
            label: self.label,
            isSelfClosing: self.isSelfClosing,
            customAttributes: self.customAttributes,
            content: self.contentBuilder
        )
    }
}
