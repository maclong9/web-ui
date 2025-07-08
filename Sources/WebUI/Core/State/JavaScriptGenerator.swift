import Foundation

/// Generates clean vanilla JavaScript code for state management and interactivity.
///
/// The `JavaScriptGenerator` produces modern ES6+ JavaScript that:
/// - Creates reactive state objects using Proxy for change detection
/// - Sets up event listeners for DOM interaction
/// - Provides clean APIs for state updates
/// - Maintains two-way binding between Swift state and browser state
///
/// The generated code follows modern JavaScript standards without requiring
/// any build tools or frameworks.
public struct JavaScriptGenerator: Sendable {

    // MARK: - Main Generation Methods

    /// Generates a complete JavaScript script for all provided states.
    ///
    /// This method creates a self-contained script that includes:
    /// - State initialization and management
    /// - Event listener setup
    /// - DOM update functions
    /// - WebSocket communication for server sync
    ///
    /// - Parameters:
    ///   - states: Dictionary of state ID to state instance
    ///   - configuration: StateManager configuration for customizing output
    /// - Returns: Complete JavaScript code as a string
    public func generateCompleteScript(
        for states: [String: any StateProtocolErased], configuration: StateManager.StateConfiguration
    ) -> String {
        var scriptParts: [String] = []

        // Add the core state management framework
        scriptParts.append(generateStateFramework(configuration: configuration))

        // Add individual state instances
        for (stateID, state) in states {
            scriptParts.append(generateStateScript(for: state, withID: stateID, configuration: configuration))
        }

        // Add initialization code
        scriptParts.append(generateInitializationCode(for: Array(states.keys), configuration: configuration))

        return scriptParts.joined(separator: "\n\n")
    }

    /// Generates a complete JavaScript script for all provided states using default configuration.
    ///
    /// This method creates a self-contained script that includes:
    /// - State initialization and management
    /// - Event listener setup
    /// - DOM update functions
    /// - WebSocket communication for server sync
    ///
    /// - Parameter states: Dictionary of state ID to state instance
    /// - Returns: Complete JavaScript code as a string
    public func generateCompleteScript(for states: [String: any StateProtocolErased]) -> String {
        let defaultConfiguration = StateManager.StateConfiguration()
        return generateCompleteScript(for: states, configuration: defaultConfiguration)
    }

    /// Generates JavaScript for a specific state instance.
    ///
    /// - Parameters:
    ///   - state: The state instance to generate code for
    ///   - stateID: The unique identifier for the state
    ///   - configuration: StateManager configuration for customizing output
    /// - Returns: JavaScript code for the specific state
    public func generateStateScript(
        for state: any StateProtocolErased, withID stateID: String, configuration: StateManager.StateConfiguration
    ) -> String {
        let initialValue = state.currentValue
        let jsonValue = serializeToJSON(initialValue)

        return """
            // State: \(stateID)
            WebUIStateManager.createState('\(stateID)', \(jsonValue));
            """
    }

    /// Generates JavaScript for a specific state instance using default configuration.
    ///
    /// - Parameters:
    ///   - state: The state instance to generate code for
    ///   - stateID: The unique identifier for the state
    /// - Returns: JavaScript code for the specific state
    public func generateStateScript(for state: any StateProtocolErased, withID stateID: String) -> String {
        let defaultConfiguration = StateManager.StateConfiguration()
        return generateStateScript(for: state, withID: stateID, configuration: defaultConfiguration)
    }

    // MARK: - Framework Generation

