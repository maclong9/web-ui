import Foundation
import Markdown

/// An enhanced HTML renderer that provides advanced markdown rendering capabilities.
///
/// This renderer extends the basic HTML rendering functionality with support for:
/// - Syntax highlighting with semantic HTML output
/// - Table of contents generation
/// - Interactive code block features (copy button, line numbers, run button)
/// - Typography styling integration
/// - Mathematical notation support
/// - Enhanced accessibility features
///
/// ## Usage
///
/// ```swift
/// let options = MarkdownRenderingOptions.enhanced
/// let typography = MarkdownTypography.documentation
/// var renderer = EnhancedHTMLRenderer(options: options, typography: typography)
/// let html = try renderer.render(document)
/// ```
public struct EnhancedHTMLRenderer {
    
    // MARK: - Configuration
    
    /// Rendering options that control feature availability
    public let options: MarkdownRenderingOptions
    
    /// Typography configuration for styling
    public let typography: MarkdownTypography
    
    /// Generated HTML content
    public var html = ""
    
    /// Table of contents entries collected during rendering
    public var tableOfContentsEntries: [TableOfContentsEntry] = []
    
    /// Counter for generating unique IDs
    private var idCounter = 0
    
    /// Flag indicating whether we're currently processing a table head
    public var insideTableHead = false
    
    // MARK: - Data Structures
    
    /// Represents an entry in the table of contents
    public struct TableOfContentsEntry {
        public let level: Int
        public let text: String
        public let id: String
        public let children: [TableOfContentsEntry]
        
        public init(level: Int, text: String, id: String, children: [TableOfContentsEntry] = []) {
            self.level = level
            self.text = text
            self.id = id
            self.children = children
        }
    }
    
    /// Represents syntax highlighting information for a code block
    public struct SyntaxHighlightInfo {
        public let language: MarkdownRenderingOptions.SupportedLanguage?
        public let fileName: String?
        public let code: String
        public let highlightedHTML: String
        
        public init(language: MarkdownRenderingOptions.SupportedLanguage?, fileName: String?, code: String, highlightedHTML: String) {
            self.language = language
            self.fileName = fileName
            self.code = code
            self.highlightedHTML = highlightedHTML
        }
    }
    
    // MARK: - Initialization
    
    /// Initialize the enhanced HTML renderer
    public init(
        options: MarkdownRenderingOptions,
        typography: MarkdownTypography
    ) {
        self.options = options
        self.typography = typography
    }
    
    // MARK: - Main Rendering Methods
    
    /// Renders a Markdown document into enhanced HTML.
    public mutating func render(_ document: Markdown.Document) throws -> String {
        html = ""
        tableOfContentsEntries = []
        idCounter = 0
        
        // Add wrapper div with typography classes
        html += "<div class=\"markdown-content\">"
        
        try renderMarkup(document)
        
        html += "</div>"
        
        return html
    }
    
    /// Renders a Markdown document with table of contents.
    public mutating func renderWithTableOfContents(_ document: Markdown.Document) throws -> (html: String, tableOfContents: String) {
        let mainHTML = try render(document)
        let tocHTML = generateTableOfContentsHTML()
        return (mainHTML, tocHTML)
    }
    
    // MARK: - Markup Rendering
    
