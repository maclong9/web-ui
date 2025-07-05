import Foundation
#if canImport(CoreFoundation)
import CoreFoundation
#endif

/// Manages client-side state synchronization and reactive updates in WebUI applications.
///
/// The `StateManager` provides a comprehensive state management solution that:
/// - Manages component-level and application-level state
/// - Generates JavaScript for client-side state synchronization
/// - Provides reactive updates through property wrappers
/// - Handles state persistence and restoration
/// - Integrates seamlessly with WebUI's Element system
///
/// ## Usage
///
/// ```swift
/// @ComponentState var isOpen: Bool = false
/// @SharedState("user") var currentUser: User?
/// 
/// struct DropdownElement: Element {
///     @ComponentState var isExpanded = false
///     
///     var body: some Element {
///         div {
///             button {
///                 "Toggle Dropdown"
///             }
///             .onClick { isExpanded.toggle() }
///             
///             if isExpanded {
///                 div {
///                     // Dropdown content
///                 }
///                 .class("dropdown-menu")
///             }
///         }
///     }
/// }
/// ```
public final class StateManager: @unchecked Sendable {
    
    /// Represents different types of state in the application
    public enum StateScope: String, CaseIterable, Sendable {
        /// Component-level state that is isolated to a specific element instance
        case component = "component"
        /// Shared state that can be accessed across multiple components
        case shared = "shared"
        /// Global application state
        case global = "global"
        /// Session-specific state that persists during the user session
        case session = "session"
    }
    
    /// Configuration for state management behavior
    public struct StateConfiguration: Sendable {
        /// Whether to enable client-side state persistence
        public let enablePersistence: Bool
        /// Storage mechanism for persistent state
        public let storageType: StorageType
        /// Whether to enable state debugging in development
        public let enableDebugging: Bool
        /// Maximum number of state updates to track for debugging
        public let maxDebugHistory: Int
        
        public enum StorageType: String, Sendable {
            case localStorage = "localStorage"
            case sessionStorage = "sessionStorage"
            case memory = "memory"
        }
        
        public init(
            enablePersistence: Bool = true,
            storageType: StorageType = .localStorage,
            enableDebugging: Bool = false,
            maxDebugHistory: Int = 100
        ) {
            self.enablePersistence = enablePersistence
            self.storageType = storageType
            self.enableDebugging = enableDebugging
            self.maxDebugHistory = maxDebugHistory
        }
    }
    
    /// Shared instance for application-wide state management
    public static let shared = StateManager()
    
    private let configuration: StateConfiguration
    private let lock = NSLock()
    private var stateStorage: [String: [String: Any]] = [:]
    private var stateSubscriptions: [String: [(Any) -> Void]] = [:]
    private var stateUpdateHistory: [(key: String, oldValue: Any?, newValue: Any, timestamp: Date)] = []
    
    /// Creates a new state manager with the specified configuration
    ///
    /// - Parameter configuration: Configuration for state management behavior
    public init(configuration: StateConfiguration = StateConfiguration()) {
        self.configuration = configuration
    }
    
    /// Registers a new state value with the specified key and scope
    ///
    /// - Parameters:
    ///   - key: Unique identifier for the state value
    ///   - initialValue: Initial value for the state
    ///   - scope: Scope of the state (component, shared, global, session)
    public func registerState<T: Codable>(
        key: String,
        initialValue: T,
        scope: StateScope = .component
    ) {
        lock.withLock {
            let scopeKey = scope.rawValue
            if stateStorage[scopeKey] == nil {
                stateStorage[scopeKey] = [:]
            }
            
            if stateStorage[scopeKey]![key] == nil {
                stateStorage[scopeKey]![key] = initialValue
                
                if configuration.enableDebugging {
                    recordStateUpdate(key: "\(scopeKey).\(key)", oldValue: nil, newValue: initialValue)
                }
            }
        }
    }
    
