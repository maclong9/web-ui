import Foundation

/// Getting started example showing basic state management usage
///
/// This example demonstrates how to build a simple interactive web application
/// using WebUI's state management system. It includes:
/// - Global state for theme management
/// - Local state for page-specific interactions
/// - Reactive UI updates
/// - Event handling with state actions
public struct GettingStartedWebsite: Website {
    public var metadata: Metadata {
        Metadata(
            site: "My First WebUI App",
            title: "Getting Started with State Management",
            description: "Learn how to use state management in WebUI"
        )
    }
    
    // Global state shared across all pages
    public var globalState: StateManager? {
        StateManager(scope: .global) {
            BooleanState(name: "darkMode", initialValue: false)
            StringState(name: "userName", initialValue: "Guest")
        }
    }
    
    public var routes: [any Document] {
        [
            WelcomePage(),
            ProfilePage(),
            SettingsPage()
        ]
    }
}

// MARK: - Welcome Page

public struct WelcomePage: Document {
    public var metadata: Metadata {
        Metadata(
            site: "My First WebUI App",
            title: "Welcome",
            description: "Welcome to our app"
        )
    }
    
    public var path: String? { "index" }
    
    // Local state specific to this page
    public var localState: StateManager? {
        StateManager(scope: .document("index")) {
            NumberState(name: "visitCount", initialValue: 1)
            BooleanState(name: "showWelcome", initialValue: true)
        }
    }
    
    public var body: some Markup {
        Body {
            // Navigation header
            Header {
                Navigation {
                    Link(href: "/") { "Home" }
                    Link(href: "/profile") { "Profile" }
                    Link(href: "/settings") { "Settings" }
                    
                    // Theme toggle in navigation
                    Button("🌙")
                        .action(.toggle("darkMode"))
                        .title("Toggle Dark Mode")
                }
            }
            
            // Main content
            MainElement {
                Stack {
                    // Welcome message with dynamic content
                    Stack {
                        Heading(.title) {
                            Text("Welcome, ").text(from: "userName")
                        }
                        .show(when: "showWelcome")
                        
                        Text("Visit count: ").text(from: "visitCount")
                        
                        Button("Increment visits")
                            .action(.increment("visitCount"))
                        
                        Button("Hide Welcome")
                            .action(.toggle("showWelcome"))
                    }
                    
                    // Interactive features section
                    Stack {
                        Heading(.subtitle) { "Try These Features:" }
                        
                        Stack {
                            FeatureDemo(
                                title: "State Binding",
                                description: "Text updates automatically when state changes"
                            )
                            
                            FeatureDemo(
                                title: "Event Handling",
                                description: "Buttons trigger state actions"
                            )
                            
                            FeatureDemo(
                                title: "Conditional Rendering",
                                description: "Elements show/hide based on state"
                            )
                        }
                    }
                }
            }
            
            // Footer
            Footer {
                Text("Built with WebUI State Management")
            }
        }
        .class("dark-theme", when: "darkMode")
    }
}

// MARK: - Profile Page

public struct ProfilePage: Document {
    public var metadata: Metadata {
        Metadata(
            site: "My First WebUI App",
            title: "Profile",
            description: "User profile page"
        )
    }
    
    public var path: String? { "profile" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("profile")) {
            StringState(name: "bio", initialValue: "Tell us about yourself...")
            ArrayState(name: "interests", initialValue: ["Technology", "Design"])
            BooleanState(name: "isEditing", initialValue: false)
        }
    }
    
    public var body: some Markup {
        Body {
            Header {
                Navigation {
                    Link(href: "/") { "Home" }
                    Link(href: "/profile") { "Profile" }
                    Link(href: "/settings") { "Settings" }
                    
                    Button("🌙")
                        .action(.toggle("darkMode"))
                        .title("Toggle Dark Mode")
                }
            }
            
            MainElement {
                Stack {
                    Heading(.title) { "User Profile" }
                    
                    // Profile information
                    Stack {
                        // User name display/edit
                        Stack {
                            Text("Name: ").text(from: "userName")
                                .hide(when: "isEditing")
                            
                            Input(name: "userNameEdit", placeholder: "Enter your name")
                                .bind(to: "userName")
                                .show(when: "isEditing")
                        }
                        
                        // Bio section
                        Stack {
                            Text("Bio:")
                            
                            Text("").text(from: "bio")
                                .hide(when: "isEditing")
                            
                            TextArea(name: "bioEdit", placeholder: "Tell us about yourself...")
                                .bind(to: "bio")
                                .show(when: "isEditing")
                        }
                        
                        // Interests
                        Stack {
                            Text("Interests:")
                            
                            Text("Technology, Design") // Static for now
                        }
                        
                        // Edit toggle
                        Button("Edit Profile")
                            .action(.toggle("isEditing"))
                            .hide(when: "isEditing")
                        
                        Button("Save Changes")
                            .action(.toggle("isEditing"))
                            .show(when: "isEditing")
                    }
                }
            }
        }
        .class("dark-theme", when: "darkMode")
    }
}

