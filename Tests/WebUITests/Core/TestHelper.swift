import Foundation
@testable import WebUI

/// A simple test element implementation for testing the Element protocol
struct TestElement: Element {
    let tag: String
    let id: String?
    let classes: [String]?
    let role: AriaRole?
    let label: String?
    let data: [String: String]?
    let isSelfClosing: Bool
    let customAttributes: [Attribute]?
    let contentBuilder: () -> [any HTML]
    
    init(
        tag: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        isSelfClosing: Bool = false,
        customAttributes: [Attribute]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.tag = tag
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.isSelfClosing = isSelfClosing
        self.customAttributes = customAttributes
        self.contentBuilder = content
    }
    
    var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            additional: customAttributes?.map { $0.toString() } ?? []
        )
        
        let content = contentBuilder().map { $0.render() }.joined()
        
        return AttributeBuilder.renderTag(
            tag,
            attributes: attributes,
            content: content,
            isSelfClosing: isSelfClosing
        )
    }
}