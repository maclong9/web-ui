import Foundation
import Testing

@testable import WebUI

@Suite("Localization Tests") struct LocalizationTests {

    // MARK: - LocalizationKey Tests

    @Test("LocalizationKey string literal initialization")
    func testLocalizationKeyStringLiteral() {
        let key: LocalizationKey = "welcome_message"

        #expect(key.key == "welcome_message")
        #expect(key.arguments.isEmpty)
        #expect(key.tableName == nil)
        #expect(key.bundle == nil)
    }

    @Test("LocalizationKey with arguments")
    func testLocalizationKeyWithArguments() {
        let key = LocalizationKey("user_count", arguments: ["5", "users"])

        #expect(key.key == "user_count")
        #expect(key.arguments == ["5", "users"])
        #expect(key.tableName == nil)
        #expect(key.bundle == nil)
    }

    @Test("LocalizationKey with table name")
    func testLocalizationKeyWithTableName() {
        let key = LocalizationKey("greeting", tableName: "Common")

        #expect(key.key == "greeting")
        #expect(key.arguments.isEmpty)
        #expect(key.tableName == "Common")
        #expect(key.bundle == nil)
    }

    @Test("LocalizationKey interpolated factory method")
    func testLocalizationKeyInterpolated() {
        let key = LocalizationKey.interpolated("user_count", arguments: ["10"])

        #expect(key.key == "user_count")
        #expect(key.arguments == ["10"])
        #expect(key.tableName == nil)
        #expect(key.bundle == nil)
    }

    @Test("LocalizationKey fromTable factory method")
    func testLocalizationKeyFromTable() {
        let key = LocalizationKey.fromTable("error_message", tableName: "Errors")

        #expect(key.key == "error_message")
        #expect(key.arguments.isEmpty)
        #expect(key.tableName == "Errors")
        #expect(key.bundle == nil)
    }

    // MARK: - LocalizationManager Tests

    @Test("LocalizationManager shared instance")
    func testLocalizationManagerSharedInstance() {
        let manager1 = LocalizationManager.shared
        let manager2 = LocalizationManager.shared

        #expect(manager1 === manager2)  // Same instance
        #expect(manager1.isLocalizationEnabled == true)
    }

    @Test("LocalizationManager localization key detection")
    func testLocalizationKeyDetection() {
        let manager = LocalizationManager.shared

        // Should be detected as localization keys
        #expect(manager.isLikelyLocalizationKey("welcome_message"))
        #expect(manager.isLikelyLocalizationKey("app.title"))
        #expect(manager.isLikelyLocalizationKey("user.profile.name"))
        #expect(manager.isLikelyLocalizationKey("error_code_404"))
        #expect(manager.isLikelyLocalizationKey("button.save_changes"))

        // Should NOT be detected as localization keys
        #expect(!manager.isLikelyLocalizationKey("Hello, world!"))
        #expect(!manager.isLikelyLocalizationKey("This is a long sentence with spaces"))
        #expect(!manager.isLikelyLocalizationKey("X"))  // Too short
        #expect(!manager.isLikelyLocalizationKey(""))  // Empty
        #expect(!manager.isLikelyLocalizationKey("CamelCase"))  // Not lowercase
        #expect(!manager.isLikelyLocalizationKey("Hello World"))  // Has spaces
    }

    @Test("LocalizationManager resolveIfLocalizationKey")
    func testResolveIfLocalizationKey() {
        let manager = LocalizationManager.shared

        // Regular text should be returned as-is
        let regularText = "Hello, world!"
        #expect(manager.resolveIfLocalizationKey(regularText) == regularText)

        // Localization key should be processed (even if not found, it should be attempted)
        let localizationKey = "welcome_message"
        let result = manager.resolveIfLocalizationKey(localizationKey)

        // Since we don't have actual localization files, it should return the key itself
        // but the important thing is that it was processed
        #expect(result == localizationKey)
    }

    @Test("LocalizationManager disabled localization")
    func testDisabledLocalization() {
        let manager = LocalizationManager.shared
        let originalState = manager.isLocalizationEnabled

        // Disable localization
        manager.isLocalizationEnabled = false

        let key = LocalizationKey("test_key")
        let result = manager.resolveKey(key)

        #expect(result == "test_key")  // Should return the key itself when disabled

        // Restore original state
        manager.isLocalizationEnabled = originalState
    }

    // MARK: - FoundationLocalizationResolver Tests

    @Test("FoundationLocalizationResolver basic resolution")
    func testFoundationLocalizationResolver() {
        let resolver = FoundationLocalizationResolver()
        let key = LocalizationKey("test_key")

        let result = resolver.resolveLocalizationKey(key)

        // Since we don't have localization files, NSLocalizedString returns the key
        #expect(result == "test_key")
    }

