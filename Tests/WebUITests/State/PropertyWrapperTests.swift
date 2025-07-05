import Testing
@testable import WebUI

@Suite("Property Wrapper Tests")
struct PropertyWrapperTests {
    
    @Test("ComponentState basic functionality")
    func componentStateBasics() {
        @ComponentState var isToggled = false
        @ComponentState var counter = 0
        @ComponentState var text = "initial"
        
        // Test initial values
        #expect(isToggled == false)
        #expect(counter == 0)
        #expect(text == "initial")
        
        // Test updates
        isToggled = true
        counter = 42
        text = "updated"
        
        #expect(isToggled == true)
        #expect(counter == 42)
        #expect(text == "updated")
    }
    
    @Test("SharedState basic functionality")
    func sharedStateBasics() {
        @SharedState("isLoggedIn", wrappedValue: false) var isLoggedIn
        @SharedState("username", wrappedValue: "guest") var username
        @SharedState("score", wrappedValue: 0) var score
        
        // Test initial values
        #expect(isLoggedIn == false)
        #expect(username == "guest")
        #expect(score == 0)
        
        // Test updates
        isLoggedIn = true
        username = "john_doe"
        score = 1337
        
        #expect(isLoggedIn == true)
        #expect(username == "john_doe")
        #expect(score == 1337)
    }
    
    @Test("GlobalState basic functionality")
    func globalStateBasics() {
        @GlobalState("theme", wrappedValue: "light") var theme
        @GlobalState("language", wrappedValue: "en") var language
        @GlobalState("debugMode", wrappedValue: false) var debugMode
        
        // Test initial values
        #expect(theme == "light")
        #expect(language == "en")
        #expect(debugMode == false)
        
        // Test updates
        theme = "dark"
        language = "es"
        debugMode = true
        
        #expect(theme == "dark")
        #expect(language == "es")
        #expect(debugMode == true)
    }
    
    @Test("SessionState basic functionality")
    func sessionStateBasics() {
        @SessionState("cartTotal", wrappedValue: 0.0) var cartTotal
        @SessionState("visitCount", wrappedValue: 1) var visitCount
        @SessionState("sessionId", wrappedValue: "abc123") var sessionId
        
        // Test initial values
        #expect(cartTotal == 0.0)
        #expect(visitCount == 1)
        #expect(sessionId == "abc123")
        
        // Test updates
        cartTotal = 99.99
        visitCount = 5
        sessionId = "xyz789"
        
        #expect(cartTotal == 99.99)
        #expect(visitCount == 5)
        #expect(sessionId == "xyz789")
    }
    
    @Test("StateBinding projected values")
    func stateBindingProjectedValues() {
        @ComponentState var count = 0
        @SharedState("shared_count", wrappedValue: 0) var sharedCount
        
        // Test projected values (bindings)
        let countBinding = $count
        let sharedCountBinding = $sharedCount
        
        #expect(countBinding.wrappedValue == 0)
        #expect(sharedCountBinding.wrappedValue == 0)
        
        // Test binding updates
        countBinding.update(10)
        sharedCountBinding.update(20)
        
        #expect(count == 10)
        #expect(sharedCount == 20)
        #expect(countBinding.wrappedValue == 10)
        #expect(sharedCountBinding.wrappedValue == 20)
    }
    
    @Test("Custom key ComponentState")
    func customKeyComponentState() {
        @ComponentState(key: "custom_toggle", wrappedValue: false) var customToggle
        @ComponentState(key: "custom_counter", wrappedValue: 100) var customCounter
        
        #expect(customToggle == false)
        #expect(customCounter == 100)
        
        customToggle = true
        customCounter = 200
        
        #expect(customToggle == true)
        #expect(customCounter == 200)
    }
    
    @Test("Complex Codable types")
    func complexCodableTypes() {
        struct User: Codable, Equatable {
            let id: Int
            let name: String
            let email: String
        }
        
        struct Settings: Codable, Equatable {
            let notifications: Bool
            let theme: String
            let language: String
        }
        
        @SharedState("currentUser", wrappedValue: nil) var currentUser: User?
        @GlobalState("appSettings", wrappedValue: Settings(
            notifications: true,
            theme: "system",
            language: "auto"
        )) var appSettings
        
        // Test initial values
        #expect(currentUser == nil)
        #expect(appSettings.notifications == true)
        #expect(appSettings.theme == "system")
        
        // Test complex updates
        let newUser = User(id: 1, name: "Alice", email: "alice@example.com")
        currentUser = newUser
        
        let newSettings = Settings(notifications: false, theme: "dark", language: "fr")
        appSettings = newSettings
        
        #expect(currentUser == newUser)
        #expect(appSettings == newSettings)
    }
    
