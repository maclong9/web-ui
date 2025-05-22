# Responsive Styling

Design responsive layouts and components that adapt to different screen sizes with WebUI's powerful responsive styling features.

## Overview

WebUI offers two approaches to responsive styling, each with its own strengths and use cases:

1. **Modifier-based approach**: Apply styles conditionally using the `on` parameter with breakpoint modifiers like `.md` or `.lg`
2. **Block-based approach**: Define responsive styles for multiple breakpoints in a single, declarative block

## Breakpoint Modifiers

WebUI includes standard breakpoint modifiers that follow Tailwind CSS conventions:

| Modifier | Screen Width | Description |
|----------|-------------|-------------|
| `.xs`    | 480px+      | Extra small devices (larger phones) |
| `.sm`    | 640px+      | Small devices (tablets, large phones) |
| `.md`    | 768px+      | Medium devices (tablets) |
| `.lg`    | 1024px+     | Large devices (desktops) |
| `.xl`    | 1280px+     | Extra large devices (large desktops) |
| `.xl2`   | 1536px+     | 2x Extra large devices (very large desktops) |

## Modifier-Based Approach

The traditional approach applies responsive styles by using the `on` parameter with breakpoint modifiers:

```swift
Text { "Responsive Text" }
  .font(size: .sm)
  .font(size: .base, on: .md)
  .font(size: .lg, on: .lg)
  .margins(of: 2)
  .margins(of: 4, on: .md)
```

This approach works well for:
- Simple responsive adjustments
- Single-property changes across breakpoints
- Maintaining backward compatibility

## Block-Based Approach

The new block-based approach allows defining responsive styles for multiple breakpoints and properties in a single, declarative block:

```swift
Text { "Responsive Text" }
  .font(size: .sm)
  .responsive {
    md {
      font(size: .base)
      margins(of: 4)
    }
    lg {
      font(size: .lg)
      margins(of: 6)
    }
  }
```

This approach is ideal for:
- Complex responsive layouts with multiple property changes
- Improved code organization and readability
- Clearer representation of breakpoint-specific styling

## Complex Examples

### Responsive Card Component

```swift
Stack(classes: ["card"])
  // Using EdgeInsets for different padding on each side
  .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
  .background(color: .white)
  .shadow(of: .sm)
  .rounded(.md)
  .responsive {
    md {
      // Uniform padding using EdgeInsets
      padding(EdgeInsets(all: 6))
      shadow(of: .md)
    }
    lg {
      // Different vertical/horizontal padding with EdgeInsets
      padding(EdgeInsets(vertical: 8, horizontal: 12))
      flex(direction: .row)
    }
  }
```

### Responsive Navigation

```swift
Navigation {
  // Mobile navigation (hamburger menu)
  Stack(classes: ["hamburger-menu"])
    .responsive {
      lg {
        hidden()  // Hide on large screens
      }
    }
    
  // Desktop navigation links
  Stack(classes: ["desktop-menu"])
    .hidden()  // Hidden by default on mobile
    .responsive {
      lg {
        hidden(false)  // Show on large screens
        flex(direction: .row, justify: .between)
      }
    }
}
```

### Responsive Typography System

```swift
// Page title
Heading(.largeTitle) { "Welcome to WebUI" }
  .font(size: .xl3, weight: .bold)
  .responsive {
    md {
      font(size: .xl4)
    }
    lg {
      font(size: .xl5)
    }
  }

// Section heading
Heading(.title) { "Key Features" }
  .font(size: .xl, weight: .semibold)
  // Add margins with EdgeInsets
  .margins(EdgeInsets(top: 4, leading: 0, bottom: 2, trailing: 0))
  .responsive {
    md {
      font(size: .xl2)
      // Different margins at medium breakpoint
      margins(EdgeInsets(top: 6, leading: 0, bottom: 3, trailing: 0))
    }
  }
```

## Combining Approaches

You can combine both approaches when needed, though the block-based approach is generally recommended for clarity:

```swift
Button { "Sign Up" }
  .background(color: .blue(._500))
  // Using EdgeInsets for different padding values
  .padding(EdgeInsets(vertical: 2, horizontal: 4))
  .font(color: .white, weight: .semibold)
  // One-off responsive adjustment
  .rounded(.full, on: .lg)
  // Block of related responsive adjustments
  .responsive {
    md {
      // Combining EdgeInsets with responsive design
      padding(EdgeInsets(vertical: 3, horizontal: 6))
    }
    lg {
      background(color: .blue(._600))
      // Advanced EdgeInsets with different values for each edge
      padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
    }
  }
```

## Using EdgeInsets for Precise Spacing

EdgeInsets allows you to define different spacing values for each edge (top, leading, bottom, trailing) in a single method call:

```swift
// Different values for each edge
Element(tag: "div")
  .padding(EdgeInsets(top: 4, leading: 6, bottom: 8, trailing: 6))

// Same value for all edges
Button() { "Submit" }
  .margins(EdgeInsets(all: 4))

// Different vertical and horizontal values
Stack()
  .padding(EdgeInsets(vertical: 2, horizontal: 4))
```

EdgeInsets can be used with:
- `padding()`: Apply padding to elements
- `margins()`: Set margins around elements
- `border()`: Define border widths for each edge
- `position()`: Set position offsets for each edge

## Best Practices

1. **Group Related Styles**: Use the block-based approach to group styles that change together at specific breakpoints

2. **Consider Mobile-First**: Start with the default mobile styles and progressively enhance for larger screens

3. **Use Meaningful Breakpoints**: Choose breakpoints based on content needs rather than specific devices

4. **Avoid Breakpoint Proliferation**: Limit the number of different breakpoints to maintain consistency

5. **Use EdgeInsets for Precision**: When elements need different spacing values on each side, use EdgeInsets instead of multiple edge-specific calls

6. **Test Across Devices**: Always test responsive designs on actual devices or using browser dev tools

## See Also

- <doc:webui-api>
- ``Element``
- ``Modifier``