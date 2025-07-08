import Foundation

// MARK: - Example 1: Simple Counter

/// Example demonstrating basic state management with a counter
public struct CounterExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Counter App")
    }
    
    public var path: String? { "counter" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("counter")) {
            NumberState(name: "counter", initialValue: 0)
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Counter App" }
                
                Stack {
                    Text("Count: ").text(from: "counter")
                        .fontSize(.xl)
                        .fontWeight(.bold)
                    
                    Stack {
                        Button("Increment")
                            .action(.increment("counter"))
                            .backgroundColor(.blue(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                        
                        Button("Decrement")
                            .action(.decrement("counter"))
                            .backgroundColor(.red(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                        
                        Button("Add 5")
                            .action(.increment("counter", 5))
                            .backgroundColor(.green(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                        
                        Button("Reset")
                            .action(.update("counter", 0))
                            .backgroundColor(.gray(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                    }
                    .flexDirection(.row)
                    .gap(.medium)
                }
                .gap(.medium)
            }
            .padding(.large)
            .maxWidth(.xl)
            .margin(.horizontal, .auto)
        }
    }
}

// MARK: - Example 2: Todo App

/// Example demonstrating array state management with a todo list
public struct TodoExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Todo App")
    }
    
    public var path: String? { "todo" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("todo")) {
            ArrayState(name: "todos", initialValue: ["Learn WebUI", "Build an app"])
            StringState(name: "newTodo", initialValue: "")
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Todo App" }
                
                // Add new todo form
                Stack {
                    Input(name: "newTodo", placeholder: "Enter a new todo...")
                        .bind(to: "newTodo")
                        .padding(.medium)
                        .border(.gray(.300))
                        .rounded(.md)
                    
                    Button("Add Todo")
                        .actions([
                            .addToArray("todos", "newTodo"),
                            .update("newTodo", "")
                        ])
                        .backgroundColor(.blue(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                        .disabled(when: "newTodo.trim() === ''")
                }
                .flexDirection(.row)
                .gap(.medium)
                
                // Todo list
                Stack {
                    // Dynamic todo items would require custom JavaScript
                    // This is a simplified representation
                    Text("Todo items will be rendered here dynamically")
                        .padding(.medium)
                        .backgroundColor(.gray(.100))
                        .rounded(.md)
                }
                .gap(.small)
            }
            .padding(.large)
            .maxWidth(.xl)
            .margin(.horizontal, .auto)
            .gap(.large)
        }
    }
}

// MARK: - Example 3: Theme Switcher (Global State)

/// Example demonstrating global state management for theme switching
public struct ThemeExample: Website {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Theme Switcher")
    }
    
    public var globalState: StateManager? {
        StateManager(scope: .global) {
            BooleanState(name: "darkMode", initialValue: false)
            StringState(name: "currentTheme", initialValue: "light")
        }
    }
    
    public var routes: [any Document] {
        [ThemeHomeDocument(), ThemeAboutDocument()]
    }
}

public struct ThemeHomeDocument: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Home - Theme Switcher")
    }
    
    public var path: String? { "index" }
    
    public var body: some Markup {
        Body {
            Stack {
                // Theme switcher
                Stack {
                    Text("Current Theme: ").text(from: "currentTheme")
                    
                    Button("Toggle Dark Mode")
                        .actions([
                            .toggle("darkMode"),
                            .expression("currentTheme", "darkMode ? 'dark' : 'light'")
                        ])
                        .backgroundColor(.blue(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                }
                .flexDirection(.row)
                .gap(.medium)
                .padding(.medium)
                .backgroundColor(.gray(.100))
                .rounded(.md)
                
                // Content that responds to theme
                Stack {
                    Heading(.title) { "Welcome to Theme Switcher" }
                    Text("This content will adapt to the selected theme.")
                }
                .padding(.large)
                .class("theme-content", when: "darkMode")
            }
            .padding(.large)
            .class("dark-theme", when: "darkMode")
        }
    }
}

public struct ThemeAboutDocument: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "About - Theme Switcher")
    }
    
    public var path: String? { "about" }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "About Theme Switcher" }
                Text("This page also respects the global theme state.")
                    .padding(.medium)
                    .backgroundColor(.gray(.100))
                    .rounded(.md)
                    .class("dark-theme", when: "darkMode")
            }
            .padding(.large)
            .class("dark-theme", when: "darkMode")
        }
    }
}

