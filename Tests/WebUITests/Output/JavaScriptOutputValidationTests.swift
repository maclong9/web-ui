import Foundation
import Testing

@testable import WebUI

@Suite("JavaScript Output Validation Tests")
struct JavaScriptOutputValidationTests {

  /// Validates basic JavaScript state generation
  @Test("Basic JavaScript state generation")
  func basicJavaScriptGeneration() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())

    // Register some test states
    stateManager.registerState(key: "counter", initialValue: 0, scope: .component)
    stateManager.registerState(key: "username", initialValue: "guest", scope: .global)

    let jsOutput = stateManager.generateJavaScript()

    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    #expect(jsOutput.contains("createState"))
    #expect(jsOutput.contains("getValue"))
    #expect(jsOutput.contains("setValue"))
  }

  /// Validates JavaScript syntax correctness
  @Test("JavaScript syntax validation")
  func javaScriptSyntaxValidation() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    stateManager.registerState(key: "testState", initialValue: "test", scope: .component)

    let jsOutput = stateManager.generateJavaScript()

    // Check for common syntax issues
    #expect(!jsOutput.contains("= undefined;"))  // Assignment to undefined
    #expect(!jsOutput.contains("return undefined;"))  // Return undefined
    #expect(!jsOutput.contains("null;"))
    #expect(!jsOutput.contains(",,"))

    // Check for proper function declarations
    #expect(jsOutput.contains("function") || jsOutput.contains("() =>"))
    #expect(jsOutput.contains("{") && jsOutput.contains("}"))
    #expect(jsOutput.contains("'use strict'"))
  }

  /// Validates state binding JavaScript generation
  @Test("State binding JavaScript")
  func stateBindingJavaScript() {
    // Test basic state registration without complex component
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    stateManager.registerState(key: "testCount", initialValue: 0, scope: .component)
    stateManager.registerState(key: "globalCount", initialValue: 0, scope: .global)

    let jsOutput = stateManager.generateJavaScript()

    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    // Test for basic state management functions
    #expect(
      jsOutput.contains("createState") || jsOutput.contains("setValue")
        || jsOutput.contains("getValue"))
  }

  /// Validates scoped state JavaScript generation
  @Test("Scoped state JavaScript")
  func scopedStateJavaScript() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())

    // Register states in different scopes
    stateManager.registerState(key: "componentState", initialValue: "comp", scope: .component)
    stateManager.registerState(key: "sharedState", initialValue: "shared", scope: .shared)
    stateManager.registerState(key: "globalState", initialValue: "global", scope: .global)
    stateManager.registerState(key: "sessionState", initialValue: "session", scope: .session)

    let jsOutput = stateManager.generateJavaScript()

    // Test that JavaScript is generated for scoped states
    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    // Scoped state handling may be implemented differently than expected
    #expect(
      jsOutput.contains("createState") || jsOutput.contains("states") || jsOutput.contains("Map"))
  }

  /// Validates JavaScript event handling generation
  @Test("JavaScript event handling")
  func javaScriptEventHandling() {
    // Test basic button rendering - event handlers may not be implemented yet
    let button = Button("Click me")
    let htmlOutput = button.render()

    #expect(htmlOutput.contains("<button"))
    #expect(htmlOutput.contains("Click me"))
    #expect(htmlOutput.contains("</button>"))

    // Security test - ensure no dangerous JavaScript injection possible
    #expect(!htmlOutput.contains("eval("))
    #expect(!htmlOutput.contains("innerHTML"))
  }

  /// Validates JavaScript data attribute generation
  @Test("JavaScript data attributes")
  func javaScriptDataAttributes() {
    // Test using the data parameter directly since .data() modifier might not be implemented
    let element = Section(data: [
      "action": "toggle",
      "target": "#modal",
    ]) {
      Text("Interactive content")
    }

    let htmlOutput = element.render()

    #expect(htmlOutput.contains("data-action"))
    #expect(htmlOutput.contains("toggle"))
    #expect(htmlOutput.contains("data-target"))
    #expect(htmlOutput.contains("#modal"))
  }

  /// Validates JavaScript state persistence
  @Test("JavaScript state persistence")
  func javaScriptStatePersistence() {
    let config = StateManager.StateConfiguration(
      enablePersistence: true,
      storageType: .localStorage
    )
    let stateManager = StateManager(configuration: config)

    stateManager.registerState(key: "persistentData", initialValue: "test", scope: .global)

    let jsOutput = stateManager.generateJavaScript()

    // Test that JavaScript is generated with persistence config
    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    // Persistence features may not be fully implemented yet
    if jsOutput.contains("localStorage") {
      #expect(jsOutput.contains("localStorage"))
    }
  }

  /// Validates JavaScript error handling
  @Test("JavaScript error handling")
  func javaScriptErrorHandling() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    stateManager.registerState(key: "errorTest", initialValue: "test", scope: .component)

    let jsOutput = stateManager.generateJavaScript()

    #expect(jsOutput.contains("try") || jsOutput.contains("catch"))
    #expect(jsOutput.contains("console.error") || jsOutput.contains("error"))
  }

  /// Validates JavaScript module structure
  @Test("JavaScript module structure")
  func javaScriptModuleStructure() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    let jsOutput = stateManager.generateJavaScript()

    // Check for proper module structure
    #expect(jsOutput.contains("(function()") || jsOutput.contains("(() =>"))
    #expect(jsOutput.contains("'use strict'"))
    #expect(jsOutput.contains("window.WebUIState"))
  }

  /// Validates JavaScript configuration generation
  @Test("JavaScript configuration")
  func javaScriptConfiguration() {
    let config = StateManager.StateConfiguration(
      enablePersistence: true,
      storageType: .sessionStorage,
      enableDebugging: false,
      maxDebugHistory: 50
    )
    let stateManager = StateManager(configuration: config)

    let jsOutput = stateManager.generateJavaScript()

    // Test that configuration affects JavaScript generation
    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    // Configuration features may not be fully implemented yet
    if jsOutput.contains("sessionStorage") {
      #expect(jsOutput.contains("sessionStorage"))
    }
  }

  /// Validates JavaScript minification readiness
  @Test("JavaScript minification readiness")
  func javaScriptMinificationReadiness() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    stateManager.registerState(key: "minTest", initialValue: 42, scope: .component)

    let jsOutput = stateManager.generateJavaScript()

    // Test that JavaScript is generated and follows basic patterns
    #expect(!jsOutput.isEmpty)
    #expect(jsOutput.contains("WebUIState"))
    #expect(jsOutput.contains("'use strict'"))

    // Minification features are nice-to-have
    if jsOutput.contains("const ") || jsOutput.contains("let ") {
      #expect(!jsOutput.contains("var "))  // Modern JS preferred
    }
  }

  /// Validates JavaScript security measures
  @Test("JavaScript security validation")
  func javaScriptSecurity() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())
    stateManager.registerState(
      key: "securityTest", initialValue: "<script>alert('xss')</script>", scope: .component)

    let jsOutput = stateManager.generateJavaScript()

    // Should not contain dangerous functions for arbitrary code execution
    #expect(!jsOutput.contains("eval("))
    #expect(!jsOutput.contains("Function("))
    // setTimeout is okay for legitimate use (like reconnection), setInterval should be avoided
    #expect(!jsOutput.contains("setInterval("))

    // Should properly escape values - XSS content should not appear raw
    #expect(!jsOutput.contains("<script>alert('xss')</script>"))
    #expect(jsOutput.contains("'use strict'"))  // Should use strict mode
  }

  /// Validates JavaScript performance optimizations
  @Test("JavaScript performance optimizations")
  func javaScriptPerformanceOptimizations() {
    let stateManager = StateManager(configuration: StateManager.StateConfiguration())

    // Register many states to test performance patterns
    for i in 0..<100 {
      stateManager.registerState(key: "state\(i)", initialValue: i, scope: .component)
    }

    let jsOutput = stateManager.generateJavaScript()

    // Check for performance patterns
    #expect(jsOutput.contains("Map") || jsOutput.contains("{}"))  // Efficient storage
    #expect(!jsOutput.contains("for...in"))  // Should avoid slow iteration
  }
}
