import Foundation

/// Manages state properties and generates JavaScript code
public struct StateManager {
  private let states: [StateProperty]
  private let scope: StateScope

  public enum StateScope {
    case global
    case document(String)
    case local(String)
  }

  public init(scope: StateScope = .global, @StateBuilder _ builder: () -> [StateProperty]) {
    self.scope = scope
    self.states = builder()
  }

  public init(scope: StateScope = .global, states: [StateProperty]) {
    self.scope = scope
    self.states = states
  }

  /// Generates the complete JavaScript code for state management
  public func generateJavaScript() -> String {
    let stateCode = states.map(\.jsCode).joined(separator: "\n\n")
    let renderFunction = generateRenderFunction()

    return """
      // Generated State Management - \(scope.description)
      \(stateCode)

      \(renderFunction)
      """
  }

  /// Generates state variable declarations only
  public func generateStateDeclarations() -> String {
    return states.map(\.jsVariableDeclaration).joined(separator: "\n")
  }

  /// Generates helper functions only
  public func generateHelperFunctions() -> String {
    return states.map(\.jsHelperFunctions).joined(separator: "\n\n")
  }

  /// Gets all state property names
  public var stateNames: [String] {
    return states.map(\.name)
  }

  /// Gets a specific state property by name
  public func getState(named name: String) -> StateProperty? {
    return states.first { $0.name == name }
  }

  /// Checks if a state property exists
  public func hasState(named name: String) -> Bool {
    return states.contains { $0.name == name }
  }

  private func generateRenderFunction() -> String {
    switch scope {
    case .global:
      return """
        // Global render function
        function render() {
            // Find all elements with template literals and update them
            document.querySelectorAll('[data-state-text]').forEach(element => {
                const template = element.getAttribute('data-state-text');
                element.textContent = eval('`' + template + '`');
            });
            
            // Update visibility based on state
            document.querySelectorAll('[data-state-show]').forEach(element => {
                const condition = element.getAttribute('data-state-show');
                element.style.display = eval(condition) ? 'block' : 'none';
            });
            
            // Update form values
            document.querySelectorAll('[data-state-value]').forEach(element => {
                const stateVar = element.getAttribute('data-state-value');
                if (window[stateVar] !== undefined) {
                    element.value = window[stateVar];
                }
            });
            
            // Custom render hooks
            if (typeof window.onStateRender === 'function') {
                window.onStateRender();
            }
        }
        """
    case .document(let path):
      return """
        // Document render function for: \(path)
        function render() {
            // Find all elements with template literals and update them
            document.querySelectorAll('[data-state-text]').forEach(element => {
                const template = element.getAttribute('data-state-text');
                element.textContent = eval('`' + template + '`');
            });
            
            // Update visibility based on state
            document.querySelectorAll('[data-state-show]').forEach(element => {
                const condition = element.getAttribute('data-state-show');
                element.style.display = eval(condition) ? 'block' : 'none';
            });
            
            // Update form values
            document.querySelectorAll('[data-state-value]').forEach(element => {
                const stateVar = element.getAttribute('data-state-value');
                if (window[stateVar] !== undefined) {
                    element.value = window[stateVar];
                }
            });
            
            // Document-specific render hooks
            if (typeof window.onDocumentRender === 'function') {
                window.onDocumentRender();
            }
        }
        """
    case .local(let elementId):
      return """
        // Local render function for: \(elementId)
        function render() {
            const container = document.getElementById('\(elementId)');
            if (!container) return;
            
            // Find elements within the container
            container.querySelectorAll('[data-state-text]').forEach(element => {
                const template = element.getAttribute('data-state-text');
                element.textContent = eval('`' + template + '`');
            });
            
            container.querySelectorAll('[data-state-show]').forEach(element => {
                const condition = element.getAttribute('data-state-show');
                element.style.display = eval(condition) ? 'block' : 'none';
            });
            
            container.querySelectorAll('[data-state-value]').forEach(element => {
                const stateVar = element.getAttribute('data-state-value');
                if (window[stateVar] !== undefined) {
                    element.value = window[stateVar];
                }
            });
            
            // Local render hooks
            if (typeof window.onLocalRender === 'function') {
                window.onLocalRender('\(elementId)');
            }
        }
        """
    }
  }
}

extension StateManager.StateScope {
  var description: String {
    switch self {
    case .global:
      return "Global"
    case .document(let path):
      return "Document(\(path))"
    case .local(let elementId):
      return "Local(\(elementId))"
    }
  }

  var fileName: String {
    switch self {
    case .global:
      return "state-global.js"
    case .document(let path):
      return "state-\(path.replacingOccurrences(of: "/", with: "-")).js"
    case .local(let elementId):
      return "state-local-\(elementId).js"
    }
  }
}
