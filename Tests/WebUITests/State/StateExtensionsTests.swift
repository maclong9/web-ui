import Foundation
import Testing

@testable import WebUI

@Suite("State Extensions Tests")
struct StateExtensionsTests {
    
    // MARK: - State Data Attributes Tests
    
    @Test("State data attributes with basic configuration")
    func stateDataAttributesBasicConfiguration() {
        let attributes = stateDataAttributes(
            key: "userName",
            scope: .component,
            bindings: []
        )
        
        // Test basic state attribute
        #expect(attributes["data-state"] == "component.userName")
        #expect(attributes.count == 1)
    }
    
    @Test("State data attributes with different scopes")
    func stateDataAttributesWithDifferentScopes() {
        let componentAttributes = stateDataAttributes(key: "value", scope: .component)
        let sharedAttributes = stateDataAttributes(key: "value", scope: .shared)
        let globalAttributes = stateDataAttributes(key: "value", scope: .global)
        let sessionAttributes = stateDataAttributes(key: "value", scope: .session)
        
        // Test different scopes
        #expect(componentAttributes["data-state"] == "component.value")
        #expect(sharedAttributes["data-state"] == "shared.value")
        #expect(globalAttributes["data-state"] == "global.value")
        #expect(sessionAttributes["data-state"] == "session.value")
    }
    
