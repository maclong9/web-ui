import Foundation

/// Configuration options for enhanced markdown rendering features.
///
/// This structure provides fine-grained control over markdown rendering capabilities,
/// allowing you to enable or disable specific features based on your application's needs.
/// The options follow a composable design pattern, enabling flexible feature combinations.
///
/// ## Usage
///
/// ```swift
/// let options = MarkdownRenderingOptions(
///     syntaxHighlighting: .enabled(languages: [.swift, .javascript]),
///     tableOfContents: .enabled(maxDepth: 3),
///     codeBlocks: .init(
///         copyButton: true,
///         lineNumbers: true,
///         showFileName: true
///     )
/// )
///
/// let markdown = WebUIMarkdown(renderingOptions: options)
/// ```
public struct MarkdownRenderingOptions: Sendable {

  // MARK: - Syntax Highlighting Configuration

  /// Configuration for syntax highlighting functionality.
  public enum SyntaxHighlighting: Sendable {
    /// Syntax highlighting is disabled
    case disabled
    /// Syntax highlighting is enabled for specified languages
    case enabled(languages: Set<SupportedLanguage>)
    /// Syntax highlighting is enabled for all supported languages
    case enabledForAll

    /// Whether syntax highlighting is enabled
    public var isEnabled: Bool {
      switch self {
      case .disabled:
        return false
      case .enabled, .enabledForAll:
        return true
      }
    }

    /// The set of supported languages for highlighting
    public var supportedLanguages: Set<SupportedLanguage> {
      switch self {
      case .disabled:
        return []
      case .enabled(let languages):
        return languages
      case .enabledForAll:
        return Set(SupportedLanguage.allCases)
      }
    }
  }

  /// Supported programming languages for syntax highlighting.
  public enum SupportedLanguage: String, CaseIterable, Hashable, Sendable {
    case swift = "swift"
    case javascript = "javascript"
    case typescript = "typescript"
    case html = "html"
    case css = "css"
    case json = "json"
    case yaml = "yaml"
    case shell = "shell"
    case bash = "bash"
    case python = "python"
    case rust = "rust"
    case go = "go"
    case kotlin = "kotlin"
    case java = "java"
    case cpp = "cpp"
    case c = "c"
    case php = "php"
    case ruby = "ruby"
    case sql = "sql"
    case xml = "xml"
    case markdown = "markdown"

    /// Display name for the language
    public var displayName: String {
      switch self {
      case .swift: return "Swift"
      case .javascript: return "JavaScript"
      case .typescript: return "TypeScript"
      case .html: return "HTML"
      case .css: return "CSS"
      case .json: return "JSON"
      case .yaml: return "YAML"
      case .shell, .bash: return "Shell"
      case .python: return "Python"
      case .rust: return "Rust"
      case .go: return "Go"
      case .kotlin: return "Kotlin"
      case .java: return "Java"
      case .cpp: return "C++"
      case .c: return "C"
      case .php: return "PHP"
      case .ruby: return "Ruby"
      case .sql: return "SQL"
      case .xml: return "XML"
      case .markdown: return "Markdown"
      }
    }

    /// CSS class name for syntax highlighting
    public var cssClassName: String {
      "language-\(self.rawValue)"
    }
  }

  // MARK: - Table of Contents Configuration

  /// Configuration for table of contents generation.
  public enum TableOfContents: Sendable {
    /// Table of contents is disabled
    case disabled
    /// Table of contents is enabled with specified options
    case enabled(maxDepth: Int = 6, includeIds: Bool = true)

    /// Whether table of contents generation is enabled
    public var isEnabled: Bool {
      switch self {
      case .disabled:
        return false
      case .enabled:
        return true
      }
    }

    /// Maximum heading depth to include in table of contents
    public var maxDepth: Int {
      switch self {
      case .disabled:
        return 0
      case .enabled(let depth, _):
        return depth
      }
    }

