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
    $0.md {
      $0.font(size: .base)
      $0.margins(of: 4)
    }
    $0.lg {
      $0.font(size: .lg)
      $0.margins(of: 6)
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
  .padding(of: 4)
  .background(color: .white)
  .shadow(of: .sm)
  .rounded(.md)
  .responsive {
    $0.md {
      $0.padding(of: 6)
      $0.shadow(of: .md)
    }
    $0.lg {
      $0.padding(of: 8)
      $0.flex(direction: .row)
    }
  }
```

### Responsive Navigation

```swift
Navigation {
  // Mobile navigation (hamburger menu)
  Stack(classes: ["hamburger-menu"])
    .responsive {
      $0.lg {
        $0.hidden()  // Hide on large screens
      }
    }
    
  // Desktop navigation links
  Stack(classes: ["desktop-menu"])
    .hidden()  // Hidden by default on mobile
    .responsive {
      $0.lg {
        $0.hidden(false)  // Show on large screens
        $0.flex(direction: .row, justify: .between)
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
    $0.md {
      $0.font(size: .xl4)
    }
    $0.lg {
      $0.font(size: .xl5)
    }
  }

// Section heading
Heading(.title) { "Key Features" }
  .font(size: .xl, weight: .semibold)
  .responsive {
    $0.md {
      $0.font(size: .xl2)
    }
  }
```

## Combining Approaches

You can combine both approaches when needed, though the block-based approach is generally recommended for clarity:

```swift
Button { "Sign Up" }
  .background(color: .blue(._500))
  .padding(of: 2, at: .vertical)
  .padding(of: 4, at: .horizontal)
  .font(color: .white, weight: .semibold)
  // One-off responsive adjustment
  .rounded(.full, on: .lg)
  // Block of related responsive adjustments
  .responsive {
    $0.md {
      $0.padding(of: 3, at: .vertical)
      $0.padding(of: 6, at: .horizontal)
    }
    $0.lg {
      $0.background(color: .blue(._600))
    }
  }
```

## Best Practices

1. **Group Related Styles**: Use the block-based approach to group styles that change together at specific breakpoints

2. **Consider Mobile-First**: Start with the default mobile styles and progressively enhance for larger screens

3. **Use Meaningful Breakpoints**: Choose breakpoints based on content needs rather than specific devices

4. **Avoid Breakpoint Proliferation**: Limit the number of different breakpoints to maintain consistency

5. **Test Across Devices**: Always test responsive designs on actual devices or using browser dev tools

## See Also

- <doc:webui-api>
- ``Element``
- ``Modifier``