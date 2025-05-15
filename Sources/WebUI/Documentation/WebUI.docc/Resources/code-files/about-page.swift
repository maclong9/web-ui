import WebUI

struct AboutPage: HTML {
  var document: Document {
    .init(
      path: "/about",
      metadata: Metadata(
        title: "About",
        description: "Learn more about this website and its creator"
      ),
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
        .margins(of: 6, at: .bottom)

        Text {
          "This is the About page of my static website built with WebUI. This page demonstrates how to create multiple pages that share common layout elements but have unique content."
        }
        .margins(at: .bottom)

        Heading(.headline) {
          "About the Creator"
        }
        .font(size: .xl, weight: .bold)
        .margins(of: 6, at: .top)
        .margins(of: 3, at: .bottom)

        Text {
          "I'm a Swift developer who loves building clean, fast websites. This site serves as a demonstration of using Swift for web development."
        }
        .margins(at: .bottom)

        Heading(.headline) {
          "Built with WebUI"
        }
        .font(size: .xl, weight: .bold)
        .margins(of: 6, at: .top)
        .margins(of: 3, at: .bottom)

        Text {
          "WebUI is a Swift library that makes it easy to build static websites using a component-based approach. Key features include:"
        }
        .margins(of: 4, at: .bottom)

        List {
          Item { "Type-safe HTML generation" }
          Item { "Tailwind-inspired styling API" }
          Item { "Component reusability" }
          Item { "Simple static site generation" }
        }
        .padding(of: 8, at: .leading)
        .margins(at: .bottom)

        Link(to: "/") {
          "Return to Home Page"
        }
        .margins(at: .top)
        .background(color: .blue(._500))
        .font(color: .custom("white"))
        .padding(at: .horizontal)
        .padding(of: 2, at: .vertical)
        .rounded(.md)
      }
      .frame(maxWidth: .fraction(2, 3))
      .margins(at: .horizontal, auto: true)
    }
  }
}
