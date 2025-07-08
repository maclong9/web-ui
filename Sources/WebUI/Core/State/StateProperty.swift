import Foundation

/// Protocol for state properties that can be used in state management
public protocol StateProperty {
    var name: String { get }
    var initialValue: Any { get }
    var jsCode: String { get }
    var jsVariableDeclaration: String { get }
    var jsHelperFunctions: String { get }
}

/// Generic state container for any type
public struct State<T> {
    public let name: String
    public let initialValue: T
    
    public init(_ name: String, _ initialValue: T) {
        self.name = name
        self.initialValue = initialValue
    }
}

/// Boolean state property implementation
public struct BooleanState: StateProperty {
    public let name: String
    public let initialValue: Bool
    
    public init(name: String, initialValue: Bool) {
        self.name = name
        self.initialValue = initialValue
    }
    
    public var jsCode: String {
        """
        \(jsVariableDeclaration)
        \(jsHelperFunctions)
        """
    }
    
    public var jsVariableDeclaration: String {
        "let \(name) = \(initialValue ? "true" : "false");"
    }
    
    public var jsHelperFunctions: String {
        """
        const toggle\(name.capitalized) = () => {
            \(name) = !\(name);
            render();
        };
        """
    }
}

/// String state property implementation
public struct StringState: StateProperty {
    public let name: String
    public let initialValue: String
    
    public init(name: String, initialValue: String) {
        self.name = name
        self.initialValue = initialValue
    }
    
    public var jsCode: String {
        """
        \(jsVariableDeclaration)
        \(jsHelperFunctions)
        """
    }
    
    public var jsVariableDeclaration: String {
        "let \(name) = \"\(initialValue.escapedForJavaScript)\";"
    }
    
    public var jsHelperFunctions: String {
        """
        const set\(name.capitalized) = (value) => {
            \(name) = value;
            render();
        };
        """
    }
}

/// Number state property implementation
public struct NumberState: StateProperty {
    public let name: String
    public let initialValue: Double
    
    public init(name: String, initialValue: Double) {
        self.name = name
        self.initialValue = initialValue
    }
    
    public var jsCode: String {
        """
        \(jsVariableDeclaration)
        \(jsHelperFunctions)
        """
    }
    
    public var jsVariableDeclaration: String {
        "let \(name) = \(initialValue);"
    }
    
    public var jsHelperFunctions: String {
        """
        const set\(name.capitalized) = (value) => {
            \(name) = value;
            render();
        };
        const increment\(name.capitalized) = (by = 1) => {
            \(name) += by;
            render();
        };
        const decrement\(name.capitalized) = (by = 1) => {
            \(name) -= by;
            render();
        };
        """
    }
}

/// Array state property implementation
public struct ArrayState: StateProperty {
    public let name: String
    public let initialValue: [Any]
    
    public init(name: String, initialValue: [Any] = []) {
        self.name = name
        self.initialValue = initialValue
    }
    
    public var jsCode: String {
        """
        \(jsVariableDeclaration)
        \(jsHelperFunctions)
        """
    }
    
    public var jsVariableDeclaration: String {
        let arrayString = initialValue.map { value in
            if let string = value as? String {
                return "\"\(string.escapedForJavaScript)\""
            } else if let number = value as? Double {
                return "\(number)"
            } else if let bool = value as? Bool {
                return bool ? "true" : "false"
            } else {
                return "null"
            }
        }.joined(separator: ", ")
        
        return "let \(name) = [\(arrayString)];"
    }
    
    public var jsHelperFunctions: String {
        """
        const set\(name.capitalized) = (value) => {
            \(name) = value;
            render();
        };
        const add\(name.capitalized) = (item) => {
            \(name).push(item);
            render();
        };
        const remove\(name.capitalized) = (index) => {
            \(name).splice(index, 1);
            render();
        };
        const clear\(name.capitalized) = () => {
            \(name) = [];
            render();
        };
        """
    }
}

/// Object state property implementation
public struct ObjectState: StateProperty {
    public let name: String
    public let initialValue: [String: Any]
    
    public init(name: String, initialValue: [String: Any] = [:]) {
        self.name = name
        self.initialValue = initialValue
    }
    
    public var jsCode: String {
        """
        \(jsVariableDeclaration)
        \(jsHelperFunctions)
        """
    }
    
    public var jsVariableDeclaration: String {
        let objectString = initialValue.map { key, value in
            let jsValue: String
            if let string = value as? String {
                jsValue = "\"\(string.escapedForJavaScript)\""
            } else if let number = value as? Double {
                jsValue = "\(number)"
            } else if let bool = value as? Bool {
                jsValue = bool ? "true" : "false"
            } else {
                jsValue = "null"
            }
            return "\(key): \(jsValue)"
        }.joined(separator: ", ")
        
        return "let \(name) = {\(objectString)};"
    }
    
    public var jsHelperFunctions: String {
        """
        const set\(name.capitalized) = (value) => {
            \(name) = value;
            render();
        };
        const update\(name.capitalized) = (key, value) => {
            \(name)[key] = value;
            render();
        };
        const delete\(name.capitalized) = (key) => {
            delete \(name)[key];
            render();
        };
        """
    }
}

extension String {
    var escapedForJavaScript: String {
        return self
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
    }
}