    @Test("FoundationLocalizationResolver with arguments")
    func testFoundationLocalizationResolverWithArguments() {
        let resolver = FoundationLocalizationResolver()

        // Create a key with format string pattern
        let key = LocalizationKey("user_count", arguments: ["5"])

        let result = resolver.resolveLocalizationKey(key)

        // Since we don't have localization files, it should still attempt interpolation
        // The exact result depends on the internal implementation
        #expect(!result.isEmpty)
    }

    // MARK: - Text Component Localization Tests

    @Test("Text component with regular string")
    func testTextComponentRegularString() {
        let text = Text("Hello, world!")
        let rendered = text.render()

        #expect(rendered.contains("Hello, world!"))
        #expect(rendered.contains("<span>") || rendered.contains("<p>"))
    }

    @Test("Text component with localization key")
    func testTextComponentLocalizationKey() {
        let text = Text("welcome_message")
        let rendered = text.render()

        // Should contain the resolved content (which is the key itself in test environment)
        #expect(rendered.contains("welcome_message"))
        #expect(rendered.contains("<span>") || rendered.contains("<p>"))
    }

    @Test("Text component with explicit localization key")
    func testTextComponentExplicitLocalizationKey() {
        let localizationKey = LocalizationKey("app_title")
        let text = Text(localizationKey: localizationKey)
        let rendered = text.render()

        #expect(rendered.contains("app_title"))
        #expect(rendered.contains("<span>") || rendered.contains("<p>"))
    }

    @Test("Text component with interpolated localization key")
    func testTextComponentInterpolatedLocalizationKey() {
        let localizationKey = LocalizationKey.interpolated("user_count", arguments: ["10"])
        let text = Text(localizationKey: localizationKey)
        let rendered = text.render()

        #expect(!rendered.isEmpty)
        #expect(rendered.contains("<span>") || rendered.contains("<p>"))
    }

    @Test("Text component with localization key from table")
    func testTextComponentLocalizationKeyFromTable() {
        let localizationKey = LocalizationKey.fromTable("greeting", tableName: "Common")
        let text = Text(localizationKey: localizationKey)
        let rendered = text.render()

        #expect(rendered.contains("greeting"))
        #expect(rendered.contains("<span>") || rendered.contains("<p>"))
    }

    // MARK: - Integration Tests

    @Test("Text component localization with attributes")
    func testTextComponentLocalizationWithAttributes() {
        let text = Text(
            "welcome_message",
            id: "welcome",
            classes: ["greeting", "primary"],
            role: .heading,
            label: "Welcome message"
        )
        let rendered = text.render()

        #expect(rendered.contains("welcome_message"))
        #expect(rendered.contains("id=\"welcome\""))
        #expect(rendered.contains("class=\"greeting primary\""))
        #expect(rendered.contains("role=\"heading\""))
        #expect(rendered.contains("aria-label=\"Welcome message\""))
    }

    @Test("Text component explicit localization with attributes")
    func testTextComponentExplicitLocalizationWithAttributes() {
        let localizationKey = LocalizationKey("app_title", tableName: "Main")
        let text = Text(
            localizationKey: localizationKey,
            id: "title",
            classes: ["title"],
            data: ["component": "header"]
        )
        let rendered = text.render()

        #expect(rendered.contains("app_title"))
        #expect(rendered.contains("id=\"title\""))
        #expect(rendered.contains("class=\"title\""))
        #expect(rendered.contains("data-component=\"header\""))
    }

    // MARK: - BundleLocalizationResolver Tests

    @Test("BundleLocalizationResolver initialization")
    func testBundleLocalizationResolver() {
        let bundle = Bundle.main
        let resolver = BundleLocalizationResolver(bundle: bundle)

        let key = LocalizationKey("test_key")
        let result = resolver.resolveLocalizationKey(key)

        // Should use the provided bundle for resolution
        #expect(result == "test_key")  // No localization files in test environment
    }

    @Test("LocalizationManager configuration")
    func testLocalizationManagerConfiguration() {
        let manager = LocalizationManager.shared
        let originalLocale = manager.currentLocale
        let originalResolver = manager.resolver

        // Configure with new locale
        let newLocale = Locale.es
        manager.configure(locale: newLocale)

        #expect(manager.currentLocale.rawValue == "es")

        // Configure with bundle
        let bundle = Bundle.main
        manager.configure(locale: newLocale, bundle: bundle)

        #expect(manager.currentLocale.rawValue == "es")
        #expect(manager.resolver is BundleLocalizationResolver)

        // Restore original state
        manager.currentLocale = originalLocale
        manager.resolver = originalResolver
    }
}