    /// Renders any markup node by dispatching to the appropriate visit method.
    private mutating func renderMarkup(_ markup: Markup) throws {
        switch markup {
        case let heading as Markdown.Heading:
            try visitHeading(heading)
        case let paragraph as Paragraph:
            try visitParagraph(paragraph)
        case let text as Markdown.Text:
            try visitText(text)
        case let link as Markdown.Link:
            try visitLink(link)
        case let emphasis as Markdown.Emphasis:
            try visitEmphasis(emphasis)
        case let strong as Markdown.Strong:
            try visitStrong(strong)
        case let codeBlock as CodeBlock:
            try visitCodeBlock(codeBlock)
        case let inlineCode as InlineCode:
            try visitInlineCode(inlineCode)
        case let listItem as ListItem:
            try visitListItem(listItem)
        case let unorderedList as UnorderedList:
            try visitUnorderedList(unorderedList)
        case let orderedList as OrderedList:
            try visitOrderedList(orderedList)
        case let blockQuote as BlockQuote:
            try visitBlockQuote(blockQuote)
        case let thematicBreak as ThematicBreak:
            try visitThematicBreak(thematicBreak)
        case let image as Markdown.Image:
            try visitImage(image)
        case let table as Table:
            try visitTable(table)
        case let tableHead as Table.Head:
            try visitTableHead(tableHead)
        case let tableRow as Table.Row:
            try visitTableRow(tableRow)
        case let tableBody as Table.Body:
            try visitTableBody(tableBody)
        case let tableCell as Table.Cell:
            try visitTableCell(tableCell)
        case let htmlBlock as Markdown.HTMLBlock:
            try visitHTMLBlock(htmlBlock)
        case let inlineHTML as Markdown.InlineHTML:
            try visitInlineHTML(inlineHTML)
        default:
            try defaultVisit(markup)
        }
    }
    
    /// Renders all child markup nodes of a container.
    private mutating func renderChildren(_ markup: Markup) throws {
        for child in markup.children {
            try renderMarkup(child)
        }
    }
    
    // MARK: - Enhanced Element Visitors
    
    /// Visits a heading node and generates enhanced HTML with optional ToC integration.
    public mutating func visitHeading(_ heading: Markdown.Heading) throws {
        let level = heading.level
        let headingText = heading.plainText
        
        // Generate heading ID if table of contents is enabled
        let headingId: String?
        if options.tableOfContents.isEnabled && options.tableOfContents.includeIds {
            headingId = generateHeadingId(from: headingText)
            
            // Add to table of contents if within max depth
            if level <= options.tableOfContents.maxDepth {
                let entry = TableOfContentsEntry(level: level, text: headingText, id: headingId!)
                tableOfContentsEntries.append(entry)
            }
        } else {
            headingId = nil
        }
        
        // Apply typography styling
        let headingLevel = MarkdownTypography.HeadingLevel(rawValue: level) ?? .h6
        let style = typography.style(for: headingLevel)
        let styleClass = style != nil ? " class=\"\(headingLevel.cssClassName)\"" : ""
        let idAttr = headingId != nil ? " id=\"\(headingId!)\"" : ""
        
        html += "<h\(level)\(idAttr)\(styleClass)>"
        try renderChildren(heading)
        html += "</h\(level)>"
    }
    
    /// Visits a paragraph node and generates HTML with typography styling.
    public mutating func visitParagraph(_ paragraph: Paragraph) throws {
        let style = typography.style(for: .paragraph)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.paragraph.cssClassName)\"" : ""
        