    @Test("Array and collection types")
    func arrayAndCollectionTypes() {
        @ComponentState var items: [String] = []
        @SharedState("favorites", wrappedValue: []) var favorites: Set<Int>
        @SessionState("cart", wrappedValue: [:]) var cart: [String: Int]
        
        // Test initial empty collections
        #expect(items.isEmpty)
        #expect(favorites.isEmpty)
        #expect(cart.isEmpty)
        
        // Test collection updates
        items = ["apple", "banana", "cherry"]
        favorites = [1, 2, 3, 5, 8]
        cart = ["apple": 3, "banana": 2]
        
        #expect(items.count == 3)
        #expect(favorites.count == 5)
        #expect(cart.count == 2)
        #expect(items.contains("banana"))
        #expect(favorites.contains(5))
        #expect(cart["apple"] == 3)
    }
    
    @Test("State subscription with property wrappers")
    func stateSubscriptionWithPropertyWrappers() async {
        // Create state manager instances for testing
        let stateManager = StateManager()
        
        // Test state subscription directly through state manager
        await confirmation("State subscription works") { confirmation in
            stateManager.registerState(key: "test", initialValue: 0, scope: .component)
            
            let _ = stateManager.subscribe(to: "test", scope: .component) { (newValue: Int) in
                #expect(newValue == 42)
                confirmation()
            }
            
            stateManager.updateState(key: "test", value: 42, scope: .component)
        }
    }
    
    @Test("Multiple property wrappers same key different scopes")
    func multiplePropertyWrappersSameKey() {
        @ComponentState(key: "value", wrappedValue: "component") var componentValue
        @SharedState("value", wrappedValue: "shared") var sharedValue
        @GlobalState("value", wrappedValue: "global") var globalValue
        @SessionState("value", wrappedValue: "session") var sessionValue
        
        // Test that same keys in different scopes don't interfere
        #expect(componentValue == "component")
        #expect(sharedValue == "shared")
        #expect(globalValue == "global")
        #expect(sessionValue == "session")
        
        // Update all with different values
        componentValue = "comp_updated"
        sharedValue = "shared_updated"
        globalValue = "global_updated"
        sessionValue = "session_updated"
        
        // Verify they remain independent
        #expect(componentValue == "comp_updated")
        #expect(sharedValue == "shared_updated")
        #expect(globalValue == "global_updated")
        #expect(sessionValue == "session_updated")
    }
    
    @Test("StateBinding manual creation")
    func stateBindingManualCreation() {
        var backingValue = "initial"
        
        let binding = StateBinding<String>(
            get: { backingValue },
            set: { backingValue = $0 }
        )
        
        #expect(binding.wrappedValue == "initial")
        
        binding.wrappedValue = "updated"
        #expect(backingValue == "updated")
        #expect(binding.wrappedValue == "updated")
        
        binding.update("final")
        #expect(backingValue == "final")
        #expect(binding.wrappedValue == "final")
    }
    
    // Note: Thread safety test disabled for now due to Swift 6 concurrency restrictions
    // @Test("Property wrapper thread safety")
    // func propertyWrapperThreadSafety() async {
    //     // This test requires careful handling of concurrent state access
    //     // Will be implemented with proper actor isolation
    // }
    
    @Test("Optional types with property wrappers")
    func optionalTypesWithPropertyWrappers() {
        @ComponentState var optionalInt: Int? = nil
        @SharedState("optionalString", wrappedValue: nil) var optionalString: String?
        @GlobalState("optionalBool", wrappedValue: true) var optionalBool: Bool?
        
        // Test initial values
        #expect(optionalInt == nil)
        #expect(optionalString == nil)
        #expect(optionalBool == true)
        
        // Test setting values
        optionalInt = 42
        optionalString = "not nil"
        optionalBool = nil
        
        #expect(optionalInt == 42)
        #expect(optionalString == "not nil")
        #expect(optionalBool == nil)
        
        // Test setting back to nil
        optionalInt = nil
        optionalString = nil
        
        #expect(optionalInt == nil)
        #expect(optionalString == nil)
    }
}