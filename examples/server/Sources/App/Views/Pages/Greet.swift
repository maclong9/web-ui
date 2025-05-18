import Foundation
import WebUI

struct GreetView: HTML {
    let greeting: String?

    init(greeting: String? = nil) {
        self.greeting = greeting
    }

    var document: Document {
        .init(
            path: "greet",
            metadata: Metadata(from: ViewConfiguration.metadata, title: "About"),
            content: { self }
        )
    }

    func render() -> String {
        Layout {
            Form(action: "/greet", method: .post) {
                Label(for: "name") { "Enter your name" }.font(weight: .bold)
                Input(name: "name", type: .text, placeholder: "Your name...")
                    .border(EdgeInsets(all: 1))
                    .padding(EdgeInsets(vertical: 2, horizontal: 4))
                    .rounded(.lg)
                Button(type: .submit) { "Enter" }
                    .padding(EdgeInsets(vertical: 2, horizontal: 4))
                    .background(color: .blue(._500))
                    .background(color: .blue(._700), on: .hover)
                    .transition(of: .colors)
                    .cursor(.pointer)
                    .rounded(.lg)
            }.flex(direction: .column).spacing(of: 2, along: .y)
            if let greeting {
                Text { greeting }
            }
        }.render()
    }
}
