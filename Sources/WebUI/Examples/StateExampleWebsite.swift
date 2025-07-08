import Foundation

/// Complete example website showcasing all state management features
public struct StateExampleWebsite: Website {
    public var metadata: Metadata {
        Metadata(
            site: "WebUI State Examples",
            title: "State Management Examples",
            description: "Comprehensive examples of state management in WebUI"
        )
    }
    
    public var globalState: StateManager? {
        StateManager(scope: .global) {
            BooleanState(name: "darkMode", initialValue: false)
            StringState(name: "currentTheme", initialValue: "light")
            ObjectState(name: "navigation", initialValue: [
                "currentPage": "home",
                "breadcrumbs": []
            ])
        }
    }
    
    public var routes: [any Document] {
        [
            StateExampleHomeDocument(),
            CounterExample(),
            TodoExample(),
            ShoppingCartExample(),
            FormValidationExample(),
            ModalExample(),
            WizardExample(),
            SearchExample()
        ]
    }
    
    public var stylesheets: [String]? {
        ["/styles/examples.css"]
    }
}

/// Home page for the state examples website
public struct StateExampleHomeDocument: Document {
    public var metadata: Metadata {
        Metadata(
            site: "WebUI State Examples",
            title: "Home - State Management Examples",
            description: "Welcome to WebUI state management examples"
        )
    }
    
    public var path: String? { "index" }
    
    public var body: some Markup {
        Body {
            // Global theme toggle
            Stack {
                Stack {
                    Text("Theme: ").text(from: "currentTheme")
                        .fontWeight(.bold)
                    
                    Button("Toggle Dark Mode")
                        .actions([
                            .toggle("darkMode"),
                            .expression("currentTheme", "darkMode ? 'dark' : 'light'")
                        ])
                }
                
                // Main content
                Stack {
                    Heading(.title) { "WebUI State Management Examples" }
                    
                    Text("Welcome to the comprehensive WebUI state management examples. Each example demonstrates different aspects of state management in WebUI applications.")
                        .fontSize(.lg)
                    
                    // Example cards
                    Stack {
                        ExampleCard(
                            title: "Counter",
                            description: "Basic state management with number state",
                            link: "/counter",
                            tags: ["Basic", "Numbers", "Actions"]
                        )
                        
                        ExampleCard(
                            title: "Todo App",
                            description: "Array state management with dynamic lists",
                            link: "/todo",
                            tags: ["Arrays", "Forms", "Dynamic"]
                        )
                        
                        ExampleCard(
                            title: "Shopping Cart",
                            description: "Complex object state with calculations",
                            link: "/cart",
                            tags: ["Objects", "Complex", "E-commerce"]
                        )
                    }
                    
                    Stack {
                        ExampleCard(
                            title: "Form Validation",
                            description: "Real-time validation with error handling",
                            link: "/form",
                            tags: ["Validation", "Forms", "Errors"]
                        )
                        
                        ExampleCard(
                            title: "Modal Dialog",
                            description: "State-controlled modal interactions",
                            link: "/modal",
                            tags: ["UI", "Interactions", "Dialogs"]
                        )
                        
                        ExampleCard(
                            title: "Multi-step Wizard",
                            description: "Complex form flow with navigation",
                            link: "/wizard",
                            tags: ["Multi-step", "Navigation", "Forms"]
                        )
                    }
                    
                    Stack {
                        ExampleCard(
                            title: "Search Functionality",
                            description: "Debounced search with filtering",
                            link: "/search",
                            tags: ["Search", "Filtering", "Performance"]
                        )
                    }
                    .display(.grid)
                    .gridTemplateColumns(.repeat(3, .fr(1)))
                    .gap(.large)
                    
                    // Feature highlights
                    Stack {
                        Heading(.subtitle) { "Key Features Demonstrated" }
                        
                        Stack {
                            FeatureHighlight(
                                title: "Global State",
                                description: "Shared state across all pages and components"
                            )
                            
                            FeatureHighlight(
                                title: "Local State",
                                description: "Page-specific state management"
                            )
                            
                            FeatureHighlight(
                                title: "Reactive Bindings",
                                description: "Automatic UI updates when state changes"
                            )
                        }
                        
                        Stack {
                            FeatureHighlight(
                                title: "Type Safety",
                                description: "Strongly typed state properties"
                            )
                            
                            FeatureHighlight(
                                title: "Performance",
                                description: "Efficient JavaScript generation"
                            )
                            
                            FeatureHighlight(
                                title: "Developer Experience",
                                description: "SwiftUI-like declarative syntax"
                            )
                        }
                    }
                }
            }
            .class("dark-theme", when: "darkMode")
        }
    }
}

