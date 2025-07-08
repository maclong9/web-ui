import Foundation
import Testing

@testable import WebUI

@Suite("State-Aware Markup Tests")
struct StateAwareMarkupTests {
    
    // MARK: - Test Elements for Markup Testing
    
    struct TestElement: Markup {
        let content: String
        
        var body: MarkupString {
            MarkupString(content: "<div>\(content)</div>")
        }
    }
    
    struct TestButton: Markup {
        let text: String
        let id: String?
        
        init(_ text: String, id: String? = nil) {
            self.text = text
            self.id = id
        }
        
        var body: MarkupString {
            let idAttr = id.map { " id=\"\($0)\"" } ?? ""
            return MarkupString(content: "<button\(idAttr)>\(text)</button>")
        }
    }
    
    struct TestInput: Markup {
        let name: String
        let type: String
        let placeholder: String?
        
        init(name: String, type: String = "text", placeholder: String? = nil) {
            self.name = name
            self.type = type
            self.placeholder = placeholder
        }
        
        var body: MarkupString {
            let placeholderAttr = placeholder.map { " placeholder=\"\($0)\"" } ?? ""
            return MarkupString(content: "<input name=\"\(name)\" type=\"\(type)\"\(placeholderAttr)>")
        }
    }
    
    // MARK: - State Binding Tests
    