// MARK: - Example 4: Shopping Cart

/// Example demonstrating complex object state management
public struct ShoppingCartExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Shopping Cart")
    }
    
    public var path: String? { "cart" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("cart")) {
            ArrayState(name: "cartItems", initialValue: [])
            ObjectState(name: "cart", initialValue: [
                "total": 0.0,
                "itemCount": 0
            ])
            BooleanState(name: "cartOpen", initialValue: false)
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Shopping Cart" }
                
                // Cart summary
                Stack {
                    Text("Items: ").text(from: "cart.itemCount")
                    Text("Total: $").text(from: "cart.total")
                    
                    Button("Toggle Cart")
                        .action(.toggle("cartOpen"))
                        .backgroundColor(.blue(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                }
                .flexDirection(.row)
                .gap(.medium)
                .padding(.medium)
                .backgroundColor(.gray(.100))
                .rounded(.md)
                
                // Sample products
                Stack {
                    ProductCard(name: "Product 1", price: 19.99)
                    ProductCard(name: "Product 2", price: 29.99)
                    ProductCard(name: "Product 3", price: 39.99)
                }
                .gap(.medium)
                
                // Cart details (shown when open)
                Stack {
                    Text("Cart Details")
                        .fontWeight(.bold)
                    Text("Cart items will be listed here")
                        .padding(.medium)
                        .backgroundColor(.gray(.100))
                        .rounded(.md)
                }
                .show(when: "cartOpen")
                .gap(.medium)
            }
            .padding(.large)
            .maxWidth(.xl)
            .margin(.horizontal, .auto)
            .gap(.large)
        }
    }
}

public struct ProductCard: Element {
    let name: String
    let price: Double
    
    public var body: some Markup {
        Stack {
            Text(name)
                .fontWeight(.bold)
            Text("$\(price, specifier: "%.2f")")
                .textColor(.gray(.600))
            
            Button("Add to Cart")
                .action(.custom("""
                    const item = { name: '\(name)', price: \(price) };
                    addCartItems(item);
                    updateCart('itemCount', cart.itemCount + 1);
                    updateCart('total', cart.total + \(price));
                """))
                .backgroundColor(.green(.600))
                .textColor(.white)
                .padding(.small)
                .rounded(.md)
        }
        .padding(.medium)
        .border(.gray(.300))
        .rounded(.md)
        .gap(.small)
    }
}

// MARK: - Example 5: Form Validation

/// Example demonstrating form state management with validation
public struct FormValidationExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Form Validation")
    }
    
    public var path: String? { "form" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("form")) {
            StringState(name: "email", initialValue: "")
            StringState(name: "password", initialValue: "")
            StringState(name: "confirmPassword", initialValue: "")
            BooleanState(name: "isValid", initialValue: false)
            ArrayState(name: "errors", initialValue: [])
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Form Validation" }
                
                Form {
                    Stack {
                        Label("Email:")
                        Input(name: "email", type: .email, placeholder: "Enter your email")
                            .bind(to: "email")
                            .padding(.medium)
                            .border(.gray(.300))
                            .rounded(.md)
                            .on("input", actions: [
                                .custom("validateEmail()")
                            ])
                        
                        Label("Password:")
                        Input(name: "password", type: .password, placeholder: "Enter your password")
                            .bind(to: "password")
                            .padding(.medium)
                            .border(.gray(.300))
                            .rounded(.md)
                            .on("input", actions: [
                                .custom("validatePassword()")
                            ])
                        
                        Label("Confirm Password:")
                        Input(name: "confirmPassword", type: .password, placeholder: "Confirm your password")
                            .bind(to: "confirmPassword")
                            .padding(.medium)
                            .border(.gray(.300))
                            .rounded(.md)
                            .on("input", actions: [
                                .custom("validateConfirmPassword()")
                            ])
                        
                        Button("Submit", type: .submit)
                            .backgroundColor(.blue(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                            .disabled(when: "!isValid")
                    }
                    .gap(.medium)
                }
                
                // Error messages
                Stack {
                    Text("Errors will be displayed here")
                        .textColor(.red(.600))
                        .padding(.medium)
                        .backgroundColor(.red(.100))
                        .rounded(.md)
                }
                .show(when: "errors.length > 0")
            }
            .padding(.large)
            .maxWidth(.md)
            .margin(.horizontal, .auto)
            .gap(.large)
        }
    }
}

