public enum Attribute {
    /// Builds an HTML attribute string if the value exists.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "id", "class", "src").
    ///   - value: Attribute value, optional.
    /// - Returns: Formatted attribute string (e.g., `id="header"`) or nil if value is empty.
    public static func string(_ name: String, _ value: String?) -> String? {
        value?.isEmpty == false ? "\(name)=\"\(value!)\"" : nil
    }

    /// Builds an HTML attribute string for a non-optional value.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "id", "class", "src").
    ///   - value: Attribute value.
    /// - Returns: Formatted attribute string (e.g., `id="header"`) or nil if value is empty.
    public static func string(_ name: String, _ value: String) -> String? {
        value.isEmpty == false ? "\(name)=\"\(value)\"" : nil
    }

    /// Builds a boolean HTML attribute if enabled.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "disabled", "checked", "required").
    ///   - enabled: Boolean enabling the attribute, optional.
    /// - Returns: Attribute name if true, nil otherwise.
    public static func bool(_ name: String, _ enabled: Bool?) -> String? {
        enabled == true ? name : nil
    }

    /// Builds an HTML attribute string from a typed enum value.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "type", "role").
    ///   - value: Enum value with String rawValue, optional.
    /// - Returns: Formatted attribute string (e.g., `type="submit"`) or nil if value is nil or empty.
    public static func typed<T: RawRepresentable>(_ name: String, _ value: T?) -> String?
    where T.RawValue == String {
        guard let stringValue = value?.rawValue, !stringValue.isEmpty else { return nil }
        return "\(name)=\"\(stringValue)\""
    }

    /// Builds an HTML attribute string from a non-optional typed enum value.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "type", "role").
    ///   - value: Enum value with String rawValue.
    /// - Returns: Formatted attribute string (e.g., `type="submit"`) or nil if value is empty.
    public static func typed<T: RawRepresentable>(_ name: String, _ value: T) -> String?
    where T.RawValue == String {
        let stringValue = value.rawValue
        return stringValue.isEmpty ? nil : "\(name)=\"\(stringValue)\""
    }
}