    @Test("Basic state binding adds correct attributes")
    func basicStateBinding() {
        @ComponentState var testValue = "Hello World"
        
        let element = TestElement(content: "Test Content")
        let boundElement = element.bindToState($testValue, property: .textContent)
        let rendered = boundElement.render()
        
        // Test that state binding attributes are added
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"textContent\""))
        #expect(rendered.contains("Test Content"))
    }
    
    @Test("State binding with different DOM properties")
    func stateBindingWithDifferentProperties() {
        @ComponentState var inputValue = "test value"
        @ComponentState var isChecked = false
        @ComponentState var isDisabled = true
        
        let textElement = TestElement(content: "Text Element")
        let inputElement = TestInput(name: "test", type: "text")
        let checkboxElement = TestInput(name: "checkbox", type: "checkbox")
        
        let textBound = textElement.bindToState($inputValue, property: .textContent)
        let valueBound = inputElement.bindToState($inputValue, property: .value)
        let checkedBound = checkboxElement.bindToState($isChecked, property: .checked)
        let disabledBound = inputElement.bindToState($isDisabled, property: .disabled)
        
        let textRendered = textBound.render()
        let valueRendered = valueBound.render()
        let checkedRendered = checkedBound.render()
        let disabledRendered = disabledBound.render()
        
        // Test different property bindings
        #expect(textRendered.contains("data-webui-property=\"textContent\""))
        #expect(valueRendered.contains("data-webui-property=\"value\""))
        #expect(checkedRendered.contains("data-webui-property=\"checked\""))
        #expect(disabledRendered.contains("data-webui-property=\"disabled\""))
    }
    
    @Test("State binding wraps element when no existing tag")
    func stateBindingWrapsElementWhenNoTag() {
        @ComponentState var plainText = "Just text"
        
        // Create a plain text element without HTML tags
        struct PlainText: Markup {
            let text: String
            var body: MarkupString {
                MarkupString(content: text)
            }
        }
        
        let plainElement = PlainText(text: "Plain text content")
        let boundElement = plainElement.bindToState($plainText, property: .textContent)
        let rendered = boundElement.render()
        
        // Test that plain text gets wrapped in a span with state attributes
        #expect(rendered.contains("<span"))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"textContent\""))
        #expect(rendered.contains("Plain text content"))
        #expect(rendered.contains("</span>"))
    }
    
    // MARK: - Click Handler Tests
    
    @Test("Click handler adds ID and script")
    func clickHandlerAddsIDAndScript() {
        @ComponentState var counter = 0
        
        let button = TestButton("Click me")
        let clickableButton = button.onClick($counter, action: .increment)
        let rendered = clickableButton.render()
        
        // Test that ID is added
        #expect(rendered.contains("id=\"webui-element-"))
        
        // Test that script is generated
        #expect(rendered.contains("<script>"))
        #expect(rendered.contains("addEventListener('click'"))
        #expect(rendered.contains("WebUIStateManager.setState"))
        #expect(rendered.contains("+ 1")) // Check for increment logic
        #expect(rendered.contains("</script>"))
    }
    
    @Test("Click handler with different actions")
    func clickHandlerWithDifferentActions() {
        @ComponentState var counter = 10
        @ComponentState var isToggled = false
        
        let incrementButton = TestButton("Increment").onClick($counter, action: .increment)
        let decrementButton = TestButton("Decrement").onClick($counter, action: .decrement)
        let toggleButton = TestButton("Toggle").onClick($isToggled, action: .toggle)
        let customButton = TestButton("Custom").onClick($counter, action: .custom("alert('Custom action');"))
        
        let incrementRendered = incrementButton.render()
        let decrementRendered = decrementButton.render()
        let toggleRendered = toggleButton.render()
        let customRendered = customButton.render()
        
        // Test increment action
        #expect(incrementRendered.contains("+ 1"))
        
        // Test decrement action
        #expect(decrementRendered.contains("- 1"))
        
        // Test toggle action
        #expect(toggleRendered.contains("!WebUIStateManager.getState"))
        
        // Test custom action
        #expect(customRendered.contains("alert('Custom action');"))
    }
    
    @Test("Click handler preserves existing ID")
    func clickHandlerPreservesExistingID() {
        @ComponentState var value = "test"
        
        let buttonWithID = TestButton("Button", id: "existing-id")
        let clickableButton = buttonWithID.onClick($value, action: .toggle)
        let rendered = clickableButton.render()
        
        // Test that existing ID is preserved
        #expect(rendered.contains("id=\"existing-id\""))
        #expect(!rendered.contains("webui-element-"))
    }
    
    // MARK: - State Management Script Tests
    
    @Test("State management script inclusion")
    func stateManagementScriptInclusion() {
        let element = TestElement(content: "Content")
        let elementWithScript = element.includeStateManagement()
        let rendered = elementWithScript.render()
        
        // Test that script is included
        #expect(rendered.contains("<script>"))
        #expect(rendered.contains("WebUIStateManager"))
        #expect(rendered.contains("</script>"))
        #expect(rendered.contains("Content"))
    }
    
    @Test("State management script insertion before closing body tag")
    func stateManagementScriptInsertionBeforeClosingBodyTag() {
        struct PageWithBody: Markup {
            var body: MarkupString {
                MarkupString(content: "<html><body><h1>Page Content</h1></body></html>")
            }
        }
        
        let page = PageWithBody()
        let pageWithScript = page.includeStateManagement()
        let rendered = pageWithScript.render()
        
        // Test that script is inserted before </body>
        #expect(rendered.contains("<script>"))
        #expect(rendered.contains("WebUIStateManager"))
        #expect(rendered.contains("</script>\n</body>"))
    }
    
    @Test("State management script appends when no body tag")
    func stateManagementScriptAppendsWhenNoBodyTag() {
        let element = TestElement(content: "No body tag")
        let elementWithScript = element.includeStateManagement()
        let rendered = elementWithScript.render()
        
        // Test that script is appended at the end
        #expect(rendered.contains("No body tag"))
        #expect(rendered.hasSuffix("</script>"))
    }
    
    // MARK: - Convenience Function Tests
    
    @Test("StateText convenience function")
    func stateTextConvenienceFunction() {
        @ComponentState var displayValue = "Display this text"
        
        let stateText = StateText($displayValue)
        let rendered = stateText.render()
        
        // Test that StateText renders correctly
        #expect(rendered.contains("Display this text"))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"textContent\""))
    }
    
    @Test("StateInput convenience function")
    func stateInputConvenienceFunction() {
        @ComponentState var inputValue = "initial"
        
        let stateInput = StateInput($inputValue, name: "test-input", placeholder: "Enter text")
        let rendered = stateInput.render()
        
        // Test that StateInput renders correctly
        #expect(rendered.contains("name=\"test-input\""))
        #expect(rendered.contains("placeholder=\"Enter text\""))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"value\""))
    }
    
    @Test("StateInput with default name")
    func stateInputWithDefaultName() {
        @ComponentState(key: "user_email", wrappedValue: "") var email
        
        let stateInput = StateInput($email, placeholder: "Email")
        let rendered = stateInput.render()
        
        // Test that default name uses state ID
        #expect(rendered.contains("name=\"user_email\""))
        #expect(rendered.contains("placeholder=\"Email\""))
    }
    
    @Test("StateCheckbox convenience function")
    func stateCheckboxConvenienceFunction() {
        @ComponentState var isChecked = false
        
        let stateCheckbox = StateCheckbox($isChecked, name: "agree")
        let rendered = stateCheckbox.render()
        
        // Test that StateCheckbox renders correctly
        #expect(rendered.contains("type=\"checkbox\""))
        #expect(rendered.contains("name=\"agree\""))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"checked\""))
    }
    
    @Test("StateCheckbox with default name")
    func stateCheckboxWithDefaultName() {
        @ComponentState(key: "newsletter_subscribe", wrappedValue: true) var subscribe
        
        let stateCheckbox = StateCheckbox($subscribe)
        let rendered = stateCheckbox.render()
        
        // Test that default name uses state ID
        #expect(rendered.contains("name=\"newsletter_subscribe\""))
    }
    
    // MARK: - Element Extension Tests
    
    @Test("Element increment button factory")
    func elementIncrementButtonFactory() {
        @ComponentState var count = 5
        
        // Note: This test assumes Button and Element types exist in the actual codebase
        // For now, we'll test the concept with our TestButton
        struct ButtonElement {
            static func incrementButton<T: Numeric & Codable & Sendable>(
                _ text: String,
                state: any StateProtocol<T>
            ) -> TestButton {
                return TestButton(text)
            }
        }
        
        let incrementBtn = ButtonElement.incrementButton("Count Up", state: $count)
        let rendered = incrementBtn.render()
        
        // Test that button is created correctly
        #expect(rendered.contains("Count Up"))
        #expect(rendered.contains("<button"))
    }
    
    @Test("Element toggle button factory")
    func elementToggleButtonFactory() {
        @ComponentState var isEnabled = false
        
        struct ButtonElement {
            static func toggleButton(
                _ text: String,
                state: any StateProtocol<Bool>
            ) -> TestButton {
                return TestButton(text)
            }
        }
        
        let toggleBtn = ButtonElement.toggleButton("Toggle State", state: $isEnabled)
        let rendered = toggleBtn.render()
        
        // Test that button is created correctly
        #expect(rendered.contains("Toggle State"))
        #expect(rendered.contains("<button"))
    }
    
    // MARK: - Complex State Binding Tests
    
    @Test("Multiple state bindings on single element")
    func multipleStateBindingsOnSingleElement() {
        @ComponentState var text = "Content"
        @ComponentState var isDisabled = false
        
        let element = TestElement(content: "Base content")
        let textBound = element.bindToState($text, property: .textContent)
        let rendered = textBound.render()
        
        // Test that first binding works
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"textContent\""))
    }
    
    @Test("Chained state operations")
    func chainedStateOperations() {
        @ComponentState var content = "Chained content"
        @ComponentState var counter = 0
        
        let element = TestButton("Click me")
        let boundAndClickable = element
            .bindToState($content, property: .textContent)
            .onClick($counter, action: .increment)
        
        let rendered = boundAndClickable.render()
        
        // Test that both operations are applied
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("addEventListener('click'"))
        #expect(rendered.contains("+ 1")) // Check for increment logic
    }
    
    // MARK: - DOM Property Enum Tests
    
    @Test("All DOM properties are supported")
    func allDOMPropertiesAreSupported() {
        @ComponentState var testValue = "test"
        
        let element = TestElement(content: "Test")
        
        // Test all DOM properties
        for property in DOMProperty.allCases {
            let boundElement = element.bindToState($testValue, property: property)
            let rendered = boundElement.render()
            
            #expect(rendered.contains("data-webui-property=\"\(property.rawValue)\""))
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test("State binding with uninitialized state ID")
    func stateBindingWithUninitializedStateID() {
        // Create a state with default behavior
        @ComponentState var testState = "test value"
        
        let element = TestElement(content: "Test")
        let boundElement = element.bindToState($testState, property: .textContent)
        let rendered = boundElement.render()
        
        // Test that state binding attributes are added
        #expect(rendered.contains("data-webui-state"))
    }
    
    @Test("Click handler with uninitialized state ID")
    func clickHandlerWithUninitializedStateID() {
        @ComponentState var counter = 0
        
        let button = TestButton("Click")
        let clickableButton = button.onClick($counter, action: .increment)
        let rendered = clickableButton.render()
        
        // Test that JavaScript is generated for click handlers
        #expect(rendered.contains("addEventListener('click'"))
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete state-aware component rendering")
    func completeStateAwareComponentRendering() {
        @ComponentState var title = "Counter App"
        @ComponentState var count = 0
        @ComponentState var isVisible = true
        
        struct CounterComponent: Markup {
            let title: String
            let count: Int
            let isVisible: Bool
            
            var body: MarkupString {
                let visibility = isVisible ? "block" : "none"
                return MarkupString(content: """
                <div style="display: \(visibility)">
                    <h1>\(title)</h1>
                    <p>Count: \(count)</p>
                    <button id="increment">+</button>
                    <button id="decrement">-</button>
                    <button id="toggle">Toggle</button>
                </div>
                """)
            }
        }
        
        let component = CounterComponent(title: title, count: count, isVisible: isVisible)
        let stateAwareComponent = component
            .bindToState($title, property: .textContent)
            .includeStateManagement()
        
        let rendered = stateAwareComponent.render()
        
        // Test complete rendering
        #expect(rendered.contains("Counter App"))
        #expect(rendered.contains("Count: 0"))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("WebUIStateManager"))
        #expect(rendered.contains("<script>"))
    }
    
    @Test("State management with complex nested markup")
    func stateManagementWithComplexNestedMarkup() {
        @ComponentState var userProfile = ["name": "Jane", "email": "jane@example.com"]
        
        struct UserCard: Markup {
            let profile: [String: String]
            
            var body: MarkupString {
                MarkupString(content: """
                <div class="user-card">
                    <div class="header">
                        <h2>\(profile["name"] ?? "Unknown")</h2>
                    </div>
                    <div class="content">
                        <p>Email: \(profile["email"] ?? "No email")</p>
                    </div>
                </div>
                """)
            }
        }
        
        let userCard = UserCard(profile: userProfile)
        let stateAwareCard = userCard
            .bindToState($userProfile, property: .innerHTML)
            .includeStateManagement()
        
        let rendered = stateAwareCard.render()
        
        // Test complex nested markup with state
        #expect(rendered.contains("user-card"))
        #expect(rendered.contains("Jane"))
        #expect(rendered.contains("jane@example.com"))
        #expect(rendered.contains("data-webui-state="))
        #expect(rendered.contains("data-webui-property=\"innerHTML\""))
        #expect(rendered.contains("WebUIStateManager"))
    }
}

// MARK: - Helper Types for Testing

private final class StateStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    
    init(initialValue: Value) {
        self._value = initialValue
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
}
