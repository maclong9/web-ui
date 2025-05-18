import WebUI

struct HomeView: HTML {
    let info: [String: String]?

    var document: Document {
        .init(
            path: "",
            metadata: Metadata(from: ViewConfiguration.metadata, title: "Home"),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            Text { "Here is a simple full stack application template built with Swift, Hummingbird, and WebUI." }
            Stack {
                Strong { "User Information:" }
                List {
                    for (key, value) in info ?? [:] {
                        Item { "\(key): \(value)" }
                    }
                }
            }.margins(at: .top)
        }.render()
    }
}