    @Test("State data attributes with toggle binding")
    func stateDataAttributesWithToggleBinding() {
        let attributes = stateDataAttributes(
            key: "isVisible",
            scope: .component,
            bindings: ["toggle"]
        )
        
        // Test toggle binding
        #expect(attributes["data-state"] == "component.isVisible")
        #expect(attributes["data-onclick"] == "component.isVisible.toggle")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with increment binding")
    func stateDataAttributesWithIncrementBinding() {
        let attributes = stateDataAttributes(
            key: "counter",
            scope: .shared,
            bindings: ["increment"]
        )
        
        // Test increment binding
        #expect(attributes["data-state"] == "shared.counter")
        #expect(attributes["data-onclick"] == "shared.counter.increment")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with decrement binding")
    func stateDataAttributesWithDecrementBinding() {
        let attributes = stateDataAttributes(
            key: "score",
            scope: .global,
            bindings: ["decrement"]
        )
        
        // Test decrement binding
        #expect(attributes["data-state"] == "global.score")
        #expect(attributes["data-onclick"] == "global.score.decrement")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with input binding")
    func stateDataAttributesWithInputBinding() {
        let attributes = stateDataAttributes(
            key: "searchTerm",
            scope: .session,
            bindings: ["input"]
        )
        
        // Test input binding
        #expect(attributes["data-state"] == "session.searchTerm")
        #expect(attributes["data-oninput"] == "session.searchTerm.set")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with change binding")
    func stateDataAttributesWithChangeBinding() {
        let attributes = stateDataAttributes(
            key: "selectedOption",
            scope: .component,
            bindings: ["change"]
        )
        
        // Test change binding
        #expect(attributes["data-state"] == "component.selectedOption")
        #expect(attributes["data-onchange"] == "component.selectedOption.set")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with multiple bindings")
    func stateDataAttributesWithMultipleBindings() {
        let attributes = stateDataAttributes(
            key: "multiState",
            scope: .shared,
            bindings: ["toggle", "increment", "input"]
        )
        
        // Test multiple bindings (should only keep the last onclick binding)
        #expect(attributes["data-state"] == "shared.multiState")
        #expect(attributes["data-oninput"] == "shared.multiState.set")
        
        // Since both toggle and increment create onclick bindings, increment should win
        #expect(attributes["data-onclick"] == "shared.multiState.increment")
        #expect(attributes.count == 3)
    }
    
    @Test("State data attributes with unknown binding")
    func stateDataAttributesWithUnknownBinding() {
        let attributes = stateDataAttributes(
            key: "test",
            scope: .component,
            bindings: ["unknown", "toggle"]
        )
        
        // Test that unknown bindings are ignored
        #expect(attributes["data-state"] == "component.test")
        #expect(attributes["data-onclick"] == "component.test.toggle")
        #expect(attributes.count == 2)
    }
    
    @Test("State data attributes with empty bindings")
    func stateDataAttributesWithEmptyBindings() {
        let attributes = stateDataAttributes(
            key: "emptyBindings",
            scope: .global,
            bindings: []
        )
        
        // Test with empty bindings array
        #expect(attributes["data-state"] == "global.emptyBindings")
        #expect(attributes.count == 1)
    }
    
    @Test("State data attributes with default scope")
    func stateDataAttributesWithDefaultScope() {
        let attributes = stateDataAttributes(key: "defaultScope")
        
        // Test default scope (should be .component)
        #expect(attributes["data-state"] == "component.defaultScope")
        #expect(attributes.count == 1)
    }
    
    // MARK: - Integration Tests with Different Key Patterns
    
    @Test("State data attributes with complex key names")
    func stateDataAttributesWithComplexKeyNames() {
        let underscoreKey = stateDataAttributes(key: "user_profile", scope: .shared)
        let camelCaseKey = stateDataAttributes(key: "userName", scope: .component)
        let numberKey = stateDataAttributes(key: "item123", scope: .global)
        let specialKey = stateDataAttributes(key: "form-data", scope: .session)
        
        // Test various key naming patterns
        #expect(underscoreKey["data-state"] == "shared.user_profile")
        #expect(camelCaseKey["data-state"] == "component.userName")
        #expect(numberKey["data-state"] == "global.item123")
        #expect(specialKey["data-state"] == "session.form-data")
    }
    
    @Test("State data attributes for form elements")
    func stateDataAttributesForFormElements() {
        let textInputAttributes = stateDataAttributes(
            key: "firstName",
            scope: .component,
            bindings: ["input"]
        )
        
        let selectAttributes = stateDataAttributes(
            key: "country",
            scope: .shared,
            bindings: ["change"]
        )
        
        let checkboxAttributes = stateDataAttributes(
            key: "newsletter",
            scope: .global,
            bindings: ["toggle"]
        )
        
        let buttonAttributes = stateDataAttributes(
            key: "counter",
            scope: .session,
            bindings: ["increment"]
        )
        
        // Test form element specific bindings
        #expect(textInputAttributes["data-oninput"] == "component.firstName.set")
        #expect(selectAttributes["data-onchange"] == "shared.country.set")
        #expect(checkboxAttributes["data-onclick"] == "global.newsletter.toggle")
        #expect(buttonAttributes["data-onclick"] == "session.counter.increment")
    }
    
    @Test("State data attributes for interactive components")
    func stateDataAttributesForInteractiveComponents() {
        let modalAttributes = stateDataAttributes(
            key: "isModalOpen",
            scope: .component,
            bindings: ["toggle"]
        )
        
        let tabAttributes = stateDataAttributes(
            key: "activeTab",
            scope: .shared,
            bindings: ["change"]
        )
        
        let themeAttributes = stateDataAttributes(
            key: "darkMode",
            scope: .global,
            bindings: ["toggle"]
        )
        
        // Test interactive component bindings
        #expect(modalAttributes["data-onclick"] == "component.isModalOpen.toggle")
        #expect(tabAttributes["data-onchange"] == "shared.activeTab.set")
        #expect(themeAttributes["data-onclick"] == "global.darkMode.toggle")
    }
    
    // MARK: - Performance and Edge Case Tests
    
    @Test("State data attributes with long key names")
    func stateDataAttributesWithLongKeyNames() {
        let longKey = "very_long_state_key_name_that_might_be_used_in_complex_applications"
        let attributes = stateDataAttributes(
            key: longKey,
            scope: .component,
            bindings: ["toggle"]
        )
        
        // Test with long key names
        #expect(attributes["data-state"] == "component.\(longKey)")
        #expect(attributes["data-onclick"] == "component.\(longKey).toggle")
    }
    
    @Test("State data attributes with Unicode characters")
    func stateDataAttributesWithUnicodeCharacters() {
        let unicodeKey = "用户名称" // Chinese characters
        let emojiKey = "user😀profile"
        
        let unicodeAttributes = stateDataAttributes(key: unicodeKey, scope: .shared)
        let emojiAttributes = stateDataAttributes(key: emojiKey, scope: .global)
        
        // Test with Unicode characters
        #expect(unicodeAttributes["data-state"] == "shared.\(unicodeKey)")
        #expect(emojiAttributes["data-state"] == "global.\(emojiKey)")
    }
    
    @Test("State data attributes with empty key")
    func stateDataAttributesWithEmptyKey() {
        let attributes = stateDataAttributes(
            key: "",
            scope: .component,
            bindings: ["toggle"]
        )
        
        // Test with empty key
        #expect(attributes["data-state"] == "component.")
        #expect(attributes["data-onclick"] == "component..toggle")
    }
    
    // MARK: - Binding Combination Tests
    
    @Test("State data attributes with all possible bindings")
    func stateDataAttributesWithAllPossibleBindings() {
        let allBindings = ["toggle", "increment", "decrement", "input", "change"]
        let attributes = stateDataAttributes(
            key: "allBindings",
            scope: .global,
            bindings: allBindings
        )
        
        // Test that all bindings are processed
        #expect(attributes["data-state"] == "global.allBindings")
        #expect(attributes["data-oninput"] == "global.allBindings.set")
        #expect(attributes["data-onchange"] == "global.allBindings.set")
        
        // Only one onclick binding should survive (last one processed)
        #expect(attributes["data-onclick"] == "global.allBindings.decrement")
        
        // Should have state + input + change + onclick = 4 attributes
        #expect(attributes.count == 4)
    }
    
    @Test("State data attributes with duplicate bindings")
    func stateDataAttributesWithDuplicateBindings() {
        let duplicateBindings = ["toggle", "toggle", "increment", "increment"]
        let attributes = stateDataAttributes(
            key: "duplicates",
            scope: .session,
            bindings: duplicateBindings
        )
        
        // Test that duplicates are handled (last one wins)
        #expect(attributes["data-state"] == "session.duplicates")
        #expect(attributes["data-onclick"] == "session.duplicates.increment")
        #expect(attributes.count == 2)
    }
    
    // MARK: - Real-world Usage Scenarios
    
    @Test("State data attributes for shopping cart")
    func stateDataAttributesForShoppingCart() {
        let cartCountAttributes = stateDataAttributes(
            key: "cartItemCount",
            scope: .session,
            bindings: ["increment", "decrement"]
        )
        
        let cartVisibilityAttributes = stateDataAttributes(
            key: "isCartVisible",
            scope: .component,
            bindings: ["toggle"]
        )
        
        // Test shopping cart scenarios
        #expect(cartCountAttributes["data-state"] == "session.cartItemCount")
        #expect(cartCountAttributes["data-onclick"] == "session.cartItemCount.decrement")
        
        #expect(cartVisibilityAttributes["data-state"] == "component.isCartVisible")
        #expect(cartVisibilityAttributes["data-onclick"] == "component.isCartVisible.toggle")
    }
    
    @Test("State data attributes for user preferences")
    func stateDataAttributesForUserPreferences() {
        let themeAttributes = stateDataAttributes(
            key: "userTheme",
            scope: .global,
            bindings: ["change"]
        )
        
        let languageAttributes = stateDataAttributes(
            key: "preferredLanguage",
            scope: .global,
            bindings: ["change"]
        )
        
        let notificationsAttributes = stateDataAttributes(
            key: "notificationsEnabled",
            scope: .global,
            bindings: ["toggle"]
        )
        
        // Test user preference scenarios
        #expect(themeAttributes["data-onchange"] == "global.userTheme.set")
        #expect(languageAttributes["data-onchange"] == "global.preferredLanguage.set")
        #expect(notificationsAttributes["data-onclick"] == "global.notificationsEnabled.toggle")
    }
    
    @Test("State data attributes for form validation")
    func stateDataAttributesForFormValidation() {
        let emailValidAttributes = stateDataAttributes(
            key: "isEmailValid",
            scope: .component,
            bindings: ["input"]
        )
        
        let passwordStrengthAttributes = stateDataAttributes(
            key: "passwordStrength",
            scope: .component,
            bindings: ["input"]
        )
        
        let formSubmittableAttributes = stateDataAttributes(
            key: "canSubmitForm",
            scope: .component,
            bindings: []
        )
        
        // Test form validation scenarios
        #expect(emailValidAttributes["data-oninput"] == "component.isEmailValid.set")
        #expect(passwordStrengthAttributes["data-oninput"] == "component.passwordStrength.set")
        #expect(formSubmittableAttributes["data-state"] == "component.canSubmitForm")
        #expect(formSubmittableAttributes.count == 1) // No bindings
    }
}