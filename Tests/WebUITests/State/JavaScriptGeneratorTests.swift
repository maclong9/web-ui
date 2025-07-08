import Foundation
import Testing

@testable import WebUI

@Suite("JavaScript Generator Tests")
struct JavaScriptGeneratorTests {

    @Test("JavaScript generation includes core framework")
    func coreFrameworkGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration(
            enablePersistence: false,
            enableDebugging: true
        )

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test that core framework is included
        #expect(javascript.contains("WebUIStateManager"))
        #expect(javascript.contains("createState"))
        #expect(javascript.contains("getState"))
        #expect(javascript.contains("setState"))
        #expect(javascript.contains("subscribe"))
        #expect(javascript.contains("bindElement"))
        #expect(javascript.contains("updateDOM"))
        #expect(javascript.contains("setupServerSync"))
        #expect(javascript.contains("debug"))

        // Test configuration is embedded
        #expect(javascript.contains("enablePersistence = false"))
        #expect(javascript.contains("enableDebugging = true"))
    }

    @Test("JavaScript generation with configuration options")
    func configurationOptions() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration(
            enablePersistence: true,
            storageType: .sessionStorage,
            enableDebugging: false,
            maxDebugHistory: 50
        )

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test configuration values are correctly embedded
        #expect(javascript.contains("enablePersistence = true"))
        #expect(javascript.contains("enableDebugging = false"))
        #expect(javascript.contains("storageType = 'sessionStorage'"))
    }

    @Test("State instance JavaScript generation")
    func stateInstanceGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        // Create a test state
        @State var testState = "initial value"
        let stateID = "test_state"

        // Create the state dictionary
        let states: [String: any StateProtocolErased] = [
            stateID: AnyStateProtocol($testState)
        ]

        let javascript = generator.generateCompleteScript(for: states, configuration: config)

        // Test that state is created
        #expect(javascript.contains("WebUIStateManager.createState('test_state', \"initial value\");"))
        #expect(javascript.contains("'test_state'"))
    }

    @Test("Multiple states JavaScript generation")
    func multipleStatesGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        // Create multiple test states
        @State var stringState = "hello"
        @State var intState = 42
        @State var boolState = true

        let states: [String: any StateProtocolErased] = [
            "string_state": AnyStateProtocol($stringState),
            "int_state": AnyStateProtocol($intState),
            "bool_state": AnyStateProtocol($boolState),
        ]

        let javascript = generator.generateCompleteScript(for: states, configuration: config)

        // Test all states are created
        #expect(javascript.contains("WebUIStateManager.createState('string_state', \"hello\");"))
        #expect(javascript.contains("WebUIStateManager.createState('int_state', 42);"))
        #expect(javascript.contains("WebUIStateManager.createState('bool_state', true);"))

        // Test initialization includes all state IDs (order may vary)
        #expect(javascript.contains("'string_state'"))
        #expect(javascript.contains("'int_state'"))
        #expect(javascript.contains("'bool_state'"))
    }

    @Test("Complex data types JavaScript generation")
    func complexDataTypesGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        struct TestStruct: Codable {
            let name: String
            let age: Int
            let active: Bool
        }

        @State var structState = TestStruct(name: "Jane", age: 30, active: true)
        @State var arrayState = [1, 2, 3, 4, 5]
        @State var dictState = ["key1": "value1", "key2": "value2"]

        let states: [String: any StateProtocolErased] = [
            "struct_state": AnyStateProtocol($structState),
            "array_state": AnyStateProtocol($arrayState),
            "dict_state": AnyStateProtocol($dictState),
        ]

        let javascript = generator.generateCompleteScript(for: states, configuration: config)

        // Test complex types are serialized correctly
        #expect(javascript.contains("struct_state"))
        #expect(javascript.contains("array_state"))
        #expect(javascript.contains("dict_state"))
        #expect(javascript.contains("Jane"))
        #expect(javascript.contains("[1,2,3,4,5]"))
        #expect(javascript.contains("value1"))
    }

    @Test("Button handler generation")
    func buttonHandlerGeneration() {
        let generator = JavaScriptGenerator()

        let incrementHandler = generator.generateButtonHandler(
            buttonID: "increment-btn",
            stateID: "counter",
            action: .increment
        )

        let toggleHandler = generator.generateButtonHandler(
            buttonID: "toggle-btn",
            stateID: "isToggled",
            action: .toggle
        )

        let decrementHandler = generator.generateButtonHandler(
            buttonID: "decrement-btn",
            stateID: "counter",
            action: .decrement
        )

        let customHandler = generator.generateButtonHandler(
            buttonID: "custom-btn",
            stateID: "customState",
            action: .custom("WebUIStateManager.setState('$STATE_ID', 'custom value');")
        )

        // Test increment handler
        #expect(incrementHandler.contains("document.getElementById('increment-btn')"))
        #expect(incrementHandler.contains("addEventListener('click'"))
        #expect(
            incrementHandler.contains(
                "WebUIStateManager.setState('counter', (WebUIStateManager.getState('counter') || 0) + 1)"))

        // Test toggle handler
        #expect(toggleHandler.contains("document.getElementById('toggle-btn')"))
        #expect(
            toggleHandler.contains("WebUIStateManager.setState('isToggled', !WebUIStateManager.getState('isToggled'))"))

        // Test decrement handler
        #expect(decrementHandler.contains("document.getElementById('decrement-btn')"))
        #expect(
            decrementHandler.contains(
                "WebUIStateManager.setState('counter', (WebUIStateManager.getState('counter') || 0) - 1)"))

        // Test custom handler
        #expect(customHandler.contains("document.getElementById('custom-btn')"))
        #expect(customHandler.contains("WebUIStateManager.setState('customState', 'custom value');"))
    }

    @Test("Form handler generation")
    func formHandlerGeneration() {
        let generator = JavaScriptGenerator()

        let stateUpdates = [
            "firstName": "user_first_name",
            "lastName": "user_last_name",
            "email": "user_email",
        ]

        let formHandler = generator.generateFormHandler(
            formID: "user-form",
            stateUpdates: stateUpdates
        )

        // Test form handler structure
        #expect(formHandler.contains("document.getElementById('user-form')"))
        #expect(formHandler.contains("addEventListener('submit'"))
        #expect(formHandler.contains("event.preventDefault()"))

        // Test state updates
        #expect(formHandler.contains("WebUIStateManager.setState('user_first_name', form['firstName'].value)"))
        #expect(formHandler.contains("WebUIStateManager.setState('user_last_name', form['lastName'].value)"))
        #expect(formHandler.contains("WebUIStateManager.setState('user_email', form['email'].value)"))
    }

    @Test("JavaScript generation with default configuration")
    func defaultConfigurationGeneration() {
        let generator = JavaScriptGenerator()

        @State var testState = "default config test"
        let states: [String: any StateProtocolErased] = [
            "default_test": AnyStateProtocol($testState)
        ]

        let javascript = generator.generateCompleteScript(for: states)

        // Test default configuration values
        #expect(javascript.contains("enablePersistence = false"))
        #expect(javascript.contains("enableDebugging = true"))
        #expect(javascript.contains("storageType = 'memory'"))

        // Test state is still created
        #expect(javascript.contains("WebUIStateManager.createState('default_test', \"default config test\");"))
    }

    @Test("Individual state script generation")
    func individualStateScriptGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        @State var individualState = ["item1", "item2", "item3"]

        let script = generator.generateStateScript(
            for: AnyStateProtocol($individualState),
            withID: "individual_state",
            configuration: config
        )

        // Test individual state script
        #expect(script.contains("// State: individual_state"))
        #expect(script.contains("WebUIStateManager.createState('individual_state', [\"item1\",\"item2\",\"item3\"]);"))
    }

    @Test("JavaScript initialization code generation")
    func initializationCodeGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        @State var state1 = "test1"
        @State var state2 = "test2"

        let states: [String: any StateProtocolErased] = [
            "state1": AnyStateProtocol($state1),
            "state2": AnyStateProtocol($state2),
        ]

        let javascript = generator.generateCompleteScript(for: states, configuration: config)

        // Test initialization code
        #expect(javascript.contains("document.addEventListener('DOMContentLoaded'"))
        #expect(javascript.contains("querySelectorAll('[data-webui-state]')"))
        #expect(javascript.contains("WebUIStateManager.bindElement"))
        #expect(javascript.contains("WebUIStateManager.setupServerSync"))
        #expect(javascript.contains("WebUI: State management initialized with states:"))

        // Test state IDs in initialization (order may vary)
        #expect(javascript.contains("'state1'"))
        #expect(javascript.contains("'state2'"))
    }

    @Test("WebSocket server sync setup")
    func webSocketServerSyncSetup() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test WebSocket functionality
        #expect(javascript.contains("setupServerSync"))
        #expect(javascript.contains("WebSocket"))
        #expect(javascript.contains("ws://localhost:8080/ws"))
        #expect(javascript.contains("onopen"))
        #expect(javascript.contains("onmessage"))
        #expect(javascript.contains("onclose"))
        #expect(javascript.contains("stateUpdate"))
        #expect(javascript.contains("reload"))
        #expect(javascript.contains("stateChange"))
    }

    @Test("DOM element binding functionality")
    func domElementBindingFunctionality() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test DOM binding methods
        #expect(javascript.contains("bindElement"))
        #expect(javascript.contains("updateDOM"))
        #expect(javascript.contains("updateElementProperty"))

        // Test element property handling
        #expect(javascript.contains("textContent"))
        #expect(javascript.contains("innerHTML"))
        #expect(javascript.contains("value"))
        #expect(javascript.contains("checked"))
        #expect(javascript.contains("disabled"))

        // Test input element handling
        #expect(javascript.contains("INPUT"))
        #expect(javascript.contains("TEXTAREA"))
        #expect(javascript.contains("SELECT"))
        #expect(javascript.contains("addEventListener('input'"))
        #expect(javascript.contains("checkbox"))
        #expect(javascript.contains("number"))
    }

    @Test("Error handling in JavaScript generation")
    func errorHandlingInJavaScriptGeneration() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test error handling
        #expect(javascript.contains("try {"))
        #expect(javascript.contains("catch (error)"))
        #expect(javascript.contains("console.error"))
        #expect(javascript.contains("Error in state listener"))
        #expect(javascript.contains("Error processing server message"))
    }

    @Test("State subscription and notification system")
    func stateSubscriptionAndNotificationSystem() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration()

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test subscription system
        #expect(javascript.contains("subscribe"))
        #expect(javascript.contains("unsubscribe"))
        #expect(javascript.contains("notifyListeners"))
        #expect(javascript.contains("listeners"))
        #expect(javascript.contains("new Set()"))
        #expect(javascript.contains("new Map()"))

        // Test callback management
        #expect(javascript.contains("callback"))
        #expect(javascript.contains("stateListeners"))
        #expect(javascript.contains("add(callback)"))
        #expect(javascript.contains("delete(callback)"))
    }

    @Test("Debug functionality in JavaScript")
    func debugFunctionalityInJavaScript() {
        let generator = JavaScriptGenerator()
        let config = StateManager.StateConfiguration(enableDebugging: true)

        let javascript = generator.generateCompleteScript(for: [:], configuration: config)

        // Test debug functionality
        #expect(javascript.contains("debug()"))
        #expect(javascript.contains("WebUI State Snapshot"))
        #expect(javascript.contains("console.log"))
        #expect(javascript.contains("stateSnapshot"))
        #expect(javascript.contains("enableDebugging = true"))
    }
}
