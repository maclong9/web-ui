import Foundation

/// Provides a backward compatibility alias for the new responsive styling API
extension Element {
    /// Alias for the `.on` method to maintain backward compatibility with existing code
    ///
    /// This method provides a backward-compatible way to use the new `.on` method
    /// with code that was written to use `.responsive`.
    ///
    /// - Parameter content: A closure defining responsive style configurations using the result builder.
    /// - Returns: An element with responsive styles applied.
    public func responsive(@ResponsiveStyleBuilder _ content: () -> ResponsiveModification) -> Element {
        on(content)
    }
}
