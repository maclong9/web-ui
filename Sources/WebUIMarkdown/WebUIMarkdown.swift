import Foundation
import Logging
import Markdown

/// A module for parsing and rendering Markdown content with front matter support.
///
/// This module provides functionality to transform Markdown text into HTML and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
/// A module for parsing and rendering Markdown content with front matter support and configurable code block rendering.
///
/// This module provides functionality to transform Markdown text into HTML and extract
/// front matter metadata, making it suitable for content-driven websites and applications.
/// Code block rendering features such as syntax highlighting, filename display, copy button,
/// and line numbers can be enabled or disabled via boolean flags.
public struct WebUIMarkdown {
    /// Logger instance for tracking events within WebUIMarkdown
    private let logger: Logger

    /// Whether to display the filename at the top of code blocks.
    public let showCodeFilename: Bool
    /// Whether to display a copy button for code blocks.
    public let showCopyButton: Bool
    /// Whether to display line numbers for code blocks.
    public let showLineNumbers: Bool
    /// Whether to enable syntax highlighting for code blocks.
    public let enableSyntaxHighlighting: Bool

    /// Initializes a WebUIMarkdown instance with configurable code block options and a custom or default logger.
    ///
    /// - Parameters:
    ///   - logger: The logger to use for tracking events. If nil, a default logger is created.
    ///   - showCodeFilename: Whether to display the filename at the top of code blocks. Default is true.
    ///   - showCopyButton: Whether to display a copy button for code blocks. Default is true.
    ///   - showLineNumbers: Whether to display line numbers for code blocks. Default is true.
    ///   - enableSyntaxHighlighting: Whether to enable syntax highlighting for code blocks. Default is true.
    public init(
        logger: Logger? = nil,
        showCodeFilename: Bool = true,
        showCopyButton: Bool = true,
        showLineNumbers: Bool = true,
        enableSyntaxHighlighting: Bool = true
    ) {
        self.logger = logger ?? Logger(label: "com.webui.markdown")
        self.logger.info("WebUIMarkdown initialized")
        self.showCodeFilename = showCodeFilename
        self.showCopyButton = showCopyButton
        self.showLineNumbers = showLineNumbers
        self.enableSyntaxHighlighting = enableSyntaxHighlighting
    }

    /// A structure representing a parsed Markdown document, containing front matter and HTML content.
    ///
    /// Encapsulates the results of parsing a Markdown document, providing access to both
    /// the extracted metadata (front matter) and the rendered HTML content.
    public struct ParsedMarkdown {
        /// The metadata extracted from the front matter section of the document.
        public let frontMatter: [String: Any]

        /// The HTML content generated from the Markdown body.
        public let htmlContent: String

        /// Initializes a `ParsedMarkdown` instance with front matter and HTML content.
        ///
        /// - Parameters:
        ///   - frontMatter: The parsed front matter as a dictionary mapping string keys to values.
        ///   - htmlContent: The HTML content generated from the Markdown body.
        public init(frontMatter: [String: Any], htmlContent: String) {
            self.frontMatter = frontMatter
            self.htmlContent = htmlContent
        }
    }

    /// Parses a Markdown string into front matter and HTML content.
    ///
    /// This method processes a Markdown string, separating the front matter (if present) and converting
    /// the Markdown content into HTML. It handles the complete workflow from extracting front matter
    /// to rendering the final HTML.
    ///
    /// - Parameter content: The raw Markdown string to parse.
    /// - Returns: A `ParsedMarkdown` instance containing the parsed front matter and HTML content.
    public func parseMarkdown(_ content: String) -> ParsedMarkdown {
        logger.debug("Starting to parse markdown content")
        let (frontMatter, markdownContent) = extractFrontMatter(from: content)
        logger.debug("Front matter extracted with \(frontMatter.count) key-value pairs")

        // Parse the markdown content to HTML
        logger.debug("Converting markdown content to HTML")
        let document = Markdown.Document(parsing: markdownContent)
        var renderer = HtmlRenderer(
            logger: logger,
            showCodeFilename: showCodeFilename,
            showCopyButton: showCopyButton,
            showLineNumbers: showLineNumbers,
            enableSyntaxHighlighting: enableSyntaxHighlighting
        )
        let html = renderer.render(document)
        logger.debug("HTML rendering complete - generated \(html.count) characters")

        return ParsedMarkdown(frontMatter: frontMatter, htmlContent: html)
    }

