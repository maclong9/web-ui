import Foundation
import WebUI

struct Layout: HTML {
    let children: Children

    init(@HTMLBuilder children: @escaping HTMLContentBuilder) {
        self.children = Children(content: children)
    }

    public func render() -> String {
        Stack {
            Header {
                Link(to: "/") { ViewConfiguration.metadata.site! }.styled()
                Navigation {
                    Link(to: "/greet") { "Greet" }.styled()
                    Link(to: "https://github.com/maclong9/web-ui", newTab: true, label: "Visit the WebUI GitHub repo") {
                        Text { Icon.github.rawValue }
                    }
                    .styled()
                    .rounded(.lg)
                    .transition(of: .colors)
                    .frame(width: 8, height: 8)
                    .flex(justify: .center, align: .center)
                }.flex(align: .center).spacing(of: 2, along: .x)
            }
            .flex(justify: .between, align: .center)
            .frame(width: .screen, maxWidth: .character(100))
            .margins(at: .horizontal, auto: true)
            .margins(at: .bottom)
            .padding(at: .horizontal)
            .padding(of: 2, at: .vertical)
            .zIndex(50)

            Main {
                children.render()
            }
            .flex(grow: .one)
            .margins(at: .horizontal, auto: true)
            .frame(maxWidth: .custom("99vw"))
            .frame(maxWidth: .character(76), on: .sm)
            .padding()
            .padding(of: 20, at: .top)

            Footer {
                Text {
                    "© \(Date().formattedYear()) "
                    Link(to: "/") { "Mac Long" }.styled(weight: .normal)
                }
            }
            .font(size: .sm)
            .flex(justify: .center, align: .center)
            .padding(at: .vertical)
        }
        .flex(direction: .column)
        .frame(minHeight: .screen)
        .render()
    }
}