        html += "<p\(styleClass)>"
        try renderChildren(paragraph)
        html += "</p>"
    }
    
    /// Visits a text node and generates escaped HTML content with math support.
    public mutating func visitText(_ text: Markdown.Text) throws {
        let textContent = text.string
        
        // Check for mathematical notation if enabled
        if options.mathSupport.isEnabled {
            let processedText = processMathematicalNotation(textContent)
            html += processedText
        } else {
            html += escapeHTML(textContent)
        }
    }
    
    /// Visits a link node and generates HTML with typography styling.
    public mutating func visitLink(_ link: Markdown.Link) throws {
        guard let destination = link.destination, !destination.isEmpty else {
            throw HtmlRendererError.invalidLinkDestination
        }
        
        let escapedDestination = escapeHTML(destination)
        let isExternal = escapedDestination.hasPrefix("http://") || escapedDestination.hasPrefix("https://")
        let targetAttr = isExternal ? " target=\"_blank\" rel=\"noopener noreferrer\"" : ""
        
        let style = typography.style(for: .link)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.link.cssClassName)\"" : ""
        
        html += "<a href=\"\(escapedDestination)\"\(targetAttr)\(styleClass)>"
        try renderChildren(link)
        html += "</a>"
    }
    
    /// Visits an emphasis node and generates HTML with typography styling.
    public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) throws {
        let style = typography.style(for: .emphasis)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.emphasis.cssClassName)\"" : ""
        
        html += "<em\(styleClass)>"
        try renderChildren(emphasis)
        html += "</em>"
    }
    
    /// Visits a strong node and generates HTML with typography styling.
    public mutating func visitStrong(_ strong: Markdown.Strong) throws {
        let style = typography.style(for: .strong)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.strong.cssClassName)\"" : ""
        
        html += "<strong\(styleClass)>"
        try renderChildren(strong)
        html += "</strong>"
    }
    
    /// Visits a code block node and generates enhanced HTML with syntax highlighting and interactive features.
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) throws {
        guard !codeBlock.code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw HtmlRendererError.invalidCodeBlock
        }
        
        let code = codeBlock.code
        let language = detectLanguage(from: codeBlock.language)
        let fileName = extractFileName(from: codeBlock.language)
        
        // Generate syntax highlighting if enabled
        let highlightInfo: SyntaxHighlightInfo
        if options.syntaxHighlighting.isEnabled, 
           let detectedLanguage = language,
           options.syntaxHighlighting.supportedLanguages.contains(detectedLanguage) {
            let highlightedHTML = generateSyntaxHighlighting(code: code, language: detectedLanguage)
            highlightInfo = SyntaxHighlightInfo(
                language: detectedLanguage,
                fileName: fileName,
                code: code,
                highlightedHTML: highlightedHTML
            )
        } else {
            highlightInfo = SyntaxHighlightInfo(
                language: language,
                fileName: fileName,
                code: code,
                highlightedHTML: escapeHTML(code)
            )
        }
        
        html += generateCodeBlockHTML(highlightInfo: highlightInfo)
    }
    
    /// Visits an inline code node and generates HTML with typography styling.
    public mutating func visitInlineCode(_ inlineCode: InlineCode) throws {
        let style = typography.style(for: .inlineCode)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.inlineCode.cssClassName)\"" : ""
        
        html += "<code\(styleClass)>"
        html += escapeHTML(inlineCode.code)
        html += "</code>"
    }
    
    /// Visits a block quote node and generates HTML with typography styling.
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) throws {
        let style = typography.style(for: .blockquote)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.blockquote.cssClassName)\"" : ""
        
        html += "<blockquote\(styleClass)>"
        try renderChildren(blockQuote)
        html += "</blockquote>"
    }
    
    // MARK: - List and Table Visitors (similar styling patterns)
    
    public mutating func visitListItem(_ listItem: ListItem) throws {
        let style = typography.style(for: .listItem)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.listItem.cssClassName)\"" : ""
        
        html += "<li\(styleClass)>"
        try renderChildren(listItem)
        html += "</li>"
    }
    
    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) throws {
        let style = typography.style(for: .unorderedList)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.unorderedList.cssClassName)\"" : ""
        
        html += "<ul\(styleClass)>"
        try renderChildren(unorderedList)
        html += "</ul>"
    }
    
    public mutating func visitOrderedList(_ orderedList: OrderedList) throws {
        let style = typography.style(for: .orderedList)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.orderedList.cssClassName)\"" : ""
        
        html += "<ol\(styleClass)>"
        try renderChildren(orderedList)
        html += "</ol>"
    }
    
    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) throws {
        let style = typography.style(for: .horizontalRule)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.horizontalRule.cssClassName)\"" : ""
        
        html += "<hr\(styleClass) />"
    }
    
    public mutating func visitImage(_ image: Markdown.Image) throws {
        guard let source = image.source, !source.isEmpty else {
            throw HtmlRendererError.missingImageSource
        }
        
        let altText = image.plainText
        let escapedSource = escapeHTML(source)
        let escapedAltText = escapeHTML(altText)
        
        let style = typography.style(for: .image)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.image.cssClassName)\"" : ""
        
        html += "<img src=\"\(escapedSource)\" alt=\"\(escapedAltText)\"\(styleClass) />"
    }
    
    // MARK: - Table Visitors
    
    public mutating func visitTable(_ table: Table) throws {
        let style = typography.style(for: .table)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.table.cssClassName)\"" : ""
        
        html += "<table\(styleClass)>"
        try renderChildren(table)
        html += "</table>"
    }
    
    public mutating func visitTableHead(_ tableHead: Table.Head) throws {
        html += "<thead><tr>"
        insideTableHead = true
        for child in tableHead.children {
            if let cell = child as? Table.Cell {
                try visitTableCell(cell)
            } else {
                try renderMarkup(child)
            }
        }
        insideTableHead = false
        html += "</tr></thead>"
    }
    
    public mutating func visitTableRow(_ tableRow: Table.Row) throws {
        let style = typography.style(for: .tableRow)
        let styleClass = style != nil ? " class=\"\(MarkdownTypography.ElementType.tableRow.cssClassName)\"" : ""
        
        html += "<tr\(styleClass)>"
        for child in tableRow.children {
            if let cell = child as? Table.Cell {
                try visitTableCell(cell)
            } else {
                try renderMarkup(child)
            }
        }
        html += "</tr>"
    }
    
    public mutating func visitTableBody(_ tableBody: Table.Body) throws {
        html += "<tbody>"
        try renderChildren(tableBody)
        html += "</tbody>"
    }
    
    public mutating func visitTableCell(_ tableCell: Table.Cell) throws {
        let tag = insideTableHead ? "th" : "td"
        let elementType: MarkdownTypography.ElementType = insideTableHead ? .tableHeader : .tableCell
        let style = typography.style(for: elementType)
        let styleClass = style != nil ? " class=\"\(elementType.cssClassName)\"" : ""
        
        html += "<\(tag)\(styleClass)>"
        try renderChildren(tableCell)
        html += "</\(tag)>"
    }
    
    public mutating func visitHTMLBlock(_ htmlBlock: Markdown.HTMLBlock) throws {
        html += htmlBlock.rawHTML
    }
    
    public mutating func visitInlineHTML(_ inlineHTML: Markdown.InlineHTML) throws {
        html += inlineHTML.rawHTML
    }
    
    public mutating func defaultVisit(_ markup: Markup) throws {
        try renderChildren(markup)
    }
    
    // MARK: - Utility Methods
    
    /// Generates a unique ID for a heading based on its text content
    private mutating func generateHeadingId(from text: String) -> String {
        let baseId = text
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "[^a-z0-9-]", with: "", options: .regularExpression)
        
        idCounter += 1
        return "\(baseId)-\(idCounter)"
    }
    
    /// Detects the programming language from a code block's language identifier
    private func detectLanguage(from languageString: String?) -> MarkdownRenderingOptions.SupportedLanguage? {
        guard let lang = languageString?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        // Handle common aliases
        switch lang {
        case "js": return .javascript
        case "ts": return .typescript
        case "sh": return .shell
        case "py": return .python
        case "rb": return .ruby
        case "cpp", "c++": return .cpp
        default:
            return MarkdownRenderingOptions.SupportedLanguage(rawValue: lang)
        }
    }
    
    /// Extracts a filename from the language string (e.g., "swift:MyFile.swift")
    private func extractFileName(from languageString: String?) -> String? {
        guard let lang = languageString, lang.contains(":") else {
            return nil
        }
        
        let components = lang.split(separator: ":", maxSplits: 1)
        return components.count > 1 ? String(components[1]).trimmingCharacters(in: .whitespacesAndNewlines) : nil
    }
    
    /// Generates syntax highlighting HTML for code
    private func generateSyntaxHighlighting(code: String, language: MarkdownRenderingOptions.SupportedLanguage) -> String {
        // This is a simplified syntax highlighter
        // In a real implementation, you might use a proper syntax highlighting library
        return generateBasicSyntaxHighlighting(code: code, language: language)
    }
    
    /// Generates basic syntax highlighting using simple pattern matching
    private func generateBasicSyntaxHighlighting(code: String, language: MarkdownRenderingOptions.SupportedLanguage) -> String {
        let escapedCode = escapeHTML(code)
        
        switch language {
        case .swift:
            return highlightSwiftSyntax(escapedCode)
        case .javascript, .typescript:
            return highlightJavaScriptSyntax(escapedCode)
        case .html:
            return highlightHTMLSyntax(escapedCode)
        case .css:
            return highlightCSSSyntax(escapedCode)
        default:
            return escapedCode
        }
    }
    
    /// Basic Swift syntax highlighting
    private func highlightSwiftSyntax(_ code: String) -> String {
        var highlighted = code
        
        // Keywords
        let keywords = ["func", "var", "let", "class", "struct", "enum", "protocol", "import", "if", "else", "for", "while", "return", "public", "private", "internal"]
        for keyword in keywords {
            highlighted = highlighted.replacingOccurrences(
                of: "\\b\(keyword)\\b",
                with: "<span class=\"keyword\">\(keyword)</span>",
                options: .regularExpression
            )
        }
        
        // Strings
        highlighted = highlighted.replacingOccurrences(
            of: "\"([^\"\\\\]|\\\\.)*\"",
            with: "<span class=\"string\">$0</span>",
            options: .regularExpression
        )
        
        // Comments
        highlighted = highlighted.replacingOccurrences(
            of: "//.*$",
            with: "<span class=\"comment\">$0</span>",
            options: [.regularExpression]
        )
        
        return highlighted
    }
    
    /// Basic JavaScript syntax highlighting
    private func highlightJavaScriptSyntax(_ code: String) -> String {
        var highlighted = code
        
        // Keywords
        let keywords = ["function", "var", "let", "const", "class", "if", "else", "for", "while", "return", "import", "export", "async", "await"]
        for keyword in keywords {
            highlighted = highlighted.replacingOccurrences(
                of: "\\b\(keyword)\\b",
                with: "<span class=\"keyword\">\(keyword)</span>",
                options: .regularExpression
            )
        }
        
        // Strings
        highlighted = highlighted.replacingOccurrences(
            of: "('[^'\\\\]|\\\\.)*'|\"([^\"\\\\]|\\\\.)*\"|`([^`\\\\]|\\\\.)*`",
            with: "<span class=\"string\">$0</span>",
            options: .regularExpression
        )
        
        return highlighted
    }
    
    /// Basic HTML syntax highlighting
    private func highlightHTMLSyntax(_ code: String) -> String {
        var highlighted = code
        
        // HTML tags
        highlighted = highlighted.replacingOccurrences(
            of: "</?[a-zA-Z][^>]*>",
            with: "<span class=\"tag\">$0</span>",
            options: .regularExpression
        )
        
        return highlighted
    }
    
    /// Basic CSS syntax highlighting
    private func highlightCSSSyntax(_ code: String) -> String {
        var highlighted = code
        
        // CSS selectors
        highlighted = highlighted.replacingOccurrences(
            of: "([a-zA-Z][a-zA-Z0-9-]*|\\.[a-zA-Z][a-zA-Z0-9-]*|#[a-zA-Z][a-zA-Z0-9-]*)\\s*\\{",
            with: "<span class=\"selector\">$1</span> {",
            options: .regularExpression
        )
        
        // CSS properties
        highlighted = highlighted.replacingOccurrences(
            of: "([a-zA-Z-]+)\\s*:",
            with: "<span class=\"property\">$1</span>:",
            options: .regularExpression
        )
        
        return highlighted
    }
    
    /// Generates enhanced HTML for code blocks with interactive features
    private func generateCodeBlockHTML(highlightInfo: SyntaxHighlightInfo) -> String {
        var html = ""
        
        // Start pre tag with appropriate classes
        var cssClasses = ["markdown-code-block"]
        if let language = highlightInfo.language {
            cssClasses.append(language.cssClassName)
        }
        if options.codeBlocks.wrapLines {
            cssClasses.append("wrap-lines")
        }
        
        let style = typography.style(for: .codeBlock)
        if style != nil {
            cssClasses.append(MarkdownTypography.ElementType.codeBlock.cssClassName)
        }
        
        html += "<pre class=\"\(cssClasses.joined(separator: " "))\">"
        
        // Add header with filename and controls if enabled
        if options.codeBlocks.showFileName || options.codeBlocks.copyButton || options.codeBlocks.runButton {
            html += "<div class=\"code-block-header\">"
            
            // Filename or language
            if options.codeBlocks.showFileName {
                if let fileName = highlightInfo.fileName {
                    html += "<span class=\"code-filename\">\(escapeHTML(fileName))</span>"
                } else if let language = highlightInfo.language {
                    html += "<span class=\"code-language\">\(language.displayName)</span>"
                }
            }
            
            // Controls
            html += "<div class=\"code-controls\">"
            
            if options.codeBlocks.copyButton {
                html += "<button class=\"copy-button\" type=\"button\" data-copy-text=\"\(escapeHTML(highlightInfo.code))\">"
                html += escapeHTML(options.codeBlocks.copyButtonText)
                html += "</button>"
            }
            
            if options.codeBlocks.runButton && highlightInfo.language == .swift {
                html += "<button class=\"run-button\" type=\"button\" data-run-code=\"\(escapeHTML(highlightInfo.code))\">"
                html += escapeHTML(options.codeBlocks.runButtonText)
                html += "</button>"
            }
            
            html += "</div>"
            html += "</div>"
        }
        
        // Code content
        if options.codeBlocks.lineNumbers {
            let lines = highlightInfo.highlightedHTML.components(separatedBy: .newlines)
            html += "<div class=\"code-content-with-lines\">"
            html += "<div class=\"line-numbers\">"
            for i in 1...lines.count {
                html += "<span class=\"line-number\">\(i)</span>"
            }
            html += "</div>"
            html += "<code class=\"code-content\">\(highlightInfo.highlightedHTML)</code>"
            html += "</div>"
        } else {
            html += "<code>\(highlightInfo.highlightedHTML)</code>"
        }
        
        html += "</pre>"
        
        return html
    }
    
    /// Processes mathematical notation in text content
    private func processMathematicalNotation(_ text: String) -> String {
        var processed = text
        
        // Process inline math ($...$)
        processed = processed.replacingOccurrences(
            of: "\\$([^$]+)\\$",
            with: "<span class=\"math-inline\">$1</span>",
            options: .regularExpression
        )
        
        // Process block math (```math...```)
        processed = processed.replacingOccurrences(
            of: "```math\\n([\\s\\S]*?)\\n```",
            with: "<div class=\"math-block\">$1</div>",
            options: .regularExpression
        )
        
        return escapeHTML(processed)
    }
    
    /// Generates table of contents HTML
    public func generateTableOfContentsHTML() -> String {
        guard !tableOfContentsEntries.isEmpty else {
            return ""
        }
        
        var html = "<aside id=\"table-of-contents\" class=\"markdown-toc\">"
        html += "<nav>"
        html += "<h2>Table of Contents</h2>"
        html += "<ul>"
        
        for entry in tableOfContentsEntries {
            html += "<li>"
            html += "<a href=\"#\(entry.id)\">\(escapeHTML(entry.text))</a>"
            // Note: Nested ToC structure could be added here for hierarchical headings
            html += "</li>"
        }
        
        html += "</ul>"
        html += "</nav>"
        html += "</aside>"
        
        return html
    }
    
    /// Escapes special HTML characters in a string to prevent injection.
    public func escapeHTML(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}