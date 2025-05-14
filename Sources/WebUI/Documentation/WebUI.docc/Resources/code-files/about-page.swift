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
        .margins(.bottom, length: 6)

        Text {
          "This is the About page of my static website built with WebUI. This page demonstrates how to create multiple pages that share common layout elements but have unique content."
        }
        .margins(.bottom, length: 4)

        Heading(.headline) {
          "About the Creator"
        }
        .font(size: .xl, weight: .bold)
        .margins(.top, length: 6)
        .margins(.bottom, length: 3)

        Text {
          "I'm a Swift developer who loves building clean, fast websites. This site serves as a demonstration of using Swift for web development."
        }
        .margins(.bottom, length: 4)

        Heading(.headline) {
          "Built with WebUI"
        }
        .font(size: .xl, weight: .bold)
        .margins(.top, length: 6)
        .margins(.bottom, length: 3)

        Text {
          "WebUI is a Swift library that makes it easy to build static websites using a component-based approach. Key features include:"
        }
        .margins(.bottom, length: 4)

        List {
          Item { "Type-safe HTML generation" }
          Item { "Tailwind-inspired styling API" }
          Item { "Component reusability" }
          Item { "Simple static site generation" }
        }
        .padding(.leading, length: 8)
        .margins(.bottom, length: 4)

        Link(to: "/") {
          "Return to Home Page"
        }
        .margins(.top, length: 4)
        .background(color: .blue(._500))
        .font(color: .custom("white"))
        .padding(.horizontal, length: 4)
        .padding(.vertical, length: 2)
        .rounded(.md)
      }
      .frame(maxWidth: .fraction(2, 3))
      .margins(.horizontal, auto: true)
    }
  }
}