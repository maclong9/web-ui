# Contributing to WebUI

Thank you for your interest in contributing to **WebUI**! This project welcomes all contributors—whether you're fixing bugs, adding new features, improving documentation, or helping others.

Below you'll find guidelines and best practices for contributing to WebUI, including how to add new elements and style modifiers.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Guidelines](#development-guidelines)
  - [Project Structure](#project-structure)
  - [Adding a New Element](#adding-a-new-element)
  - [Adding a New Style Modifier](#adding-a-new-style-modifier)
  - [Documentation](#documentation)
  - [Testing](#testing)
- [Commit & Branch Naming](#commit--branch-naming)
- [Issue Templates & GitHub Workflows](#issue-templates--github-workflows)
- [Community](#community)
- [License](#license)

---

## Code of Conduct

By participating, you are expected to uphold the [WebUI Code of Conduct](./CODE_OF_CONDUCT.md). Please be respectful and considerate in all interactions.

---

## Getting Started

1. **Fork** the repository and clone your fork locally.
2. Run `swift build` to ensure you can build the project.
3. Create a new branch for your work using the naming convention described below.

---

## How to Contribute

### Reporting Bugs

- Search [issues](https://github.com/maclong9/web-ui/issues) to see if your bug has already been reported.
- If not, open a new issue with a clear, descriptive title and detailed steps to reproduce.
- Please use the **Bug Report** issue template provided in [`.github/ISSUE_TEMPLATE/01_BUG_REPORT.md`](.github/ISSUE_TEMPLATE/01_BUG_REPORT.md) for consistency.

### Suggesting Enhancements

- Open an issue to discuss your idea before submitting a pull request.
- Clearly describe the enhancement and its use case.
- Please use the **Feature Request** issue template in [`.github/ISSUE_TEMPLATE/02_FEATURE_REQUEST.md`](.github/ISSUE_TEMPLATE/02_FEATURE_REQUEST.md) and refer to the [Adding New Elements](#adding-a-new-element) and [Adding New Style Modifiers](#adding-a-new-style-modifier) sections as appropriate.

### Pull Requests

- Fork the repo and create your branch from `main`.
- Follow the [commit & branch naming](#commit--branch-naming) conventions.
- Ensure your code is well-documented and tested.
- Submit a pull request with a clear description of your changes.
- For new elements or style modifiers, use the specialized PR templates in [`.github/PULL_REQUEST_TEMPLATE/`](.github/PULL_REQUEST_TEMPLATE/).

---

## Development Guidelines

### Project Structure

- **Core protocols**: `Sources/WebUI/Core/Protocols/`
- **Elements**: `Sources/WebUI/Elements/`
- **Styles**: `Sources/WebUI/Styles/`
- **Utilities**: `Sources/WebUI/Utilities/`

### Adding a New Element

1. **Create a new file** in the appropriate subdirectory under `Sources/WebUI/Elements/`.
2. **Define a struct** conforming to `Element` protocol.
3. **Implement the required initializer and `body` property**.
4. **Use the `@HTMLBuilder`** for content closures.
5. **Document your element** using Swift docc comments, including usage examples.
6. **Add tests/examples** if possible.

**Example:**
```swift
import Foundation

/// Creates a custom badge element.
///
/// ## Example
/// ```swift
/// Badge(text: "New")
/// ```
public struct Badge: Element {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some HTML {
        HTMLString(content: "<span class=\"badge\">\(text)</span>")
    }
}
```

### Adding a New Style Modifier

1. **Create a new file** in the appropriate subdirectory under `Sources/WebUI/Styles/`.
2. **Define a struct** conforming to `StyleOperation`.
3. **Implement the required methods**: parameter struct, `applyClasses(params:)`, and singleton instance.
4. **Add an extension to `HTML`** for ergonomic usage.
5. **Document your modifier** with docc comments and usage examples.
6. **Add tests/examples** if possible.

**Example:**
```swift
import Foundation

/// Style operation for example styling
///
/// Provides a unified implementation for example styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct ExampleStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for example styling
    public struct Parameters {
        /// The example value
        public let value: Int?

        /// The example flag
        public let flag: Bool?

        /// Creates parameters for example styling
        ///
        /// - Parameters:
        ///   - value: The example value
        ///   - flag: The example flag
        public init(
            value: Int? = nil,
            flag: Bool? = nil
        ) {
            self.value = value
            self.flag = flag
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: ExampleStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                value: params.get("value"),
                flag: params.get("flag")
            )
        }
    }

    /// Applies the example style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for example styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []
        if let value = params.value { classes.append("example-\(value)") }
        if let flag = params.flag, flag { classes.append("example-flag") }
        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = ExampleStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for HTML to provide example styling
extension HTML {
    /// Applies example styling to the element with optional modifiers.
    ///
    /// This method allows controlling all aspects of the example style.
    ///
    /// - Parameters:
    ///   - value: The example value.
    ///   - flag: The example flag.
    ///   - modifiers: Zero or more modifiers to scope the styles (e.g., responsive breakpoints or states).
    /// - Returns: A new element with updated example styling classes.
    ///
    /// ## Example
    /// ```swift
    /// Text { "Example" }
    ///   .example(value: 42, flag: true)
    /// ```
    public func example(
        value: Int? = nil,
        flag: Bool? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = ExampleStyleOperation.Parameters(
            value: value,
            flag: flag
        )
        return ExampleStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: modifiers
        )
    }
}

// Global function for Declarative DSL
/// Applies example styling in the responsive context.
///
/// - Parameters:
///   - value: The example value.
///   - flag: The example flag.
/// - Returns: A responsive modification for example styling.
public func example(
    value: Int? = nil,
    flag: Bool? = nil
) -> ResponsiveModification {
    let params = ExampleStyleOperation.Parameters(
        value: value,
        flag: flag
    )
    return ExampleStyleOperation.shared.asModification(params: params)
}
```

### Documentation

- **Document every public declaration** using Swift docc comments.
- Include a summary, parameter descriptions, return values, and usage examples.
- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).

### Testing

- Add or update tests to cover your changes.
- Ensure all tests pass before submitting a pull request.

---

## Commit & Branch Naming

- **Branch names**: `issue-<issue_number>-<short-description>`
  - Example: `issue-42-add-badge-element`
- **Commit messages**: Use clear, concise messages describing the change.
  - Example: `Add Badge element for status indicators`

---

## Community

- Join discussions in [GitHub Discussions](https://github.com/maclong9/web-ui/discussions).
- For questions, open an issue or start a discussion.

---

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).

---

Happy coding! 🚀
