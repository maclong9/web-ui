# Markdown Basics

Learn how to use WebUIMarkdown to render Markdown content in your web applications.

## Overview

WebUIMarkdown provides seamless integration of Markdown content within your WebUI applications.

## Basic Usage

```swift
import WebUI
import WebUIMarkdown

struct BlogPost: Website {
    var body: some HTML {
        Document {
            Markdown {
                """
                # Welcome to my blog
                
                This is a paragraph with **bold** and *italic* text.
                
                - List item 1
                - List item 2
                """
            }
        }
    }
}
```

## Features

### Supported Markdown Elements

- Headers (H1-H6)
- Emphasis (bold, italic)
- Lists (ordered and unordered)
- Links and images
- Code blocks with syntax highlighting
- Tables
- Blockquotes
- Task lists

### Syntax Highlighting

WebUIMarkdown includes built-in syntax highlighting for code blocks:

```swift
Markdown {
    """
    ```swift
    func hello() {
        print("Hello, World!")
    }
    ```
    """
}
.syntaxHighlighting(.github)
```

## Topics

### Getting Started

- <doc:MarkdownStyling>
- <doc:SyntaxHighlighting>

### Advanced Features

- <doc:CustomRendering>
- ``MarkdownParser``
- ``HighlightingOptions``