/// Reusable example card component
public struct ExampleCard: Element {
    let title: String
    let description: String
    let link: String
    let tags: [String]
    
    public var body: some Markup {
        Link(href: link) {
            Stack {
                Heading(.h3) { title }
                
                Text(description)
                
                // Tags
                Stack {
                    ForEach(tags) { tag in
                        Text(tag)
                    }
                }
            }
        }
    }
}

/// Feature highlight component
public struct FeatureHighlight: Element {
    let title: String
    let description: String
    
    public var body: some Markup {
        Stack {
            Heading(.h4) { title }
            
            Text(description)
        }
    }
}

/// Example of using ForEach for dynamic content
public struct ForEach<T>: Element {
    let items: [T]
    let content: (T) -> any Markup
    
    public init(_ items: [T], @MarkupBuilder content: @escaping (T) -> any Markup) {
        self.items = items
        self.content = content
    }
    
    public var body: some Markup {
        Group {
            items.map { item in
                AnyMarkup(content(item))
            }
        }
    }
}

/// CSS styles for the examples
public let exampleStyles = """
/* Example styles for state management examples */
.dark-theme {
    background-color: #1a1a1a;
    color: #ffffff;
}

.dark-theme .bg-gray-100 {
    background-color: #2d2d2d;
}

.dark-theme .bg-white {
    background-color: #2d2d2d;
    border-color: #404040;
}

.dark-theme .text-gray-600 {
    color: #a0a0a0;
}

.dark-theme .border-gray-200 {
    border-color: #404040;
}

.dark-theme .border-gray-300 {
    border-color: #555555;
}

.theme-content {
    transition: all 0.3s ease;
}

.dark-theme .theme-content {
    background-color: #2d2d2d;
    color: #ffffff;
}

/* Form styles */
.form-field {
    margin-bottom: 1rem;
}

.form-field label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
}

.form-field input,
.form-field textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 0.375rem;
    font-size: 1rem;
}

.form-field input:focus,
.form-field textarea:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Error states */
.form-field.error input,
.form-field.error textarea {
    border-color: #ef4444;
}

.error-message {
    color: #ef4444;
    font-size: 0.875rem;
    margin-top: 0.25rem;
}

/* Button styles */
.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.75rem 1.5rem;
    font-size: 1rem;
    font-weight: 500;
    border: none;
    border-radius: 0.375rem;
    cursor: pointer;
    transition: all 0.2s ease;
    text-decoration: none;
}

.btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.btn-primary {
    background-color: #3b82f6;
    color: white;
}

.btn-primary:hover:not(:disabled) {
    background-color: #2563eb;
}

.btn-secondary {
    background-color: #6b7280;
    color: white;
}

.btn-secondary:hover:not(:disabled) {
    background-color: #4b5563;
}

.btn-danger {
    background-color: #ef4444;
    color: white;
}

.btn-danger:hover:not(:disabled) {
    background-color: #dc2626;
}

.btn-success {
    background-color: #10b981;
    color: white;
}

.btn-success:hover:not(:disabled) {
    background-color: #059669;
}

/* Modal styles */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.modal-content {
    background: white;
    border-radius: 0.5rem;
    padding: 2rem;
    max-width: 500px;
    width: 90%;
    max-height: 90vh;
    overflow-y: auto;
}

.dark-theme .modal-content {
    background-color: #2d2d2d;
    color: #ffffff;
}

/* Animation utilities */
.fade-in {
    animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.slide-up {
    animation: slideUp 0.3s ease-in-out;
}

@keyframes slideUp {
    from {
        transform: translateY(100%);
    }
    to {
        transform: translateY(0);
    }
}

/* Responsive design */
@media (max-width: 768px) {
    .grid-cols-3 {
        grid-template-columns: 1fr;
    }
    
    .flex-row {
        flex-direction: column;
    }
    
    .container {
        padding: 1rem;
    }
}
"""