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
                Link(to: "/") { Application.metadata.site! }
                    .font(size: .xl2)
                    .font(size: .xl3, on: .md)
                    .font(decoration: .underline, on: .hover)
                Navigation {
                    for path in Application.routes {
                        Link(to: "/\(path.path ?? "")") { path.metadata.title ?? "" }
                            .font(size: .sm)
                            .font(size: .base, on: .md)
                            .font(decoration: .underline, on: .hover)
                    }
                }.flex(align: .center).spacing(of: 2, along: .x)
            }
            .flex(justify: .between, align: .center)
            .frame(width: .full, maxWidth: .character(86))
            .margins(at: .bottom)
            .margins(at: .horizontal, auto: true)
            .padding(at: .vertical)

            Main {
                children.render()
            }
            .flex(grow: .one)
            .font(wrapping: .pretty)
            .frame(maxWidth: .character(72))
            .margins(at: .horizontal, auto: true)

            Footer {
                Text {
                    "© \(Date().formattedYear()) "
                    Link(to: "/") { Application.metadata.site! }.font(
                        weight: .normal
                    )
                }.font(size: .sm, color: .neutral(._700, opacity: 0.7))
            }
            .flex(justify: .center, align: .center)
        }
        .font(family: "system-ui")
        .frame(minHeight: .screen)
        .flex(direction: .column)
        .padding()
        .responsive {
            $0.md {
                $0.font(size: .lg)
            }
        }
        .render()
    }
}