    /// Updates a state value and notifies subscribers
    ///
    /// - Parameters:
    ///   - key: Unique identifier for the state value
    ///   - value: New value for the state
    ///   - scope: Scope of the state
    public func updateState<T: Codable>(
        key: String,
        value: T,
        scope: StateScope = .component
    ) {
        lock.withLock {
            let scopeKey = scope.rawValue
            let oldValue = stateStorage[scopeKey]?[key]
            
            if stateStorage[scopeKey] == nil {
                stateStorage[scopeKey] = [:]
            }
            stateStorage[scopeKey]![key] = value
            
            if configuration.enableDebugging {
                recordStateUpdate(key: "\(scopeKey).\(key)", oldValue: oldValue, newValue: value)
            }
        }
        
        // Notify subscribers
        notifySubscribers(key: "\(scope.rawValue).\(key)", value: value)
    }
    
    /// Retrieves a state value
    ///
    /// - Parameters:
    ///   - key: Unique identifier for the state value
    ///   - scope: Scope of the state
    ///   - type: Expected type of the state value
    /// - Returns: The state value if it exists, nil otherwise
    public func getState<T: Codable>(
        key: String,
        scope: StateScope = .component,
        as type: T.Type
    ) -> T? {
        return lock.withLock {
            return stateStorage[scope.rawValue]?[key] as? T
        }
    }
    
    /// Subscribes to state changes for a specific key
    ///
    /// - Parameters:
    ///   - key: State key to subscribe to
    ///   - scope: Scope of the state
    ///   - callback: Callback to invoke when state changes
    /// - Returns: A function to unsubscribe from changes
    public func subscribe<T>(
        to key: String,
        scope: StateScope = .component,
        callback: @escaping (T) -> Void
    ) -> () -> Void {
        let fullKey = "\(scope.rawValue).\(key)"
        
        lock.withLock {
            if stateSubscriptions[fullKey] == nil {
                stateSubscriptions[fullKey] = []
            }
            let callbackWrapper: (Any) -> Void = { value in
                if let typedValue = value as? T {
                    callback(typedValue)
                }
            }
            stateSubscriptions[fullKey]!.append(callbackWrapper)
        }
        
        // Return unsubscribe function (simplified - just returns empty function for now)
        return { }
    }
    
