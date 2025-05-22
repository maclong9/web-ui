# Styling in WebUI

Learn how to style your web applications using WebUI's type-safe styling system.

## Overview

WebUI provides a comprehensive styling system that combines Swift's type safety with modern CSS capabilities. The styling system includes:

- Responsive design with breakpoints
- Typography and spacing
- Layout controls
- Sizing and positioning
- Interactive states

## Basic Styling

### Frame and Sizing

Control element dimensions using the `frame` modifier:

```swift
Element(tag: "div")
    .frame(width: .full, height: .screen)             // Full width, screen height
    .frame(width: .fraction(1, 2))                    // Half width
    .frame(width: .container(.medium))                // Container width
    .frame(width: .character(60))                     // Character-based width
    .frame(minWidth: .min, maxHeight: .fit)          // Min/max constraints
```

### Typography

Style text with the `font` modifier:

```swift
Text("Hello World")
    .font(
        size: .xl,
        weight: .semibold,
        color: .gray(._700)
    )
    .font(
        alignment: .center,
        tracking: .wide,
        leading: .loose
    )
```

### Spacing

Control margins and padding:

```swift
Element(tag: "div")
    .margins(of: 4)                          // All sides
    .margins(of: 8, at: .top, .bottom)       // Specific edges
    .margins(at: .horizontal, auto: true)    // Auto margins
    .padding(of: 6)                          // Padding all sides
    .padding(of: 5, at: .vertical)           // Vertical padding
    .spacing(of: 4, along: .both)           // Child element spacing
```

## Responsive Design

WebUI provides a powerful responsive design system using the `responsive` or `on` modifier:

```swift
Button("Click Me")
    .background(color: .blue(._500))
    .padding(of: 2)
    .on {
        sm {
            padding(of: 3)
        }
        md {
            padding(of: 4)
            font(size: .lg)
        }
        lg {
            padding(of: 6)
            background(color: .blue(._600))
        }
    }
```

### Available Breakpoints

- `xs`: Extra small screens
- `sm`: Small screens
- `md`: Medium screens
- `lg`: Large screens
- `xl`: Extra large screens
- `xl2`: 2X Extra large screens

## Layout

### Flex Layout

```swift
Layout.flex {
    Text("Sidebar")
        .width(250)
    Text("Main Content")
        .flexGrow(1)
}
.gap(.medium)
```

### Grid Layout

```swift
Layout.grid {
    Text("Header")
        .gridColumn(.span(12))
    Text("Sidebar")
        .gridColumn(.span(3))
    Text("Content")
        .gridColumn(.span(9))
}
.columns(12)
.gap(.medium)
```

## Interactive States

Add styles for different interaction states:

```swift
Button("Submit")
    .background(color: .blue(._500))
    .on(.hover) {
        background(color: .blue(._600))
    }
    .on(.focus) {
        outline(width: 2, color: .blue(._300))
    }
```

## Custom Themes

Define custom themes with consistent design tokens:

```swift
let theme = Theme(
    colors: [
        "primary": "blue",
        "secondary": "#10b981"
    ],
    spacing: ["4": "1rem"],
    textSizes: ["lg": "1.25rem"],
    custom: ["opacity": ["faint": "0.1"]]
)
```

## Topics

### Basics

- ``Style``
- ``Theme``
- ``Color``

### Layout

- ``Layout``
- ``Flex``
- ``Grid``

### Responsive

- ``Breakpoint``
- ``ResponsiveModifier``

### Advanced

- ``CustomStyle``
- ``StyleModifier``
