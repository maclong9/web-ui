# Creating Custom Elements

Learn how to create reusable components in WebUI.

## Overview

WebUI allows you to create custom elements that encapsulate design and behavior. Custom elements can:
- Accept generic content
- Handle custom styling
- Manage internal state
- Be composition-friendly

## Basic Custom Elements

Create a simple custom element:

```swift
struct Card: Element {
    var title: String
    var content: String
    
    var body: some HTML {
        Layout.stack {
            Text(title)
                .font(size: .lg, weight: .bold)
            Text(content)
                .color(.gray(._600))
        }
        .padding(.medium)
        .backgroundColor(.white)
        .rounded(.md)
        .shadow(.medium)
    }
}
```

Use your custom element:

```swift
Card(
    title: "Welcome",
    content: "This is a custom card component"
)
```

## Generic Content

Create elements that accept custom content:

```swift
struct Container<Content: HTML>: Element {
    var alignment: Alignment = .center
    var maxWidth: Length = .container(.large)
    var content: () -> Content
    
    var body: some HTML {
        Layout.flex {
            content()
        }
        .alignItems(alignment)
        .maxWidth(maxWidth)
        .marginX(.auto)
        .padding(.medium)
    }
}
```

Use with any content:

```swift
Container {
    Stack {
        Heading(.title) { "Title" }
        Text { "Content" }
    }
}
```

## Layout Components

Create reusable layout patterns:

```swift
struct SplitView<Left: HTML, Right: HTML>: Element {
    var left: () -> Left
    var right: () -> Right
    
    var body: some HTML {
        Layout.grid {
            Layout.flex {
                left()
            }
            .gridColumn(.span(4))
            
            Layout.flex {
                right()
            }
            .gridColumn(.span(8))
        }
        .columns(12)
        .gap(.medium)
        .responsive {
            sm {
                grid(columns: 1)
            }
        }
    }
}
```

## State Management

Create elements with internal state:

```swift
struct Counter: Element {
    @State var count: Int = 0
    
    var body: some HTML {
        Stack {
            Text { "Count: \(count)" }
                .font(size: .xl)
            
            Button("Increment") {
                count += 1
            }
            .padding()
            .backgroundColor(.blue(._500))
            .color(.white)
            .rounded(.md)
        }
        .spacing(of: 4)
    }
}
```

## Composable Elements

Create elements that work well together:

```swift
struct FormField: Element {
    var label: String
    var error: String?
    var required: Bool = false
    
    var body: some HTML {
        Stack {
            Label(label)
                .font(weight: .medium)
            
            Input(type: .text)
                .required(required)
                .border(of: 1, color: error != nil ? .red(._500) : .gray(._200))
            
            if let error = error {
                Text(error)
                    .color(.red(._500))
                    .font(size: .sm)
            }
        }
        .spacing(of: 2)
    }
}

struct FormSection: Element {
    var title: String
    var children: [FormField]
    
    var body: some HTML {
        Stack {
            Text(title)
                .font(size: .lg, weight: .semibold)
            
            Stack {
                children
            }
            .spacing(of: 4)
        }
        .padding()
        .border(of: 1, color: .gray(._200))
        .rounded(.lg)
    }
}
```

## Topics

### Basics

- ``Element``
- ``HTML``
- ``Children``

### State

- ``State``
- ``Binding``
- ``Observable``
