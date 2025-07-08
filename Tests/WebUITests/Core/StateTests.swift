import XCTest
@testable import WebUI

final class StateTests: XCTestCase {
    
    // MARK: - StateProperty Tests
    
    func testBooleanStateGeneration() {
        let state = BooleanState(name: "isVisible", initialValue: true)
        
        XCTAssertEqual(state.name, "isVisible")
        XCTAssertEqual(state.initialValue, true)
        XCTAssertEqual(state.jsVariableDeclaration, "let isVisible = true;")
        XCTAssertTrue(state.jsHelperFunctions.contains("const toggleIsVisible = () => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("isVisible = !isVisible;"))
        XCTAssertTrue(state.jsHelperFunctions.contains("render();"))
    }
    
    func testStringStateGeneration() {
        let state = StringState(name: "message", initialValue: "Hello World")
        
        XCTAssertEqual(state.name, "message")
        XCTAssertEqual(state.initialValue, "Hello World")
        XCTAssertEqual(state.jsVariableDeclaration, "let message = \"Hello World\";")
        XCTAssertTrue(state.jsHelperFunctions.contains("const setMessage = (value) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("message = value;"))
        XCTAssertTrue(state.jsHelperFunctions.contains("render();"))
    }
    
    func testNumberStateGeneration() {
        let state = NumberState(name: "counter", initialValue: 42.5)
        
        XCTAssertEqual(state.name, "counter")
        XCTAssertEqual(state.initialValue, 42.5)
        XCTAssertEqual(state.jsVariableDeclaration, "let counter = 42.5;")
        XCTAssertTrue(state.jsHelperFunctions.contains("const setCounter = (value) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const incrementCounter = (by = 1) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const decrementCounter = (by = 1) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("counter += by;"))
        XCTAssertTrue(state.jsHelperFunctions.contains("counter -= by;"))
    }
    
    func testArrayStateGeneration() {
        let state = ArrayState(name: "items", initialValue: ["apple", "banana", "cherry"])
        
        XCTAssertEqual(state.name, "items")
        XCTAssertEqual(state.initialValue.count, 3)
        XCTAssertEqual(state.jsVariableDeclaration, "let items = [\"apple\", \"banana\", \"cherry\"];")
        XCTAssertTrue(state.jsHelperFunctions.contains("const setItems = (value) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const addItems = (item) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const removeItems = (index) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const clearItems = () => {"))
    }
    
    func testObjectStateGeneration() {
        let state = ObjectState(name: "user", initialValue: ["name": "John", "age": 30])
        
        XCTAssertEqual(state.name, "user")
        XCTAssertEqual(state.initialValue.count, 2)
        XCTAssertTrue(state.jsVariableDeclaration.contains("let user = {"))
        XCTAssertTrue(state.jsVariableDeclaration.contains("name: \"John\""))
        XCTAssertTrue(state.jsVariableDeclaration.contains("age: 30"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const setUser = (value) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const updateUser = (key, value) => {"))
        XCTAssertTrue(state.jsHelperFunctions.contains("const deleteUser = (key) => {"))
    }
    
    func testStringEscaping() {
        let state = StringState(name: "text", initialValue: "Hello \"World\"\nNew Line")
        
        XCTAssertEqual(state.jsVariableDeclaration, "let text = \"Hello \\\"World\\\"\\nNew Line\";")
    }
    
    // MARK: - StateAction Tests
    
    func testToggleAction() {
        let action = StateAction.toggle("isVisible")
        XCTAssertEqual(action.jsCode, "toggleIsVisible()")
    }
    
    func testUpdateActionWithString() {
        let action = StateAction.update("message", "Hello World")
        XCTAssertEqual(action.jsCode, "setMessage('Hello World')")
    }
    
    func testUpdateActionWithNumber() {
        let action = StateAction.update("counter", 42.0)
        XCTAssertEqual(action.jsCode, "setCounter(42.0)")
    }
    
    func testUpdateActionWithBool() {
        let action = StateAction.update("isVisible", true)
        XCTAssertEqual(action.jsCode, "setIsVisible(true)")
    }
    
    func testIncrementAction() {
        let action = StateAction.increment("counter")
        XCTAssertEqual(action.jsCode, "incrementCounter()")
    }
    
    func testIncrementActionWithCustomAmount() {
        let action = StateAction.increment("counter", 5.0)
        XCTAssertEqual(action.jsCode, "incrementCounter(5.0)")
    }
    
    func testDecrementAction() {
        let action = StateAction.decrement("counter")
        XCTAssertEqual(action.jsCode, "decrementCounter()")
    }
    
    func testDecrementActionWithCustomAmount() {
        let action = StateAction.decrement("counter", 3.0)
        XCTAssertEqual(action.jsCode, "decrementCounter(3.0)")
    }
    
    func testExpressionAction() {
        let action = StateAction.expression("counter", "counter * 2")
        XCTAssertEqual(action.jsCode, "setCounter(counter * 2)")
    }
    
    func testAddToArrayAction() {
        let action = StateAction.addToArray("items", "new item")
        XCTAssertEqual(action.jsCode, "addItems('new item')")
    }
    
    func testRemoveFromArrayAction() {
        let action = StateAction.removeFromArray("items", 2)
        XCTAssertEqual(action.jsCode, "removeItems(2)")
    }
    
    func testUpdateObjectAction() {
        let action = StateAction.updateObject("user", "name", "Jane")
        XCTAssertEqual(action.jsCode, "updateUser('name', 'Jane')")
    }
    
    func testDeleteFromObjectAction() {
        let action = StateAction.deleteFromObject("user", "age")
        XCTAssertEqual(action.jsCode, "deleteUser('age')")
    }
    
    func testCustomAction() {
        let action = StateAction.custom("console.log('Hello World')")
        XCTAssertEqual(action.jsCode, "console.log('Hello World')")
    }
    
    func testChainedActions() {
        let chainedCode = StateAction.chain(
            .increment("counter"),
            .update("message", "Updated"),
            .toggle("isVisible")
        )
        XCTAssertEqual(chainedCode, "incrementCounter(); setMessage('Updated'); toggleIsVisible()")
    }
    
    func testActionArrayJSCode() {
        let actions: [StateAction] = [
            .increment("counter"),
            .update("message", "Updated"),
            .toggle("isVisible")
        ]
        XCTAssertEqual(actions.jsCode, "incrementCounter(); setMessage('Updated'); toggleIsVisible()")
    }
    
    // MARK: - StateManager Tests
    
    func testStateManagerGeneration() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
            StringState(name: "message", initialValue: "Hello")
            NumberState(name: "counter", initialValue: 0)
        }
        
        let js = stateManager.generateJavaScript()
        
        XCTAssertTrue(js.contains("let isVisible = true;"))
        XCTAssertTrue(js.contains("let message = \"Hello\";"))
        XCTAssertTrue(js.contains("let counter = 0;"))
        XCTAssertTrue(js.contains("const toggleIsVisible = () => {"))
        XCTAssertTrue(js.contains("const setMessage = (value) => {"))
        XCTAssertTrue(js.contains("const setCounter = (value) => {"))
        XCTAssertTrue(js.contains("function render() {"))
    }
    
    func testStateManagerScope() {
        let globalManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
        }
        
        let documentManager = StateManager(scope: .document("about")) {
            StringState(name: "message", initialValue: "Hello")
        }
        
        let localManager = StateManager(scope: .local("component-123")) {
            NumberState(name: "counter", initialValue: 0)
        }
        
        XCTAssertEqual(globalManager.scope.fileName, "state-global.js")
        XCTAssertEqual(documentManager.scope.fileName, "state-about.js")
        XCTAssertEqual(localManager.scope.fileName, "state-local-component-123.js")
    }
    
    func testStateManagerStateNames() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
            StringState(name: "message", initialValue: "Hello")
            NumberState(name: "counter", initialValue: 0)
        }
        
        XCTAssertEqual(stateManager.stateNames, ["isVisible", "message", "counter"])
    }
    
    func testStateManagerGetState() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
            StringState(name: "message", initialValue: "Hello")
        }
        
        let visibleState = stateManager.getState(named: "isVisible")
        XCTAssertNotNil(visibleState)
        XCTAssertEqual(visibleState?.name, "isVisible")
        
        let nonExistentState = stateManager.getState(named: "notFound")
        XCTAssertNil(nonExistentState)
    }
    
    func testStateManagerHasState() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
        }
        
        XCTAssertTrue(stateManager.hasState(named: "isVisible"))
        XCTAssertFalse(stateManager.hasState(named: "notFound"))
    }
    