    /// Extracts front matter and Markdown content from a raw Markdown string.
    ///
    /// The front matter is expected to be enclosed in `---` delimiters at the start of the string.
    /// If no front matter is present, an empty dictionary is returned, and the entire string is treated
    /// as Markdown content.
    ///
    /// - Parameter content: The raw Markdown string.
    /// - Returns: A tuple containing the parsed front matter as a dictionary and the remaining Markdown content.
    public func extractFrontMatter(from content: String) -> ([String: Any], String) {
        logger.debug("Extracting front matter from content")
        let lines = content.components(separatedBy: .newlines)
        var frontMatter: [String: Any] = [:]
        var contentStartIndex = 0

        // Check if the string starts with front matter (---)
        if lines.first?.trimmingCharacters(in: .whitespaces) == "---" {
            logger.debug("Front matter delimiter found at start of content")
            var frontMatterLines: [String] = []
            var foundEndDelimiter = false

            // Collect lines until the closing ---
            for (index, line) in lines.dropFirst().enumerated() {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                if trimmedLine == "---" {
                    foundEndDelimiter = true
                    contentStartIndex = index + 2  // Skip the --- line
                    logger.debug("End front matter delimiter found at line \(index + 2)")
                    break
                }
                frontMatterLines.append(line)
            }

            if foundEndDelimiter {
                // Parse front matter lines into a dictionary
                logger.debug("Parsing \(frontMatterLines.count) lines of front matter")
                frontMatter = parseFrontMatterLines(frontMatterLines)
            } else {
                logger.warning("Front matter started but end delimiter not found")
            }
        } else {
            logger.debug("No front matter found in content")
        }

        // Join the remaining lines for the markdown content
        let markdownContent = lines[contentStartIndex...].joined(separator: "\n")
        logger.debug("Extracted \(markdownContent.count) characters of markdown content")
        return (frontMatter, markdownContent)
    }

    /// Parses front matter lines into a key-value dictionary.
    ///
    /// This method processes lines of front matter, splitting each line on the first colon to create
    /// key-value pairs. It also attempts to parse date values for keys containing "date" or "published".
    ///
    /// - Parameter lines: An array of strings representing front matter lines.
    /// - Returns: A dictionary containing the parsed key-value pairs.
    public func parseFrontMatterLines(_ lines: [String]) -> [String: Any] {
        var frontMatter: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        logger.debug("Parsing \(lines.count) front matter lines")
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty {
                logger.trace("Skipping empty line at index \(index)")
                continue
            }

            // Split on the first colon to separate key and value
            let components = trimmed.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
            guard components.count == 2 else {
                logger.warning("Invalid front matter format at line \(index): \(trimmed)")
                continue
            }

            let key = components[0].trimmingCharacters(in: .whitespaces).lowercased()
            let valueString = components[1].trimmingCharacters(in: .whitespaces)

            // Attempt to parse the value as a date if the key suggests it
            if key.contains("date") || key == "published",
                let date = dateFormatter.date(from: valueString)
            {
                logger.trace("Parsed date value for key '\(key)': \(valueString)")
                frontMatter[key] = date
            } else {
                // Store as string by default
                logger.trace("Stored string value for key '\(key)': \(valueString)")
                frontMatter[key] = valueString
            }
        }

        logger.debug("Front matter parsing complete: \(frontMatter.count) key-value pairs extracted")
        return frontMatter
    }
}

/// A renderer that converts a Markdown Abstract Syntax Tree (AST) into HTML.
///
/// `HtmlRenderer` walks through the Markdown document structure and generates appropriate
/// HTML tags for each Markdown element, with special handling for links, code blocks,
/// and other formatting constructs.
/// A renderer that converts a Markdown Abstract Syntax Tree (AST) into HTML with configurable code block rendering options.
///
/// `HtmlRenderer` walks through the Markdown document structure and generates appropriate
/// HTML tags for each Markdown element, with special handling for links, code blocks,
/// and other formatting constructs. Code block rendering features such as syntax highlighting,
/// filename display, copy button, and line numbers can be enabled or disabled via boolean flags.
public struct HtmlRenderer: MarkupWalker {
    public var html = ""
    private let logger: Logger
    public let showCodeFilename: Bool
    public let showCopyButton: Bool
    public let showLineNumbers: Bool
    public let enableSyntaxHighlighting: Bool

