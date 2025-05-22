import WebUI

struct Home: HTML {
    var document: Document {
        .init(
            path: "",
            metadata: Metadata(from: Application.metadata, title: "Home"),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            Section {
                Heading(.title) {
                    "Welcome to WebUI"
                }
                .font(size: .xl3, weight: .bold)
                .font(weight: .semibold)

                Text {
                    "This is a static site generator built with Swift, generates compliant HTML, CSS and JavaScript code for your web projects in a SwiftUI like Syntax."
                }

                Stack {
                    Link(to: "https://github.com/maclong9/web-ui", newTab: true) { "Source Code" }
                        .background(color: .neutral(._950))
                        .font(color: .neutral(._100))
                        .rounded(.md)
                    Link(to: "https://maclong9.github.io/web-ui/documentation/webui/", newTab: true) {
                        "Read Documentation"
                    }
                    .background(color: .blue(._500))
                    .font(color: .neutral(._100))
                    .rounded(.md)
                }
                .spacing(of: 2, along: .vertical)
                .margins(at: .top)
            }
            .spacing(of: 4, along: .horizontal)
            .margins(at: .horizontal, auto: true)
        }.render()
    }
}