    func testStateManagerEmptyStates() {
        let stateManager = StateManager(scope: .global) {
            // Empty
        }
        
        XCTAssertTrue(stateManager.stateNames.isEmpty)
        XCTAssertFalse(stateManager.hasState(named: "anything"))
        XCTAssertNil(stateManager.getState(named: "anything"))
    }
    
    func testStateManagerScopeDescriptions() {
        let globalScope = StateManager.StateScope.global
        let documentScope = StateManager.StateScope.document("about")
        let localScope = StateManager.StateScope.local("component-123")
        
        XCTAssertEqual(globalScope.description, "Global")
        XCTAssertEqual(documentScope.description, "Document(about)")
        XCTAssertEqual(localScope.description, "Local(component-123)")
    }
    
    func testStateManagerGenerateDeclarations() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
            StringState(name: "message", initialValue: "Hello")
        }
        
        let declarations = stateManager.generateStateDeclarations()
        XCTAssertTrue(declarations.contains("let isVisible = true;"))
        XCTAssertTrue(declarations.contains("let message = \"Hello\";"))
    }
    
    func testStateManagerGenerateHelperFunctions() {
        let stateManager = StateManager(scope: .global) {
            BooleanState(name: "isVisible", initialValue: true)
            NumberState(name: "counter", initialValue: 0)
        }
        
        let helpers = stateManager.generateHelperFunctions()
        XCTAssertTrue(helpers.contains("const toggleIsVisible = () => {"))
        XCTAssertTrue(helpers.contains("const setCounter = (value) => {"))
        XCTAssertTrue(helpers.contains("const incrementCounter = (by = 1) => {"))
        XCTAssertTrue(helpers.contains("const decrementCounter = (by = 1) => {"))
    }
}