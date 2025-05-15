import Testing

@testable import WebUI

@Suite("Responsive Style Tests") struct ResponsiveStyleTests {
  // MARK: - Basic Responsive Tests

  @Test("Basic responsive font styling")
  func testBasicResponsiveFontStyling() async throws {
    let element = Element(tag: "div")
      .font(size: .sm)
      .responsive {
        $0.md {
          $0.font(size: .lg)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"text-sm md:text-lg\""))
  }

  @Test("Multiple breakpoints in one responsive block")
  func testMultipleBreakpoints() async throws {
    let element = Element(tag: "div")
      .background(color: .gray(._100))
      .font(size: .sm)
      .responsive {
        $0.sm {
          $0.font(size: .base)
        }
        $0.md {
          $0.font(size: .lg)
          $0.background(color: .gray(._200))
        }
        $0.lg {
          $0.font(size: .xl)
          $0.background(color: .gray(._300))
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"bg-gray-100 text-sm sm:text-base md:text-lg md:bg-gray-200 lg:text-xl lg:bg-gray-300\""))
  }

  // MARK: - Multiple Style Types Tests

  @Test("Responsive block with multiple style types")
  func testResponsiveWithMultipleStyleTypes() async throws {
    let element = Element(tag: "div")
      .padding(of: 2)
      .font(size: .sm)
      .responsive {
        $0.md {
          $0.padding(of: 4)
          $0.font(size: .lg)
          $0.margins(of: 2)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"p-2 text-sm md:p-4 md:text-lg md:m-2\""))
  }

  // MARK: - Complex Component Tests

  @Test("Responsive styling with a complex component")
  func testResponsiveWithComplexComponent() async throws {
    let button = Button(type: .submit) { "Submit" }
      .background(color: .blue(._500))
      .font(color: .blue(._50))
      .padding(of: 2)
      .rounded(.md)
      .responsive {
        $0.sm {
          $0.padding(of: 3)
        }
        $0.md {
          $0.padding(of: 4)
          $0.font(size: .lg)
        }
        $0.lg {
          $0.padding(of: 6)
          $0.background(color: .blue(._600))
        }
      }

    let rendered = button.render()
    #expect(rendered.contains("type=\"submit\""))
    #expect(rendered.contains("bg-blue-500"))
    #expect(rendered.contains("text-blue-50"))
    #expect(rendered.contains("p-2"))
    #expect(rendered.contains("rounded-md"))
    #expect(rendered.contains("sm:p-3"))
    #expect(rendered.contains("md:p-4"))
    #expect(rendered.contains("md:text-lg"))
    #expect(rendered.contains("lg:p-6"))
    #expect(rendered.contains("lg:bg-blue-600"))
  }

  // MARK: - Layout Tests

  @Test("Responsive flex layout")
  func testResponsiveFlexLayout() async throws {
    let element = Element(tag: "div")
      .flex(direction: .column)
      .responsive {
        $0.md {
          $0.flex(direction: .row, justify: .between)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("flex"))
    #expect(rendered.contains("flex-col"))
    #expect(rendered.contains("md:flex"))
  }

  @Test("Responsive grid layout")
  func testResponsiveGridLayout() async throws {
    let element = Element(tag: "div")
      .grid(columns: 1)
      .responsive {
        $0.md {
          $0.grid(columns: 2)
        }
        $0.lg {
          $0.grid(columns: 3)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3\""))
  }

  // MARK: - Sizing & Position Tests

  @Test("Responsive sizing")
  func testResponsiveSizing() async throws {
    let element = Element(tag: "div")
      .frame(width: 100)
      .responsive {
        $0.md {
          $0.frame(maxWidth: 600)
          $0.margins(at: .horizontal, auto: true)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"w-100 md:max-w-600 md:mx-auto\""))
  }

  @Test("Responsive positioning")
  func testResponsivePositioning() async throws {
    let element = Element(tag: "div")
      .position(.relative)
      .responsive {
        $0.lg {
          $0.position(.fixed, at: .top, offset: 0)
          $0.frame(width: 100)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("class=\"relative lg:fixed lg:top-0 lg:w-100\""))
  }

  // MARK: - Visibility Tests

  @Test("Responsive visibility")
  func testResponsiveVisibility() async throws {
    let element = Element(tag: "div")
      .hidden()
      .responsive {
        $0.md {
          $0.hidden(false)
        }
      }

    let rendered = element.render()
    // This test would need a special implementation to verify the absence
    // of the .md:hidden class or the presence of a display value
    #expect(rendered.contains("class=\"hidden\""))
    #expect(!rendered.contains("md:hidden"))
  }

  // MARK: - Compound Tests

  @Test("Responsive nav menu")
  func testResponsiveNavMenu() async throws {
    let nav = Navigation {
      Stack(classes: ["mobile-menu"])
        .responsive {
          $0.md {
            $0.hidden()
          }
        }

      List(classes: ["desktop-menu"])
        .hidden()
        .responsive {
          $0.md {
            $0.hidden(false)
          }
        }
    }

    let rendered = nav.render()
    #expect(rendered.contains("class=\"mobile-menu md:hidden\""))
    #expect(rendered.contains("class=\"desktop-menu hidden\""))
  }

  @Test("Responsive hero section")
  func testResponsiveHeroSection() async throws {
    let hero = Section(classes: ["hero"])
      .padding(of: 4)
      .responsive {
        $0.sm {
          $0.padding(of: 6)
        }
        $0.md {
          $0.padding(of: 8)
        }
        $0.lg {
          $0.padding(of: 12)
          $0.frame(height: 100)
        }
      }

    let rendered = hero.render()
    #expect(rendered.contains("class=\"hero p-4 sm:p-6 md:p-8 lg:p-12 lg:h-100\""))
  }
}