    /// Initializes a HtmlRenderer with a logger and code block rendering options.
    ///
    /// - Parameters:
    ///   - logger: The logger to use for tracking the rendering process.
    ///   - showCodeFilename: Whether to display the filename at the top of code blocks.
    ///   - showCopyButton: Whether to display a copy button for code blocks.
    ///   - showLineNumbers: Whether to display line numbers for code blocks.
    ///   - enableSyntaxHighlighting: Whether to enable syntax highlighting for code blocks.
    public init(
        logger: Logger = Logger(label: "com.webui.markdown.renderer"),
        showCodeFilename: Bool = true,
        showCopyButton: Bool = true,
        showLineNumbers: Bool = true,
        enableSyntaxHighlighting: Bool = true
    ) {
        self.logger = logger
        self.showCodeFilename = showCodeFilename
        self.showCopyButton = showCopyButton
        self.showLineNumbers = showLineNumbers
        self.enableSyntaxHighlighting = enableSyntaxHighlighting
        logger.debug("HtmlRenderer initialized")
    }

    /// Renders a Markdown document into HTML.
    ///
    /// Traverses the entire document tree and converts each node into its corresponding HTML representation.
    ///
    /// - Parameter document: The Markdown document to render.
    /// - Returns: The generated HTML string.
    public mutating func render(_ document: Markdown.Document) -> String {
        logger.debug("Starting HTML rendering")
        html = ""
        visit(document)
        logger.debug("HTML rendering complete, generated \(html.count) characters")
        return html
    }

    /// Visits a heading node and generates corresponding HTML.
    public mutating func visitHeading(_ heading: Markdown.Heading) {
        let level = heading.level
        logger.trace("Rendering h\(level) heading")
        html += "<h\(level)>"
        descendInto(heading)
        html += "</h\(level)>"
    }

    /// Visits a paragraph node and generates corresponding HTML.
    public mutating func visitParagraph(_ paragraph: Paragraph) {
        logger.trace("Rendering paragraph")
        html += "<p>"
        descendInto(paragraph)
        html += "</p>"
    }

    /// Visits a text node and generates escaped HTML content.
    public mutating func visitText(_ text: Markdown.Text) {
        logger.trace("Rendering text: \(text.string.prefix(20))...")
        html += escapeHTML(text.string)
    }

    /// Visits a link node and generates corresponding HTML.
    public mutating func visitLink(_ link: Markdown.Link) {
        let destination = escapeHTML(link.destination ?? "")
        let isExternal = destination.hasPrefix("http://") || destination.hasPrefix("https://")
        let targetAttr = isExternal ? " target=\"_blank\" rel=\"noopener noreferrer\"" : ""
        logger.trace("Rendering link to \(destination) (external: \(isExternal))")
        html += "<a href=\"\(destination)\"\(targetAttr)>"
        descendInto(link)
        html += "</a>"
    }

    /// Visits an emphasis node and generates corresponding HTML.
    public mutating func visitEmphasis(_ emphasis: Markdown.Emphasis) {
        logger.trace("Rendering emphasis")
        html += "<em>"
        descendInto(emphasis)
        html += "</em>"
    }

    /// Visits a strong node and generates corresponding HTML.
    public mutating func visitStrong(_ strong: Markdown.Strong) {
        logger.trace("Rendering strong emphasis")
        html += "<strong>"
        descendInto(strong)
        html += "</strong>"
    }

    /// Visits a code block node and generates corresponding HTML with optional syntax highlighting, filename, copy button, and line numbers.
    ///
    /// - Parameter codeBlock: The code block node to render.
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
        let language = codeBlock.language ?? ""
        logger.trace("Rendering code block with language: \(language)")
        let (filename, codeWithoutFilename) = extractFilename(from: codeBlock.code, language: language)
        
        // Count the number of lines for line numbers - ensure we count the right number of lines
        // Handle empty lines at the end properly
        let lines = codeWithoutFilename.components(separatedBy: .newlines)
        let lineCount = codeWithoutFilename.isEmpty ? 0 : (codeWithoutFilename.hasSuffix("\n") ? lines.count - 1 : lines.count)
        
