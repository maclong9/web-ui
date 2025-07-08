import Foundation
import Testing

@testable import WebUI

@Suite("State Generation Output Tests")
struct StateGenerationOutputTests {
    
    // MARK: - JavaScript Output Validation Tests
    
    @Test("Generated JavaScript has valid syntax structure")
    func generatedJavaScriptValidSyntax() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        @State var counter = 42
        @State var isEnabled = true
        @State var username = "testuser"
        
        let states: [String: any StateProtocolErased] = [
            "counter": AnyStateProtocol($counter),
            "isEnabled": AnyStateProtocol($isEnabled), 
            "username": AnyStateProtocol($username)
        ]
        
        let javascript = generator.generateCompleteScript(for: states, configuration: config)
        
        // Test basic JavaScript structure
        #expect(javascript.contains("window.WebUIStateManager = {"))
        #expect(javascript.contains("};"))
        
        // Test state initialization order
        let counterIndex = javascript.range(of: "WebUIStateManager.createState('counter', 42);")
        let enabledIndex = javascript.range(of: "WebUIStateManager.createState('isEnabled', true);")
        let usernameIndex = javascript.range(of: "WebUIStateManager.createState('username', \"testuser\");")
        
        #expect(counterIndex != nil)
        #expect(enabledIndex != nil)
        #expect(usernameIndex != nil)
        
