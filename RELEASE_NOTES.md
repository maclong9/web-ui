# 🚀 WebUI 2.0.0 Pre-release

> **⚠️ Pre-release Notice**: This is a pre-release version containing breaking changes. Please review the migration guide before upgrading.

## 🌟 What's New

### 🔄 Advanced State Management System
- **Complete property wrapper system** with `@State`, `@Binding`, `@SharedState`, and `@ObservableState`
- **Comprehensive StateManager** with scoped state (component, shared, global, session)
- **Automatic JavaScript generation** for client-side state synchronization
- **State-aware markup components** that automatically bind to state changes
- **Property wrapper configurations** for persistence, storage types, and debugging

### 🏗️ Architecture Refactoring
- **HTML → Markup terminology** across entire codebase for Swift API Design Guidelines compliance
- **Core protocol refactoring** (HTMLBuilder → MarkupBuilder, HTML → Markup)
- **Directory restructuring** for better maintainability and readability
- **Improved type safety** and API consistency

### 🌍 Comprehensive Localization System
- **LocalizationManager** with global state management
- **Text component localization** support with automatic key resolution
- **Multiple resolver strategies** including Foundation and custom resolvers
- **Locale-aware rendering** with fallback mechanisms

### 📝 Enhanced Markdown Module
- **Separate WebUIMarkdown library** with advanced rendering features
- **Syntax highlighting** for code blocks with comprehensive language support
- **Table of contents generation** with automatic heading extraction
- **Enhanced typography** with configurable styles and spacing
- **Front matter parsing** for content-driven websites

### ✨ View Transition API
- **Comprehensive transition system** with fade, slide, scale, and flip animations
- **Configurable timing functions** including custom cubic-bezier curves
- **Multiple transition origins** and directions
- **Built-in animation sequences** and property-based animations

### 🧩 Component Library Foundation
- **UI component system** with Button, Card, Alert, Modal, Toast, Input, Select, Container, Navigation, and Breadcrumb components
- **Theming system** with consistent styling across components
- **Foundation components** with extensible architecture

### 🚀 Development Server
- **Comprehensive development server** with live reloading
- **File watching** for automatic rebuilds
- **WebSocket integration** for real-time updates
- **HTTP server** with static file serving
- **Build management** with intelligent caching

### 🎨 Enhanced Icon System
- **Comprehensive Lucide Icons** support with 200+ icons
- **Type-safe icon access** with enum-based API
- **SystemImage integration** with SF Symbols support
- **Icon styling** with size, color, and class customization

### 📊 Data Management Patterns
- **Repository pattern** implementation
- **HTTP data sources** with async/await support
- **Data caching** with configurable strategies
- **Sync engine** for client-server synchronization

### ⚡ Performance and Testing
- **Comprehensive test suite** with 96%+ coverage
- **Performance benchmarks** and optimization
- **Output validation** for HTML, CSS, and JavaScript
- **Memory management** improvements

## 💥 Breaking Changes

⚠️ **Important**: This release contains breaking changes that require code migration.

### 🔄 Terminology Changes
- **HTML → Markup**: All `HTML` references changed to `Markup` (e.g., `HTMLBuilder` → `MarkupBuilder`)
- **Protocol updates**: Core protocols renamed for consistency

### 🏷️ State Management
- **Property wrapper scoping**: Existing state usage requires migration to new scoped system
- **StateManager integration**: Component state now managed through centralized system

### 🧩 Component Architecture
- **UI components**: New component system may require updates to existing custom components
- **Theming**: Components now use centralized theming system

### 🌍 Localization
- **Text rendering**: Enhanced localization support with automatic key resolution
- **Key resolution**: New resolver strategies provide more flexible localization options

## 🔧 Technical Requirements

### 📋 Platform Support
- **Swift**: 6.1 or later
- **macOS**: 15+
- **iOS**: 13+
- **tvOS**: 13+
- **watchOS**: 6+
- **visionOS**: 2+

### 📦 New Dependencies
- Swift Markdown for enhanced markdown processing
- Swift DocC Plugin for documentation generation

## 🗂️ Migration Guide

### 1. Update Import Statements
```swift
// Before
import WebUI

// After (no change needed)
import WebUI
```

### 2. Replace HTML with Markup
```swift
// Before
struct MyView: HTML {
    var body: some HTML {
        // content
    }
}

// After
struct MyView: Markup {
    var body: some Markup {
        // content
    }
}
```

### 3. Update State Management
```swift
// Before
@State var count = 0

// After
@State(.component) var count = 0
// or
@SharedState var count = 0
```

### 4. Text Components - Enhanced Options
```swift
// Both patterns are supported for different use cases:

// Direct text (useful for static content)
Text("Hello World")

// Localized text (useful for internationalized content)
Text(localized: "greeting.hello")
```

## 📚 Documentation

- **Updated README** with new features and examples
- **Enhanced code documentation** following Swift DocC standards
- **Example projects** demonstrating new capabilities
- **Migration guides** for breaking changes
- **API reference** with comprehensive documentation

## 🎯 What's Next

This pre-release represents a major evolution of WebUI from a simple HTML generation tool to a comprehensive web application framework. We're looking for feedback on:

- **State management** system usability
- **Component architecture** effectiveness
- **Migration experience** from 1.x
- **Performance** improvements
- **Documentation** clarity

## 🐛 Known Issues

- Migration tools for automated code updates are in development
- Some legacy examples may need updates for new API
- Documentation site rebuild in progress with new features

## 🤝 Contributing

We welcome feedback and contributions! Please:
1. Test the new features in your projects
2. Report any issues or bugs
3. Suggest improvements for the final 2.0.0 release
4. Share your migration experiences