    /// Whether to include ID attributes on headings
    public var includeIds: Bool {
      switch self {
      case .disabled:
        return false
      case .enabled(_, let includeIds):
        return includeIds
      }
    }
  }

  // MARK: - Code Block Configuration

  /// Configuration for enhanced code block features.
  public struct CodeBlockOptions: Sendable {
    /// Whether to show a copy button for code blocks
    public let copyButton: Bool

    /// Whether to display line numbers
    public let lineNumbers: Bool

    /// Whether to show the file name or language identifier
    public let showFileName: Bool

    /// Whether to enable the experimental run button for Swift code
    public let runButton: Bool

    /// Custom copy button text
    public let copyButtonText: String

    /// Custom run button text
    public let runButtonText: String

    /// Whether to wrap long lines or allow horizontal scrolling
    public let wrapLines: Bool

    /// Initialize code block options
    public init(
      copyButton: Bool = false,
      lineNumbers: Bool = false,
      showFileName: Bool = false,
      runButton: Bool = false,
      copyButtonText: String = "Copy",
      runButtonText: String = "Run",
      wrapLines: Bool = false
    ) {
      self.copyButton = copyButton
      self.lineNumbers = lineNumbers
      self.showFileName = showFileName
      self.runButton = runButton
      self.copyButtonText = copyButtonText
      self.runButtonText = runButtonText
      self.wrapLines = wrapLines
    }

    /// Default configuration with all features disabled
    @MainActor public static let disabled = CodeBlockOptions()

    /// Basic configuration with essential features enabled
    @MainActor public static let basic = CodeBlockOptions(
      copyButton: true,
      lineNumbers: true,
      showFileName: true
    )

    /// Full-featured configuration with all features enabled
    @MainActor public static let enhanced = CodeBlockOptions(
      copyButton: true,
      lineNumbers: true,
      showFileName: true,
      runButton: true,
      wrapLines: false
    )
  }

  // MARK: - Mathematical Notation Configuration

  /// Configuration for mathematical notation support.
  public enum MathSupport: Sendable {
    /// Mathematical notation is disabled
    case disabled
    /// Mathematical notation is enabled with specified rendering
    case enabled(renderer: MathRenderer = .html)

    /// Whether mathematical notation is enabled
    public var isEnabled: Bool {
      switch self {
      case .disabled:
        return false
      case .enabled:
        return true
      }
    }

    /// The math rendering method to use
    public var renderer: MathRenderer {
      switch self {
      case .disabled:
        return .html
      case .enabled(let renderer):
        return renderer
      }
    }
  }

  /// Methods for rendering mathematical notation.
  public enum MathRenderer: Sendable {
    /// Render math as basic HTML with limited formatting
    case html
    /// Render math using MathML (future extension point)
    case mathml
    /// Render math using LaTeX-style formatting (future extension point)
    case latex
  }

  // MARK: - Main Configuration Properties

  /// Syntax highlighting configuration
  public let syntaxHighlighting: SyntaxHighlighting

  /// Table of contents configuration
  public let tableOfContents: TableOfContents

  /// Code block enhancement options
  public let codeBlocks: CodeBlockOptions

  /// Mathematical notation support
  public let mathSupport: MathSupport

  /// Whether to generate semantic HTML with enhanced accessibility
  public let enhancedAccessibility: Bool

  /// Whether to include performance optimizations
  public let performanceOptimizations: Bool

  // MARK: - Initialization

  /// Initialize markdown rendering options with specific configurations.
  ///
  /// - Parameters:
  ///   - syntaxHighlighting: Syntax highlighting configuration
  ///   - tableOfContents: Table of contents configuration
  ///   - codeBlocks: Code block enhancement options
  ///   - mathSupport: Mathematical notation support
  ///   - enhancedAccessibility: Whether to generate enhanced accessibility features
  ///   - performanceOptimizations: Whether to include performance optimizations
  public init(
    syntaxHighlighting: SyntaxHighlighting = .disabled,
    tableOfContents: TableOfContents = .disabled,
    codeBlocks: CodeBlockOptions,
    mathSupport: MathSupport = .disabled,
    enhancedAccessibility: Bool = true,
    performanceOptimizations: Bool = true
  ) {
    self.syntaxHighlighting = syntaxHighlighting
    self.tableOfContents = tableOfContents
    self.codeBlocks = codeBlocks
    self.mathSupport = mathSupport
    self.enhancedAccessibility = enhancedAccessibility
    self.performanceOptimizations = performanceOptimizations
  }

