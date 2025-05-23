# Form Elements

Learn how to create and handle forms in WebUI.

## Overview

WebUI provides a comprehensive set of form elements with built-in validation and styling support. Form elements are designed to be:

- Type-safe
- Accessible
- Easy to validate
- Styleable with the WebUI styling system

## Basic Form Usage

Create a basic form with various input types:

```swift
Form {
    Input(type: .text, name: "username")
        .placeholder("Enter username")
        .required(true)
        .minLength(3)
        .maxLength(20)
        .validationMessage("Username must be 3-20 characters")

    Input(type: .email, name: "email")
        .placeholder("Enter email")
        .required(true)

    TextArea(name: "message")
        .placeholder("Your message")
        .rows(5)

    Button("Submit")
        .type(.submit)
}
.onSubmit { data in
    // Handle form submission
}
```

## Form Layout

Group form elements with semantic layout components:

```swift
Form {
    Stack {
        Label("Personal Information")
            .font(size: .lg, weight: .semibold)

        Grid {
            Label("First Name")
            Input(type: .text, name: "firstName")
                .required(true)

            Label("Last Name")
            Input(type: .text, name: "lastName")
                .required(true)
        }
        .columns(2)
        .gap(.medium)
    }
    .spacing(of: 4)
}
```

## Input Types

WebUI supports all HTML5 input types:

```swift
Input(type: .text)          // Text input
Input(type: .email)         // Email input
Input(type: .password)      // Password input
Input(type: .number)        // Number input
Input(type: .tel)          // Telephone input
Input(type: .url)          // URL input
Input(type: .date)         // Date picker
Input(type: .time)         // Time picker
Input(type: .file)         // File upload
Input(type: .checkbox)     // Checkbox
Input(type: .radio)        // Radio button
```

## Form Validation

Add validation rules to your inputs:

```swift
Input(type: .text, name: "username")
    .required(true)
    .pattern("[A-Za-z0-9]+")
    .minLength(3)
    .maxLength(20)
    .validationMessage("Username must be 3-20 characters, alphanumeric only")

Input(type: .email, name: "email")
    .required(true)
    .validationMessage("Please enter a valid email address")

Input(type: .number, name: "age")
    .min(18)
    .max(100)
    .validationMessage("Age must be between 18 and 100")
```

## Custom Form Controls

Create reusable form components:

```swift
struct FormField: Element {
    var label: String
    var name: String
    var type: Input.`Type`
    var required: Bool = false
    var validationMessage: String? = nil

    var body: some HTML {
        Stack {
            Label(label)
                .font(weight: .medium)
            Input(type: type, name: name)
                .required(required)
                .validationMessage(validationMessage)
        }
        .spacing(of: 2)
    }
}
```

Use your custom components:

```swift
Form {
    FormField(
        label: "Username",
        name: "username",
        type: .text,
        required: true,
        validationMessage: "Username is required"
    )
    FormField(
        label: "Email",
        name: "email",
        type: .email,
        required: true
    )
}
```

## Styling Forms

Apply WebUI's styling system to form elements:

```swift
Input(type: .text, name: "search")
    .padding(of: 3)
    .rounded(.md)
    .border(of: 1, color: .gray(._200))
    .on(.focus) {
        border(of: 2, color: .blue(._500))
        outline(width: 0)
    }
```

## Topics

### Form Elements

- ``Form``
- ``Input``
- ``TextArea``
- ``Label``
- ``Button``

### Validation

- ``ValidationRule``
- ``ValidationMessage``
- ``FormValidation``

### Events

- ``FormEvent``
- ``SubmitHandler``
- ``InputHandler``
