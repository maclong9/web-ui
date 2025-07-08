import Foundation

/// A protocol for defining website pages with a SwiftUI-like pattern.
///
/// The `Document` protocol allows you to define website pages using a
/// declarative syntax similar to SwiftUI. Pages specify their metadata and
/// content through computed properties, making the code more readable and
/// maintainable.
///
/// ## Example
/// ```swift
/// struct Home: Document {
///   var metadata {
///     Metadata(from: Portfolio.metadata, title: "Home")
///   }
///
///   var body: some Markup {
///     Card(title: "Hello, world")
///   }
/// }
/// ```
public protocol Document {
    /// The type of markup content this document produces.
    associatedtype Body: Markup

    /// The metadata configuration for this document.
    ///
    /// Defines the page title, description, and other metadata that will
    /// appear in the HTML head section.
    var metadata: Metadata { get }

    /// The main content of the document.
    ///
    /// This property returns the markup content that will be rendered as the
    /// body of the page.
    var body: Body { get }

    /// The URL path for this document.
    ///
    /// If not provided, the path will be derived from the metadata title.  Use
    /// "/" or "index" for the root page, or specify custom paths like "about"
    /// or "blog/post".
    var path: String? { get }

    /// Optional JavaScript sources specific to this document.
    var scripts: [Script]? { get }

    /// Optional stylesheet URLs specific to this document.
    var stylesheets: [String]? { get }

    /// Optional theme configuration specific to this document.
    var theme: Theme? { get }

    /// Optional custom markup to append to this document's head section.
    var head: String? { get }

    /// Optional view transition configuration for this document.
    var viewTransitions: DocumentViewTransitionConfiguration? { get }
}

// MARK: - Default Implementations

extension Document {
    /// Default path implementation derives from metadata title.
    public var path: String? { metadata.title?.pathFormatted() }

    /// Default scripts implementation returns nil.
    public var scripts: [Script]? { nil }

    /// Default stylesheets implementation returns nil.
    public var stylesheets: [String]? { nil }

    /// Default theme implementation returns nil.
    public var theme: Theme? { nil }

    /// Default head implementation returns nil.
    public var head: String? { nil }

    /// Default view transitions implementation returns nil.
    public var viewTransitions: DocumentViewTransitionConfiguration? { nil }

    /// Creates a concrete Document instance for rendering.
    public func render() throws -> String {
        var optionalTags: [String] = metadata.tags + []
        var bodyTags: [String] = []
        
        // Add state scripts if they exist
        if let localStateScript = localStateScript {
            let scriptTag = localStateScript.render()
            localStateScript.placement == .head
                ? optionalTags.append(scriptTag)
                : bodyTags.append(scriptTag)
        }
        
        // Add global state script if it exists (from Website context)
        // Note: This would need to be passed through the render context
        // For now, we'll add the global state script link directly
        let globalStateScriptTag = "<script src=\"/scripts/state-global.js\"></script>"
        optionalTags.append(globalStateScriptTag)
        
        if let scripts = scripts {
            for script in scripts {
                let scriptTag = script.render()
                script.placement == .head
                    ? optionalTags.append(scriptTag)
                    : bodyTags.append(scriptTag)
            }
        }
        if let stylesheets = stylesheets {
            for stylesheet in stylesheets {
                optionalTags.append(
                    "<link rel=\"stylesheet\" href=\"\(stylesheet)\">"
                )
            }
        }
        
        // Generate state-aware render function
        let stateRenderScript = generateStateRenderScript()
        
        let html = """
            <!DOCTYPE html>
            <html lang="\(metadata.locale.rawValue)">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>\(metadata.pageTitle)</title>
                \(optionalTags.joined(separator: "\n"))
                <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
                <meta name="generator" content="WebUI" />
                \(head ?? "")
              </head>
              \(body.render())
              \(bodyTags.joined(separator: "\n"))
              \(stateRenderScript)
            </html>
            """
        return HTMLMinifier.minify(html)
    }
    
    /// Generates the state render script for reactive updates
    private func generateStateRenderScript() -> String {
        guard localState != nil else { return "" }
        
        return """
        <script>
        // Enhanced state rendering system
        function updateStateBindings() {
            // Update text content with state
            document.querySelectorAll('[data-state-text]').forEach(element => {
                const template = element.getAttribute('data-state-text');
                try {
                    element.textContent = eval('`' + template + '`');
                } catch (e) {
                    console.warn('State binding error:', e);
                }
            });
            
            // Update visibility based on state
            document.querySelectorAll('[data-state-show]').forEach(element => {
                const condition = element.getAttribute('data-state-show');
                try {
                    element.style.display = eval(condition) ? 'block' : 'none';
                } catch (e) {
                    console.warn('State visibility error:', e);
                }
            });
            
            // Update form values
            document.querySelectorAll('[data-state-value]').forEach(element => {
                const stateVar = element.getAttribute('data-state-value');
                try {
                    if (window[stateVar] !== undefined) {
                        element.value = window[stateVar];
                    }
                } catch (e) {
                    console.warn('State value error:', e);
                }
            });
            
            // Update checkbox states
            document.querySelectorAll('[data-state-checked]').forEach(element => {
                const stateVar = element.getAttribute('data-state-checked');
                try {
                    if (window[stateVar] !== undefined) {
                        element.checked = window[stateVar];
                    }
                } catch (e) {
                    console.warn('State checked error:', e);
                }
            });
            
            // Update conditional classes
            document.querySelectorAll('[data-state-classes]').forEach(element => {
                const classExpression = element.getAttribute('data-state-classes');
                try {
                    const classes = eval(classExpression);
                    if (classes) {
                        element.className = (element.className.replace(/data-state-classes-\\w+/g, '') + ' ' + classes).trim();
                    }
                } catch (e) {
                    console.warn('State classes error:', e);
                }
            });
            
            // Update conditional styles
            document.querySelectorAll('[data-state-style]').forEach(element => {
                const styleExpression = element.getAttribute('data-state-style');
                try {
                    const style = eval(styleExpression);
                    if (style) {
                        element.style.cssText += ';' + style;
                    }
                } catch (e) {
                    console.warn('State style error:', e);
                }
            });
            
            // Update disabled states
            document.querySelectorAll('[data-state-disabled]').forEach(element => {
                const condition = element.getAttribute('data-state-disabled');
                try {
                    element.disabled = eval(condition);
                } catch (e) {
                    console.warn('State disabled error:', e);
                }
            });
        }
        
        // Override the render function to include state bindings
        const originalRender = window.render;
        window.render = function() {
            if (originalRender) {
                originalRender();
            }
            updateStateBindings();
        };
        
        // Initial state binding on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateStateBindings();
        });
        </script>
        """
    }
}
