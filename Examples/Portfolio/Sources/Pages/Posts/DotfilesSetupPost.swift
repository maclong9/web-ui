import Foundation
import WebUI

/// "Dotfiles Setup" blog post
struct DotfilesSetupPost: Document {
    private static let post = Post(
        slug: "dotfiles-setup",
        title: "Dotfiles Setup",
        description: "My complete development environment setup and dotfiles configuration.",
        content: sampleContent,
        date: "2025-07-20",
        readTime: "3 min read",
        emoji: "⚙️",
        tags: ["Development", "Configuration", "Productivity"],
        excerpt: "My complete development environment setup and configuration."
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
        <p>A well-configured development environment can significantly boost productivity and make coding more enjoyable. This post covers my complete dotfiles setup and the tools I use daily.</p>
        
        <h2>Shell Configuration</h2>
        
        <p>I use Zsh with Oh My Zsh for my shell configuration. The setup includes custom aliases, functions, and prompt customization that streamline common development tasks.</p>
        
        <pre><code class="language-bash"># Useful aliases
        alias ll="ls -la"
        alias gc="git commit"
        alias gst="git status"
        alias dev="cd ~/Developer"</code></pre>
        
        <h2>Editor Configuration</h2>
        
        <p>VS Code is my primary editor, configured with a carefully curated set of extensions and settings that enhance the development experience.</p>
        
        <h3>Essential Extensions</h3>
        
        <ul>
        <li>Swift Language Support</li>
        <li>Prettier - Code formatter</li>
        <li>GitLens - Git supercharged</li>
        <li>Auto Rename Tag</li>
        <li>Bracket Pair Colorizer</li>
        </ul>
        
        <h2>Git Configuration</h2>
        
        <p>Git configuration includes global settings for user information, default branch names, and useful aliases that speed up common Git operations.</p>
        
        <pre><code class="language-bash"># Global Git config
        git config --global user.name "Mac Long"
        git config --global user.email "hello@maclong.uk"
        git config --global init.defaultBranch main</code></pre>
        
        <h2>Development Tools</h2>
        
        <p>My toolkit includes several command-line tools that enhance productivity:</p>
        
        <ul>
        <li><strong>Homebrew</strong> - Package manager for macOS</li>
        <li><strong>Node.js & npm</strong> - JavaScript runtime and package manager</li>
        <li><strong>Swift</strong> - Apple's programming language</li>
        <li><strong>Docker</strong> - Containerization platform</li>
        </ul>
        
        <h2>Automation</h2>
        
        <p>The entire setup is automated with shell scripts that can bootstrap a new machine in minutes. This includes installing software, configuring settings, and setting up project directories.</p>
        
        <p>Having a reproducible development environment setup saves hours when setting up new machines and ensures consistency across different development environments.</p>
        """
}