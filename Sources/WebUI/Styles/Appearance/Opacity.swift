extension Element {
    /// Sets the opacity of the element with optional modifiers.
    ///
    /// - Parameters:
    ///   - value: The opacity value, typically between 0 and 100.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated opacity classes including applied modifiers.
    ///
    /// ## Example
    /// ```swift
    /// Image(source: "/images/profile.jpg", description: "Profile Photo")
    ///   .opacity(50)
    ///   .opacity(100, on: .hover)
    /// ```
    public func opacity(
        _ value: Int,
        on modifiers: Modifier...
    ) -> Element {
        let baseClass = "opacity-\(value)"
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