    /// Generates the core WebUI state management framework in vanilla JavaScript.
    ///
    /// This creates a global `WebUIStateManager` object that manages all application state
    /// using modern JavaScript features like Proxy for reactivity.
    ///
    /// - Parameter configuration: StateManager configuration for customizing output
    /// - Returns: Core framework JavaScript code
    private func generateStateFramework(configuration: StateManager.StateConfiguration) -> String {
        """
        /**
         * WebUI State Management Framework
         * Pure vanilla JavaScript state management with reactive updates
         */
        (function() {
            'use strict';
            
            // Global state storage
            const states = new Map();
            const listeners = new Map();
            const elements = new Map();
            
            // Configuration
            const enablePersistence = \(configuration.enablePersistence);
            const enableDebugging = \(configuration.enableDebugging);
            const storageType = '\(configuration.storageType.rawValue)';
            
            // Create the global WebUIStateManager object
            window.WebUIStateManager = {
                
                /**
                 * Creates a new reactive state instance
                 * @param {string} id - Unique identifier for the state
                 * @param {*} initialValue - Initial value for the state
                 */
                createState(id, initialValue) {
                    // Create reactive proxy for the state
                    const stateProxy = new Proxy({ value: initialValue }, {
                        set(target, property, value) {
                            if (property === 'value') {
                                target[property] = value;
                                this.notifyListeners(id, value);
                                this.updateDOM(id, value);
                                return true;
                            }
                            return false;
                        },
                        
                        get(target, property) {
                            return target[property];
                        }
                    });
                    
                    states.set(id, stateProxy);
                    listeners.set(id, new Set());
                    
                    return stateProxy;
                },
                
                /**
                 * Gets the current value of a state
                 * @param {string} id - State identifier
                 * @returns {*} Current state value
                 */
                getState(id) {
                    const state = states.get(id);
                    return state ? state.value : undefined;
                },
                
                /**
                 * Sets the value of a state
                 * @param {string} id - State identifier
                 * @param {*} value - New value
                 */
                setState(id, value) {
                    const state = states.get(id);
                    if (state) {
                        state.value = value;
                    }
                },
                
                /**
                 * Gets the current value of a state (alias for getState)
                 * @param {string} id - State identifier
                 * @returns {*} Current state value
                 */
                getValue(id) {
                    return this.getState(id);
                },
                
                /**
                 * Sets the value of a state (alias for setState)
                 * @param {string} id - State identifier
                 * @param {*} value - New value
                 */
                setValue(id, value) {
                    this.setState(id, value);
                },
                
                /**
                 * Subscribes to state changes
                 * @param {string} id - State identifier
                 * @param {Function} callback - Callback function to execute on change
                 */
                subscribe(id, callback) {
                    const stateListeners = listeners.get(id);
                    if (stateListeners) {
                        stateListeners.add(callback);
                    }
                },
                
                /**
                 * Unsubscribes from state changes
                 * @param {string} id - State identifier
                 * @param {Function} callback - Callback function to remove
                 */
                unsubscribe(id, callback) {
                    const stateListeners = listeners.get(id);
                    if (stateListeners) {
                        stateListeners.delete(callback);
                    }
                },
                
                /**
                 * Binds a DOM element to a state
                 * @param {string} stateId - State identifier
                 * @param {string} elementId - DOM element ID
                 * @param {string} property - Element property to bind (value, textContent, etc.)
                 */
                bindElement(stateId, elementId, property = 'textContent') {
                    const element = document.getElementById(elementId);
                    if (!element) return;
                    
                    // Store the binding for updates
                    if (!elements.has(stateId)) {
                        elements.set(stateId, new Set());
                    }
                    elements.get(stateId).add({ element, property });
                    
                    // Set initial value
                    const currentValue = this.getState(stateId);
                    if (currentValue !== undefined) {
                        this.updateElementProperty(element, property, currentValue);
                    }
                    
                    // Set up two-way binding for input elements
                    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA' || element.tagName === 'SELECT') {
                        element.addEventListener('input', (event) => {
                            let newValue = event.target.value;
                            
                            // Handle different input types
                            if (element.type === 'checkbox') {
                                newValue = event.target.checked;
                            } else if (element.type === 'number') {
                                newValue = parseFloat(event.target.value) || 0;
                            }
                            
                            this.setState(stateId, newValue);
                        });
                    }
                },
                
                /**
                 * Updates DOM elements bound to a state
                 * @param {string} stateId - State identifier
                 * @param {*} value - New value
                 */
                updateDOM(stateId, value) {
                    const boundElements = elements.get(stateId);
                    if (boundElements) {
                        boundElements.forEach(({ element, property }) => {
                            this.updateElementProperty(element, property, value);
                        });
                    }
                },
                
                /**
                 * Updates a specific property of a DOM element
                 * @param {Element} element - DOM element
                 * @param {string} property - Property to update
                 * @param {*} value - New value
                 */
                updateElementProperty(element, property, value) {
                    switch (property) {
                        case 'textContent':
                            element.textContent = String(value);
                            break;
                        case 'innerHTML':
                            element.innerHTML = String(value);
                            break;
                        case 'value':
                            if (element.type === 'checkbox') {
                                element.checked = Boolean(value);
                            } else {
                                element.value = String(value);
                            }
                            break;
                        case 'checked':
                            element.checked = Boolean(value);
                            break;
                        case 'disabled':
                            element.disabled = Boolean(value);
                            break;
                        default:
                            element.setAttribute(property, String(value));
                    }
                },
                
                /**
                 * Notifies all listeners of a state change
                 * @param {string} id - State identifier
                 * @param {*} value - New value
                 */
                notifyListeners(id, value) {
                    const stateListeners = listeners.get(id);
                    if (stateListeners) {
                        stateListeners.forEach(callback => {
                            try {
                                callback(value);
                            } catch (error) {
                                console.error(`Error in state listener for ${id}:`, error);
                            }
                        });
                    }
                },
                
                /**
                 * Sets up server synchronization via WebSocket
                 * @param {string} url - WebSocket server URL
                 */
                setupServerSync(url = 'ws://localhost:8080/ws') {
                    if (typeof WebSocket === 'undefined') return;
                    
                    const ws = new WebSocket(url);
                    
                    ws.onopen = () => {
                        console.log('WebUI: Connected to development server');
                    };
                    
                    ws.onmessage = (event) => {
                        try {
                            const message = JSON.parse(event.data);
                            if (message.type === 'stateUpdate') {
                                this.setState(message.stateId, message.value);
                            } else if (message.type === 'reload') {
                                window.location.reload();
                            }
                        } catch (error) {
                            console.error('WebUI: Error processing server message:', error);
                        }
                    };
                    
                    ws.onclose = () => {
                        console.log('WebUI: Disconnected from development server');
                        // Attempt to reconnect after 3 seconds
                        setTimeout(() => this.setupServerSync(url), 3000);
                    };
                    
                    // Send state changes to server
                    states.forEach((state, id) => {
                        this.subscribe(id, (value) => {
                            if (ws.readyState === WebSocket.OPEN) {
                                ws.send(JSON.stringify({
                                    type: 'stateChange',
                                    stateId: id,
                                    value: value
                                }));
                            }
                        });
                    });
                },
                
                /**
                 * Debug utility to inspect all states
                 */
                debug() {
                    const stateSnapshot = {};
                    states.forEach((state, id) => {
                        stateSnapshot[id] = state.value;
                    });
                    console.log('WebUI State Snapshot:', stateSnapshot);
                    return stateSnapshot;
                }
            };
            
        })();
        """
    }

