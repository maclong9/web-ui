# Responsive Design

Learn how to create responsive layouts using WebUI's responsive design system.

## Overview

WebUI provides a powerful responsive design system that allows you to:
- Define styles for different screen sizes
- Create mobile-first layouts
- Use breakpoint-specific styling
- Combine multiple responsive modifiers

## Basic Responsive Styling

Use the `on` or `responsive` modifier to apply breakpoint-specific styles:

```swift
Button("Click Me")
    .font(size: .sm)
    .responsive {
        md {
            font(size: .lg)
        }
    }
```

## Multiple Breakpoints

Apply styles across different breakpoints:

```swift
Element(tag: "div")
    .background(color: .gray(._100))
    .font(size: .sm)
    .on {
        sm {
            font(size: .base)
        }
        md {
            font(size: .lg)
            background(color: .gray(._200))
        }
        lg {
            font(size: .xl)
            background(color: .gray(._300))
        }
    }
```

## Responsive Layout

Create layouts that adapt to screen size:

```swift
Layout.flex {
    Text("Sidebar")
    Text("Main Content")
}
.responsive { context in
    sm {
        direction(.column)
    }
    md {
        direction(.row)
    }
}
```

## Grid System

Use the responsive grid system:

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
.on {
    sm {
        grid(columns: 1)
    }
    lg {
        grid(columns: 12)
    }
}
```

## Breakpoint-Specific Visibility

Control element visibility at different breakpoints:

```swift
Element(tag: "div")
    .hidden()
    .on {
        md {
            hidden(false)
        }
    }
```

## Complex Components

Create components with comprehensive responsive behavior:

```swift
struct ResponsiveNavigation: Element {
    var body: some HTML {
        Navigation {
            // Mobile menu button
            Button("Menu")
                .hidden()
                .on {
                    sm {
                        hidden(false)
                    }
                    md {
                        hidden(true)
                    }
                }
            
            // Navigation links
            Layout.flex {
                Link(to: "home") { "Home" }
                Link(to: "about") { "About" }
                Link(to: "contact") { "Contact" }
            }
            .direction(.column)
            .on {
                md {
                    direction(.row)
                    gap(.medium)
                }
            }
        }
    }
}
```

## Available Breakpoints

| Breakpoint | Screen Size |
|------------|-------------|
| `xs`       | Extra small |
| `sm`       | Small       |
| `md`       | Medium      |
| `lg`       | Large       |
| `xl`       | Extra large |
| `xl2`      | 2X Large    |

## Topics

### Basics

- ``Responsive``
- ``Breakpoint``
- ``ResponsiveModifier``

### Layout

- ``ResponsiveLayout``
- ``ResponsiveGrid``
- ``ResponsiveFlex``

### Utilities

- ``BreakpointContext``
- ``ResponsiveValue``
- ``ViewportSize``