# Contributing to WebUI

First off, thank you for considering contributing to WebUI! It's people like you that make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are greatly appreciated.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
  - [Issues](#issues)
  - [Pull Requests](#pull-requests)
- [Development Process](#development-process)
- [Branch Structure](#branch-structure)
- [Development Workflow](#development-workflow)
- [Versioning](#versioning)
- [Release Process](#release-process)
- [Quick Fixes (Hotfixes)](#quick-fixes-hotfixes)
- [Testing](#testing)
- [Documentation Generation](#documentation-generation)
- [Core Directory Structure](#core-directory-structure)
- [Adding New Elements](#adding-new-elements)
- [Adding New Style Modifiers](#adding-new-style-modifiers)
- [Adding Extensions to Existing Elements](#adding-extensions-to-existing-elements)
- [Styleguides](#styleguides)
  - [Swift Style Guide](#swift-style-guide)
  - [Commit Messages](#commit-messages)
  - [Documentation](#documentation)

## Code of Conduct

This project and everyone participating in it is governed by the [WebUI Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

### Issues

- **Bug Reports**: Use the bug report template to provide detailed information about the issue.
- **Feature Requests**: Use the feature request template to describe your suggestion in detail.
- **Questions**: Use GitHub Discussions for questions about WebUI.

### Pull Requests

1. Fork the repository
2. Create your feature branch from the `development` branch, (`git checkout -b feature/amazing-feature`)
3. Commit your changes following conventional commit messages (`git commit -m 'feat: add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request to the `development` branch.

## Development Process

### Branch Structure

WebUI maintains three primary branches:

- `main` - Production-ready code. Releases from this branch have stable version numbers (e.g., `1.2.3`).
- `next` - Pre-release code for upcoming features. Releases from this branch have the `next-` prefix (e.g., `next-1.2.3`).
- `development` - Active development branch where new features are integrated before moving to `next`.

### Development Workflow

1. Create a feature branch from `development`.
2. Implement your changes with appropriate tests.
3. Create a PR to merge back into `development`.
4. Once approved and merged into `development`, changes will eventually flow to `next` and then `main`.

### Versioning

Version bumps are triggered automatically via commit messages. Use the following prefixes:

- `feat!:` - Major version increment for breaking changes (e.g., `1.0.0` → `2.0.0`).
- `feat:` - Minor version increment for new features (e.g., `1.0.0` → `1.1.0`).
- `fix:` or `fix!:` - Patch version increment for bug fixes (e.g., `1.0.0` → `1.0.1`).

### Release Process

The release workflow is fully automated:

1. When commits are pushed to `main` or `next` with the appropriate commit prefix, a new release is automatically created.
2. The version number is determined based on the commit prefix and previous version.
3. Release notes are automatically generated from the commit messages.
4. A new tag is created and the release is published on GitHub.

### Quick Fixes (Hotfixes)

For urgent fixes that need to be pushed to `main` right away:

1. Create a PR targeting the `main` branch.
2. Include `fix!:` in the PR title and merge message.
3. Once approved and merged, an action will automatically create PRs for `next` and `development` branches.
4. This ensures all branches remain in sync when quick changes are required in the main branch.

> [!WARNING]
> Ensure the auto-generated PRs are approved and merged promptly to maintain branch synchronization.

### Testing

Automated tests run on every pull request to `main` and `next` branches:

1. Tests are executed in a macOS environment with Swift 6.1.
2. The workflow includes caching of Swift Package Manager dependencies for faster builds.
3. All tests must pass before a PR can be merged.

To run tests locally:

```sh
swift test
```

### Documentation Generation

WebUI uses Swift DocC for documentation:

1. Documentation is automatically published to GitHub Pages (https://maclong9.github.io/web-ui/documentation/webui/).
2. Locally generate and preview documentation with:

```sh
swift package --disable-sandbox preview-documentation
```

### Adding New Elements

WebUI follows a compositional pattern for creating HTML elements. When adding a new element, adhere to these guidelines:

1. **File Location**: Create the new element file in the appropriate directory under `Sources/WebUI/Elements/`. For example:
   - Basic elements go in `Base/`
   - Form elements go in `Form/`
   - Layout elements go in `Layout/`
   - Create a new directory if needed

2. **Class Structure**:
   - Extend the base `Element` class
   - Create a `final` class (unless inheritance is required)
   - Implement element-specific properties and initialization logic
   - Document thoroughly with DocC comments

3. **Implementation Steps**:

   a. **Define Required Enums** (if applicable):
   ```swift
   /// Defines the types available for the element.
   ///
   /// Detailed documentation about the enum and its purpose.
   public enum ElementType: String {
       /// Documentation for this case.
       case primary

       /// Documentation for this case.
       case secondary
   }
   ```

   b. **Implement the Element Class**:
   ```swift
   /// Creates HTML element_name elements.
   ///
   /// Detailed documentation about what this element represents and its use cases.
   public final class ElementName: Element {
       // Properties specific to this element
       let type: ElementType?

       /// Creates a new HTML element_name.
       ///
       /// - Parameters:
       ///   - type: Type of the element, optional.
       ///   - id: Unique identifier, optional.
       ///   - classes: CSS class names, optional.
       ///   - role: ARIA role for accessibility, optional.
       ///   - label: ARIA label for accessibility, optional.
       ///   - data: Custom data attributes, optional.
       ///   - content: Closure providing element content, defaults to empty.
       ///
       /// - Example:
       ///   ```swift
       ///   ElementName(type: .primary, id: "example") {
       ///     "Content here"
       ///   }
       ///   ```
       public init(
           type: ElementType? = nil,
           id: String? = nil,
           classes: [String]? = nil,
           role: AriaRole? = nil,
           label: String? = nil,
           data: [String: String]? = nil,
           @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
       ) {
           self.type = type

           // Build custom attributes using Attr namespace
           let customAttributes = [
               Attribute.typed("type", type)
           ].compactMap { $0 }

           // Initialize the parent Element class
           super.init(
               tag: "tagname",
               id: id,
               classes: classes,
               role: role,
               label: label,
               data: data,
               customAttributes: customAttributes.isEmpty ? nil : customAttributes,
               content: content
           )
       }
   }
   ```

4. **Testing**: Add unit tests for the new element in the `Tests` directory.

5. **Documentation**: Include comprehensive DocC documentation with:
   - Class-level documentation explaining the element's purpose
   - Parameter documentation for all initializer parameters
   - Usage examples showing common implementations
   - Mention any accessibility considerations

## Adding New Style Modifiers

Style modifiers in WebUI follow an extension pattern on the `Element` class. Here's how to add a new style modifier:

1. **File Location**: Add the new style modifier to the appropriate file in `Sources/WebUI/Styles/`:
   - Appearance-related modifiers go in the `Appearance/` directory
   - Layout-related modifiers go in the `Base/` or `Positioning/` directories
   - Create a new file if the modifier doesn't fit an existing category

2. **Implementation Steps**:

   a. **Define Required Enums/Types** (if applicable):
   ```swift
   /// Defines style options for the modifier.
   ///
   /// Detailed documentation about the enum and its purpose.
   public enum StyleOption: String {
       /// Documentation for this case.
       case option1 = "option1-value"

       /// Documentation for this case.
       case option2 = "option2-value"
   }
   ```

   b. **Implement the Extension Method**:
   ```swift
   extension Element {
       /// Applies a style modifier to the element.
       ///
       /// Detailed documentation about what this modifier does and when to use it.
       ///
       /// - Parameters:
       ///   - option: The style option to apply.
       ///   - modifiers: Conditional modifiers (e.g., .hover, .md) to scope the style.
       /// - Returns: A new element with the updated style classes.
       ///
       /// - Example:
       ///   ```swift
       ///   Button() { "Click me" }
       ///     .styleModifier(option: .option1)
       ///     .styleModifier(option: .option2, on: .hover)
       ///   ```
       public func styleModifier(
           option: StyleOption,
           on modifiers: Modifier...
       ) -> Element {
           let baseClass = "style-\(option.rawValue)"
           let newClasses = combineClasses([baseClass], withModifiers: modifiers)

           return Element(
               tag: self.tag,
               id: self.id,
               classes: (self.classes ?? []) + newClasses,
               role: self.role,
               label: self.label,
               data: self.data,
               isSelfClosing: self.isSelfClosing,
               customAttributes: self.customAttributes,
               content: self.contentBuilder
           )
       }
   }
   ```

   c. **Update Responsive Support** (if applicable):
   ```swift
   extension Element {
       /// Responsive version for use within the .responsive block
       @discardableResult
       public func styleModifier(option: StyleOption) -> Element {
           return self.styleModifier(option: option, on: []).proxy()
       }
   }
   ```

3. **Testing**: Add unit tests for the new style modifier in the `Tests` directory.

4. **Documentation**: Include comprehensive DocC documentation with:
   - Method-level documentation explaining the modifier's purpose
   - Parameter documentation for all method parameters
   - Usage examples showing common implementations
   - Visual examples if the style has a significant impact on appearance
   - Examples of using the modifier within responsive blocks

### Adding Extensions to Existing Elements

You can extend existing elements with specialized methods to improve developer experience:

1. **Implementation Pattern**:
   ```swift
   extension ElementName {
       /// Description of what this extension method does.
       ///
       /// Detailed documentation about the extension.
       ///
       /// - Parameters:
       ///   - parameter: Description of the parameter.
       /// - Returns: Description of the return value.
       public func specializedMethod(parameter: ParameterType) -> Element {
           // Implementation that likely uses existing modifiers
           return self.someExistingModifier(option: .derivedFromParameter)
       }
   }
   ```

2. **Responsive Support**: If the method should work within responsive blocks, add a version without the `on modifiers` parameter:
   ```swift
   extension ElementName {
       /// Responsive version of the specialized method for use within responsive blocks.
       @discardableResult
       public func specializedMethod(parameter: ParameterType) -> Element {
           return self.specializedMethod(parameter: parameter, on: []).proxy()
       }
   }
   ```

3. **Documentation**: As with other additions, include comprehensive DocC documentation.

### Using Responsive Styling

WebUI provides a block-based responsive API for cleaner responsive designs.

### Basic Usage

The `.responsive` modifier allows applying multiple style changes across different breakpoints in a single block:

```swift
Text { "Responsive Content" }
  .font(size: .sm)
  .background(color: .neutral(._500))
  .responsive {
    $0.md {
      $0.font(size: .lg)
      $0.background(color: .neutral(._700))
      $0.padding(of: 4)
    }
    $0.lg {
      $0.font(size: .xl)
      $0.background(color: .neutral(._900))
    }
  }
```

### File Organization Principles

When organizing code in the WebUI library, follow these principles:

1. **Single Responsibility**: Each file should have a clear, focused purpose
2. **Logical Grouping**: Group related functionality together
3. **Progressive Disclosure**: Place most commonly used functionality first
4. **Manageable Size**: Keep files under on the smaller side where possible
5. **Clear Dependencies**: Make dependencies between components explicit and avoid circularity

When refactoring or adding new code, consider if you should:
- Add to an existing file (for small, closely related additions)
- Create a new file in an existing directory (for new components in an established category)
- Create a new directory (for entirely new subsystems or categories)

### Adding Support to Custom Style Methods

When creating custom style modifiers, ensure they work within responsive blocks by:

1. Adding a version without the `on modifiers` parameter
2. Using the `.proxy()` method to maintain the proper element chain
3. Adding examples showing how to use the style in responsive contexts

## Styleguides

### Swift Style Guide

WebUI follows the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/):

- Prioritize clarity over brevity
- Use proper naming conventions:
  - Types and protocols use UpperCamelCase
  - Everything else uses lowerCamelCase
- Document every declaration with comments

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Use prefixes to trigger version bumps:
  - `feat!:` - Breaking changes
  - `feat:` - New features
  - `fix:` - Bug fixes
  - `fix!:` - Urgent bug fixes
  - `docs:` - Documentation changes
  - `test:` - Adding or updating tests
  - `chore:` - Maintenance tasks

### Documentation

- Use Swift DocC for API documentation
- Include usage examples for complex functionality
- Document public APIs thoroughly with parameter descriptions, return values, and any exceptions
- When extracting code to new files, ensure documentation references are updated accordingly
- For complex components split across multiple files, include cross-references between related types

### Code Structure

- Aim for vertical cohesion - related code should be close together
- Place most important/commonly used methods first
- Group methods by functionality or feature
- When a file approaches 500 lines, consider refactoring into multiple files following the Core directory guidelines

Thank you for contributing to WebUI! Your effort helps make this library better for everyone.
