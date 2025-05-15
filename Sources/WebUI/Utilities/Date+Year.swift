import Foundation

extension Date {
    /// Formats the date as a four-digit year string.
    ///
    /// This extension provides a convenient way to extract just the year component from a date
    /// as a formatted string, which is useful for copyright notices and other year-specific displays.
    ///
    /// - Returns: The year as a four-digit string (e.g., "2023").
    ///
    /// - Example:
    ///   ```swift
    ///   let currentYear = Date().formattedYear()
    ///   Text { "© \(currentYear) My Company" }
    ///   // Renders: "© 2023 My Company" (assuming current year is 2023)
    ///   ```
    public func formattedYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
}
