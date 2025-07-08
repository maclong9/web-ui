import XCTest
import Foundation
@testable import WebUI

final class StateIntegrationTests: XCTestCase {
    
    var tempOutputDirectory: URL!
    
    override func setUpWithError() throws {
        // Create temporary directory for test output
        tempOutputDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("WebUIStateTests")
            .appendingPathComponent(UUID().uuidString)
        
        try FileManager.default.createDirectory(
            at: tempOutputDirectory,
            withIntermediateDirectories: true
        )
    }
    
    override func tearDownWithError() throws {
        // Clean up temporary directory
        if FileManager.default.fileExists(atPath: tempOutputDirectory.path) {
            try FileManager.default.removeItem(at: tempOutputDirectory)
        }
    }
    
    // MARK: - Test Website with Global State
    
    func testWebsiteWithGlobalState() throws {
        let website = TestWebsiteWithGlobalState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify global state script was generated
        let globalStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-global.js")
        XCTAssertTrue(FileManager.default.fileExists(atPath: globalStateScript.path))
        
        // Verify script content
        let scriptContent = try String(contentsOf: globalStateScript)
        XCTAssertTrue(scriptContent.contains("let darkMode = false;"))
        XCTAssertTrue(scriptContent.contains("let siteName = \"Test Site\";"))
        XCTAssertTrue(scriptContent.contains("const toggleDarkMode = () => {"))
        XCTAssertTrue(scriptContent.contains("const setSiteName = (value) => {"))
        XCTAssertTrue(scriptContent.contains("function render() {"))
    }
    
    // MARK: - Test Document with Local State
    
    func testDocumentWithLocalState() throws {
        let website = TestWebsiteWithDocumentState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify document state script was generated
        let documentStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-counter.js")
        XCTAssertTrue(FileManager.default.fileExists(atPath: documentStateScript.path))
        
        // Verify script content
        let scriptContent = try String(contentsOf: documentStateScript)
        XCTAssertTrue(scriptContent.contains("let counter = 0;"))
        XCTAssertTrue(scriptContent.contains("const setCounter = (value) => {"))
        XCTAssertTrue(scriptContent.contains("const incrementCounter = (by = 1) => {"))
        XCTAssertTrue(scriptContent.contains("const decrementCounter = (by = 1) => {"))
    }
    
    // MARK: - Test Document HTML Generation
    
    func testDocumentHTMLIncludesStateScripts() throws {
        let website = TestWebsiteWithDocumentState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify HTML file includes state scripts
        let indexHTML = tempOutputDirectory.appendingPathComponent("counter.html")
        XCTAssertTrue(FileManager.default.fileExists(atPath: indexHTML.path))
        
        let htmlContent = try String(contentsOf: indexHTML)
        XCTAssertTrue(htmlContent.contains("<script src=\"/scripts/state-global.js\"></script>"))
        XCTAssertTrue(htmlContent.contains("<script src=\"/scripts/state-counter.js\"></script>"))
        XCTAssertTrue(htmlContent.contains("updateStateBindings()"))
    }
    
    // MARK: - Test Element State Bindings
    
    func testElementStateBindingsInHTML() throws {
        let website = TestWebsiteWithElementBindings()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify HTML includes state binding attributes
        let indexHTML = tempOutputDirectory.appendingPathComponent("index.html")
        XCTAssertTrue(FileManager.default.fileExists(atPath: indexHTML.path))
        
        let htmlContent = try String(contentsOf: indexHTML)
        XCTAssertTrue(htmlContent.contains("data-state-text=\"counter\""))
        XCTAssertTrue(htmlContent.contains("data-state-show=\"isVisible\""))
        XCTAssertTrue(htmlContent.contains("onclick=\"incrementCounter()\""))
        XCTAssertTrue(htmlContent.contains("onclick=\"toggleIsVisible()\""))
    }
    
    // MARK: - Test Multiple Documents with Different State
    
