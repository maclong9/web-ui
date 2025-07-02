public enum Attribute {
    /// Builds a markup attribute string if the value exists.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "id", "class", "src").
    ///   - value: Attribute value, optional.
    /// - Returns: Formatted attribute string (e.g., `id="header"`) or nil if value is empty.
    public static func string(_ name: String, _ value: String?) -> String? {
        guard let value = value, !value.isEmpty else { return nil }
        return "\(name)=\"\(value)\""
    }

    /// Builds a boolean markup attribute if enabled.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "disabled", "checked", "required").
    ///   - enabled: Boolean enabling the attribute, optional.
    /// - Returns: Attribute name if true, nil otherwise.
    public static func bool(_ name: String, _ enabled: Bool?) -> String? {
        enabled == true ? name : nil
    }

    /// Builds a markup attribute string from a typed enum value.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "type", "role").
    ///   - value: Enum value with String rawValue, optional.
    /// - Returns: Formatted attribute string (e.g., `type="submit"`) or nil if value is nil or empty.
    public static func typed<T: RawRepresentable>(_ name: String, _ value: T?)
        -> String?
    where T.RawValue == String {
        guard let stringValue = value?.rawValue, !stringValue.isEmpty else {
            return nil
        }
        return "\(name)=\"\(value?.rawValue ?? "")\""
    }
}
