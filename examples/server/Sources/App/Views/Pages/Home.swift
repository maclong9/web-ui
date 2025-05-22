import WebUI

struct HomeView: HTML {
    let info: [String: String]?
    let greeting: String?

    init(info: [String: String]? = nil, greeting: String? = nil) {
        self.info = info
        self.greeting = greeting
    }

    var document: Document {
        .init(
            path: "",
            metadata: Metadata(from: ViewConfiguration.metadata, title: "Home"),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            // Intro Section
            Stack {
                Heading(.largeTitle) { "Welcome to WebUI!" }.font(size: .xl4, weight: .bold)
                Text { "Here is a simple full stack application template built with Swift, Hummingbird, and WebUI." }
                Stack {
                    Link(to: "https://github.com/maclong9/web-ui", newTab: true) { "Source Code" }.button()
                    Link(to: "https://maclong9.github.io/web-ui/documentation/webui/", newTab: true) {
                        "Read Documentation"
                    }
                    .button(primary: true)
                }.spacing(of: 2, along: .vertical).margins(at: .top)
            }
            .frame(maxWidth: .fraction(3, 4))
            .margins(at: .horizontal, auto: true)
            .spacing(along: .horizontal)

            // Information Section
            Stack {
                Strong { "User Information:" }
                List {
                    for (key, value) in info ?? [:] {
                        Item { "\(key): \(value)" }
                    }
                }
            }
            .margins(at: .top)
            .frame(maxWidth: .fraction(3, 4))
            .margins(at: .horizontal, auto: true)
            .padding(at: .vertical)

            // Greeting Section
            Form(action: "/", method: .post) {
                Label(for: "name") { "Enter your name" }.font(weight: .bold)
                Input(name: "name", type: .text, placeholder: "Your name...")
                    .rounded(.lg)
                Button(type: .submit) { "Enter" }.button(primary: true)
            }
            .flex(direction: .column)
            .spacing(of: 2, along: .horizontal)
            .frame(maxWidth: .fraction(3, 4))
            .margins(at: .horizontal, auto: true)
            if let greeting {
                Text { greeting }
            }
        }.render()
    }
}
