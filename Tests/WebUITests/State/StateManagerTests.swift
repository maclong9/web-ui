import Testing

@testable import WebUI

@Suite("State Manager Tests")
struct StateManagerTests {

    @Test("State registration and retrieval")
    func stateRegistration() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test registering a new state value
        stateManager.registerState(key: "test", initialValue: "hello", scope: StateScope.component)

        let value = stateManager.getState(key: "test", scope: StateScope.component, as: String.self)
        #expect(value == "hello")
    }

    @Test("State updates")
    func stateUpdate() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test updating state value
        stateManager.registerState(key: "counter", initialValue: 0, scope: StateScope.component)
        stateManager.updateState(key: "counter", value: 5, scope: StateScope.component)

        let value = stateManager.getState(key: "counter", scope: StateScope.component, as: Int.self)
        #expect(value == 5)
    }

    @Test("Different state scopes")
    func differentScopes() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test that different scopes maintain separate state
        stateManager.registerState(key: "value", initialValue: "component", scope: StateScope.component)
        stateManager.registerState(key: "value", initialValue: "shared", scope: StateScope.shared)
        stateManager.registerState(key: "value", initialValue: "global", scope: StateScope.global)

        #expect(stateManager.getState(key: "value", scope: StateScope.component, as: String.self) == "component")
        #expect(stateManager.getState(key: "value", scope: StateScope.shared, as: String.self) == "shared")
        #expect(stateManager.getState(key: "value", scope: StateScope.global, as: String.self) == "global")
    }

    @Test("State subscription and notifications")
    func stateSubscription() async {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        await confirmation("State subscription callback") { confirmation in
            stateManager.registerState(key: "observable", initialValue: 0, scope: StateScope.component)

            let _ = stateManager.subscribe(to: "observable", scope: StateScope.component) { (newValue: Int) in
                #expect(newValue == 42)
                confirmation()
            }

            stateManager.updateState(key: "observable", value: 42, scope: StateScope.component)
        }
    }

    @Test("State clearing by scope")
    func stateClear() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test clearing state for a scope
        stateManager.registerState(key: "temp1", initialValue: "value1", scope: StateScope.component)
        stateManager.registerState(key: "temp2", initialValue: "value2", scope: StateScope.component)
        stateManager.registerState(key: "persist", initialValue: "value3", scope: StateScope.shared)

        stateManager.clearState(scope: StateScope.component)

        #expect(stateManager.getState(key: "temp1", scope: StateScope.component, as: String.self) == nil)
        #expect(stateManager.getState(key: "temp2", scope: StateScope.component, as: String.self) == nil)
        #expect(stateManager.getState(key: "persist", scope: StateScope.shared, as: String.self) == "value3")
    }

    @Test("Debug history tracking")
    func debugHistory() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test debug history tracking
        stateManager.registerState(key: "tracked", initialValue: 0, scope: StateScope.component)
        stateManager.updateState(key: "tracked", value: 1, scope: StateScope.component)
        stateManager.updateState(key: "tracked", value: 2, scope: StateScope.component)

        let history = stateManager.getDebugHistory()
        #expect(history.count >= 3)  // Initial registration + 2 updates

        let lastUpdate = history.last!
        #expect(lastUpdate.key == "component.tracked")
        #expect(lastUpdate.newValue as? Int == 2)
    }

    @Test("JavaScript code generation")
    func javaScriptGeneration() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test that JavaScript generation doesn't crash
        stateManager.registerState(key: "jsTest", initialValue: true, scope: StateScope.component)
        stateManager.registerState(key: "counter", initialValue: 0, scope: StateScope.shared)

        let javascript = stateManager.generateJavaScript()

        #expect(javascript.contains("WebUIStateManager"))
        #expect(javascript.contains("setState"))
        #expect(javascript.contains("getState"))
        #expect(javascript.contains("subscribe"))
    }

    @Test("State export and import")
    func stateExportImport() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test exporting and importing state
        stateManager.registerState(key: "export1", initialValue: "value1", scope: StateScope.component)
        stateManager.registerState(key: "export2", initialValue: 42, scope: StateScope.shared)

        let exported = stateManager.exportStateJSON()

        let newStateManager = StateManager(configuration: StateManager.StateConfiguration())
        newStateManager.importStateJSON(exported)

        #expect(newStateManager.getState(key: "export1", scope: StateScope.component, as: String.self) == "value1")
        #expect(newStateManager.getState(key: "export2", scope: StateScope.shared, as: Int.self) == 42)
    }

    @Test("Codable type compliance")
    func codableCompliance() {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test with various Codable types
        struct TestStruct: Codable, Equatable {
            let name: String
            let age: Int
        }

        let testData = TestStruct(name: "Test", age: 25)
        stateManager.registerState(key: "struct", initialValue: testData, scope: StateScope.component)

        let retrieved = stateManager.getState(key: "struct", scope: StateScope.component, as: TestStruct.self)
        #expect(retrieved == testData)

        // Test arrays
        let testArray = [1, 2, 3, 4, 5]
        stateManager.registerState(key: "array", initialValue: testArray, scope: StateScope.shared)

        let retrievedArray = stateManager.getState(key: "array", scope: StateScope.shared, as: [Int].self)
        #expect(retrievedArray == testArray)
    }

    @Test("Concurrent access safety")
    func concurrentAccess() async {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test thread safety with concurrent access
        stateManager.registerState(key: "concurrent", initialValue: 0, scope: StateScope.component)

        await withTaskGroup(of: Void.self) { group in
            for i in 1...100 {
                group.addTask {
                    stateManager.updateState(key: "concurrent", value: i, scope: StateScope.component)
                }
            }
        }

        // Verify final state is some valid value
        let finalValue = stateManager.getState(key: "concurrent", scope: StateScope.component, as: Int.self)
        #expect(finalValue != nil)
        #expect(finalValue! > 0)
        #expect(finalValue! <= 100)
    }

    @Test("Multiple subscribers")
    func multipleSubscribers() async {
        let stateManager = StateManager(
            configuration: StateManager.StateConfiguration(
                enablePersistence: false,
                enableDebugging: true
            ))

        // Test multiple subscribers to the same state
        await confirmation("All subscribers notified", expectedCount: 3) { confirmation in
            stateManager.registerState(key: "multiSub", initialValue: "initial", scope: StateScope.shared)

            let _ = stateManager.subscribe(to: "multiSub", scope: StateScope.shared) { (newValue: String) in
                if newValue == "updated" {
                    confirmation()
                }
            }

            let _ = stateManager.subscribe(to: "multiSub", scope: StateScope.shared) { (newValue: String) in
                if newValue == "updated" {
                    confirmation()
                }
            }

            let _ = stateManager.subscribe(to: "multiSub", scope: StateScope.shared) { (newValue: String) in
                if newValue == "updated" {
                    confirmation()
                }
            }

            stateManager.updateState(key: "multiSub", value: "updated", scope: StateScope.shared)
        }
    }

    @Test("State configuration options")
    func stateConfiguration() {
        // Test different configuration options
        let config = StateManager.StateConfiguration(
            enablePersistence: true,
            storageType: .sessionStorage,
            enableDebugging: false,
            maxDebugHistory: 50
        )

        let configuredManager = StateManager(configuration: config)
        // Test that manager was created successfully (contains empty scopes)
        let exportedJSON = configuredManager.exportStateJSON()
        #expect(exportedJSON.contains("component"))

        // Test JavaScript generation includes configuration
        let javascript = configuredManager.generateJavaScript()
        #expect(javascript.contains("sessionStorage"))
        #expect(javascript.contains("enablePersistence = true"))
        #expect(javascript.contains("enableDebugging = false"))
    }
}