// MARK: - Example 6: Modal Dialog

/// Example demonstrating modal state management
public struct ModalExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Modal Dialog")
    }
    
    public var path: String? { "modal" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("modal")) {
            BooleanState(name: "modalOpen", initialValue: false)
            StringState(name: "modalTitle", initialValue: "")
            StringState(name: "modalContent", initialValue: "")
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Modal Dialog Example" }
                
                Stack {
                    Button("Open Info Modal")
                        .actions([
                            .update("modalTitle", "Information"),
                            .update("modalContent", "This is an informational modal."),
                            .toggle("modalOpen")
                        ])
                        .backgroundColor(.blue(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                    
                    Button("Open Warning Modal")
                        .actions([
                            .update("modalTitle", "Warning"),
                            .update("modalContent", "This is a warning modal."),
                            .toggle("modalOpen")
                        ])
                        .backgroundColor(.yellow(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                }
                .flexDirection(.row)
                .gap(.medium)
                
                // Modal overlay
                Stack {
                    // Modal content
                    Stack {
                        Stack {
                            Text("").text(from: "modalTitle")
                                .fontWeight(.bold)
                                .fontSize(.lg)
                            
                            Button("×")
                                .action(.toggle("modalOpen"))
                                .backgroundColor(.transparent)
                                .textColor(.gray(.600))
                                .fontSize(.xl)
                        }
                        .flexDirection(.row)
                        .justifyContent(.spaceBetween)
                        .alignItems(.center)
                        
                        Text("").text(from: "modalContent")
                            .padding(.medium)
                        
                        Button("Close")
                            .action(.toggle("modalOpen"))
                            .backgroundColor(.gray(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                    }
                    .backgroundColor(.white)
                    .padding(.large)
                    .rounded(.lg)
                    .border(.gray(.300))
                    .maxWidth(.md)
                    .gap(.medium)
                }
                .show(when: "modalOpen")
                .position(.fixed)
                .top(.zero)
                .left(.zero)
                .width(.full)
                .height(.full)
                .backgroundColor(.black.opacity(0.5))
                .display(.flex)
                .justifyContent(.center)
                .alignItems(.center)
            }
            .padding(.large)
            .gap(.large)
        }
    }
}

// MARK: - Example 7: Multi-step Wizard

/// Example demonstrating multi-step form state management
public struct WizardExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Multi-step Wizard")
    }
    
    public var path: String? { "wizard" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("wizard")) {
            NumberState(name: "currentStep", initialValue: 1)
            NumberState(name: "totalSteps", initialValue: 3)
            ObjectState(name: "formData", initialValue: [
                "name": "",
                "email": "",
                "preferences": ""
            ])
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Multi-step Wizard" }
                
                // Progress indicator
                Stack {
                    Text("Step ").text(from: "currentStep")
                    Text(" of ").text(from: "totalSteps")
                }
                .fontSize(.lg)
                .fontWeight(.bold)
                .textAlign(.center)
                
                // Step 1: Basic Info
                Stack {
                    Heading(.subtitle) { "Basic Information" }
                    
                    Input(name: "name", placeholder: "Enter your name")
                        .padding(.medium)
                        .border(.gray(.300))
                        .rounded(.md)
                        .on("input", actions: [
                            .updateObject("formData", "name", "event.target.value")
                        ])
                    
                    Button("Next")
                        .action(.increment("currentStep"))
                        .backgroundColor(.blue(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                }
                .show(when: "currentStep === 1")
                .gap(.medium)
                
                // Step 2: Contact Info
                Stack {
                    Heading(.subtitle) { "Contact Information" }
                    
                    Input(name: "email", type: .email, placeholder: "Enter your email")
                        .padding(.medium)
                        .border(.gray(.300))
                        .rounded(.md)
                        .on("input", actions: [
                            .updateObject("formData", "email", "event.target.value")
                        ])
                    
                    Stack {
                        Button("Back")
                            .action(.decrement("currentStep"))
                            .backgroundColor(.gray(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                        
                        Button("Next")
                            .action(.increment("currentStep"))
                            .backgroundColor(.blue(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                    }
                    .flexDirection(.row)
                    .gap(.medium)
                }
                .show(when: "currentStep === 2")
                .gap(.medium)
                
                // Step 3: Preferences
                Stack {
                    Heading(.subtitle) { "Preferences" }
                    
                    TextArea(name: "preferences", placeholder: "Enter your preferences")
                        .padding(.medium)
                        .border(.gray(.300))
                        .rounded(.md)
                        .on("input", actions: [
                            .updateObject("formData", "preferences", "event.target.value")
                        ])
                    
                    Stack {
                        Button("Back")
                            .action(.decrement("currentStep"))
                            .backgroundColor(.gray(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                        
                        Button("Submit")
                            .action(.custom("submitForm()"))
                            .backgroundColor(.green(.600))
                            .textColor(.white)
                            .padding(.medium)
                            .rounded(.md)
                    }
                    .flexDirection(.row)
                    .gap(.medium)
                }
                .show(when: "currentStep === 3")
                .gap(.medium)
            }
            .padding(.large)
            .maxWidth(.md)
            .margin(.horizontal, .auto)
            .gap(.large)
        }
    }
}

// MARK: - Example 8: Search Functionality

/// Example demonstrating search state management
public struct SearchExample: Document {
    public var metadata: Metadata {
        Metadata(site: "WebUI Examples", title: "Search Functionality")
    }
    
    public var path: String? { "search" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("search")) {
            StringState(name: "searchQuery", initialValue: "")
            ArrayState(name: "searchResults", initialValue: [])
            BooleanState(name: "isSearching", initialValue: false)
            ArrayState(name: "allItems", initialValue: [
                "Apple", "Banana", "Cherry", "Date", "Elderberry",
                "Fig", "Grape", "Honeydew", "Kiwi", "Lemon"
            ])
        }
    }
    
    public var body: some Markup {
        Body {
            Stack {
                Heading(.title) { "Search Functionality" }
                
                // Search input
                Stack {
                    Input(name: "search", placeholder: "Search items...")
                        .bind(to: "searchQuery")
                        .padding(.medium)
                        .border(.gray(.300))
                        .rounded(.md)
                        .on("input", actions: [
                            .custom("debounceSearch()")
                        ])
                    
                    Button("Clear")
                        .actions([
                            .update("searchQuery", ""),
                            .update("searchResults", [])
                        ])
                        .backgroundColor(.gray(.600))
                        .textColor(.white)
                        .padding(.medium)
                        .rounded(.md)
                }
                .flexDirection(.row)
                .gap(.medium)
                
                // Search status
                Text("Searching...")
                    .show(when: "isSearching")
                    .textColor(.gray(.600))
                
                // Search results
                Stack {
                    Text("Search Results:")
                        .fontWeight(.bold)
                        .show(when: "searchResults.length > 0")
                    
                    // Results would be dynamically rendered
                    Text("Results will appear here")
                        .padding(.medium)
                        .backgroundColor(.gray(.100))
                        .rounded(.md)
                        .show(when: "searchQuery.length > 0")
                }
                .gap(.medium)
                
                // All items
                Stack {
                    Text("All Items:")
                        .fontWeight(.bold)
                        .show(when: "searchQuery.length === 0")
                    
                    Text("Apple, Banana, Cherry, Date, Elderberry, Fig, Grape, Honeydew, Kiwi, Lemon")
                        .padding(.medium)
                        .backgroundColor(.gray(.100))
                        .rounded(.md)
                        .show(when: "searchQuery.length === 0")
                }
                .gap(.medium)
            }
            .padding(.large)
            .maxWidth(.xl)
            .margin(.horizontal, .auto)
            .gap(.large)
        }
    }
}