  // MARK: - Preset Configurations

  /// Basic configuration with minimal enhancements
  @MainActor public static let basic = MarkdownRenderingOptions(
    syntaxHighlighting: .enabledForAll,
    codeBlocks: .basic
  )

  /// Enhanced configuration with most features enabled
  @MainActor public static let enhanced = MarkdownRenderingOptions(
    syntaxHighlighting: .enabledForAll,
    tableOfContents: .enabled(maxDepth: 4),
    codeBlocks: .enhanced,
    mathSupport: .enabled()
  )

  /// Minimal configuration for performance-critical applications
  @MainActor public static let minimal = MarkdownRenderingOptions(
    syntaxHighlighting: .disabled,
    tableOfContents: .disabled,
    codeBlocks: .disabled,
    mathSupport: .disabled,
    enhancedAccessibility: false,
    performanceOptimizations: true
  )

  /// Documentation-focused configuration
  @MainActor public static let documentation = MarkdownRenderingOptions(
    syntaxHighlighting: .enabled(languages: [.swift, .javascript, .typescript, .json, .yaml]),
    tableOfContents: .enabled(maxDepth: 3),
    codeBlocks: CodeBlockOptions(
      copyButton: true,
      lineNumbers: true,
      showFileName: true,
      runButton: false,
      wrapLines: true
    ),
    mathSupport: .enabled(),
    enhancedAccessibility: true,
    performanceOptimizations: true
  )

  // MARK: - Utility Methods

  /// Determines if any enhanced features are enabled
  public var hasEnhancedFeatures: Bool {
    syntaxHighlighting.isEnabled || tableOfContents.isEnabled || codeBlocks.copyButton
      || codeBlocks.lineNumbers
      || codeBlocks.showFileName || codeBlocks.runButton || mathSupport.isEnabled
  }

  /// Returns a copy of the options with modified syntax highlighting
  public func withSyntaxHighlighting(_ syntaxHighlighting: SyntaxHighlighting)
    -> MarkdownRenderingOptions
  {
    MarkdownRenderingOptions(
      syntaxHighlighting: syntaxHighlighting,
      tableOfContents: self.tableOfContents,
      codeBlocks: self.codeBlocks,
      mathSupport: self.mathSupport,
      enhancedAccessibility: self.enhancedAccessibility,
      performanceOptimizations: self.performanceOptimizations
    )
  }

  /// Returns a copy of the options with modified table of contents configuration
  public func withTableOfContents(_ tableOfContents: TableOfContents) -> MarkdownRenderingOptions {
    MarkdownRenderingOptions(
      syntaxHighlighting: self.syntaxHighlighting,
      tableOfContents: tableOfContents,
      codeBlocks: self.codeBlocks,
      mathSupport: self.mathSupport,
      enhancedAccessibility: self.enhancedAccessibility,
      performanceOptimizations: self.performanceOptimizations
    )
  }

  /// Returns a copy of the options with modified code block configuration
  public func withCodeBlocks(_ codeBlocks: CodeBlockOptions) -> MarkdownRenderingOptions {
    MarkdownRenderingOptions(
      syntaxHighlighting: self.syntaxHighlighting,
      tableOfContents: self.tableOfContents,
      codeBlocks: codeBlocks,
      mathSupport: self.mathSupport,
      enhancedAccessibility: self.enhancedAccessibility,
      performanceOptimizations: self.performanceOptimizations
    )
  }
}
