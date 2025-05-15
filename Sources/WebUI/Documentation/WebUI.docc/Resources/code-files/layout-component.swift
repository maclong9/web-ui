import Foundation
import WebUI

struct Layout: HTML {
  let children: Children

  init(@HTMLBuilder children: @escaping HTMLContentBuilder) {
    self.children = Children(content: children)
  }

  public func render() -> String {
    return Stack {
      Header {
        Link(to: "/") { Application.metadata.site ?? "" }.font(size: .xl2)
        Navigation {
          for path in Application.routes {
            Link(to: path.path ?? "") { path.metadata.title ?? "" }
              .nav()
              .font(size: .sm)
          }
        }.flex(align: .center).spacing(of: 2, along: .x)
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen)
      .margins(at: .bottom)
      .padding()

      Main {
        children.render()
      }
      .flex(grow: .one)
      .font(wrapping: .pretty)

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Link(to: "/") { Application.metadata.site ?? "" }.font(
            weight: .normal
          )
        }.font(
          size: .sm,
          color: .neutral(._700, opacity: 0.7),
        )
      }
      .flex(justify: .center, align: .center)
      .padding()
    }
    .font(family: Application.theme.fonts["body"] ?? "system-ui")
    .frame(minHeight: .screen)
    .flex(direction: .column)
    .render()
  }
}
