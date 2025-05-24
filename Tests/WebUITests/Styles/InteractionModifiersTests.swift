import Testing

@testable import WebUI

@Suite("Interaction Modifiers Tests")
struct InteractionModifiersTests {
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
        let element = Button { "Disabled Button" }
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
        #expect(rendered.contains("motion-reduce:duration-0"))
    }

    @Test("Complex interactive button")
    func testComplexInteractiveButton() async throws {
        let button = Button { "Hello World!" }
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
}
