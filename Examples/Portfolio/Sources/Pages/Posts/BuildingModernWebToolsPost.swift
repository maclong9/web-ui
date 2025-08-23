import Foundation
import WebUI

/// "Building Modern Web Tools" blog post
struct BuildingModernWebToolsPost: Document {
    private static let contentManager = ContentManager()
    private static let post: Post = {
        do {
            let posts = try contentManager.loadPosts()
            return posts.first { $0.slug == "building-modern-web-tools" } ?? defaultPost
        } catch {
            print("⚠️  Error loading posts: \(error)")
            return defaultPost
        }
    }()
    
    private static let defaultPost = Post(
        slug: "building-modern-web-tools",
        title: "Building Modern Web Tools",
        description: "Building modern utility tools with TailwindCSS v4, Alpine.js, and progressive enhancement techniques.", 
        content: sampleContent,
        date: "2025-07-25",
        readTime: "5 min read",
        emoji: "🛠️",
        tags: ["Web Development", "TailwindCSS", "Alpine.js"],
        excerpt: "Building modern utility tools with TailwindCSS v4, Alpine.js, and progressive enhancement techniques."
    )
    
    var metadata: Metadata { 
        BlogPostPage(post: Self.post).metadata 
    }
    
    var path: String? { 
        BlogPostPage(post: Self.post).path 
    }
    
    var body: some Markup {
        BlogPostPage(post: Self.post).body
    }
    
    private static let sampleContent = """
    <p>Recently, I embarked on a project to modernize my collection of web-based utility tools. What started as a simple migration turned into an exploration of cutting-edge web technologies and developer experience improvements.</p>
    
    <h2>The Challenge</h2>
    
    <p>My original tools were built with vanilla HTML, CSS, and JavaScript. While functional, they lacked consistency in design, had poor mobile responsiveness, and were becoming increasingly difficult to maintain. I needed a solution that would:</p>
    
    <ul>
    <li>Provide a consistent, modern design system</li>
    <li>Offer excellent mobile responsiveness</li>
    <li>Enable rapid development of new tools</li>
    <li>Support advanced theming (light, dark, and system preferences)</li>
    <li>Maintain minimal bundle sizes and fast loading times</li>
    </ul>
    
    <h2>The Tech Stack</h2>
    
    <p>After evaluating several options, I settled on a stack that prioritizes developer experience and performance:</p>
    
    <h3>TailwindCSS v4</h3>
    
    <p>The latest version of Tailwind brings significant improvements, including the new <code>@tailwindcss/browser</code> CDN that compiles styles on-demand. This approach eliminated the need for a build step while maintaining all of Tailwind's powerful utility classes.</p>
    
    <pre><code class="language-html">&lt;script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"&gt;&lt;/script&gt;
    &lt;style type="text/tailwindcss"&gt;
      @custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
    &lt;/style&gt;</code></pre>
    
    <h3>Alpine.js</h3>
    
    <p>For interactivity, Alpine.js proved to be the perfect lightweight alternative to heavier frameworks. It provides reactive functionality while maintaining the simplicity of vanilla JavaScript.</p>
    
    <pre><code class="language-html">&lt;div x-data="{ count: 0 }" class="p-4"&gt;
      &lt;button x-on:click="count++" class="bg-teal-600 text-white px-4 py-2 rounded"&gt;
        Increment
      &lt;/button&gt;
      &lt;span x-text="count" class="ml-4 font-bold"&gt;&lt;/span&gt;
    &lt;/div&gt;</code></pre>
    
    <p>Alpine.js shines in its declarative syntax that feels natural within HTML, making it perfect for enhancing existing markup with reactive behavior.</p>
    
    <h2>Design System</h2>
    
    <p>One of the most significant improvements was implementing a cohesive design system. I chose teal as the primary accent color throughout the interface, creating visual consistency while maintaining accessibility standards.</p>
    
    <blockquote>
    <p>"Consistency in design isn't just about aesthetics—it's about creating predictable, intuitive user experiences."<br>— Don Norman, <em>The Design of Everyday Things</em></p>
    </blockquote>
    
    <h2>Three-Way Theme System</h2>
    
    <p>Modern users expect their applications to respect their system preferences while still providing manual override options. I implemented a three-way theme system supporting:</p>
    
    <ul>
    <li><strong>Light mode</strong> - Clean, bright interface</li>
    <li><strong>Dark mode</strong> - Eye-friendly dark theme</li>
    <li><strong>System mode</strong> - Automatically follows OS preference</li>
    </ul>
    
    <p>The theme toggle cycles through all three options, with appropriate icons (sun, moon, monitor) to clearly communicate the current state.</p>
    
    <h2>Results</h2>
    
    <p>The migration resulted in several significant improvements:</p>
    
    <ul>
    <li>50% faster loading times through optimized assets</li>
    <li>100% mobile responsiveness across all tools</li>
    <li>Consistent user experience with proper dark mode support</li>
    <li>90% reduction in development time for new tools</li>
    </ul>
    
    <h2>What's Next</h2>
    
    <p>This foundation opens up exciting possibilities for future tools. The template system makes it trivial to add new utilities, and the modern tech stack ensures they'll be fast, accessible, and maintainable.</p>
    
    <p>The complete source code is available on <a href="https://github.com/maclong9/web">GitHub</a>, and you can explore the live tools at <a href="https://tools.maclong.uk">tools.maclong.uk</a>. The collection currently includes a Schengen Area visit tracker and interactive guitar barre scales chart, with more utilities planned for the future.</p>
    """
}