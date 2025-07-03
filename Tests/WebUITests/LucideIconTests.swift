import Testing
import Foundation

@testable import WebUI

@Suite("Lucide Icon Tests") struct LucideIconTests {
    
    // MARK: - LucideIcon Enum Tests
    
    @Test("LucideIcon enum raw values")
    func testLucideIconRawValues() {
        #expect(LucideIcon.airplay.rawValue == "airplay")
        #expect(LucideIcon.arrowLeft.rawValue == "arrow-left")
        #expect(LucideIcon.checkCircle.rawValue == "check-circle")
        #expect(LucideIcon.moreHorizontal.rawValue == "more-horizontal")
        #expect(LucideIcon.shoppingCart.rawValue == "shopping-cart")
    }
    
    @Test("LucideIcon CSS class generation")
    func testLucideIconCSSClass() {
        #expect(LucideIcon.airplay.cssClass == "lucide-airplay")
        #expect(LucideIcon.arrowLeft.cssClass == "lucide-arrow-left")
        #expect(LucideIcon.checkCircle.cssClass == "lucide-check-circle")
        #expect(LucideIcon.github.cssClass == "lucide-github")
    }
    
    @Test("LucideIcon identifier property")
    func testLucideIconIdentifier() {
        #expect(LucideIcon.settings.identifier == "settings")
        #expect(LucideIcon.userPlus.identifier == "user-plus")
        #expect(LucideIcon.fileText.identifier == "file-text")
    }
    
    @Test("LucideIcon display name generation")
    func testLucideIconDisplayName() {
        #expect(LucideIcon.airplay.displayName == "Airplay")
        #expect(LucideIcon.arrowLeft.displayName == "Arrow Left")
        #expect(LucideIcon.checkCircle.displayName == "Check Circle")
        #expect(LucideIcon.userPlus.displayName == "User Plus")
        #expect(LucideIcon.shoppingCart.displayName == "Shopping Cart")
    }
    
    @Test("LucideIcon string literal initialization")
    func testLucideIconStringLiteral() {
        let icon1: LucideIcon = "airplay"
        let icon2: LucideIcon = "check-circle"
        let icon3: LucideIcon = "nonexistent-icon"
        
        #expect(icon1 == .airplay)
        #expect(icon2 == .checkCircle)
        #expect(icon3 == .circle)  // Falls back to default
    }
    
    @Test("LucideIcon description")
    func testLucideIconDescription() {
        #expect(LucideIcon.airplay.description == "airplay")
        #expect(LucideIcon.arrowLeft.description == "arrow-left")
        #expect(LucideIcon.checkCircle.description == "check-circle")
    }
    
    // MARK: - Icon Component Tests
    
    @Test("Icon component with LucideIcon enum")
    func testIconComponentWithEnum() {
        let icon = Icon(.airplay)
        let rendered = icon.render()
        
        #expect(rendered.contains("<i"))
        #expect(rendered.contains("class=\"lucide lucide-airplay\""))
        #expect(rendered.contains("aria-label=\"Airplay\""))
        #expect(rendered.contains("></i>"))
    }
    
    @Test("Icon component with string identifier")
    func testIconComponentWithString() {
        let icon = Icon("heart")
        let rendered = icon.render()
        
        #expect(rendered.contains("<i"))
        #expect(rendered.contains("class=\"lucide lucide-heart\""))
        #expect(rendered.contains("aria-label=\"Heart\""))
        #expect(rendered.contains("></i>"))
    }
    
    @Test("Icon component with size")
    func testIconComponentWithSize() {
        let smallIcon = Icon(.check, size: .small)
        let largeIcon = Icon(.settings, size: .large)
        
        let smallRendered = smallIcon.render()
        let largeRendered = largeIcon.render()
        
        #expect(smallRendered.contains("lucide-sm"))
        #expect(smallRendered.contains("lucide-check"))
        
        #expect(largeRendered.contains("lucide-lg"))
        #expect(largeRendered.contains("lucide-settings"))
    }
    
    @Test("Icon component with custom classes")
    func testIconComponentWithCustomClasses() {
        let icon = Icon(.heart, classes: ["favorite-icon", "text-red-500"])
        let rendered = icon.render()
        
        #expect(rendered.contains("class=\"lucide lucide-heart favorite-icon text-red-500\""))
    }
    
    @Test("Icon component with all attributes")
    func testIconComponentWithAllAttributes() {
        let icon = Icon(
            .settings,
            size: .large,
            id: "settings-icon",
            classes: ["toolbar-icon"],
            role: .button,
            label: "Open settings menu",
            data: ["action": "settings"]
        )
        let rendered = icon.render()
        
        #expect(rendered.contains("id=\"settings-icon\""))
        #expect(rendered.contains("class=\"lucide lucide-settings lucide-lg toolbar-icon\""))
        #expect(rendered.contains("role=\"button\""))
        #expect(rendered.contains("aria-label=\"Open settings menu\""))
        #expect(rendered.contains("data-action=\"settings\""))
    }
    
