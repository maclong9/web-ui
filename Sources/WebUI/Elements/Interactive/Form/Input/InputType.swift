/// Defines types for HTML input elements.
///
/// Specifies the type of data to be collected by an input element, affecting both
/// appearance and validation behavior.
public enum InputType: String {
    /// Single-line text input field for general text entry.
    case text
    /// Masked password input field that hides characters for security.
    case password
    /// Email address input field with validation for email format.
    case email
    /// Numeric input field optimized for number entry, often with increment/decrement controls.
    case number
    /// Date picker input field for selecting dates.
    case date
    /// URL input field with validation for web addresses.
    case url
    /// Telephone number input field optimized for phone number entry.
    case tel
    /// Search input field optimized for search queries.
    case search
    /// Radio button input for single selection from multiple options.
    case radio
    /// Checkbox input for boolean (yes/no) selections.
    case checkbox
    /// Submit button input that triggers form submission when clicked.
    case submit
}