    /// Generates JavaScript code for client-side state management
    ///
    /// - Returns: JavaScript code that implements the state management system
    public func generateJavaScript() -> String {
        let stateData = lock.withLock { stateStorage }
        
        return """
        // WebUI State Manager - Client-side implementation
        (function() {
            'use strict';
            
            class WebUIStateManager {
                constructor() {
                    this.state = \(generateStateJSON(stateData));
                    this.subscribers = new Map();
                    this.updateQueue = [];
                    this.isProcessingUpdates = false;
                    this.enablePersistence = \(configuration.enablePersistence);
                    this.storageType = '\(configuration.storageType.rawValue)';
                    this.enableDebugging = \(configuration.enableDebugging);
                    
                    this.initializeStorage();
                    this.setupWebSocketConnection();
                }
                
                initializeStorage() {
                    if (!this.enablePersistence) return;
                    
                    try {
                        const storage = this.getStorage();
                        const persistedState = storage.getItem('webui-state');
                        if (persistedState) {
                            const parsed = JSON.parse(persistedState);
                            this.state = { ...this.state, ...parsed };
                        }
                    } catch (error) {
                        console.warn('Failed to load persisted state:', error);
                    }
                }
                
                getStorage() {
                    switch (this.storageType) {
                        case 'localStorage': return localStorage;
                        case 'sessionStorage': return sessionStorage;
                        default: return null;
                    }
                }
                
                persistState() {
                    if (!this.enablePersistence) return;
                    
                    try {
                        const storage = this.getStorage();
                        if (storage) {
                            storage.setItem('webui-state', JSON.stringify(this.state));
                        }
                    } catch (error) {
                        console.warn('Failed to persist state:', error);
                    }
                }
                
                setState(scope, key, value) {
                    if (!this.state[scope]) {
                        this.state[scope] = {};
                    }
                    
                    const oldValue = this.state[scope][key];
                    this.state[scope][key] = value;
                    
                    if (this.enableDebugging) {
                        console.log(`State Update: ${scope}.${key}`, { 
                            oldValue, 
                            newValue: value,
                            timestamp: new Date().toISOString()
                        });
                    }
                    
                    this.notifySubscribers(`${scope}.${key}`, value, oldValue);
                    this.persistState();
                    this.queueDOMUpdate(scope, key, value);
                }
                
                getState(scope, key) {
                    return this.state[scope]?.[key];
                }
                
                subscribe(key, callback) {
                    if (!this.subscribers.has(key)) {
                        this.subscribers.set(key, new Set());
                    }
                    this.subscribers.get(key).add(callback);
                    
                    return () => {
                        const callbacks = this.subscribers.get(key);
                        if (callbacks) {
                            callbacks.delete(callback);
                            if (callbacks.size === 0) {
                                this.subscribers.delete(key);
                            }
                        }
                    };
                }
                
                notifySubscribers(key, newValue, oldValue) {
                    const callbacks = this.subscribers.get(key);
                    if (callbacks) {
                        callbacks.forEach(callback => {
                            try {
                                callback(newValue, oldValue);
                            } catch (error) {
                                console.error('Error in state subscriber:', error);
                            }
                        });
                    }
                }
                
                queueDOMUpdate(scope, key, value) {
                    this.updateQueue.push({ scope, key, value });
                    if (!this.isProcessingUpdates) {
                        this.processUpdateQueue();
                    }
                }
                
                async processUpdateQueue() {
                    this.isProcessingUpdates = true;
                    
                    while (this.updateQueue.length > 0) {
                        const updates = this.updateQueue.splice(0);
                        
                        for (const update of updates) {
                            await this.updateDOM(update.scope, update.key, update.value);
                        }
                    }
                    
                    this.isProcessingUpdates = false;
                }
                
                async updateDOM(scope, key, value) {
                    // Update elements with data-state attributes
                    const selector = `[data-state="${scope}.${key}"]`;
                    const elements = document.querySelectorAll(selector);
                    
                    elements.forEach(element => {
                        if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                            if (element.value !== value) {
                                element.value = value;
                            }
                        } else if (element.tagName === 'SELECT') {
                            element.value = value;
                        } else {
                            element.textContent = value;
                        }
                        
                        // Trigger custom event for advanced components
                        element.dispatchEvent(new CustomEvent('webui:state-update', {
                            detail: { scope, key, value }
                        }));
                    });
                    
                    // Handle conditional rendering
                    this.updateConditionalElements(scope, key, value);
                }
                
                updateConditionalElements(scope, key, value) {
                    const conditionalSelector = `[data-if="${scope}.${key}"]`;
                    const conditionalElements = document.querySelectorAll(conditionalSelector);
                    
                    conditionalElements.forEach(element => {
                        const shouldShow = this.evaluateCondition(value);
                        element.style.display = shouldShow ? '' : 'none';
                    });
                }
                
                evaluateCondition(value) {
                    if (typeof value === 'boolean') return value;
                    if (typeof value === 'string') return value.length > 0;
                    if (typeof value === 'number') return value !== 0;
                    if (Array.isArray(value)) return value.length > 0;
                    if (value === null || value === undefined) return false;
                    return Boolean(value);
                }
                
                setupWebSocketConnection() {
                    // Connect to development server WebSocket for hot reload
                    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                        try {
                            const wsUrl = `ws://${window.location.hostname}:3001`;
                            const ws = new WebSocket(wsUrl);
                            
                            ws.onopen = () => {
                                if (this.enableDebugging) {
                                    console.log('WebUI: Connected to development server');
                                }
                            };
                            
                            ws.onmessage = (event) => {
                                try {
                                    const message = JSON.parse(event.data);
                                    if (message.type === 'reload') {
                                        window.location.reload();
                                    } else if (message.type === 'state-update') {
                                        this.setState(message.scope, message.key, message.value);
                                    }
                                } catch (error) {
                                    console.warn('Invalid WebSocket message:', error);
                                }
                            };
                            
                            ws.onerror = () => {
                                // Silently ignore WebSocket errors in production
                            };
                        } catch (error) {
                            // Silently ignore WebSocket connection errors
                        }
                    }
                }
            }
            
            // Global state manager instance
            window.webuiState = new WebUIStateManager();
            
            // Helper functions for components
            window.webuiSetState = (scope, key, value) => {
                window.webuiState.setState(scope, key, value);
            };
            
            window.webuiGetState = (scope, key) => {
                return window.webuiState.getState(scope, key);
            };
            
            window.webuiSubscribe = (scope, key, callback) => {
                return window.webuiState.subscribe(`${scope}.${key}`, callback);
            };
            
            // Auto-setup event listeners when DOM is ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', setupEventListeners);
            } else {
                setupEventListeners();
            }
            
            function setupEventListeners() {
                // Setup automatic event binding for elements with data-on-* attributes
                document.addEventListener('click', handleStateEvent);
                document.addEventListener('change', handleStateEvent);
                document.addEventListener('input', handleStateEvent);
            }
            
            function handleStateEvent(event) {
                const element = event.target;
                const action = element.dataset[`on${event.type.charAt(0).toUpperCase() + event.type.slice(1)}`];
                
                if (action) {
                    try {
                        const [scope, key, operation] = action.split('.');
                        const currentValue = window.webuiState.getState(scope, key);
                        
                        switch (operation) {
                            case 'toggle':
                                window.webuiState.setState(scope, key, !currentValue);
                                break;
                            case 'increment':
                                window.webuiState.setState(scope, key, (currentValue || 0) + 1);
                                break;
                            case 'decrement':
                                window.webuiState.setState(scope, key, (currentValue || 0) - 1);
                                break;
                            case 'set':
                                const newValue = element.value || element.textContent || true;
                                window.webuiState.setState(scope, key, newValue);
                                break;
                        }
                    } catch (error) {
                        console.error('Error handling state event:', error);
                    }
                }
            }
        })();
        """
    }
    