    /// Generates initialization code that sets up all states and bindings.
    ///
    /// - Parameters:
    ///   - stateIDs: Array of state identifiers to initialize
    ///   - configuration: StateManager configuration for customizing output
    /// - Returns: JavaScript initialization code
    private func generateInitializationCode(for stateIDs: [String], configuration: StateManager.StateConfiguration)
        -> String
    {
        var initParts: [String] = []

        initParts.append(
            """
            // Initialize WebUI when DOM is ready
            document.addEventListener('DOMContentLoaded', function() {
                // Auto-bind elements with data-webui-state attributes
                document.querySelectorAll('[data-webui-state]').forEach(element => {
                    const stateId = element.getAttribute('data-webui-state');
                    const property = element.getAttribute('data-webui-property') || 'textContent';
                    WebUIStateManager.bindElement(stateId, element.id || element.getAttribute('data-webui-id'), property);
                });
                
                // Set up development server connection in development mode
                if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                    WebUIStateManager.setupServerSync();
                }
                
                console.log('WebUI: State management initialized with states:', [\(stateIDs.map { "'\($0)'" }.joined(separator: ", "))]);
            });
            """)

        return initParts.joined(separator: "\n\n")
    }

    // MARK: - Utilities

    /// Serializes a value to JSON string for JavaScript consumption.
    ///
    /// - Parameter value: The value to serialize
    /// - Returns: JSON string representation
    private func serializeToJSON(_ value: Any) -> String {
        // Handle basic types first
        if let stringValue = value as? String {
            return "\"\(stringValue.replacingOccurrences(of: "\"", with: "\\\""))\""
        } else if let boolValue = value as? Bool {
            return boolValue ? "true" : "false"
        } else if let intValue = value as? Int {
            return String(intValue)
        } else if let doubleValue = value as? Double {
            return String(doubleValue)
        } else if let floatValue = value as? Float {
            return String(floatValue)
        }

        // Try to encode Codable types using JSONEncoder first
        if let codableValue = value as? any Codable {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(AnyEncodable(codableValue))
                return String(data: data, encoding: .utf8) ?? "null"
            } catch {
                // Continue to next approach
            }
        }

        // Try JSON serialization for Foundation types (Array, Dictionary, etc.)
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            return String(data: data, encoding: .utf8) ?? "null"
        } catch {
            // Final fallback - try to convert to string representation
            return "\"\(String(describing: value).replacingOccurrences(of: "\"", with: "\\\""))\""
        }
    }
}

