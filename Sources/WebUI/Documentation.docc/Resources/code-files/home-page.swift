import WebUI

struct Home: HTML {
    var document: Document {
        .init(
            path: "/",
            metadata: Metadata(
                title: "Home",
                description: "Welcome to my personal website built with WebUI"
            ),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            Section {
                Heading(.title) {
                    "Welcome to My Website"
                }
                .font(size: .xl3, weight: .bold)
                .margins(at: .bottom)

                Text {
                    "This is a simple static website built with WebUI and Swift. WebUI makes it easy to create clean, semantic HTML without writing any HTML directly."
                }
                .margins(at: .bottom)

                Text {
                    "This homepage is one of two pages in our site. You can navigate to the About page using the link in the header."
                }
                .margins(at: .bottom)

                Text {
                    "Learn more about WebUI by exploring this site!"
                }
                .font(weight: .semibold)
            }
            .frame(maxWidth: .fraction(2, 3))
            .margins(at: .horizontal, auto: true)
        }.render()
    }
}
