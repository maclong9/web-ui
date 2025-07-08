import Foundation

/// Protocol for components that can manage state
public protocol StateManageable {
    /// Optional state manager for this component
    var stateManager: StateManager? { get }
}

/// Extension to Website protocol to add state management capabilities
extension Website {
    /// Global state manager for the entire website
    public var globalState: StateManager? { nil }
    
    /// Generates state scripts for the website
    internal func generateStateScripts(in outputDirectory: URL) throws {
        guard let stateManager = globalState else { return }
        
        // Create scripts directory
        let scriptsDirectory = outputDirectory.appendingPathComponent("scripts")
        try FileManager.default.createDirectory(at: scriptsDirectory, withIntermediateDirectories: true)
        
        // Generate global state script
        let globalStateScript = stateManager.generateJavaScript()
        let globalStateFile = scriptsDirectory.appendingPathComponent("state-global.js")
        
        try globalStateScript.write(to: globalStateFile, atomically: true, encoding: .utf8)
    }
    
    /// Gets the script tag for global state
    internal var globalStateScript: Script? {
        guard globalState != nil else { return nil }
        return Script(src: "/scripts/state-global.js", placement: .head)
    }
}

/// Extension to Document protocol to add state management capabilities
extension Document {
    /// Local state manager for this document
    public var localState: StateManager? { nil }
    
    /// Generates state scripts for the document
    internal func generateStateScripts(in outputDirectory: URL, path: String) throws {
        guard let stateManager = localState else { return }
        
        // Create scripts directory
        let scriptsDirectory = outputDirectory.appendingPathComponent("scripts")
        try FileManager.default.createDirectory(at: scriptsDirectory, withIntermediateDirectories: true)
        
        // Generate document state script
        let documentStateScript = stateManager.generateJavaScript()
        let documentStateFile = scriptsDirectory.appendingPathComponent(stateManager.scope.fileName)
        
        try documentStateScript.write(to: documentStateFile, atomically: true, encoding: .utf8)
    }
    
    /// Gets the script tag for document state
    internal var localStateScript: Script? {
        guard let stateManager = localState else { return nil }
        return Script(src: "/scripts/\(stateManager.scope.fileName)", placement: .head)
    }
}