    @Test("Icon component convenience methods")
    func testIconComponentConvenienceMethods() {
        let smallIcon = Icon.small(.check)
        let largeIcon = Icon.large(.heart, classes: ["favorite"])
        let extraLargeIcon = Icon.extraLarge(.settings, label: "Settings")
        
        let smallRendered = smallIcon.render()
        let largeRendered = largeIcon.render()
        let extraLargeRendered = extraLargeIcon.render()
        
        #expect(smallRendered.contains("lucide-sm"))
        #expect(largeRendered.contains("lucide-lg favorite"))
        #expect(extraLargeRendered.contains("lucide-xl"))
        #expect(extraLargeRendered.contains("aria-label=\"Settings\""))
    }
    
    // MARK: - SystemImage Component Tests
    
    @Test("SystemImage with LucideIcon enum")
    func testSystemImageWithLucideEnum() {
        let systemImage = SystemImage(.airplay)
        let rendered = systemImage.render()
        
        #expect(rendered.contains("<i"))
        #expect(rendered.contains("class=\"lucide lucide-airplay\""))
        #expect(rendered.contains("aria-label=\"Airplay\""))
        #expect(rendered.contains("></i>"))
    }
    
    @Test("SystemImage with Lucide string auto-detection")
    func testSystemImageWithLucideStringDetection() {
        let lucideIcon = SystemImage("heart")
        let systemIcon = SystemImage("checkmark")  // Not in Lucide enum
        
        let lucideRendered = lucideIcon.render()
        let systemRendered = systemIcon.render()
        
        // Lucide icon should use <i> tag and lucide classes
        #expect(lucideRendered.contains("<i"))
        #expect(lucideRendered.contains("lucide lucide-heart"))
        
        // System icon should use <span> tag and system classes
        #expect(systemRendered.contains("<span"))
        #expect(systemRendered.contains("system-image icon-checkmark"))
    }
    
    @Test("SystemImage with custom attributes")
    func testSystemImageWithAttributes() {
        let systemImage = SystemImage(
            .github,
            id: "github-icon",
            classes: ["social-icon"],
            role: .link,
            label: "Visit GitHub profile"
        )
        let rendered = systemImage.render()
        
        #expect(rendered.contains("id=\"github-icon\""))
        #expect(rendered.contains("class=\"lucide lucide-github social-icon\""))
        #expect(rendered.contains("role=\"link\""))
        #expect(rendered.contains("aria-label=\"Visit GitHub profile\""))
    }
    
    // MARK: - Button Component Tests
    