    func testMultipleDocumentsWithDifferentState() throws {
        let website = TestWebsiteWithMultipleDocuments()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify multiple state scripts were generated
        let homeStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-index.js")
        let aboutStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-about.js")
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: homeStateScript.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: aboutStateScript.path))
        
        // Verify different state content
        let homeContent = try String(contentsOf: homeStateScript)
        let aboutContent = try String(contentsOf: aboutStateScript)
        
        XCTAssertTrue(homeContent.contains("let welcomeMessage = \"Welcome Home\";"))
        XCTAssertTrue(aboutContent.contains("let aboutText = \"About Us\";"))
        XCTAssertTrue(aboutContent.contains("let teamSize = 5;"))
    }
    
    // MARK: - Test State Script Structure
    
    func testStateScriptStructure() throws {
        let website = TestWebsiteWithGlobalState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify script structure
        let globalStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-global.js")
        let scriptContent = try String(contentsOf: globalStateScript)
        
        // Check for proper sections
        XCTAssertTrue(scriptContent.contains("// Generated State Management - Global"))
        XCTAssertTrue(scriptContent.contains("let darkMode = false;"))
        XCTAssertTrue(scriptContent.contains("const toggleDarkMode = () => {"))
        XCTAssertTrue(scriptContent.contains("function render() {"))
        XCTAssertTrue(scriptContent.contains("document.querySelectorAll('[data-state-text]')"))
        XCTAssertTrue(scriptContent.contains("document.querySelectorAll('[data-state-show]')"))
    }
    
    // MARK: - Test Build Process with No State
    
    func testBuildProcessWithNoState() throws {
        let website = TestWebsiteWithoutState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        // Verify no state scripts were generated
        let scriptsDirectory = tempOutputDirectory.appendingPathComponent("scripts")
        let scriptsExist = FileManager.default.fileExists(atPath: scriptsDirectory.path)
        
        if scriptsExist {
            let scriptFiles = try FileManager.default.contentsOfDirectory(at: scriptsDirectory, includingPropertiesForKeys: nil)
            XCTAssertTrue(scriptFiles.isEmpty, "No state scripts should be generated when no state is defined")
        }
    }
    
    // MARK: - Test Complex State Structure
    
    func testComplexStateStructure() throws {
        let website = TestWebsiteWithComplexState()
        
        // Build the website
        try website.build(to: tempOutputDirectory)
        
        let globalStateScript = tempOutputDirectory.appendingPathComponent("scripts/state-global.js")
        let scriptContent = try String(contentsOf: globalStateScript)
        
        // Test array state
        XCTAssertTrue(scriptContent.contains("let todoItems = [\"Task 1\", \"Task 2\"];"))
        XCTAssertTrue(scriptContent.contains("const addTodoItems = (item) => {"))
        XCTAssertTrue(scriptContent.contains("const removeTodoItems = (index) => {"))
        
        // Test object state
        XCTAssertTrue(scriptContent.contains("let userProfile = {name: \"John\", age: 30};"))
        XCTAssertTrue(scriptContent.contains("const updateUserProfile = (key, value) => {"))
        XCTAssertTrue(scriptContent.contains("const deleteUserProfile = (key) => {"))
    }
}

// MARK: - Test Websites and Documents

struct TestWebsiteWithGlobalState: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var globalState: StateManager? {
        StateManager(scope: .global) {
            BooleanState(name: "darkMode", initialValue: false)
            StringState(name: "siteName", initialValue: "Test Site")
        }
    }
    
    var routes: [any Document] {
        [TestHomeDocument()]
    }
}

struct TestWebsiteWithDocumentState: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var routes: [any Document] {
        [TestCounterDocument()]
    }
}

struct TestWebsiteWithElementBindings: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var routes: [any Document] {
        [TestElementBindingsDocument()]
    }
}

struct TestWebsiteWithMultipleDocuments: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var routes: [any Document] {
        [TestHomeStateDocument(), TestAboutStateDocument()]
    }
}

struct TestWebsiteWithoutState: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var routes: [any Document] {
        [TestSimpleDocument()]
    }
}

struct TestWebsiteWithComplexState: Website {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Test")
    }
    
    var globalState: StateManager? {
        StateManager(scope: .global) {
            ArrayState(name: "todoItems", initialValue: ["Task 1", "Task 2"])
            ObjectState(name: "userProfile", initialValue: ["name": "John", "age": 30])
        }
    }
    
    var routes: [any Document] {
        [TestHomeDocument()]
    }
}

// MARK: - Test Documents

struct TestHomeDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Home")
    }
    
    var path: String? { "index" }
    
    var body: some Markup {
        Body {
            Text("Welcome Home")
        }
    }
}

struct TestCounterDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Counter")
    }
    
    var path: String? { "counter" }
    
    var localState: StateManager? {
        StateManager(scope: .document("counter")) {
            NumberState(name: "counter", initialValue: 0)
        }
    }
    
    var body: some Markup {
        Body {
            Text("Counter App")
        }
    }
}

struct TestElementBindingsDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Element Bindings")
    }
    
    var path: String? { "index" }
    
    var localState: StateManager? {
        StateManager(scope: .document("index")) {
            NumberState(name: "counter", initialValue: 0)
            BooleanState(name: "isVisible", initialValue: true)
        }
    }
    
    var body: some Markup {
        Body {
            // These would use hypothetical element extension methods
            Text("Counter: ").text(from: "counter")
            Button("Increment").action(.increment("counter"))
            Button("Toggle").action(.toggle("isVisible"))
            Text("Conditional Text").show(when: "isVisible")
        }
    }
}

struct TestHomeStateDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Home")
    }
    
    var path: String? { "index" }
    
    var localState: StateManager? {
        StateManager(scope: .document("index")) {
            StringState(name: "welcomeMessage", initialValue: "Welcome Home")
        }
    }
    
    var body: some Markup {
        Body {
            Text("Home Page")
        }
    }
}

struct TestAboutStateDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "About")
    }
    
    var path: String? { "about" }
    
    var localState: StateManager? {
        StateManager(scope: .document("about")) {
            StringState(name: "aboutText", initialValue: "About Us")
            NumberState(name: "teamSize", initialValue: 5)
        }
    }
    
    var body: some Markup {
        Body {
            Text("About Page")
        }
    }
}

struct TestSimpleDocument: Document {
    var metadata: Metadata {
        Metadata(site: "Test Site", title: "Simple")
    }
    
    var path: String? { "index" }
    
    var body: some Markup {
        Body {
            Text("Simple page without state")
        }
    }
}