        // Build the HTML for the code block
        html += "<div class=\"code-block-wrapper\">"
        
        // Add filename if available and enabled
        if showCodeFilename, let filename = filename {
            html += "<div class=\"code-language\">\(filename)</div>"
        }
        
        // Add copy button if enabled
        if showCopyButton {
            html += "<button class=\"copy-button\" onclick=\"navigator.clipboard.writeText(this.parentElement.querySelector('code').innerText)\">Copy</button>"
        }
        
        if showLineNumbers {
            // Generate line numbers HTML - ensure we have the right count
            let lineNumbersHTML = lineCount > 0 
                ? (1...lineCount).map { "<span>\($0)</span>" }.joined(separator: "\n")
                : "<span>1</span>" // At least one line number for empty blocks
            
            html += "<pre class=\"line-numbers\"><div class=\"line-numbers-container\">\(lineNumbersHTML)</div>"
        } else {
            html += "<pre>"
        }
        
        // Add the code with syntax highlighting
        html += "<code class=\"language-\(language)\">"
        
        if enableSyntaxHighlighting {
            html += applySyntaxHighlighting(codeWithoutFilename, language: language)
        } else {
            // Escape HTML in the code to prevent injection if not highlighting
            html += escapeHTML(codeWithoutFilename)
        }
        
