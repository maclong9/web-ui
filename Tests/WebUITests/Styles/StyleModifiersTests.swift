import Testing

@testable import WebUI

@Suite("Style Modifiers Tests") struct StyleModifiersTests {
  // MARK: - Opacity Modifier Tests

  @Test("Opacity with hover modifier")
  func testOpacityWithHoverModifier() async throws {
    let element = Stack().opacity(75, on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:opacity-75\""))
  }

  @Test("Opacity with multiple modifiers")
  func testOpacityWithMultipleModifiers() async throws {
    let element = Stack().opacity(25, on: .hover, .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:md:opacity-25\""))
  }

  // MARK: - Background Color Modifier Tests

  @Test("Background color with hover modifier")
  func testBackgroundColorWithHoverModifier() async throws {
    let element = Stack().background(color: .green(._700), on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:bg-green-700\""))
  }

  // MARK: - Border Modifier Tests

  @Test("Border with modifiers")
  func testBorderWithModifiers() async throws {
    let element = Stack().border(of: 3, on: .hover, .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:md:border-3\""))
  }

  // MARK: - Outline Modifier Tests

  @Test("Outline with style and modifier")
  func testOutlineWithStyleAndModifier() async throws {
    let element = Stack().outline(style: .dashed, on: .focus)
    let rendered = element.render()
    #expect(rendered.contains("class=\"focus:outline-dashed\""))
  }

  // MARK: - Shadow Modifier Tests

  @Test("Shadow with color and modifier")
  func testShadowWithColorAndModifier() async throws {
    let element = Stack().shadow(size: .md, color: .gray(._500), on: .hover)
    let rendered = element.render()
    #expect(
      rendered.contains("class=\"hover:shadow-md hover:shadow-gray-500\"")
    )
  }

  // MARK: - Ring Modifier Tests

  @Test("Ring with color and modifier")
  func testRingWithColorAndModifier() async throws {
    let element = Stack().ring(size: 2, color: .pink(._400), on: .focus)
    let rendered = element.render()
    #expect(rendered.contains("class=\"focus:ring-2 focus:ring-pink-400\""))
  }

  // MARK: - Flex Modifier Tests

  @Test("Flex with modifiers")
  func testFlexWithModifiers() async throws {
    let element = Stack().flex(direction: .column, on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:flex md:flex-col\""))
  }

  // MARK: - Hidden Modifier Tests

  @Test("Hidden with modifier")
  func testHiddenWithModifier() async throws {
    let element = Stack().hidden(true, on: .sm)
    let rendered = element.render()
    #expect(rendered.contains("class=\"sm:hidden\""))
  }

  // MARK: - Display Modifier Tests

  @Test("Display element as inline-block with hover")
  func testDisplayAsInlineBlockWithHover() async throws {
    let element = Stack().display(.inlineBlock, on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:display-inline-block\""))
  }

  @Test("Display as table on medium screens")
  func testDisplayAsTableOnMedium() async throws {
    let element = Stack().display(.table, on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:display-table\""))
  }

  // MARK: - Frame Modifier Tests

  @Test("Frame with character width and modifier")
  func testFrameWithCharacterWidthAndModifier() async throws {
    let element = Stack().frame(width: .character(60), on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:w-[60ch]\""))
  }

  @Test("Frame with modifiers on specific dimensions")
  func testFrameWithModifiersOnSpecificDimensions() async throws {
    let element = Stack().frame(
      width: .auto,
      maxWidth: .container(.fourExtraLarge),
      on: .md,
      .dark
    )
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:dark:w-auto md:dark:max-w-4xl\""))
  }

  // MARK: - Size Modifier Tests

  @Test("Size method with modifiers")
  func testSizeMethodWithModifiers() async throws {
    let element = Stack().size(16.spacing, on: .hover, .lg)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:lg:size-16\""))
  }

  // MARK: - Aspect Ratio Modifier Tests

  @Test("Aspect ratio with modifiers")
  func testAspectRatioWithModifiers() async throws {
    let element = Stack().aspectRatio(4, 3, on: .hover)
    let rendered = element.render()
    #expect(
      rendered.contains("class=\"hover:aspect-[1.3333333333333333]\""))
  }

  // MARK: - Font Modifier Tests

  @Test("Font with family and modifier")
  func testFontWithFamilyAndModifier() async throws {
    let element = Stack().font(family: "sans", on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:font-[sans]\""))
  }

  // MARK: - Cursor Modifier Tests

  @Test("Font modifier with family and on: modifier on Text (Element)")
  func testFontModifierWithFamilyAndOnModifierOnText() async throws {
    let element = Text("Hello").font(family: "serif", on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:font-[serif]\""))
  }

  @Test("Cursor with not-allowed type and modifier")
  func testCursorWithNotAllowedAndModifier() async throws {
    let element = Stack().cursor(.notAllowed, on: .focus)
    let rendered = element.render()
    #expect(rendered.contains("class=\"focus:cursor-not-allowed\""))
  }

  // MARK: - Margin Modifier Tests

  @Test("Margins with modifier")
  func testMarginsWithModifier() async throws {
    let element = Stack().margins(of: 6, at: .leading, on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:ml-6\""))
  }

  // MARK: - Padding Modifier Tests

  @Test("Padding with modifier")
  func testPaddingWithModifier() async throws {
    let element = Stack().padding(of: 3, at: .trailing, on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:pr-3\""))
  }

  // MARK: - Spacing Modifier Tests

  @Test("Spacing with modifier")
  func testSpacingWithModifier() async throws {
    let element = Stack().spacing(of: 2, along: .vertical, on: .lg)
    let rendered = element.render()
    #expect(rendered.contains("class=\"lg:space-y-2\""))
  }

  // MARK: - Transition Modifier Tests

  @Test("Transition with modifier")
  func testTransitionWithModifier() async throws {
    let element = Stack().transition(of: .colors, for: 500, on: .hover)
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"hover:transition-colors hover:duration-500\""))
  }

  // MARK: - Z-Index Modifier Tests

  @Test("Z-Index with modifier")
  func testZIndexWithModifier() async throws {
    let element = Stack().zIndex(20, on: .focus)
    let rendered = element.render()
    #expect(rendered.contains("class=\"focus:z-20\""))
  }

  // MARK: - Position Modifier Tests

  @Test("Position with modifier")
  func testPositionWithModifier() async throws {
    let element = Stack().position(.sticky, at: .top, offset: 0, on: .md)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:sticky md:top-0\""))
  }

  // MARK: - Overflow Modifier Tests

  @Test("Overflow with modifier")
  func testOverflowWithModifier() async throws {
    let element = Stack().overflow(.auto, axis: .vertical, on: .lg)
    let rendered = element.render()
    #expect(rendered.contains("class=\"lg:overflow-y-auto\""))
  }

  @Test("Overflow with multiple modifiers")
  func testOverflowWithMultipleModifiers() async throws {
    let element = Stack().overflow(.visible, axis: .both, on: .md, .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"md:hover:overflow-visible\""))
  }

  // MARK: - Transform Modifier Tests

  @Test("Transform with skew and modifier")
  func testTransformWithSkewAndModifier() async throws {
    let element = Stack().transform(skew: (x: 15, y: nil), on: .hover)
    let rendered = element.render()
    #expect(rendered.contains("class=\"hover:transform hover:skew-x-15\""))
  }

  // MARK: - Scroll Modifier Tests

  @Test("Scroll with modifier")
  func testScrollWithModifier() async throws {
    let element = Stack().scroll(
      behavior: .auto,
      snapType: .mandatory,
      on: .hover
    )
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"hover:scroll-auto hover:snap-mandatory\""))
  }

  // MARK: - Interaction State Modifier Tests

  @Test("Hover state modifier")
  func testHoverStateModifier() async throws {
    let element = Stack()
      .on {
        hover {
          background(color: .blue(._500))
          font(color: .gray(._50))
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("hover:bg-blue-500"))
    #expect(rendered.contains("hover:text-gray-50"))
  }

  @Test("Focus state modifier")
  func testFocusStateModifier() async throws {
    let element = Stack()
      .on {
        focus {
          border(of: 2, color: .blue(._500))
          outline(of: 0)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("focus:border-2"))
    #expect(rendered.contains("focus:border-blue-500"))
    #expect(rendered.contains("focus:outline-0"))
  }

  @Test("Multiple state modifiers")
  func testMultipleStateModifiers() async throws {
    let element = Stack()
      .background(color: .gray(._100))
      .padding(of: 4)
      .on {
        hover {
          background(color: .gray(._200))
        }
        focus {
          background(color: .blue(._100))
          border(of: 1, color: .blue(._500))
        }
        active {
          background(color: .blue(._200))
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("bg-gray-100"))
    #expect(rendered.contains("p-4"))
    #expect(rendered.contains("hover:bg-gray-200"))
    #expect(rendered.contains("focus:bg-blue-100"))
    #expect(rendered.contains("focus:border-1"))
    #expect(rendered.contains("focus:border-blue-500"))
    #expect(rendered.contains("active:bg-blue-200"))
  }

  @Test("Multi-modifier block: hover and dark")
  func testMultiModifierHoverDark() async throws {
    let element = Stack()
      .on {
        modifiers(.hover, .dark) {
          background(color: .red(._500))
          font(color: .white())
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:bg-red-500"))
    #expect(rendered.contains("hover:dark:text-white"))
  }

  @Test("Multi-modifier block: md and placeholder")
  func testMultiModifierMdPlaceholder() async throws {
    let element = Input(name: "email", type: .email)
      .on {
        modifiers(.md, .placeholder) {
          font(color: .blue(._400))
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("md:placeholder:text-blue-400"))
  }

  @Test("Multi-modifier block: hover, dark, focus")
  func testMultiModifierHoverDarkFocus() async throws {
    let element = Stack()
      .on {
        modifiers(.hover, .dark, .focus) {
          opacity(80)
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:focus:opacity-80"))
  }

  @Test("Nested multi-modifier blocks")
  func testNestedMultiModifierBlocks() async throws {
    let element = Stack()
      .on {
        modifiers(.hover) {
          modifiers(.dark, .focus) {
            background(color: .amber(._600))
          }
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:focus:bg-amber-600"))
  }

  @Test("Mixed single and multi-modifier usage")
  func testMixedSingleAndMultiModifierUsage() async throws {
    let element = Stack()
      .on {
        hover {
          background(color: .blue(._500))
        }
        modifiers(.dark, .focus) {
          font(color: .white())
        }
        lg {
          padding(of: 16)
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:bg-blue-500"))
    #expect(rendered.contains("dark:focus:text-white"))
    #expect(rendered.contains("lg:p-16"))
  }

  @Test("Multi-modifier with variadic syntax: hover, dark")
  func testVariadicModifierSyntax() async throws {
    let element = Stack()
      .on {
        modifiers(.hover, .dark) {
          background(color: .red(._500))
          font(color: .white())
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:bg-red-500"))
    #expect(rendered.contains("hover:dark:text-white"))
  }

  @Test("Multi-modifier with variadic syntax: three modifiers")
  func testVariadicThreeModifiers() async throws {
    let element = Stack()
      .on {
        modifiers(.hover, .dark, .focus) {
          opacity(75)
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:focus:opacity-75"))
  }

  @Test("Multi-modifier with variadic syntax: breakpoint and state")
  func testVariadicBreakpointAndState() async throws {
    let element = Input(name: "email", type: .email)
      .on {
        modifiers(.md, .placeholder) {
          font(color: .gray(._400))
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("md:placeholder:text-gray-400"))
  }

  @Test("Custom operator modifier syntax: hover <&> dark")
  func testCustomOperatorModifierSyntax() async throws {
    let element = Stack()
      .on {
        (hover <&> dark) {
          background(color: .blue(._600))
          font(color: .yellow(._300))
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:bg-blue-600"))
    #expect(rendered.contains("hover:dark:text-yellow-300"))
  }

  @Test("Custom operator modifier syntax: three modifiers")
  func testCustomOperatorThreeModifiers() async throws {
    let element = Stack()
      .on {
        (hover <&> dark <&> focus) {
          opacity(90)
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:focus:opacity-90"))
  }

  @Test("Nested modifier syntax support")
  func testNestedModifierSyntax() async throws {
    let element = Stack()
      .on {
        hover {
          dark {
            background(color: .red(._500))
            font(color: .white())
          }
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:bg-red-500"))
    #expect(rendered.contains("hover:dark:text-white"))
  }

  @Test("Comprehensive multiple modifier syntax demonstration")
  func testComprehensiveMultipleModifierSyntax() async throws {
    let element = Stack()
      .on {
        // Method 1: Variadic modifiers function
        modifiers(.hover, .dark) {
          background(color: .blue(._600))
        }

        // Method 2: Nested syntax
        hover {
          focus {
            border(of: 2, color: .green(._500))
          }
        }

        // Method 3: Custom operator syntax
        (md <&> placeholder) {
          font(color: .gray(._400))
        }

        // Method 4: Mixed usage
        lg {
          padding(of: 8)
        }
        modifiers(.disabled, .ariaBusy) {
          opacity(50)
        }
      }

    let rendered = element.render()

    // Verify variadic syntax
    #expect(rendered.contains("hover:dark:bg-blue-600"))

    // Verify nested syntax
    #expect(rendered.contains("hover:focus:border-2"))
    #expect(rendered.contains("hover:focus:border-green-500"))

    // Verify custom operator syntax
    #expect(rendered.contains("md:placeholder:text-gray-400"))

    // Verify mixed usage
    #expect(rendered.contains("lg:p-8"))
    #expect(rendered.contains("disabled:aria-busy:opacity-50"))
  }

  @Test("Multiple multi-modifier blocks")
  func testMultipleMultiModifierBlocks() async throws {
    let element = Stack()
      .on {
        modifiers(.hover, .dark) {
          background(color: .red(._500))
        }
        modifiers(.focus, .dark) {
          border(of: 1, color: .blue(._500))
        }
        modifiers(.lg, .dark) {
          padding(of: 6)
        }
      }
    let rendered = element.render()
    #expect(rendered.contains("hover:dark:bg-red-500"))
    #expect(rendered.contains("focus:dark:border-1"))
    #expect(rendered.contains("focus:dark:border-blue-500"))
    #expect(rendered.contains("lg:dark:p-6"))
  }

  @Test("ARIA state modifiers")
  func testAriaStateModifiers() async throws {
    let element = Stack()
      .on {
        ariaExpanded {
          border(of: 1, color: .gray(._300))
        }
        ariaSelected {
          background(color: .blue(._100))
          font(weight: .bold)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("aria-expanded:border-1"))
    #expect(rendered.contains("aria-expanded:border-gray-300"))
    #expect(rendered.contains("aria-selected:bg-blue-100"))
    #expect(rendered.contains("aria-selected:font-bold"))
  }

  @Test("Placeholder modifier")
  func testPlaceholderModifier() async throws {
    let element = Input(name: "name", type: .text)
      .on {
        placeholder {
          font(color: .gray(._400))
          font(weight: .light)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("placeholder:text-gray-400"))
    #expect(rendered.contains("placeholder:font-light"))
  }

  @Test("First and last child modifiers")
  func testFirstLastChildModifiers() async throws {
    let element = List {
      Item { "Item 1" }
      Item { "Item 2" }
    }
    .on {
      first {
        border(of: 0, at: .top)
      }
      last {
        border(of: 0, at: .bottom)
      }
    }

    let rendered = element.render()
    #expect(rendered.contains("first:border-t-0"))
    #expect(rendered.contains("last:border-b-0"))
  }

  @Test("Disabled state modifier")
  func testDisabledStateModifier() async throws {
    let element = Button("Disabled Button")
      .on {
        disabled {
          opacity(50)
          cursor(.notAllowed)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("disabled:opacity-50"))
    #expect(rendered.contains("disabled:cursor-not-allowed"))
  }

  @Test("Motion reduce modifier")
  func testMotionReduceModifier() async throws {
    let element = Stack()
      .transition(of: .transform, for: 300)
      .on {
        motionReduce {
          transition(of: .transform, for: 0)
        }
      }

    let rendered = element.render()
    #expect(rendered.contains("transition-transform"))
    #expect(rendered.contains("duration-300"))
    #expect(!rendered.contains("motion-reduce:transition-transform"))
    #expect(rendered.contains("motion-reduce:duration-0"))
  }

  // MARK: - Responsive Modifier Tests

  @Test("Complex component with responsive syntax")
  func testComplexComponentResponsiveSyntax() async throws {
    let button = Button("Submit", type: .submit)
      .background(color: .blue(._500))
      .font(color: .blue(._50))
      .padding(of: 2)
      .rounded(.md)
      .on {
        sm {
          padding(of: 3)
        }
        md {
          padding(of: 4)
          font(size: .lg)
        }
        lg {
          padding(of: 6)
          background(color: .blue(._600))
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

  @Test("Combined sizing styles with responsive modifiers")
  func testCombinedSizingStylesWithResponsiveModifiers() async throws {
    let element = Stack()
      .frame(width: .container(.extraLarge), minHeight: 50.spacing)
      .size(24.spacing, on: .sm)
      .aspectRatioVideo(on: .lg)
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"w-xl min-h-50 sm:size-24 lg:aspect-video\""
      )
    )
  }

  // MARK: - Complex Interactive Modifier Tests

  @Test("Complex interactive button with modifiers")
  func testComplexInteractiveButtonWithModifiers() async throws {
    let button = Button("Hello World!")
      .padding(of: 4)
      .background(color: .blue(._500))
      .font(color: .gray(._50))
      .rounded(.md)
      .transition(of: .all, for: 150)
      .on {
        hover {
          background(color: .blue(._600))
          transform(scale: (x: 105, y: 105))
        }
        focus {
          outline(of: 2, color: .blue(._300))
          outline(style: .solid)
        }
        active {
          background(color: .blue(._700))
          transform(scale: (x: 95, y: 95))
        }
        disabled {
          background(color: .gray(._400))
          opacity(75)
          cursor(.notAllowed)
        }
      }

    let rendered = button.render()
    #expect(rendered.contains("p-4"))
    #expect(rendered.contains("bg-blue-500"))
    #expect(rendered.contains("text-gray-50"))
    #expect(rendered.contains("rounded-md"))
    #expect(rendered.contains("transition-all"))
    #expect(rendered.contains("duration-150"))
    #expect(rendered.contains("hover:bg-blue-600"))
    #expect(rendered.contains("hover:scale-x-105"))
    #expect(rendered.contains("hover:scale-y-105"))
    #expect(rendered.contains("focus:outline-2"))
    #expect(rendered.contains("focus:outline-blue-300"))
    #expect(rendered.contains("focus:outline-solid"))
    #expect(rendered.contains("active:bg-blue-700"))
    #expect(rendered.contains("active:scale-x-95"))
    #expect(rendered.contains("active:scale-y-95"))
    #expect(rendered.contains("disabled:bg-gray-400"))
    #expect(rendered.contains("disabled:opacity-75"))
    #expect(rendered.contains("disabled:cursor-not-allowed"))
  }

  @Test("Combined appearance styles with hover modifier")
  func testCombinedAppearanceStylesWithHoverModifier() async throws {
    let element = Stack()
      .background(color: .blue(._600))
      .border(of: 1, style: .solid, color: .blue(._800))
      .opacity(90, on: .hover)
      .flex(direction: .row, justify: .center)
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"bg-blue-600 border-1 border-solid border-blue-800 hover:opacity-90 flex flex-row justify-center\""
      )
    )
  }

  @Test("Element Structure Test")
  func elementStructureTest() async throws {
    // Works fine in ``Document``
    struct TestDocument: Document {
      var metadata: Metadata {
        .init(title: "Hello")
      }

      var body: some Markup {
        Text("Hello")
          .on {
            md {
              S.font(color: .amber(._100))
            }
            placeholder {
              S.font(color: .amber(._100))
            }
          }
      }
    }
    // FIXME: If possible remove `S.` prefix
    struct TestElement: Element {
      var body: some Markup {
        Text("Hello")
          .on {
            md {
              S.font(color: .amber(._100))
            }
            modifiers(placeholder, hover) {
              S.font(color: .amber(._100))
            }
          }
      }
    }

    let renderedDoc = try TestDocument().render()
    let renderedEle = TestElement().render()

    #expect(renderedDoc.contains("placeholder:text-amber-100"))
    #expect(renderedEle.contains("placeholder:hover:text-amber-100"))
    #expect(renderedDoc.contains("md:text-amber-100"))
    #expect(renderedEle.contains("md:text-amber-100"))
  }
}