    @Test("Button with LucideIcon systemImage")
    func testButtonWithLucideIcon() {
        let button = Button("Save", systemImage: .check, type: .submit)
        let rendered = button.render()
        
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("<i class=\"lucide lucide-check button-icon\""))
        #expect(rendered.contains(" Save"))
        #expect(rendered.contains("</button>"))
    }
    
    @Test("Button with LucideIcon and attributes")
    func testButtonWithLucideIconAndAttributes() {
        let button = Button(
            "Delete",
            systemImage: .trash,
            onClick: "confirmDelete()",
            id: "delete-btn",
            classes: ["danger-button"],
            label: "Delete item"
        )
        let rendered = button.render()
        
        #expect(rendered.contains("id=\"delete-btn\""))
        #expect(rendered.contains("class=\"danger-button\""))
        #expect(rendered.contains("onclick=\"confirmDelete()\""))
        #expect(rendered.contains("aria-label=\"Delete item\""))
        #expect(rendered.contains("lucide-trash button-icon"))
        #expect(rendered.contains(" Delete"))
    }
    
    @Test("Button with string systemImage (legacy)")
    func testButtonWithStringSystemImage() {
        let button = Button("Save", systemImage: "checkmark")
        let rendered = button.render()
        
        // Should use traditional system image classes
        #expect(rendered.contains("system-image icon-checkmark button-icon"))
        #expect(rendered.contains(" Save"))
    }
    
    // MARK: - LucideStyles Utility Tests
    
    @Test("LucideStyles CDN URL generation")
    func testLucideStylesCDN() {
        #expect(LucideStyles.cdnURL == "https://unpkg.com/lucide-static@latest/font/lucide.css")
        #expect(LucideStyles.cdnURL(version: "0.294.0") == "https://unpkg.com/lucide-static@0.294.0/font/lucide.css")
        
        #expect(LucideStyles.cdn == ["https://unpkg.com/lucide-static@latest/font/lucide.css"])
        #expect(LucideStyles.cdn(version: "0.294.0") == ["https://unpkg.com/lucide-static@0.294.0/font/lucide.css"])
    }
    
    @Test("LucideStyles local path")
    func testLucideStylesLocal() {
        #expect(LucideStyles.localPath == "/css/lucide.css")
        #expect(LucideStyles.local == ["/css/lucide.css"])
    }
    
    @Test("LucideStyles icon detection")
    func testLucideStylesIconDetection() {
        let htmlWithLucideIcons = "<i class=\"lucide lucide-heart\"></i>"
        let htmlWithoutLucideIcons = "<span>No icons here</span>"
        let htmlWithLucideClass = "<div class=\"lucide\">Some content</div>"
        
        #expect(LucideStyles.containsLucideIcons(in: htmlWithLucideIcons))
        #expect(!LucideStyles.containsLucideIcons(in: htmlWithoutLucideIcons))
        #expect(LucideStyles.containsLucideIcons(in: htmlWithLucideClass))
    }
    
    @Test("LucideStyles conditional inclusion")
    func testLucideStylesConditionalInclusion() {
        let htmlWithIcons = "<i class=\"lucide lucide-heart\"></i>"
        let htmlWithoutIcons = "<span>No icons</span>"
        
        let cdnWithIcons = LucideStyles.conditionalCDN(for: htmlWithIcons)
        let cdnWithoutIcons = LucideStyles.conditionalCDN(for: htmlWithoutIcons)
        
        let localWithIcons = LucideStyles.conditionalLocal(for: htmlWithIcons)
        let localWithoutIcons = LucideStyles.conditionalLocal(for: htmlWithoutIcons)
        
        #expect(cdnWithIcons == LucideStyles.cdn)
        #expect(cdnWithoutIcons.isEmpty)
        
        #expect(localWithIcons == LucideStyles.local)
        #expect(localWithoutIcons.isEmpty)
    }
    
    // MARK: - Document Extension Tests
    
    @Test("Document extension Lucide CSS helpers")
    func testDocumentLucideExtensions() {
        struct TestDocument: Document {
            var metadata: Metadata {
                Metadata(site: "Test", title: "Test Page")
            }
            
            var body: some HTML {
                Icon(.heart)
            }
            
            var stylesheets: [String]? {
                ["/css/custom.css"]
            }
        }
        
        let document = TestDocument()
        
        let withCDN = document.withLucideCDN
        let withLocal = document.withLucideLocal
        
        #expect(withCDN.contains("/css/custom.css"))
        #expect(withCDN.contains(LucideStyles.cdnURL))
        
        #expect(withLocal.contains("/css/custom.css"))
        #expect(withLocal.contains(LucideStyles.localPath))
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete icon rendering workflow")
    func testCompleteIconWorkflow() {
        // Test that all icon types render correctly together
        let content = Stack {
            Icon(.heart, size: .large, classes: ["text-red-500"])
            SystemImage(.settings)
            Button("Save", systemImage: .check, type: .submit)
        }
        
        let rendered = content.render()
        
        // Check that all Lucide icons are properly rendered
        #expect(rendered.contains("lucide lucide-heart lucide-lg text-red-500"))
        #expect(rendered.contains("lucide lucide-settings"))
        #expect(rendered.contains("lucide lucide-check button-icon"))
        
        // Verify that Lucide detection works
        #expect(LucideStyles.containsLucideIcons(in: rendered))
    }
    
    @Test("Icon accessibility features")
    func testIconAccessibilityFeatures() {
        let iconWithLabel = Icon(.settings, label: "Open settings menu")
        let iconWithRole = Icon(.search, role: .button)
        let iconDefault = Icon(.heart)
        
        let labelRendered = iconWithLabel.render()
        let roleRendered = iconWithRole.render()
        let defaultRendered = iconDefault.render()
        
        #expect(labelRendered.contains("aria-label=\"Open settings menu\""))
        #expect(roleRendered.contains("role=\"button\""))
        #expect(defaultRendered.contains("aria-label=\"Heart\""))  // Auto-generated from display name
    }
    
    // MARK: - Edge Cases
    
    @Test("Unknown icon handling")
    func testUnknownIconHandling() {
        let unknownIcon = Icon("nonexistent-icon")
        let rendered = unknownIcon.render()
        
        // Should fall back to circle icon
        #expect(rendered.contains("lucide-circle"))
    }
    
    @Test("Empty and nil attributes")
    func testEmptyAndNilAttributes() {
        let icon = Icon(.check, classes: [], data: [:])
        let rendered = icon.render()
        
        #expect(rendered.contains("class=\"lucide lucide-check\""))
        #expect(!rendered.contains("data-"))
    }
}