import WebUI

// Example component showing various uses of EdgeInsets
struct CardComponent: HTML {
    let title: String
    let content: String
    let imageSrc: String?

    init(title: String, content: String, imageSrc: String? = nil) {
        self.title = title
        self.content = content
        self.imageSrc = imageSrc
    }

    func render() -> String {
        Stack(classes: ["card"]) {
            // Card header with different top/bottom padding
            Stack(classes: ["card-header"]) {
                Heading(.subtitle) { title }
                    .font(weight: .semibold)
            }
            .background(color: .gray(._100))
            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
            .border(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0), style: .solid, color: .gray(._200))

            // Card content with uniform padding
            Stack(classes: ["card-body"]) {
                if let src = imageSrc {
                    Image(src: src, alt: "Card image")
                        .margins(of: 4, at: .bottom)
                        .frame(width: .full)
                }

                Text { content }
                    .font(size: .sm)
            }
            .padding(EdgeInsets(all: 6))

            // Card footer with different horizontal/vertical padding
            Stack(classes: ["card-footer"]) {
                Link(to: "#") { "Learn More" }
                    .background(color: .blue(._500))
                    .font(color: .white)
                    .padding(EdgeInsets(vertical: 2, horizontal: 4))
                    .rounded(.md)
            }
            .padding(EdgeInsets(vertical: 4, horizontal: 6))
            .background(color: .gray(._50))
            .border(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0), style: .solid, color: .gray(._200))
        }
        .background(color: .white)
        .rounded(.lg)
        .shadow(of: .md)
        // Responsive styling with EdgeInsets
        .responsive {
            md {
                // Uniform margins on medium screens
                margins(EdgeInsets(all: 4))
            }
            lg {
                // Custom margins on large screens - centered with auto horizontal margins
                margins(EdgeInsets(vertical: 6, horizontal: 0), auto: true)
                // Override width on large screens
                frame(maxWidth: 600)
            }
        }
        .render()
    }
}

// Usage example
let card = CardComponent(
    title: "Using EdgeInsets for Precise Spacing",
    content:
        "EdgeInsets provide a convenient way to specify different spacing values for each edge of an element with a single method call. They can be used with padding, margins, borders, and positions.",
    imageSrc: "/images/spacing-diagram.png"
)