        html += "</code></pre>"
        html += "</div>"
    }

    /// Visits an inline code node and generates corresponding HTML.
    public mutating func visitInlineCode(_ inlineCode: InlineCode) {
        logger.trace("Rendering inline code")
        html += "<code>"
        html += escapeHTML(inlineCode.code)
        html += "</code>"
    }

    /// Visits a list item node and generates corresponding HTML.
    public mutating func visitListItem(_ listItem: ListItem) {
        logger.trace("Rendering list item")
        html += "<li>"
        descendInto(listItem)
        html += "</li>"
    }

    /// Visits an unordered list node and generates corresponding HTML.
    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
        logger.trace("Rendering unordered list")
        html += "<ul>"
        descendInto(unorderedList)
        html += "</ul>"
    }

    /// Visits an ordered list node and generates corresponding HTML.
    public mutating func visitOrderedList(_ orderedList: OrderedList) {
        logger.trace("Rendering ordered list")
        html += "<ol>"
        descendInto(orderedList)
        html += "</ol>"
    }

    /// Visits a block quote node and generates corresponding HTML.
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
        logger.trace("Rendering blockquote")
        html += "<blockquote>"
        descendInto(blockQuote)
        html += "</blockquote>"
    }

    /// Visits a thematic break node and generates corresponding HTML.
    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
        logger.trace("Rendering horizontal rule")
        html += "<hr />"
    }

    /// Visits an image node and generates corresponding HTML.
    public mutating func visitImage(_ image: Markdown.Image) {
        let altText = image.plainText
        let source = image.source ?? ""
        logger.trace("Rendering image: \(source)")
        html += "<img src=\"\(source)\" alt=\"\(altText)\" />"
    }

    /// Visits a table node and generates corresponding HTML.
    public mutating func visitTable(_ table: Table) {
        logger.trace("Rendering table")
        html += "<table>"
        descendInto(table)
        html += "</table>"
    }

    /// Visits a table head node and generates corresponding HTML.
    public mutating func visitTableHead(_ tableHead: Table.Head) {
        logger.trace("Rendering table head")
        html += "<thead><tr>"
        insideTableHead = true
        for child in tableHead.children {
            if let cell = child as? Table.Cell {
                visitTableCell(cell)
            } else {
                descendInto(child)
            }
        }
        insideTableHead = false
        html += "</tr></thead>"
    }

    /// Visits a table row node and generates corresponding HTML.
    public mutating func visitTableRow(_ tableRow: Table.Row) {
        logger.trace("Rendering table row")
        html += "<tr>"
        for child in tableRow.children {
            if let cell = child as? Table.Cell {
                visitTableCell(cell)
            } else {
                descendInto(child)
            }
        }
        html += "</tr>"
    }

    /// Visits a table body node and generates corresponding HTML.
    public mutating func visitTableBody(_ tableBody: Table.Body) {
        logger.trace("Rendering table body")
        html += "<tbody>"
        descendInto(tableBody)
        html += "</tbody>"
    }

    /// A flag indicating whether the renderer is currently processing a table head.
    public var insideTableHead = false

    /// Visits a table cell node and generates corresponding HTML.
    public mutating func visitTableCell(_ tableCell: Table.Cell) {
        let tag = insideTableHead ? "th" : "td"
        logger.trace("Rendering table \(tag) cell")
        html += "<\(tag)>"
        descendInto(tableCell)
        html += "</\(tag)>"
    }

    /// A fallback method for visiting any unhandled markup nodes.
    public mutating func defaultVisit(_ markup: Markup) {
        logger.trace("Visiting unhandled markup node: \(type(of: markup))")
        descendInto(markup)
    }

    /// Escapes special HTML characters in a string to prevent injection.
    ///
    /// - Parameter string: The string to escape.
    /// - Returns: The escaped HTML string.
    public func escapeHTML(_ string: String) -> String {
        logger.trace("Escaping HTML characters in string (\(string.count) characters)")
        return
            string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
    
    /// Unescapes HTML span tags used for syntax highlighting while keeping other HTML escaping intact
    /// - Parameter string: The string containing escaped HTML span tags
    /// - Returns: A string with span tags unescaped but other HTML escaping intact


    /// Extracts a filename from the first line of the code block if it matches a comment convention for the language.
    ///
    /// - Parameters:
    ///   - code: The code block string.
    ///   - language: The language identifier.
    /// - Returns: A tuple of (filename, codeWithoutFilename).
    public func extractFilename(from code: String, language: String) -> (String?, String) {
        let lines = code.components(separatedBy: .newlines)
        guard let first = lines.first else { return (nil, code) }
        let trimmed = first.trimmingCharacters(in: .whitespaces)
        let filename: String?
        let pattern: String
        switch language {
        case "sh":
            pattern = #"^#\s*([\w\-.]+\.(sh|bash))$"#
        case "swift":
            pattern = #"^//\s*([\w\-.]+\.swift)$"#
        case "yml", "yaml":
            pattern = #"^#\s*([\w\-.]+\.ya?ml)$"#
        default:
            pattern = ""
        }
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
           let match = regex.firstMatch(in: trimmed, options: [], range: NSRange(location: 0, length: trimmed.utf16.count)),
           let range = Range(match.range(at: 1), in: trimmed) {
            filename = String(trimmed[range])
            let codeWithoutFilename = lines.dropFirst().joined(separator: "\n")
            return (filename, codeWithoutFilename)
        }
        return (nil, code)
    }


    
    /// Applies syntax highlighting to the given code in the given language.
    /// Apply syntax highlighting based on the language type
    private func applySyntaxHighlighting(_ code: String, language: String) -> String {
        switch language.lowercased() {
        case "swift": return highlightSwift(code)
        case "sh", "bash", "shell": return highlightShell(code)
        case "js", "javascript": return applyJavaScriptHighlighting(code)
        case "yaml", "yml": return highlightYAML(code)
        default: return escapeHTML(code)
        }
    }

    /// Wraps code lines in spans and generates line numbers HTML.
    ///
    /// - Parameter code: The code to wrap.
    /// - Returns: A tuple containing the wrapped code lines and the HTML for line numbers.
    public func wrapWithLineNumbers(_ code: String) -> (String, String) {
        let lines = code.components(separatedBy: .newlines)
        let linesHTML = lines.map { "<span class=\"code-line\">\($0)</span>" }.joined(separator: "\n")
        let numbersHTML = (1...lines.count).map { "<span class=\"line-number\">\($0)</span>" }.joined(separator: "\n")
        return (linesHTML, numbersHTML)
    }
    
    /// Applies JavaScript syntax highlighting to the code.
    ///
    /// - Parameter code: The code to highlight.
    /// - Returns: The HTML string with syntax highlighting.
    private func applyJavaScriptHighlighting(_ code: String) -> String {
        let keywords = ["var", "let", "const", "function", "class", "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue", "return", "try", "catch", "finally", "throw", "new", "this", "super", "extends", "static", "import", "export", "from", "as", "async", "await", "yield"]
        let types = ["String", "Number", "Boolean", "Object", "Array", "Symbol", "undefined", "null", "true", "false"]
        
        var highlighted = escapeHTML(code)
        
        // Highlight keywords
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-keyword\">\(keyword)</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight types
        for type in types {
            let pattern = "\\b\(type)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-type\">\(type)</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight string literals (handle both single and double quotes)
        let doubleQuotePattern = "&quot;[^&quot;\\\\]*(\\\\.[^&quot;\\\\]*)*&quot;"
        highlighted = highlighted.replacingOccurrences(
            of: doubleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        let singleQuotePattern = "&#39;[^&#39;\\\\]*(\\\\.[^&#39;\\\\]*)*&#39;"
        highlighted = highlighted.replacingOccurrences(
            of: singleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight numbers
        let numberPattern = "\\b\\d+(\\.\\d+)?\\b"
        highlighted = highlighted.replacingOccurrences(
            of: numberPattern,
            with: "<span class=\"hl-number\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight comments
        let lineCommentPattern = "//.*?$"
        highlighted = highlighted.replacingOccurrences(
            of: lineCommentPattern,
            with: "<span class=\"hl-comment\">$0</span>",
            options: [.regularExpression]
        )
        
        return highlighted
    }

    /// Highlights shell script code.
    ///
    /// - Parameter code: The code string.
    /// - Returns: The HTML string with shell syntax highlighting.
    public func highlightShell(_ code: String) -> String {
        let keywords = ["if", "then", "else", "fi", "for", "in", "do", "done", "while", "case", "esac", "function", "echo", "exit"]
        let literals = ["true", "false", "null"]
        let commands = ["cd", "pwd", "ls", "mkdir", "rm", "cp", "mv", "cat", "grep", "find", "sed", "awk", "curl", "wget", "sudo", "chmod", "chown", "export", "source", "touch", "git", "ssh", "tar", "unzip", "ssh-keygen", "ssh-add", "eval", "printf", "cat", "pbcopy"]
        
        var highlighted = escapeHTML(code)
        
        // First handle comments to avoid highlighting inside them
        let commentPattern = "#.*?$"
        highlighted = highlighted.replacingOccurrences(
            of: commentPattern,
            with: "<span class=\"hl-comment\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight strings (single and double quotes)
        let doubleQuotePattern = "(&quot;)(?:[^&quot;\\\\]|\\\\.|\\\\\\n)*?(&quot;)"
        highlighted = highlighted.replacingOccurrences(
            of: doubleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        let singleQuotePattern = "(&apos;)(?:[^&apos;\\\\]|\\\\.|\\\\\\n)*?(&apos;)"
        highlighted = highlighted.replacingOccurrences(
            of: singleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight variables (do this before commands to avoid issues)
        let variablePattern = "\\$\\{?[A-Za-z0-9_]+\\}?"
        highlighted = highlighted.replacingOccurrences(
            of: variablePattern,
            with: "<span class=\"hl-variable\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight commands - only at beginning of lines or after specific shell operators
        for command in commands {
            // Match command only at start of line or after pipe, semicolon, ampersand, or parentheses
            let pattern = "(^|\\s|;|\\||&|\\(|\\`|\\$\\()\\s*\\b(\(command))\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "$1<span class=\"hl-command\">$2</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight keywords
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-keyword\">\(keyword)</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight literals
        for literal in literals {
            let pattern = "\\b\(literal)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-literal\">\(literal)</span>",
                options: [.regularExpression]
            )
        }
        
        return highlighted
    }

    /// Highlights Swift code.
    ///
    /// - Parameter code: The code string.
    /// - Returns: The HTML string with Swift syntax highlighting.
    public func highlightSwift(_ code: String) -> String {
        let keywords = ["class", "struct", "enum", "protocol", "extension", "func", "var", "let", "if", "else", "guard", "return", "for", "while", "in", "switch", "case", "break", "default", "where", "self", "init", "deinit", "get", "set", "public", "private", "internal", "fileprivate", "open", "import", "typealias", "associatedtype", "try", "catch", "throws", "rethrows", "throw", "async", "await", "actor", "main"]
        let types = ["String", "Int", "Double", "Float", "Bool", "Character", "Array", "Dictionary", "Set", "Optional", "Any", "AnyObject", "Void", "Never", "Result", "Date", "URL", "Data", "Error"]
        
        var highlighted = escapeHTML(code)
        
        // Process comments first to avoid highlighting inside comments
        let commentPattern = "//.*?$"
        highlighted = highlighted.replacingOccurrences(
            of: commentPattern,
            with: "<span class=\"hl-comment\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight string literals with better regex
        let stringPattern = "(&quot;)(?:[^&quot;\\\\]|\\\\.|\\\\\\n)*?(&quot;)"
        highlighted = highlighted.replacingOccurrences(
            of: stringPattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight numbers
        let numberPattern = "\\b\\d+(\\.\\d+)?\\b"
        highlighted = highlighted.replacingOccurrences(
            of: numberPattern,
            with: "<span class=\"hl-number\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight keywords
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-keyword\">\(keyword)</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight types
        for type in types {
            let pattern = "\\b\(type)\\b"
            highlighted = highlighted.replacingOccurrences(
                of: pattern,
                with: "<span class=\"hl-type\">\(type)</span>",
                options: [.regularExpression]
            )
        }
        
        // Highlight symbol names (after struct, class, enum declarations)
        let symbolPattern = "(?<=\\b(?:struct|class|enum|protocol|typealias|actor)\\s+)\\b([A-Za-z][A-Za-z0-9_]*)\\b"
        highlighted = highlighted.replacingOccurrences(
            of: symbolPattern,
            with: "<span class=\"hl-type\">$1</span>",
            options: [.regularExpression]
        )
        
        // Highlight function names
        let functionPattern = "(?<=\\bfunc\\s+)\\b([A-Za-z][A-Za-z0-9_]*)\\b"
        highlighted = highlighted.replacingOccurrences(
            of: functionPattern,
            with: "<span class=\"hl-function\">$1</span>",
            options: [.regularExpression]
        )
        
        // Highlight conformance types (after : in declarations)
        let conformancePattern = "(?<=:\\s*)([A-Za-z][A-Za-z0-9_]*(?:\\s*,\\s*[A-Za-z][A-Za-z0-9_]*)*)"
        highlighted = highlighted.replacingOccurrences(
            of: conformancePattern,
            with: "<span class=\"hl-type\">$1</span>",
            options: [.regularExpression]
        )
        
        return highlighted
    }

    /// Highlights YAML code.
    ///
    /// - Parameter code: The code string.
    /// - Returns: The HTML string with YAML syntax highlighting.
    public func highlightYAML(_ code: String) -> String {
        var highlighted = escapeHTML(code)
        
        // Highlight keys
        let keyPattern = "^\\s*([\\w\\-\\.]+):"
        highlighted = highlighted.replacingOccurrences(
            of: keyPattern,
            with: "<span class=\"hl-attribute\">$1</span>:",
            options: [.regularExpression]
        )
        
        // Highlight string literals
        let doubleQuotePattern = "&quot;[^&quot;\\\\]*(\\\\.[^&quot;\\\\]*)*&quot;"
        highlighted = highlighted.replacingOccurrences(
            of: doubleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        let singleQuotePattern = "&#39;[^&#39;\\\\]*(\\\\.[^&#39;\\\\]*)*&#39;"
        highlighted = highlighted.replacingOccurrences(
            of: singleQuotePattern,
            with: "<span class=\"hl-string\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight numbers
        let numberPattern = "\\b\\d+(\\.\\d+)?\\b"
        highlighted = highlighted.replacingOccurrences(
            of: numberPattern,
            with: "<span class=\"hl-number\">$0</span>",
            options: [.regularExpression]
        )
        
        // Highlight booleans and null
        let literalPattern = "\\b(true|false|null)\\b"
        highlighted = highlighted.replacingOccurrences(
            of: literalPattern,
            with: "<span class=\"hl-literal\">$0</span>",
            options: [.regularExpression, .caseInsensitive]
        )
        
        // Highlight comments
        let commentPattern = "#.*?$"
        highlighted = highlighted.replacingOccurrences(
            of: commentPattern,
            with: "<span class=\"hl-comment\">$0</span>",
            options: [.regularExpression]
        )
        
        return highlighted
    }
}
