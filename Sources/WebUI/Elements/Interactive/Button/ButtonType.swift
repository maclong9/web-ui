/// Defines types of HTML button elements.
///
/// Specifies the purpose and behavior of buttons within forms.
public enum ButtonType: String {
    /// Regular button without specific form behavior.
    case button

    /// Submits the form data to the server.
    case submit

    /// Resets all form controls to their initial values.
    case reset
}
