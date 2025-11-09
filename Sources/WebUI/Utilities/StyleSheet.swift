/// Utilities for generating CSS stylesheets programmatically.
///
/// Provides type-safe CSS generation for media queries, feature queries, and custom styles.
public enum StyleSheet {
    /// Generates a CSS @media rule with nested styles.
    ///
    /// - Parameters:
    ///   - query: The media query condition
    ///   - styles: CSS rules to apply within the media query
    /// - Returns: Complete @media block as a string
    ///
    /// ## Example
    /// ```swift
    /// StyleSheet.mediaQuery(.prefersReducedMotion, styles: """
    ///     * { animation-duration: 0.01ms !important; }
    ///     .reveal-card { opacity: 1 !important; }
    /// """)
    /// ```
    public static func mediaQuery(_ query: MediaQuery, styles: String) -> String {
        """
        @media \(query.query) {
        \(styles.split(separator: "\n").map { "    \($0)" }.joined(separator: "\n"))
        }
        """
    }

    /// Generates a CSS @supports (feature query) rule with nested styles.
    ///
    /// - Parameters:
    ///   - feature: The feature to check for support
    ///   - styles: CSS rules to apply if feature is supported
    /// - Returns: Complete @supports block as a string
    ///
    /// ## Example
    /// ```swift
    /// StyleSheet.featureQuery(.backdropFilter, styles: """
    ///     .glass {
    ///         backdrop-filter: blur(20px);
    ///         -webkit-backdrop-filter: blur(20px);
    ///     }
    /// """)
    /// ```
    public static func featureQuery(_ feature: FeatureQuery, styles: String) -> String {
        """
        @supports \(feature.query) {
        \(styles.split(separator: "\n").map { "    \($0)" }.joined(separator: "\n"))
        }
        """
    }

    /// Generates a CSS @keyframes animation definition.
    ///
    /// - Parameters:
    ///   - name: The animation name
    ///   - keyframes: Keyframe definitions (e.g., "0% { ... } 100% { ... }")
    /// - Returns: Complete @keyframes block as a string
    ///
    /// ## Example
    /// ```swift
    /// StyleSheet.keyframes("slideUp", keyframes: """
    ///     from {
    ///         opacity: 0;
    ///         transform: translateY(20px);
    ///     }
    ///     to {
    ///         opacity: 1;
    ///         transform: translateY(0);
    ///     }
    /// """)
    /// ```
    public static func keyframes(_ name: String, keyframes: String) -> String {
        """
        @keyframes \(name) {
        \(keyframes.split(separator: "\n").map { "    \($0)" }.joined(separator: "\n"))
        }
        """
    }

    /// Combines multiple CSS blocks into a single stylesheet.
    ///
    /// - Parameter blocks: CSS blocks to combine
    /// - Returns: Combined CSS as a string
    ///
    /// ## Example
    /// ```swift
    /// StyleSheet.combine(
    ///     StyleSheet.keyframes("fadeIn", keyframes: "..."),
    ///     StyleSheet.mediaQuery(.prefersReducedMotion, styles: "..."),
    ///     ".custom-class { color: blue; }"
    /// )
    /// ```
    public static func combine(_ blocks: String...) -> String {
        blocks.joined(separator: "\n\n")
    }

    /// Generates a complete <style> element with the provided CSS.
    ///
    /// - Parameters:
    ///   - css: The CSS content
    ///   - type: The style type attribute (default: "text/tailwindcss")
    /// - Returns: Complete <style> element as markup
    ///
    /// ## Example
    /// ```swift
    /// StyleSheet.element(
    ///     StyleSheet.combine(
    ///         StyleSheet.keyframes("slideUp", keyframes: "..."),
    ///         StyleSheet.mediaQuery(.prefersReducedMotion, styles: "...")
    ///     ),
    ///     type: "text/css"
    /// )
    /// ```
    public static func element(_ css: String, type: String = "text/tailwindcss") -> String {
        """
        <style type="\(type)">
        \(css)
        </style>
        """
    }
}

// MARK: - Convenience Extensions

extension StyleSheet {
    /// Common animation keyframes ready to use.
    public enum CommonKeyframes {
        /// Fade in animation
        public static let fadeIn = StyleSheet.keyframes(
            "fade-in",
            keyframes: """
            from { opacity: 0; }
            to { opacity: 1; }
            """
        )

        /// Slide up animation
        public static let slideUp = StyleSheet.keyframes(
            "slide-up",
            keyframes: """
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
            """
        )

        /// Slide down animation
        public static let slideDown = StyleSheet.keyframes(
            "slide-down",
            keyframes: """
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
            """
        )

        /// Scale up animation
        public static let scaleUp = StyleSheet.keyframes(
            "scale-up",
            keyframes: """
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
            """
        )

        /// Jelly animation (elastic bounce)
        public static let jellyIn = StyleSheet.keyframes(
            "jelly-in",
            keyframes: """
            0% {
                opacity: 0;
                transform: scale(0.8) translateY(-10px);
            }
            50% {
                transform: scale(1.05) translateY(0);
            }
            70% {
                transform: scale(0.95);
            }
            100% {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
            """
        )
    }

    /// Common media query styles ready to use.
    public enum CommonMediaQueries {
        /// Reduce animations for users who prefer reduced motion
        public static let reducedMotion = StyleSheet.mediaQuery(
            .prefersReducedMotion,
            styles: """
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
            """
        )
    }
}