        // Test DOM content loaded listener
        #expect(javascript.contains("document.addEventListener('DOMContentLoaded', function() {"))
        #expect(javascript.contains("});"))
    }
    
    @Test("State values are properly escaped in JavaScript")
    func stateValuesProperlyEscaped() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        @State var specialChars = "quotes\"and'backslashes\\and\nnewlines"
        @State var htmlContent = "<script>alert('xss')</script>"
        @State var jsonData = "{\"key\": \"value\", \"number\": 123}"
        
        let states: [String: any StateProtocolErased] = [
            "specialChars": AnyStateProtocol($specialChars),
            "htmlContent": AnyStateProtocol($htmlContent),
            "jsonData": AnyStateProtocol($jsonData)
        ]
        
        let javascript = generator.generateCompleteScript(for: states, configuration: config)
        
        // Test proper escaping
        #expect(javascript.contains("quotes\\\"and'backslashes"))
        #expect(javascript.contains("<script>alert('xss')</script>"))
        #expect(!javascript.contains("\"quotes\"")) // Should be escaped
        
        // Test that the JavaScript is properly structured (should have newlines for formatting)
        #expect(javascript.contains("\n")) // Properly formatted JavaScript should have newlines
    }
    
    @Test("Complex nested data structures serialize correctly")
    func complexNestedDataStructuresSerialize() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        struct UserProfile: Codable {
            let id: Int
            let name: String
            let preferences: UserPreferences
            let tags: [String]
        }
        
        struct UserPreferences: Codable {
            let theme: String
            let notifications: Bool
            let privacy: PrivacySettings
        }
        
        struct PrivacySettings: Codable {
            let publicProfile: Bool
            let showEmail: Bool
        }
        
        @State var userProfile = UserProfile(
            id: 12345,
            name: "John Doe",
            preferences: UserPreferences(
                theme: "dark",
                notifications: true,
                privacy: PrivacySettings(publicProfile: false, showEmail: true)
            ),
            tags: ["developer", "swift", "ios"]
        )
        
        let states: [String: any StateProtocolErased] = [
            "userProfile": AnyStateProtocol($userProfile)
        ]
        
        let javascript = generator.generateCompleteScript(for: states, configuration: config)
        
        // Test nested structure serialization
        #expect(javascript.contains("\"id\":12345"))
        #expect(javascript.contains("\"name\":\"John Doe\""))
        #expect(javascript.contains("\"theme\":\"dark\""))
        #expect(javascript.contains("\"notifications\":true"))
        #expect(javascript.contains("\"publicProfile\":false"))
        #expect(javascript.contains("[\"developer\",\"swift\",\"ios\"]"))
        
        // Test that the JSON is valid (no trailing commas, proper quotes)
        #expect(!javascript.contains(",}")) // No trailing commas
        #expect(!javascript.contains(",]")) // No trailing commas in arrays
    }
    
    @Test("Generated JavaScript includes proper error boundaries")
    func generatedJavaScriptErrorBoundaries() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        @State var testState = "test"
        let states: [String: any StateProtocolErased] = [
            "testState": AnyStateProtocol($testState)
        ]
        
        let javascript = generator.generateCompleteScript(for: states, configuration: config)
        
        // Test error handling in state listeners
        #expect(javascript.contains("try {"))
        #expect(javascript.contains("} catch (error) {"))
        #expect(javascript.contains("console.error"))
        
        // Test specific error messages
        #expect(javascript.contains("Error in state listener"))
        #expect(javascript.contains("Error processing server message"))
        
        // Test WebSocket error handling structure (implicit in other handlers)
        #expect(javascript.contains("console.error"))
    }
    
    @Test("JavaScript output contains all required WebSocket functionality")
    func javaScriptWebSocketFunctionality() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        let javascript = generator.generateCompleteScript(for: [:], configuration: config)
        
        // Test WebSocket setup
        #expect(javascript.contains("setupServerSync(url = 'ws://localhost:8080/ws')"))
        #expect(javascript.contains("new WebSocket(url)"))
        
        // Test WebSocket event handlers
        #expect(javascript.contains("ws.onopen"))
        #expect(javascript.contains("ws.onmessage"))
        #expect(javascript.contains("ws.onclose"))
        
        // Test message handling
        #expect(javascript.contains("const message = JSON.parse(event.data)"))
        #expect(javascript.contains("if (message.type === 'stateUpdate')"))
        #expect(javascript.contains("if (message.type === 'reload')"))
        #expect(javascript.contains("window.location.reload()"))
    }
    
    @Test("State manager provides complete API surface")
    func stateManagerCompleteAPISurface() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()
        
        let javascript = generator.generateCompleteScript(for: [:], configuration: config)
        
        // Test core API methods
        let expectedMethods = [
            "createState",
            "getState", 
            "setState",
            "subscribe",
            "unsubscribe",
            "bindElement",
            "updateDOM",
            "updateElementProperty",
            "notifyListeners",
            "setupServerSync",
            "debug"
        ]
        
        for method in expectedMethods {
            #expect(javascript.contains("\(method)(") || javascript.contains("\(method):"))
        }
        
        // Test that WebUIStateManager object is properly structured
        #expect(javascript.contains("window.WebUIStateManager = {"))
        #expect(javascript.contains("const states = new Map()"))
        #expect(javascript.contains("const listeners = new Map()"))
        #expect(javascript.contains("const elements = new Map()"))
    }
    
    @Test("Button action JavaScript generation is syntactically correct")
    func buttonActionJavaScriptSyntax() {
        let generator = JavaScriptGenerator()
        
        let actions: [(ButtonAction, String)] = [
            (.increment, "+ 1"),
            (.decrement, "- 1"), 
            (.toggle, "!WebUIStateManager.getState"),
            (.custom("customFunction('$STATE_ID')"), "customFunction('testState')")
        ]
        
        for (action, expectedContent) in actions {
            let handler = generator.generateButtonHandler(
                buttonID: "test-btn",
                stateID: "testState", 
                action: action
            )
            
            // Test basic structure
            #expect(handler.contains("document.getElementById('test-btn')"))
            #expect(handler.contains("addEventListener('click', function() {"))
            #expect(handler.contains("});"))
            
            // Test action-specific content
            #expect(handler.contains(expectedContent))
        }
    }
    
    @Test("Form handler JavaScript generation handles multiple inputs")
    func formHandlerMultipleInputs() {
        let generator = JavaScriptGenerator()
        
        let stateUpdates = [
            "firstName": "user_first_name",
            "lastName": "user_last_name", 
            "email": "user_email",
            "age": "user_age",
            "newsletter": "user_newsletter_opt_in"
        ]
        
        let formHandler = generator.generateFormHandler(
            formID: "registration-form",
            stateUpdates: stateUpdates
        )
        
        // Test form structure
        #expect(formHandler.contains("document.getElementById('registration-form')"))
        #expect(formHandler.contains("addEventListener('submit', function(event) {"))
        #expect(formHandler.contains("event.preventDefault()"))
        #expect(formHandler.contains("const form = event.target"))
        
        // Test all state updates are present
        for (fieldName, stateID) in stateUpdates {
            #expect(formHandler.contains("WebUIStateManager.setState('\(stateID)', form['\(fieldName)'].value)"))
        }
    }
    
    @Test("Configuration options properly affect generated JavaScript")
    func configurationOptionsAffectJavaScript() {
        let generator = JavaScriptGenerator()
        
        let configs = [
            StateManager.StateConfiguration(
                enablePersistence: true,
                storageType: .localStorage,
                enableDebugging: false
            ),
            StateManager.StateConfiguration(
                enablePersistence: false,
                storageType: .sessionStorage,
                enableDebugging: true,
                maxDebugHistory: 100
            )
        ]
        
        for config in configs {
            let javascript = generator.generateCompleteScript(for: [:], configuration: config)
            
            // Test persistence configuration
            #expect(javascript.contains("enablePersistence = \(config.enablePersistence)"))
            #expect(javascript.contains("storageType = '\(config.storageType.rawValue)'"))
            #expect(javascript.contains("enableDebugging = \(config.enableDebugging)"))
            
            if config.enableDebugging {
                #expect(javascript.contains("debug()"))
                #expect(javascript.contains("WebUI State Snapshot"))
            }
        }
    }
}