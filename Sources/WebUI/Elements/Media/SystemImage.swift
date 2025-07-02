import Foundation

/// Creates HTML elements for system images/icons using SVG or icon fonts.
///
/// Represents system icons that can be used in buttons, labels, and other UI elements.
/// This component supports both traditional system icons and Lucide icons, providing
/// flexibility for different icon systems while maintaining a consistent API.
///
/// ## Usage with Lucide Icons
/// ```swift
/// SystemImage(.airplay)                        // Lucide enum
/// SystemImage("airplay")                      // String (auto-detects Lucide)
/// SystemImage(.heart, classes: ["favorite"])  // With custom styling
/// ```
///
/// ## Traditional System Icons
/// ```swift
/// SystemImage("checkmark")                    // Legacy system icon
/// SystemImage("arrow.down", classes: ["download-icon"])
/// ```
public struct SystemImage: Element {
    private let iconType: IconType
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    
    /// The type of icon being rendered.
    private enum IconType {
        case lucide(LucideIcon)
        case system(String)
    }

    /// Creates a new system image element using a LucideIcon.
    ///
    /// This initializer provides type-safe access to Lucide icons and
    /// automatically configures the appropriate CSS classes.
    ///
    /// - Parameters:
    ///   - icon: The Lucide icon to display.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the icon.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the icon for accessibility.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///
    /// ## Example
    /// ```swift
    /// SystemImage(.airplay)
    /// SystemImage(.heart, classes: ["favorite-icon"])
    /// SystemImage(.settings, label: "Open settings")
    /// ```
    public init(
        _ icon: LucideIcon,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.iconType = .lucide(icon)
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }

    /// Creates a new system image element using a string identifier.
    ///
    /// This initializer automatically detects whether the string corresponds
    /// to a known Lucide icon or should be treated as a traditional system icon.
    ///
    /// - Parameters:
    ///   - name: The name/identifier of the icon.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the icon.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the icon for accessibility.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///
    /// ## Example
    /// ```swift
    /// SystemImage("airplay")                    // Auto-detects as Lucide
    /// SystemImage("checkmark")                  // Traditional system icon
    /// SystemImage("custom-icon", classes: ["my-style"])
    /// ```
    public init(
        _ name: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        // Check if this is a known Lucide icon
        if let lucideIcon = LucideIcon(rawValue: name) {
            self.iconType = .lucide(lucideIcon)
        } else {
            self.iconType = .system(name)
        }
        
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var allClasses: [String] = []
        var labelText: String
        
        switch iconType {
        case .lucide(let icon):
            // Use Lucide CSS classes
            allClasses.append("lucide")
            allClasses.append(icon.cssClass)
            labelText = label ?? icon.displayName
            
        case .system(let name):
            // Use traditional system icon classes
            allClasses.append("system-image")
            allClasses.append("icon-\(name.replacingOccurrences(of: ".", with: "-"))")
            labelText = label ?? name
        }
        
        // Add custom classes
        if let classes = classes {
            allClasses.append(contentsOf: classes)
        }
        
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: allClasses,
            role: role,
            label: labelText,
            data: data
        )
        
        // Use <i> for Lucide icons (icon font convention), <span> for system icons
        let tagName = switch iconType {
        case .lucide: "i"
        case .system: "span"
        }
        
        return AttributeBuilder.renderTag(
            tagName, attributes: attributes, content: ""
        )
    }
}