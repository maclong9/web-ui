import Foundation

/// Configuration for document-level view transitions
public struct DocumentViewTransitionConfiguration: Sendable {
    /// The default transition type for the document
    public let defaultTransition: ViewTransitionType?

    /// The duration for document-level transitions in milliseconds
    public let duration: Int?

    /// The timing function for document-level transitions
    public let timing: ViewTransitionTiming?

    /// The delay before transitions start in milliseconds
    public let delay: Int?

    /// Whether to enable cross-document view transitions
    public let enableCrossDocument: Bool

    /// Custom CSS for view transitions
    public let customCSS: String?

    /// Initialize document view transition configuration.
    ///
    /// - Parameters:
    ///   - defaultTransition: The default transition type for the document
    ///   - duration: The duration for document-level transitions in milliseconds
    ///   - timing: The timing function for document-level transitions
    ///   - delay: The delay before transitions start in milliseconds
    ///   - enableCrossDocument: Whether to enable cross-document view transitions
    ///   - customCSS: Custom CSS for view transitions
    public init(
        defaultTransition: ViewTransitionType? = nil,
        duration: Int? = nil,
        timing: ViewTransitionTiming? = nil,
        delay: Int? = nil,
        enableCrossDocument: Bool = false,
        customCSS: String? = nil
    ) {
        self.defaultTransition = defaultTransition
        self.duration = duration
        self.timing = timing
        self.delay = delay
        self.enableCrossDocument = enableCrossDocument
        self.customCSS = customCSS
    }
}

/// Extension to add view transition support to Documents
extension Document {
    /// View transition configuration for this document.
    ///
    /// Override this property to configure document-level view transitions.
    /// When specified, generates CSS and JavaScript for smooth page transitions.
    ///
    /// - Returns: The view transition configuration, or nil for no document-level transitions
    public var viewTransitions: DocumentViewTransitionConfiguration? {
        nil
    }

    /// Generate CSS for document-level view transitions.
    ///
    /// This method generates CSS that enables smooth transitions between pages
    /// and provides default styling for view transition elements.
    ///
    /// - Returns: CSS string for view transitions, or nil if no configuration
    public func generateViewTransitionCSS() -> String? {
        guard let config = viewTransitions else { return nil }

        var css = """
            /* Document-level view transitions */
            @view-transition {
                navigation: auto;
            }

            """

        // Add default transition styles
        if let defaultTransition = config.defaultTransition {
            css += """
                ::view-transition-old(root),
                ::view-transition-new(root) {
                    animation-duration: \(config.duration ?? 300)ms;
                    animation-timing-function: \(config.timing?.rawValue ?? "ease-in-out");
                }

                """

            // Add transition-specific styles
            switch defaultTransition {
                case .fade:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: fade-out;
                        }

                        ::view-transition-new(root) {
                            animation-name: fade-in;
                        }

                        @keyframes fade-out {
                            from { opacity: 1; }
                            to { opacity: 0; }
                        }

                        @keyframes fade-in {
                            from { opacity: 0; }
                            to { opacity: 1; }
                        }

                        """
                case .slide, .slideLeft:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: slide-out-left;
                        }

                        ::view-transition-new(root) {
                            animation-name: slide-in-right;
                        }

                        @keyframes slide-out-left {
                            from { transform: translateX(0); }
                            to { transform: translateX(-100%); }
                        }

                        @keyframes slide-in-right {
                            from { transform: translateX(100%); }
                            to { transform: translateX(0); }
                        }

                        """
                case .slideRight:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: slide-out-right;
                        }

                        ::view-transition-new(root) {
                            animation-name: slide-in-left;
                        }

                        @keyframes slide-out-right {
                            from { transform: translateX(0); }
                            to { transform: translateX(100%); }
                        }

                        @keyframes slide-in-left {
                            from { transform: translateX(-100%); }
                            to { transform: translateX(0); }
                        }

                        """
                case .slideUp:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: slide-out-up;
                        }

                        ::view-transition-new(root) {
                            animation-name: slide-in-down;
                        }

                        @keyframes slide-out-up {
                            from { transform: translateY(0); }
                            to { transform: translateY(-100%); }
                        }

                        @keyframes slide-in-down {
                            from { transform: translateY(-100%); }
                            to { transform: translateY(0); }
                        }

                        """
                case .slideDown:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: slide-out-down;
                        }

                        ::view-transition-new(root) {
                            animation-name: slide-in-up;
                        }

                        @keyframes slide-out-down {
                            from { transform: translateY(0); }
                            to { transform: translateY(100%); }
                        }

                        @keyframes slide-in-up {
                            from { transform: translateY(100%); }
                            to { transform: translateY(0); }
                        }