    /// Clears all state for a specific scope
    ///
    /// - Parameter scope: Scope to clear
    public func clearState(scope: StateScope) {
        lock.withLock {
            stateStorage[scope.rawValue] = [:]
        }
    }
    
    /// Gets debug information about state updates
    ///
    /// - Returns: Array of state update history entries
    public func getDebugHistory() -> [(key: String, oldValue: Any?, newValue: Any, timestamp: Date)] {
        return lock.withLock { stateUpdateHistory }
    }
    
    /// Exports state as JSON for client-side hydration
    ///
    /// - Parameter scopes: Scopes to export
    /// - Returns: JSON string containing state data
    public func exportStateJSON(scopes: [StateScope] = StateScope.allCases) -> String {
        let exportData = lock.withLock { () -> [String: [String: Any]] in
            var result: [String: [String: Any]] = [:]
            for scope in scopes {
                result[scope.rawValue] = stateStorage[scope.rawValue] ?? [:]
            }
            return result
        }
        
        return generateStateJSON(exportData)
    }
    
    /// Imports state from JSON (useful for SSR hydration)
    ///
    /// - Parameter json: JSON string containing state data
    public func importStateJSON(_ json: String) {
        guard let data = json.data(using: .utf8),
              let stateData = try? JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] else {
            return
        }
        
        lock.withLock {
            for (scopeKey, scopeState) in stateData {
                stateStorage[scopeKey] = scopeState
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func notifySubscribers<T>(key: String, value: T) {
        let callbacks = lock.withLock { stateSubscriptions[key] ?? [] }
        for callback in callbacks {
            callback(value)
        }
    }
    
    private func recordStateUpdate(key: String, oldValue: Any?, newValue: Any) {
        stateUpdateHistory.append((
            key: key,
            oldValue: oldValue,
            newValue: newValue,
            timestamp: Date()
        ))
        
        // Keep only the most recent updates
        if stateUpdateHistory.count > configuration.maxDebugHistory {
            stateUpdateHistory.removeFirst(stateUpdateHistory.count - configuration.maxDebugHistory)
        }
    }
    
    private func generateStateJSON(_ stateData: [String: [String: Any]]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: stateData, options: [])
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }
}