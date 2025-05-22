import WebUI

struct About: HTML {
    var document: Document {
        .init(
            path: "about",
            metadata: Metadata(from: Application.metadata, title: "About"),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            Section {
                Heading(.title) {
                    "About This Site"
                }
                .font(size: .xl3, weight: .bold)

                Text {
                    "This is the About page of my static website built with WebUI. This page demonstrates how to create multiple pages that share common layout elements but have unique content."
                }

                Heading(.headline) {
                    "About the Creator"
                }
                .font(size: .xl, weight: .bold)

                Text {
                    "I'm a Swift developer who loves building clean, fast websites. This site serves as a demonstration of using Swift for web development."
                }

                Heading(.headline) {
                    "Built with WebUI"
                }
                .font(size: .xl, weight: .bold)

                Text {
                    "WebUI is a Swift library that makes it easy to build static websites using a component-based approach. Key features include:"
                }

                List(style: .disc) {
                    Item { "Type-safe HTML generation" }
                    Item { "Tailwind-inspired styling API" }
                    Item { "Component reusability" }
                    Item { "Simple static site generation" }
                }.padding()

                Link(to: "/") {
                    "Return to Home Page"
                }
                .background(color: .blue(._500))
                .font(color: .custom("white"))
                .rounded(.md)
            }.spacing(of: 4, along: .horizontal)
        }.render()
    }
}
