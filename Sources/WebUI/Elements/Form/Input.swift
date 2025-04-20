import Foundation

/// Defines types for HTML input elements.
public enum InputType: String {
  /// Single-line text input field.
  case text
  /// Masked password input field.
  case password
  /// Email address input field.
  case email
  /// Numeric input field.
  case number
  /// Checkbox input.
  case checkbox
  /// Radio button input.
  case radio
  /// Submit button input.
  case submit
  /// Reset button input.
  case reset
  /// Hidden input field.
  case hidden
  /// File upload input.
  case file
  /// Date picker input.
  case date
  /// Date and time picker input.
  case datetime
  /// Month picker input.
  case month
  /// Color picker input.
  case color
  /// Range slider input.
  case range
  /// Search input field.
  case search
  /// Telephone number input field.
  case tel
  /// URL input field.
  case url
}

/// Generates an HTML input element for collecting user input, such as text or numbers.
final public class Input: Element {
  private let name: String
  private let type: InputType
  private let value: String?
  private let placeholder: String?
  private let autofocus: Bool?
  private let required: Bool?
  private let checked: Bool?
  private let min: String?
  private let max: String?
  private let step: String?
  private let pattern: String?
  private let accept: String?
  private let multiple: Bool?
  private let readonly: Bool?
  private let disabled: Bool?

  /// Private initializer that takes all possible parameters
  /// This is not exposed publicly - users will use factory methods instead
  private init(
    name: String,
    type: InputType,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    checked: Bool? = nil,
    min: String? = nil,
    max: String? = nil,
    step: String? = nil,
    pattern: String? = nil,
    accept: String? = nil,
    multiple: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    self.checked = checked
    self.min = min
    self.max = max
    self.step = step
    self.pattern = pattern
    self.accept = accept
    self.multiple = multiple
    self.readonly = readonly
    self.disabled = disabled
    super.init(tag: "input", config: config, isSelfClosing: true)
  }

  /// Provides input-specific attributes for the HTML element.
  public override func additionalAttributes() -> [String] {
    [
      attribute("name", name),
      attribute("type", type.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      attribute("min", min),
      attribute("max", max),
      attribute("step", step),
      attribute("pattern", pattern),
      attribute("accept", accept),
      booleanAttribute("autofocus", autofocus),
      booleanAttribute("required", required),
      booleanAttribute("checked", checked),
      booleanAttribute("multiple", multiple),
      booleanAttribute("readonly", readonly),
      booleanAttribute("disabled", disabled),
    ].compactMap { $0 }
  }

  // MARK: - Factory Methods

  /// Creates a text input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A text input element.
  public static func text(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .text,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a password input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A password input element.
  public static func password(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .password,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates an email input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: An email input element.
  public static func email(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .email,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a number input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - min: Minimum value allowed, optional.
  ///   - max: Maximum value allowed, optional.
  ///   - step: Stepping interval for value changes, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A number input element.
  public static func number(
    name: String,
    value: String? = nil,
    min: String? = nil,
    max: String? = nil,
    step: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .number,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      min: min,
      max: max,
      step: step,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a checkbox input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - checked: Indicates if the checkbox is checked, optional.
  ///   - value: Value to be submitted if checkbox is checked, defaults to "on" if not specified.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A checkbox input element.
  public static func checkbox(
    name: String,
    checked: Bool? = nil,
    value: String? = nil,
    required: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .checkbox,
      value: value,
      required: required,
      checked: checked,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a radio button input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Value to be submitted if this radio button is selected.
  ///   - checked: Indicates if the radio button is selected, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A radio button input element.
  public static func radio(
    name: String,
    value: String,
    checked: Bool? = nil,
    required: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .radio,
      value: value,
      required: required,
      checked: checked,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a submit button input element.
  ///
  /// - Parameters:
  ///   - value: Text displayed on the button.
  ///   - name: Name for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A submit button input element.
  public static func submit(
    value: String,
    name: String? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name ?? "",
      type: .submit,
      value: value,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a reset button input element.
  ///
  /// - Parameters:
  ///   - value: Text displayed on the button.
  ///   - name: Name for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A reset button input element.
  public static func reset(
    value: String,
    name: String? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name ?? "",
      type: .reset,
      value: value,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a hidden input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Value to be submitted.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A hidden input element.
  public static func hidden(
    name: String,
    value: String,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .hidden,
      value: value,
      config: config
    )
  }

  /// Creates a file upload input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - accept: File types that can be selected, optional (e.g., ".jpg,.png" or "image/*").
  ///   - multiple: Allows selection of multiple files if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A file upload input element.
  public static func file(
    name: String,
    accept: String? = nil,
    multiple: Bool? = nil,
    required: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .file,
      required: required,
      accept: accept,
      multiple: multiple,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a date picker input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial date value in yyyy-mm-dd format, optional.
  ///   - min: Minimum date allowed in yyyy-mm-dd format, optional.
  ///   - max: Maximum date allowed in yyyy-mm-dd format, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A date picker input element.
  public static func date(
    name: String,
    value: String? = nil,
    min: String? = nil,
    max: String? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .date,
      value: value,
      required: required,
      min: min,
      max: max,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a color picker input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial color value in #rrggbb format, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A color picker input element.
  public static func color(
    name: String,
    value: String? = nil,
    required: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .color,
      value: value,
      required: required,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a range slider input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - min: Minimum value allowed, optional, defaults to "0".
  ///   - max: Maximum value allowed, optional, defaults to "100".
  ///   - step: Stepping interval for value changes, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A range slider input element.
  public static func range(
    name: String,
    value: String? = nil,
    min: String = "0",
    max: String = "100",
    step: String? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .range,
      value: value,
      min: min,
      max: max,
      step: step,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a search input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A search input element.
  public static func search(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .search,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a telephone number input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - pattern: Regular expression pattern for validation, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A telephone number input element.
  public static func tel(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    pattern: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .tel,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      pattern: pattern,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }

  /// Creates a URL input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - readonly: Prevents the user from modifying the value, optional.
  ///   - disabled: Disables the input element, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: A URL input element.
  public static func url(
    name: String,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    readonly: Bool? = nil,
    disabled: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    Input(
      name: name,
      type: .url,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus,
      required: required,
      readonly: readonly,
      disabled: disabled,
      config: config
    )
  }
}
