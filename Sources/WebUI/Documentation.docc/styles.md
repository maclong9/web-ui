# WebUI Style System

The WebUI style system is a powerful and flexible framework for defining and applying styles to UI elements. It provides a set of core components that enable developers to create custom styles across multiple breakpoints and modifiers, and apply them to their applications.

## Core Components

### StyleOperation Protocol

The `StyleOperation` protocol is the foundation of the system, defining a common interface for all style operations:

```swift
public protocol StyleOperation {
    associatedtype Parameters
    func applyClasses(params: Parameters) -> [String]
}
```

Each style operation implements this protocol with its specific parameters and class generation logic.

### Style Registry

The `StyleRegistry` provides a central access point for all style operations:

```swift
StyleRegistry.border   // Access the border style operation
StyleRegistry.margins  // Access the margins style operation
StyleRegistry.padding  // Access the padding style operation
```

## Using Style Operations

Style operations are automatically available in two contexts:

1. **Element Extensions**: Apply styles directly to elements
   ```swift
   element.border(of: 1, at: .top, color: .blue(._500))
   ```

2. **Declaritive DSL**: Use in result builder context with a clean, declarative syntax
   ```swift
   element.on {
     sm {
       border(of: 1, at: .top)
     }
   }
   ```

## Implementing a New Style Operation

To add a new style operation:

1. Create a new file in `Styles/Core` named `[Style]StyleOperation.swift`
2. Implement the `StyleOperation` protocol
3. Add the operation to `StyleRegistry`
4. Create the two interface variants (Element extension and global function)

### Example Template

```swift
import Foundation

public struct NewStyleOperation: StyleOperation {
    // Parameters struct
    public struct Parameters {
        // Define parameters

        public init(/* parameters */) {
            // Initialize parameters
        }
    }

    // Implementation
    public func applyClasses(params: Parameters) -> [String] {
        // Generate and return CSS classes
    }

    // Shared instance
    public static let shared = NewStyleOperation()

    // Private initializer
    private init() {}
}

// Element extension
extension Element {
    public func newStyle(/* parameters */) -> Element {
        // Use the shared operation
    }
}



// Global function for Declaritive DSL
public func newStyle(/* parameters */) -> ResponsiveModification {
    // Use the shared operation
}
```

## Benefits

1. **Single Point of Definition**: Each style property defined once
2. **Maintainability**: Changes need to be made in only one place
3. **Consistency**: Guarantees consistency between different interfaces
4. **Extensibility**: Makes adding new style properties simpler
5. **Reduced Code Size**: Significantly less code to maintain