// MARK: - Settings Page

public struct SettingsPage: Document {
    public var metadata: Metadata {
        Metadata(
            site: "My First WebUI App",
            title: "Settings",
            description: "Application settings"
        )
    }
    
    public var path: String? { "settings" }
    
    public var localState: StateManager? {
        StateManager(scope: .document("settings")) {
            BooleanState(name: "notifications", initialValue: true)
            StringState(name: "language", initialValue: "English")
            NumberState(name: "fontSize", initialValue: 16)
        }
    }
    
    public var body: some Markup {
        Body {
            Header {
                Navigation {
                    Link(href: "/") { "Home" }
                    Link(href: "/profile") { "Profile" }
                    Link(href: "/settings") { "Settings" }
                    
                    Button("🌙")
                        .action(.toggle("darkMode"))
                        .title("Toggle Dark Mode")
                }
            }
            
            MainElement {
                Stack {
                    Heading(.title) { "Settings" }
                    
                    // Settings form
                    Stack {
                        // Theme setting (using global state)
                        Stack {
                            Label("Dark Mode:")
                            
                            Stack {
                                Button("Light")
                                    .actions([
                                        .update("darkMode", false)
                                    ])
                                    .class("active", when: "!darkMode")
                                
                                Button("Dark")
                                    .actions([
                                        .update("darkMode", true)
                                    ])
                                    .class("active", when: "darkMode")
                            }
                            .flexDirection(.row)
                            }
                        
                        // Notifications setting
                        Stack {
                            Label("Enable Notifications:")
                            
                            Input(name: "notifications", type: .checkbox)
                                .bindChecked(to: "notifications")
                        }
                        
                        // Font size setting
                        Stack {
                            Label("Font Size:")
                            
                            Stack {
                                Input(name: "fontSize", type: .range)
                                    .bindNumber(to: "fontSize")
                                    .attribute("min", "12")
                                    .attribute("max", "24")
                                
                                Text("").text(from: "fontSize")
                            }
                        }
                        
                        // Language setting
                        Stack {
                            Label("Language:")
                            
                            Select(name: "language") {
                                Option(value: "English") { "English" }
                                Option(value: "Spanish") { "Español" }
                                Option(value: "French") { "Français" }
                            }
                            .bind(to: "language")
                        }
                        
                        // Save button
                        Button("Save Settings")
                            .action(.custom("alert('Settings saved!')"))
                            .width(.full)
                    }
                }
            }
        }
        .class("dark-theme", when: "darkMode")
    }
}

// MARK: - Reusable Components

public struct FeatureDemo: Element {
    let title: String
    let description: String
    
    public var body: some Markup {
        Stack {
            Heading(.h4) { title }
            
            Text(description)
        }
    }
}

// MARK: - Usage Instructions

/*
 To use this example:
 
 1. Create a new WebUI project
 2. Copy this file to your Sources directory
 3. Update your main.swift file:
 
 ```swift
 import WebUI
 
 let website = GettingStartedWebsite()
 
 do {
     try website.build()
     print("✅ Website built successfully!")
 } catch {
     print("❌ Build failed: \(error)")
 }
 ```
 
 4. Run your project:
 ```bash
 swift run
 ```
 
 5. Open `.output/index.html` in your browser
 
 Key concepts demonstrated:
 
 - **Global State**: The `darkMode` and `userName` states are shared across all pages
 - **Local State**: Each page has its own state for page-specific features
 - **Reactive Bindings**: UI automatically updates when state changes
 - **Event Handling**: Buttons trigger state actions that update the UI
 - **Conditional Rendering**: Elements show/hide based on state conditions
 - **Form Binding**: Input fields are bound to state variables
 - **State Actions**: Various types of state updates (toggle, increment, update, etc.)
 
 This example shows how WebUI's state management makes it easy to build
 interactive web applications with a SwiftUI-like declarative syntax.
 */