// MARK: - Event Handling Extensions

extension JavaScriptGenerator {

    /// Generates JavaScript for a button click handler that updates state.
    ///
    /// - Parameters:
    ///   - buttonID: ID of the button element
    ///   - stateID: ID of the state to update
    ///   - action: The action to perform (increment, toggle, custom)
    /// - Returns: JavaScript code for the event handler
    public func generateButtonHandler(buttonID: String, stateID: String, action: ButtonAction) -> String {
        let actionCode = generateActionCode(for: action, stateID: stateID)

        return """
            document.getElementById('\(buttonID)').addEventListener('click', function() {
                \(actionCode)
            });
            """
    }

    /// Generates JavaScript for form submission handling.
    ///
    /// - Parameters:
    ///   - formID: ID of the form element
    ///   - stateUpdates: Dictionary of field names to state IDs
    /// - Returns: JavaScript code for form submission
    public func generateFormHandler(formID: String, stateUpdates: [String: String]) -> String {
        let updateCodes = stateUpdates.map { fieldName, stateID in
            "WebUIStateManager.setState('\(stateID)', form['\(fieldName)'].value);"
        }.joined(separator: "\n    ")

        return """
            document.getElementById('\(formID)').addEventListener('submit', function(event) {
                event.preventDefault();
                const form = event.target;
                \(updateCodes)
            });
            """
    }

    private func generateActionCode(for action: ButtonAction, stateID: String) -> String {
        switch action {
            case .increment:
                return "WebUIStateManager.setState('\(stateID)', (WebUIStateManager.getState('\(stateID)') || 0) + 1);"
            case .decrement:
                return "WebUIStateManager.setState('\(stateID)', (WebUIStateManager.getState('\(stateID)') || 0) - 1);"
            case .toggle:
                return "WebUIStateManager.setState('\(stateID)', !WebUIStateManager.getState('\(stateID)'));"
            case .custom(let code):
                return code.replacingOccurrences(of: "$STATE_ID", with: stateID)
        }
    }
}

// MARK: - Supporting Types

/// Represents different types of button actions for JavaScript generation.
public enum ButtonAction {
    case increment
    case decrement
    case toggle
    case custom(String)
}

// MARK: - Helper Types

/// Helper type to encode any Codable value
private struct AnyEncodable: Encodable {
    private let encodableValue: any Encodable

    init(_ value: any Codable) {
        self.encodableValue = value
    }

    func encode(to encoder: Encoder) throws {
        try encodableValue.encode(to: encoder)
    }
}