                        """
                case .scale, .scaleUp:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: scale-out;
                        }

                        ::view-transition-new(root) {
                            animation-name: scale-in;
                        }

                        @keyframes scale-out {
                            from { transform: scale(1); }
                            to { transform: scale(1.1); opacity: 0; }
                        }

                        @keyframes scale-in {
                            from { transform: scale(0.9); opacity: 0; }
                            to { transform: scale(1); opacity: 1; }
                        }

                        """
                case .scaleDown:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: scale-down-out;
                        }

                        ::view-transition-new(root) {
                            animation-name: scale-down-in;
                        }

                        @keyframes scale-down-out {
                            from { transform: scale(1); }
                            to { transform: scale(0.9); opacity: 0; }
                        }

                        @keyframes scale-down-in {
                            from { transform: scale(1.1); opacity: 0; }
                            to { transform: scale(1); opacity: 1; }
                        }

                        """
                case .flip, .flipHorizontal:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: flip-out;
                        }

                        ::view-transition-new(root) {
                            animation-name: flip-in;
                        }

                        @keyframes flip-out {
                            from { transform: rotateY(0deg); }
                            to { transform: rotateY(90deg); }
                        }

                        @keyframes flip-in {
                            from { transform: rotateY(-90deg); }
                            to { transform: rotateY(0deg); }
                        }

                        """
                case .flipVertical:
                    css += """
                        ::view-transition-old(root) {
                            animation-name: flip-vertical-out;
                        }

                        ::view-transition-new(root) {
                            animation-name: flip-vertical-in;
                        }

                        @keyframes flip-vertical-out {
                            from { transform: rotateX(0deg); }
                            to { transform: rotateX(90deg); }
                        }

                        @keyframes flip-vertical-in {
                            from { transform: rotateX(-90deg); }
                            to { transform: rotateX(0deg); }
                        }

                        """
                case .none:
                    css += """
                        ::view-transition-old(root),
                        ::view-transition-new(root) {
                            animation: none;
                        }

                        """
            }
        }

        // Add custom CSS if provided
        if let customCSS = config.customCSS {
            css += "\n/* Custom view transition styles */\n"
            css += customCSS
            css += "\n"
        }

        return css
    }

    /// Generate JavaScript for document-level view transitions.
    ///
    /// This method generates JavaScript that enables cross-document view transitions
    /// and provides programmatic control over view transitions.
    ///
    /// - Returns: JavaScript string for view transitions, or nil if not enabled
    public func generateViewTransitionJS() -> String? {
        guard let config = viewTransitions, config.enableCrossDocument else { return nil }

        return """
            // Document-level view transitions
            (function() {
                'use strict';
                
                // Check for View Transitions API support
                if (!document.startViewTransition) {
                    return;
                }
                
                // Enable cross-document view transitions
                document.addEventListener('DOMContentLoaded', function() {
                    // Handle navigation with view transitions
                    document.addEventListener('click', function(e) {
                        const link = e.target.closest('a');
                        if (link && link.href && link.hostname === window.location.hostname) {
                            e.preventDefault();
                            
                            // Start view transition
                            document.startViewTransition(() => {
                                window.location.href = link.href;
                            });
                        }
                    });
                });
                
                // Handle back/forward navigation
                window.addEventListener('popstate', function(e) {
                    document.startViewTransition(() => {
                        window.location.reload();
                    });
                });
            })();
            """
    }
}

/// Website extension to provide default view transition configuration
extension Website {
    /// Default view transition configuration for all documents in this website.
    ///
    /// Override this property to set default view transitions for all pages.
    /// Individual documents can override this configuration.
    ///
    /// - Returns: The default view transition configuration, or nil for no defaults
    public var defaultViewTransitions: DocumentViewTransitionConfiguration? {
        nil
    }
}

/// Extension to integrate view transitions into the Document rendering pipeline
extension Document {
    /// Enhanced head content that includes view transition CSS and JavaScript.
    ///
    /// This method combines the original head content with generated view transition
    /// CSS and JavaScript, providing seamless integration with the existing rendering system.
    ///
    /// - Returns: Complete head content including view transitions
    public var enhancedHead: String? {
        var headContent = head ?? ""

        // Add view transition CSS
        if let viewTransitionCSS = generateViewTransitionCSS() {
            headContent += """

                <style>
                \(viewTransitionCSS)
                </style>
                """
        }

        // Add view transition JavaScript
        if let viewTransitionJS = generateViewTransitionJS() {
            headContent += """

                <script>
                \(viewTransitionJS)
                </script>
                """
        }

        return headContent.isEmpty ? nil : headContent
    }

    /// Render the document with integrated view transitions.
    ///
    /// This method provides an alternative to the standard render() method
    /// that automatically includes view transition CSS and JavaScript.
    ///
    /// - Returns: Complete HTML document with view transitions
    public func renderWithViewTransitions() throws -> String {
        var optionalTags: [String] = metadata.tags + []
        var bodyTags: [String] = []
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
                \(enhancedHead ?? "")
              </head>
              \(body.render())
              \(bodyTags.joined(separator: "\n"))
            </html>
            """
        return HTMLMinifier.minify(html)
    }
}
