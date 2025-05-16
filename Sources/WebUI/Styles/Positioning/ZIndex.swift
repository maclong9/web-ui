extension Element {
    /// Applies a z-index to the element.
    ///
    /// Sets the stacking order of the element, optionally scoped to modifiers.
    ///
    /// - Parameters:
    ///   - value: Specifies the z-index value as an integer.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated z-index classes.
    ///
    /// ## Example
    /// ```swift
    /// // Header that stays on top of other content
    /// Header()
    ///   .zIndex(50)
    ///
    /// // Dropdown menu that appears above other elements when activated
    /// Stack(classes: ["dropdown-menu"])
    ///   .zIndex(10, on: .hover)
    /// ```
    public func zIndex(
        _ value: Int,
        on modifiers: Modifier...
    ) -> Element {
        let baseClass = "z-\(value)"
        let newClasses = combineClasses([baseClass], withModifiers: modifiers)

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
