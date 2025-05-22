import WebUI

/// Interactive Button Component Example
///
/// This example demonstrates how to use interactive state modifiers to create
/// a responsive and accessible button with various state-based styles.
struct InteractiveButton: HTML {
    var label: String
    var isPrimary: Bool = true
    var isDisabled: Bool = false
    var onClick: String? = nil

    func render() -> String {
        Button(disabled: isDisabled, onClick: onClick) { label }
            // Base styles
            .padding(of: 4)
            .rounded(.md)
            .transition(of: .all, for: 150)
            .font(weight: .medium)

            // Conditional primary/secondary styles
            .on {
                if isPrimary {
                    background(color: .blue(._600))
                    font(color: .gray(._50))
                } else {
                    background(color: .gray(._200))
                    font(color: .gray(._800))
                    border(of: 1, color: .gray(._300))
                }
            }

            // Interactive state modifiers
            .on {
                // Hover state
                hover {
                    if isPrimary {
                        background(color: .blue(._700))
                    } else {
                        background(color: .gray(._300))
                    }
                    transform(scale: (x: 102, y: 102))
                }

                // Focus state (accessibility)
                focus {
                    if isPrimary {
                        outline(of: 2, color: .blue(._300))
                    } else {
                        outline(of: 2, color: .gray(._400))
                    }
                    outline(style: .solid)
                    transform(translateY: -1)
                }

                // Active state (when pressing)
                active {
                    if isPrimary {
                        background(color: .blue(._800))
                    } else {
                        background(color: .gray(._400))
                    }
                    transform(scale: (x: 98, y: 98))
                }

                // Disabled state
                disabled {
                    if isPrimary {
                        background(color: .blue(._300))
                    } else {
                        background(color: .gray(._100))
                        font(color: .gray(._400))
                    }
                    opacity(70)
                    cursor(.notAllowed)
                }
            }
            .render()
    }
}

/// Form Input Component Example
///
/// This example demonstrates how to create a form input with various
/// interactive states including placeholder styling and ARIA states.
struct FormInput: HTML {
    var id: String
    var label: String
    var placeholder: String = ""
    var isRequired: Bool = false
    var isInvalid: Bool = false
    var value: String? = nil

    func render() -> String {
        Div {
            Label(for: id) { label }
                .font(size: .sm)
                .font(weight: .medium)
                .font(color: .gray(._700))
                .on {
                    if isRequired {
                        after {
                            font(color: .red(._500))
                        }
                    }
                }

            Input(id: id, value: value, placeholder: placeholder, required: isRequired)
                .padding(of: 3)
                .rounded(.md)
                .border(of: 1, color: .gray(._300))
                .width(.full)
                .font(size: .sm)
                .transition(of: .all, for: 150)

                // Interactive state styling
                .on {
                    // Placeholder styling
                    placeholder {
                        font(color: .gray(._400))
                        font(weight: .light)
                    }

                    // Focus state
                    focus {
                        border(of: 1, color: .blue(._500))
                        shadow(of: .sm, color: .blue(._100))
                    }

                    // When the field is invalid
                    if isInvalid {
                        border(of: 1, color: .red(._500))

                        // Invalid + focus state
                        focus {
                            border(of: 1, color: .red(._500))
                            shadow(of: .sm, color: .red(._100))
                        }
                    }

                    // ARIA required state
                    ariaRequired {
                        border(of: 1, style: .solid)
                    }
                }
        }
        .render()
    }
}

/// Navigation Menu Item Example
///
/// This example demonstrates how to create an accessible navigation menu item
/// with different states for hover, focus, active, and selected.
struct NavMenuItem: HTML {
    var label: String
    var href: String
    var isSelected: Bool = false

    func render() -> String {
        Link(to: href) { label }
            .padding(vertical: 2, horizontal: 4)
            .rounded(.md)
            .font(size: .sm)
            .transition(of: .all, for: 150)

            // Base state
            .on {
                if isSelected {
                    font(weight: .semibold)
                    font(color: .blue(._700))
                    background(color: .blue(._50))
                } else {
                    font(weight: .normal)
                    font(color: .gray(._700))
                }
            }

            // Interactive states
            .on {
                // Hover state
                hover {
                    if !isSelected {
                        background(color: .gray(._100))
                    } else {
                        background(color: .blue(._100))
                    }
                }

                // Focus state for keyboard navigation
                focus {
                    outline(of: 2, color: .blue(._300))
                    outline(style: .solid)
                    outline(offset: 1)
                }

                // Active state (when pressing)
                active {
                    if !isSelected {
                        background(color: .gray(._200))
                    } else {
                        background(color: .blue(._200))
                    }
                    transform(scale: (x: 98, y: 98))
                }

                // ARIA selected state for screen readers
                ariaSelected {
                    font(weight: .semibold)
                }
            }
            .render()
    }
}

/// Example usage in a page context
struct InteractiveComponentsDemo: HTML {
    func render() -> String {
        Document(title: "Interactive Components Demo") {
            Section {
                Heading(level: 1) { "Interactive Components Demo" }
                    .font(size: .xl2)
                    .padding(bottom: 6)

                // Buttons section
                Div {
                    Heading(level: 2) { "Buttons" }
                        .font(size: .xl)
                        .padding(bottom: 4)

                    Div {
                        InteractiveButton(label: "Primary Button")
                        InteractiveButton(label: "Secondary Button", isPrimary: false)
                        InteractiveButton(label: "Disabled Button", isDisabled: true)
                    }
                    .spacing(of: 4)
                    .display(.flex)
                }
                .padding(bottom: 8)

                // Form section
                Div {
                    Heading(level: 2) { "Form Inputs" }
                        .font(size: .xl)
                        .padding(bottom: 4)

                    Div {
                        FormInput(id: "name", label: "Name", placeholder: "Enter your name")
                        FormInput(id: "email", label: "Email", placeholder: "Enter your email", isRequired: true)
                        FormInput(
                            id: "password",
                            label: "Password",
                            placeholder: "Enter your password",
                            isInvalid: true
                        )
                    }
                    .spacing(of: 4, along: .vertical)
                }
                .padding(bottom: 8)

                // Navigation section
                Div {
                    Heading(level: 2) { "Navigation" }
                        .font(size: .xl)
                        .padding(bottom: 4)

                    Nav {
                        Div {
                            NavMenuItem(label: "Home", href: "/", isSelected: true)
                            NavMenuItem(label: "Products", href: "/products")
                            NavMenuItem(label: "About", href: "/about")
                            NavMenuItem(label: "Contact", href: "/contact")
                        }
                        .display(.flex)
                        .spacing(of: 2)
                    }
                }
            }
            .padding(of: 8)
            .maxWidth(.character(80))
            .margins(at: .horizontal, auto: true)
        }
        .render()
    }
}
