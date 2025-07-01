import Testing

@testable import WebUI

// MARK: - HTML Protocol Tests

@Suite("Element Tests") struct ElementTests {
    // MARK: - Button Tests

    @Test("Button element with type and autofocus")
    func testButtonElement() async throws {
        let button = Button(
            type: .submit,
            autofocus: true,
            id: "submit-btn",
            classes: ["primary", "large"],
        ) {
            "Submit"
        }

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("id=\"submit-btn\""))
        #expect(rendered.contains("class=\"primary large\""))
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("autofocus"))
        #expect(rendered.contains(">Submit</button>"))
    }

    @Test("Button element with string initializer")
    func testButtonStringInitializer() async throws {
        let button = Button("Click Me")

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains(">Click Me</button>"))
    }

    @Test("Button element with string initializer and attributes")
    func testButtonStringInitializerWithAttributes() async throws {
        let button = Button(
            "Save Changes",
            type: .submit,
            autofocus: true,
            onClick: "saveForm()",
            id: "save-btn",
            classes: ["primary", "large"],
            role: .button
        )

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("id=\"save-btn\""))
        #expect(rendered.contains("class=\"primary large\""))
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("autofocus"))
        #expect(rendered.contains("onclick=\"saveForm()\""))
        #expect(rendered.contains("role=\"button\""))
        #expect(rendered.contains(">Save Changes</button>"))
    }

    @Test("Button element with systemImage initializer")
    func testButtonSystemImageInitializer() async throws {
        let button = Button("Save", systemImage: "checkmark")

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("system-image"))
        #expect(rendered.contains("icon-checkmark"))
        #expect(rendered.contains("button-icon"))
        #expect(rendered.contains(" Save"))
        #expect(rendered.contains("</button>"))
    }

    @Test("Button element with systemImage and attributes")
    func testButtonSystemImageInitializerWithAttributes() async throws {
        let button = Button(
            "Delete Item",
            systemImage: "trash.fill",
            type: .submit,
            onClick: "confirmDelete()",
            id: "delete-btn",
            classes: ["danger"],
            label: "Delete selected item"
        )

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("id=\"delete-btn\""))
        #expect(rendered.contains("class=\"danger\""))
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("onclick=\"confirmDelete()\""))
        #expect(rendered.contains("aria-label=\"Delete selected item\""))
        #expect(rendered.contains("system-image"))
        #expect(rendered.contains("icon-trash-fill"))
        #expect(rendered.contains("button-icon"))
        #expect(rendered.contains(" Delete Item"))
        #expect(rendered.contains("</button>"))
    }

    @Test("SystemImage element standalone")
    func testSystemImageElement() async throws {
        let image = SystemImage("star.fill", classes: ["rating-star"])

        let rendered = image.render()
        #expect(rendered.contains("<span"))
        #expect(rendered.contains("class=\"system-image icon-star-fill rating-star\""))
        #expect(rendered.contains("aria-label=\"star.fill\""))
        #expect(rendered.contains("></span>"))
    }

    @Test("SystemImage element with custom attributes")
    func testSystemImageElementWithAttributes() async throws {
        let image = SystemImage(
            "heart",
            id: "favorite-icon",
            classes: ["favorite"],
            role: .button,
            label: "Add to favorites"
        )

        let rendered = image.render()
        #expect(rendered.contains("<span"))
        #expect(rendered.contains("id=\"favorite-icon\""))
        #expect(rendered.contains("class=\"system-image icon-heart favorite\""))
        #expect(rendered.contains("role=\"button\""))
        #expect(rendered.contains("aria-label=\"Add to favorites\""))
        #expect(rendered.contains("></span>"))
    }

    @Test("Button element with onClick only")
    func testButtonWithOnClick() async throws {
        let button = Button("Cancel", onClick: "closeDialog()")

        let rendered = button.render()
        #expect(rendered.contains("<button"))
        #expect(rendered.contains("onclick=\"closeDialog()\""))
        #expect(rendered.contains(">Cancel</button>"))
    }

    // MARK: - List Tests

    @Test("Unordered list")
    func testUnorderedList() async throws {
        let list = List(type: .unordered) {
            Item { "Item 1" }
            Item { "Item 2" }
            Item { "Item 3" }
        }

        let rendered = list.render()
        #expect(rendered.contains("<ul>"))
        #expect(rendered.contains("<li>Item 1</li>"))
        #expect(rendered.contains("<li>Item 2</li>"))
        #expect(rendered.contains("<li>Item 3</li>"))
        #expect(rendered.contains("</ul>"))
    }

    @Test("Ordered list")
    func testOrderedList() async throws {
        let list = List(type: .ordered) {
            Item { "Item 1" }
            Item { "Item 2" }
        }

        let rendered = list.render()
        #expect(rendered.contains("<ol>"))
        #expect(rendered.contains("<li>Item 1</li>"))
        #expect(rendered.contains("<li>Item 2</li>"))
        #expect(rendered.contains("</ol>"))
    }

    @Test("List Styles")
    func testListStyles() async throws {
        let disc = List(style: .disc).render()
        let circle = List(style: .circle).render()
        let square = List(style: .square).render()

        #expect(disc.contains("list-disc"))
        #expect(circle.contains("list-circle"))
        #expect(square.contains("list-[square]"))
    }

    // MARK: - Media Tests

    @Test("Picture element with multiple sources")
    func testPictureElement() async throws {
        let picture = Picture(
            sources: [
                (src: "/image.jpg", type: .jpeg),
                (src: "/image.webp", type: .webp),
            ],
            description: "Profile picture",
            size: MediaSize(width: 300, height: 200),
            id: "profile-pic",
            classes: ["rounded"]
        )

        let rendered = picture.render()
        #expect(rendered.contains("<picture"))
        #expect(rendered.contains("id=\"profile-pic\""))
        #expect(rendered.contains("class=\"rounded\""))
        #expect(
            rendered.contains(
                "<source type=\"image/jpeg\" srcset=\"/image.jpg\" />"))
        #expect(
            rendered.contains(
                "<source type=\"image/webp\" srcset=\"/image.webp\" />")
        )
        #expect(rendered.contains("<img"))
        #expect(rendered.contains("alt=\"Profile picture\""))
        #expect(rendered.contains("width=\"300\""))
        #expect(rendered.contains("height=\"200\""))
        #expect(rendered.contains("</picture>"))
    }

    @Test("Figure element with picture and figcaption")
    func testFigureElement() async throws {
        let figure = Figure(
            sources: [
                (src: "/large.jpg", type: .jpeg),
                (src: "/small.webp", type: .webp),
            ],
            description: "A scenic mountain view",
            size: MediaSize(width: 800, height: 600),
            id: "mountain-fig",
            classes: ["image-figure"]
        )

        let rendered = figure.render()
        #expect(rendered.contains("<figure"))
        #expect(rendered.contains("id=\"mountain-fig\""))
        #expect(rendered.contains("class=\"image-figure\""))
        #expect(rendered.contains("<picture"))
        #expect(
            rendered.contains(
                "<source type=\"image/jpeg\" srcset=\"/large.jpg\">"))
        #expect(
            rendered.contains(
                "<source type=\"image/webp\" srcset=\"/small.webp\">"))
        #expect(rendered.contains("<img"))
        #expect(rendered.contains("alt=\"A scenic mountain view\""))
        #expect(rendered.contains("width=\"800\""))
        #expect(rendered.contains("height=\"600\""))
        #expect(rendered.contains("</picture>"))
        #expect(
            rendered.contains("<figcaption>A scenic mountain view</figcaption>")
        )
        #expect(rendered.contains("</figure>"))
    }

    @Test("Video element")
    func testVideoElement() async throws {
        let video = Video(
            sources: [
                (src: "/video/intro.mp4", type: .mp4),
                (src: "/video/intro.webm", type: .webm),
            ],
            controls: true,
            autoplay: false,
            loop: true,
            size: MediaSize(width: 800, height: 450),
            id: "intro-video"
        )

        let rendered = video.render()
        #expect(rendered.contains("<video"))
        #expect(rendered.contains("id=\"intro-video\""))
        #expect(rendered.contains("controls"))
        #expect(!rendered.contains("autoplay"))
        #expect(rendered.contains("loop"))
        #expect(rendered.contains("width=\"800\""))
        #expect(rendered.contains("height=\"450\""))
        #expect(
            rendered.contains(
                "<source src=\"/video/intro.mp4\" type=\"video/mp4\">"))
        #expect(
            rendered.contains(
                "<source src=\"/video/intro.webm\" type=\"video/webm\">"))
        #expect(
            rendered.contains(
                ">Your browser does not support the video tag.</video>")
        )
    }

    @Test("Audio element")
    func testAudioElement() async throws {
        let audio = Audio(
            sources: [
                (src: "/audio/podcast.mp3", type: .mp3),
                (src: "/audio/podcast.ogg", type: .ogg),
            ],
            controls: true,
            autoplay: false,
            loop: false,
            id: "podcast"
        )

        let rendered = audio.render()
        #expect(rendered.contains("<audio"))
        #expect(rendered.contains("id=\"podcast\""))
        #expect(rendered.contains("controls"))
        #expect(!rendered.contains("autoplay"))
        #expect(!rendered.contains("loop"))
        #expect(
            rendered.contains(
                "<source src=\"/audio/podcast.mp3\" type=\"audio/mpeg\">"))
        #expect(
            rendered.contains(
                "<source src=\"/audio/podcast.ogg\" type=\"audio/ogg\">"))
        #expect(
            rendered.contains(
                ">Your browser does not support the audio element.</audio>"))
    }

    // MARK: - Style Tests

    @Test("Style element")
    func testStyleElement() async throws {
        let style = Style {
            ".header { color: blue; }"
        }

        let rendered = style.render()
        #expect(rendered == "<style>.header { color: blue; }</style>")
    }

    // MARK: - Text Element Tests

    @Test("Text element as paragraph")
    func testTextAsParagraph() async throws {
        let text = Text {
            "This is a long paragraph. It contains multiple sentences. This should be rendered as a p tag."
        }

        let rendered = text.render()
        #expect(rendered.contains("<p>"))
        #expect(rendered.contains("This is a long paragraph."))
        #expect(rendered.contains("</p>"))
    }

    @Test("Text element as span")
    func testTextAsSpan() async throws {
        let text = Text {
            "Just one sentence."
        }

        let rendered = text.render()
        #expect(rendered.contains("<span>"))
        #expect(rendered.contains("Just one sentence."))
        #expect(rendered.contains("</span>"))
    }

    @Test("Text element with string initializer as paragraph")
    func testTextStringInitializerAsParagraph() async throws {
        let text = Text("This is a long paragraph. It contains multiple sentences. This should be rendered as a p tag.")

        let rendered = text.render()
        #expect(rendered.contains("<p>"))
        #expect(rendered.contains("This is a long paragraph."))
        #expect(rendered.contains("</p>"))
    }

    @Test("Text element with string initializer as span")
    func testTextStringInitializerAsSpan() async throws {
        let text = Text("Just one sentence.")

        let rendered = text.render()
        #expect(rendered.contains("<span>"))
        #expect(rendered.contains("Just one sentence."))
        #expect(rendered.contains("</span>"))
    }

    @Test("Text element with string initializer and additional attributes")
    func testTextStringInitializerWithAttributes() async throws {
        let text = Text(
            "Hello, world!",
            id: "greeting",
            classes: ["intro", "bold"],
            role: .status
        )

        let rendered = text.render()
        #expect(rendered.contains("<span"))
        #expect(rendered.contains("id=\"greeting\""))
        #expect(rendered.contains("class=\"intro bold\""))
        #expect(rendered.contains("role=\"status\""))
        #expect(rendered.contains("Hello, world!"))
        #expect(rendered.contains("</span>"))
    }

    @Test("Heading element")
    func testHeadingElement() async throws {
        let heading1 = Heading(.largeTitle) { "Main Title" }
        let heading2 = Heading(.title) { "Subtitle" }
        let heading6 = Heading(.footnote) { "Small Heading" }

        #expect(heading1.render() == "<h1>Main Title</h1>")
        #expect(heading2.render() == "<h2>Subtitle</h2>")
        #expect(heading6.render() == "<h6>Small Heading</h6>")
    }

    @Test("Heading element with string initializer")
    func testHeadingStringInitializer() async throws {
        let heading1 = Heading(.largeTitle, "Main Title")
        let heading2 = Heading(.title, "Subtitle")
        let heading6 = Heading(.footnote, "Small Heading")

        #expect(heading1.render() == "<h1>Main Title</h1>")
        #expect(heading2.render() == "<h2>Subtitle</h2>")
        #expect(heading6.render() == "<h6>Small Heading</h6>")
    }

    @Test("Heading element with string initializer and attributes")
    func testHeadingStringInitializerWithAttributes() async throws {
        let heading = Heading(
            .title,
            "Section Title",
            id: "section-title",
            classes: ["article-heading", "primary"],
            role: .heading
        )

        let rendered = heading.render()
        #expect(rendered.contains("<h2"))
        #expect(rendered.contains("id=\"section-title\""))
        #expect(rendered.contains("class=\"article-heading primary\""))
        #expect(rendered.contains("role=\"heading\""))
        #expect(rendered.contains(">Section Title</h2>"))
    }

    @Test("Link element")
    func testLinkElement() async throws {
        let link = Link(to: "https://example.com", newTab: true) {
            "Visit Example"
        }

        let rendered = link.render()
        #expect(rendered.contains("<a"))
        #expect(rendered.contains("href=\"https://example.com\""))
        #expect(rendered.contains("target=\"_blank\""))
        #expect(rendered.contains("rel=\"noreferrer\""))
        #expect(rendered.contains(">Visit Example</a>"))
    }

    @Test("Emphasis element")
    func testEmphasisElement() async throws {
        let em = Emphasis { "Important text" }

        #expect(em.render() == "<em>Important text</em>")
    }

    @Test("Strong element")
    func testStrongElement() async throws {
        let strong = Strong { "Bold text" }

        #expect(strong.render() == "<strong>Bold text</strong>")
    }

    @Test("Strong element with string initializer")
    func testStrongStringInitializer() async throws {
        let strong = Strong("Bold text")

        #expect(strong.render() == "<strong>Bold text</strong>")
    }

    @Test("Strong element with string initializer and attributes")
    func testStrongStringInitializerWithAttributes() async throws {
        let strong = Strong(
            "Important warning!",
            id: "warning",
            classes: ["alert", "critical"]
        )

        let rendered = strong.render()
        #expect(rendered.contains("<strong"))
        #expect(rendered.contains("id=\"warning\""))
        #expect(rendered.contains("class=\"alert critical\""))
        #expect(rendered.contains(">Important warning!</strong>"))
    }

    @Test("Emphasis element with string initializer")
    func testEmphasisStringInitializer() async throws {
        let emphasis = Emphasis("Important text")

        #expect(emphasis.render() == "<em>Important text</em>")
    }

    @Test("Emphasis element with string initializer and attributes")
    func testEmphasisStringInitializerWithAttributes() async throws {
        let emphasis = Emphasis(
            "Key point to remember",
            classes: ["highlight", "important"]
        )

        let rendered = emphasis.render()
        #expect(rendered.contains("<em"))
        #expect(rendered.contains("class=\"highlight important\""))
        #expect(rendered.contains(">Key point to remember</em>"))
    }

    @Test("Code element with string initializer")
    func testCodeStringInitializer() async throws {
        let code = Code("let x = 5")

        #expect(code.render() == "<code>let x = 5</code>")
    }

    @Test("Code element with string initializer and attributes")
    func testCodeStringInitializerWithAttributes() async throws {
        let code = Code(
            "console.log('Hello, world!')",
            classes: ["javascript", "inline-code"]
        )

        let rendered = code.render()
        #expect(rendered.contains("<code"))
        #expect(rendered.contains("class=\"javascript inline-code\""))
        #expect(rendered.contains(">console.log('Hello, world!')</code>"))
    }

    @Test("Link element with string initializer")
    func testLinkStringInitializer() async throws {
        let link = Link("Visit Example", destination: "https://example.com")

        let rendered = link.render()
        #expect(rendered.contains("<a"))
        #expect(rendered.contains("href=\"https://example.com\""))
        #expect(rendered.contains(">Visit Example</a>"))
    }

    @Test("Link element with string initializer and newTab")
    func testLinkStringInitializerWithNewTab() async throws {
        let link = Link("Open in New Tab", destination: "https://example.com", newTab: true)

        let rendered = link.render()
        #expect(rendered.contains("<a"))
        #expect(rendered.contains("href=\"https://example.com\""))
        #expect(rendered.contains("target=\"_blank\""))
        #expect(rendered.contains("rel=\"noreferrer\""))
        #expect(rendered.contains(">Open in New Tab</a>"))
    }

    @Test("Link element with string initializer and attributes")
    func testLinkStringInitializerWithAttributes() async throws {
        let link = Link(
            "Contact Us",
            destination: "/contact",
            id: "contact-link",
            classes: ["nav-link", "primary"]
        )

        let rendered = link.render()
        #expect(rendered.contains("<a"))
        #expect(rendered.contains("href=\"/contact\""))
        #expect(rendered.contains("id=\"contact-link\""))
        #expect(rendered.contains("class=\"nav-link primary\""))
        #expect(rendered.contains(">Contact Us</a>"))
    }

    @Test("Time element")
    func testTimeElement() async throws {
        let time = Time(datetime: "2025-04-21") {
            "April 21, 2025"
        }

        let rendered = time.render()
        #expect(rendered.contains("<time"))
        #expect(rendered.contains("datetime=\"2025-04-21\""))
        #expect(rendered.contains(">April 21, 2025</time>"))
    }

    @Test("Code element")
    func testCodeElement() async throws {
        let code = Code {
            "let x = 5"
        }

        #expect(code.render() == "<code>let x = 5</code>")
    }

    @Test("Preformatted element")
    func testPreformattedElement() async throws {
        let pre = Preformatted {
            "function hello() {\n  console.log(\"Hello\");\n}"
        }

        let rendered = pre.render()
        #expect(rendered.contains("<pre>"))
        #expect(
            rendered.contains("function hello() {\n  console.log(&quot;Hello&quot;);\n}"))
        #expect(rendered.contains("</pre>"))
    }

    // MARK: - Form Element Tests

    @Test("Form element")
    func testFormElement() async throws {
        let form = Form(
            action: "/submit",
            method: .post,
            id: "contact-form",
        ) {
            Input(name: "test")
        }

        let rendered = form.render()
        #expect(rendered.contains("<form"))
        #expect(rendered.contains("id=\"contact-form\""))
        #expect(rendered.contains("action=\"/submit\""))
        #expect(rendered.contains("method=\"post\""))
        #expect(rendered.contains("<input name=\"test\" />"))
        #expect(rendered.contains("</form>"))
    }

    // MARK: - Input Element Tests

    @Test("Input element")
    func testInputElement() async throws {
        let input = Input(
            name: "username",
            type: .text,
            value: "default",
            placeholder: "Enter username",
            autofocus: true,
            required: true,
            id: "username",
        )

        let rendered = input.render()
        #expect(rendered.contains("<input"))
        #expect(rendered.contains("id=\"username\""))
        #expect(rendered.contains("name=\"username\""))
        #expect(rendered.contains("type=\"text\""))
        #expect(rendered.contains("value=\"default\""))
        #expect(rendered.contains("placeholder=\"Enter username\""))
        #expect(rendered.contains("autofocus"))
        #expect(rendered.contains("required"))
    }

    @Test("Checkbox input")
    func testCheckboxInput() async throws {
        let checkbox = Input(
            name: "agree",
            type: .checkbox,
            checked: true,
            id: "agree",
        )

        let rendered = checkbox.render()
        #expect(rendered.contains("<input"))
        #expect(rendered.contains("id=\"agree\""))
        #expect(rendered.contains("type=\"checkbox\""))
        #expect(rendered.contains("checked"))
    }

    // MARK: - Label Element Tests

    @Test("Label element")
    func testLabelElement() async throws {
        let label = Label(
            for: "name-input",
            id: "name-label",
        ) {
            "Your Name:"
        }

        let rendered = label.render()
        #expect(rendered.contains("<label"))
        #expect(rendered.contains("id=\"name-label\""))
        #expect(rendered.contains("for=\"name-input\""))
        #expect(rendered.contains(">Your Name:</label>"))
    }

    // MARK: - Progress Element Tests

    @Test("Progress element")
    func testProgressElement() async throws {
        let progress = Progress(
            value: 75,
            max: 100,
            id: "download-progress",
        )

        let rendered = progress.render()
        #expect(rendered.contains("<progress"))
        #expect(rendered.contains("id=\"download-progress\""))
        #expect(rendered.contains("value=\"75.0\""))
        #expect(rendered.contains("max=\"100.0\""))
    }

    // MARK: - TextArea Element Tests

    @Test("TextArea element")
    func testTextAreaElement() async throws {
        let textarea = TextArea(
            name: "message",
            placeholder: "Enter your message",
            required: true,
            id: "message",
        )

        let rendered = textarea.render()
        #expect(rendered.contains("<textarea"))
        #expect(rendered.contains("id=\"message\""))
        #expect(rendered.contains("name=\"message\""))
        #expect(rendered.contains("placeholder=\"Enter your message\""))
        #expect(rendered.contains("required"))
        #expect(rendered.contains("</textarea>"))
    }

    // MARK: - Layout Element Tests

    @Test("Header element")
    func testHeaderElement() async throws {
        let header = Header(id: "page-header") {
            Heading(.largeTitle) { "Site Title" }
        }

        let rendered = header.render()
        #expect(rendered.contains("<header"))
        #expect(rendered.contains("id=\"page-header\""))
        #expect(rendered.contains("<h1>Site Title</h1>"))
        #expect(rendered.contains("</header>"))
    }

    @Test("Navigation element")
    func testNavigationElement() async throws {
        let nav = Navigation(id: "main-nav") {
            List(type: .unordered) { Item { "Home" } }
        }

        let rendered = nav.render()
        #expect(rendered.contains("<nav"))
        #expect(rendered.contains("id=\"main-nav\""))
        #expect(rendered.contains("<ul><li>Home</li></ul>"))
        #expect(rendered.contains("</nav>"))
    }

    @Test("Aside element")
    func testAsideElement() async throws {
        let aside = Aside(id: "sidebar") {
            Text { "Related content" }
        }

        let rendered = aside.render()
        #expect(rendered.contains("<aside"))
        #expect(rendered.contains("id=\"sidebar\""))
        #expect(rendered.contains("Related content"))
        #expect(rendered.contains("</aside>"))
    }

    @Test("Main element")
    func testMainElement() async throws {
        let mainElement = Main(id: "content") {
            Text { "Main content" }
        }

        let rendered = mainElement.render()
        #expect(rendered.contains("<main"))
        #expect(rendered.contains("id=\"content\""))
        #expect(rendered.contains("Main content"))
        #expect(rendered.contains("</main>"))
    }

    @Test("Footer element")
    func testFooterElement() async throws {
        let footer = Footer(id: "page-footer") {
            Text { "Copyright 2025" }
        }

        let rendered = footer.render()
        #expect(rendered.contains("<footer"))
        #expect(rendered.contains("id=\"page-footer\""))
        #expect(rendered.contains("Copyright 2025"))
        #expect(rendered.contains("</footer>"))
    }

    // MARK: - Structure Element Tests

    @Test("Article element")
    func testArticleElement() async throws {
        let article = Article(id: "blog-post") {
            Heading(.title) { "Article Title" }
            Text { "Article content" }
        }

        let rendered = article.render()
        #expect(rendered.contains("<article"))
        #expect(rendered.contains("id=\"blog-post\""))
        #expect(rendered.contains("<h2>Article Title</h2>"))
        #expect(rendered.contains("Article content"))
        #expect(rendered.contains("</article>"))
    }

    @Test("Section element")
    func testSectionElement() async throws {
        let section = Section(id: "features") {
            Heading(.headline) { "Features" }
            Text { "Feature list" }
        }

        let rendered = section.render()
        #expect(rendered.contains("<section"))
        #expect(rendered.contains("id=\"features\""))
        #expect(rendered.contains("<h3>Features</h3>"))
        #expect(rendered.contains("Feature list"))
        #expect(rendered.contains("</section>"))
    }

    @Test("Stack element")
    func testStackElement() async throws {
        let stack = Stack(id: "container", classes: ["flex", "gap-4"]) {
            Stack(classes: ["card"]) { "Card 1" }
            Stack(classes: ["card"]) { "Card 2" }
        }

        let rendered = stack.render()
        #expect(rendered.contains("<div"))
        #expect(rendered.contains("id=\"container\""))
        #expect(rendered.contains("class=\"flex gap-4\""))
        #expect(rendered.contains("<div class=\"card\">Card 1</div>"))
        #expect(rendered.contains("<div class=\"card\">Card 2</div>"))
        #expect(rendered.contains("</div>"))
    }

    // MARK: - Complex Element Composition Tests

    @Test("Complex form with multiple elements")
    func testComplexForm() async throws {
        let contactForm = Form(action: "/submit", method: .post, id: "contact") {
            Stack(classes: ["form-group"]) {
                Label(for: "name") { "Name:" }
                Input(name: "name", type: .text, required: true, id: "name")
            }
            Stack(classes: ["form-group"]) {
                Label(for: "email") { "Email:" }
                Input(name: "email", type: .email, required: true, id: "email")
            }
            Stack(classes: ["form-group"]) {
                Label(for: "message") { "Message:" }
                TextArea(name: "message", required: true, id: "message")
            }
            Stack(classes: ["form-check"]) {
                Input(name: "subscribe", type: .checkbox, id: "subscribe")
                Label(for: "subscribe") { "Subscribe to newsletter" }
            }
            Button(type: .submit) { "Send Message" }
        }

        let rendered = contactForm.render()
        #expect(
            rendered.contains(
                "<form id=\"contact\" action=\"/submit\" method=\"post\">"
            )
        )
        #expect(rendered.contains("<div class=\"form-group\">"))
        #expect(rendered.contains("<label for=\"name\">Name:</label>"))
        #expect(
            rendered.contains(
                "<input id=\"name\" name=\"name\" type=\"text\" required />"
            )
        )
        #expect(rendered.contains("<label for=\"email\">Email:</label>"))
        #expect(
            rendered.contains(
                "<input id=\"email\" name=\"email\" type=\"email\" required />"
            )
        )
        #expect(rendered.contains("<label for=\"message\">Message:</label>"))
        #expect(
            rendered.contains(
                "<textarea id=\"message\" name=\"message\" required></textarea>"
            )
        )
        #expect(
            rendered.contains(
                "<input id=\"subscribe\" name=\"subscribe\" type=\"checkbox\" />"
            )
        )
        #expect(
            rendered.contains(
                "<label for=\"subscribe\">Subscribe to newsletter</label>"
            )
        )
        #expect(
            rendered.contains("<button type=\"submit\">Send Message</button>"))
        #expect(rendered.contains("</form>"))
    }

    @Test("Page layout with multiple sections")
    func testPageLayout() async throws {
        let page = Stack {
            Header(id: "main-header") {
                Heading(.largeTitle) { "My Website" }
                Navigation {
                    List(type: .unordered, classes: ["nav-links"]) {
                        Item { Link(to: "/") { "Home" } }
                        Item { Link(to: "/about") { "About" } }
                        Item { Link(to: "/contact") { "Contact" } }
                    }
                }
            }
            Main {
                Article {
                    Heading(.title) { "Welcome" }
                    Text { "This is the main content of the page." }
                }
            }
            Aside(id: "sidebar") {
                Heading(.headline) { "Related Links" }
                List(type: .unordered) {
                    Item { Link(to: "/link1") { "Link 1" } }
                    Item { Link(to: "/link2") { "Link 2" } }
                }
            }
            Footer {
                Text { "Copyright © 2025" }
            }
        }

        let rendered = page.render()
        #expect(rendered.contains("<header id=\"main-header\">"))
        #expect(rendered.contains("<h1>My Website</h1>"))
        #expect(rendered.contains("<nav>"))
        #expect(rendered.contains("<ul class=\"nav-links\">"))
        #expect(rendered.contains("<li><a href=\"/\">Home</a></li>"))
        #expect(rendered.contains("<main>"))
        #expect(rendered.contains("<article>"))
        #expect(rendered.contains("<h2>Welcome</h2>"))
        #expect(rendered.contains("<aside id=\"sidebar\">"))
        #expect(rendered.contains("<h3>Related Links</h3>"))
        #expect(rendered.contains("<footer>"))
        #expect(rendered.contains("<span>Copyright © 2025</span>"))
    }

    // MARK: - Abbrevation Tests

    @Test("Abbreviation element")
    func testAbbreviationElement() async throws {
        let abbr = Abbreviation(title: "Hypertext Markup Language") {
            "HTML"
        }

        let rendered = abbr.render()
        #expect(rendered.contains("<abbr"))
        #expect(rendered.contains("title=\"Hypertext Markup Language\""))
        #expect(rendered.contains(">HTML</abbr>"))
    }

    @Test("Abbreviation with additional attributes")
    func testAbbreviationWithAttributes() async throws {
        let abbr = Abbreviation(
            title: "World Health Organization",
            id: "who-abbr",
            classes: ["term", "org"]
        ) {
            "WHO"
        }

        let rendered = abbr.render()
        #expect(rendered.contains("<abbr"))
        #expect(rendered.contains("id=\"who-abbr\""))
        #expect(rendered.contains("class=\"term org\""))
        #expect(rendered.contains("title=\"World Health Organization\""))
        #expect(rendered.contains(">WHO</abbr>"))
    }

    // MARK: - ARIA Support Tests

    @Test("Element with ARIA attributes")
    func testElementWithAriaAttributes() async throws {
        let element = Stack(
            role: .tabpanel,
            label: "Panel Description"
        ) { "Tab panel content" }

        let rendered = element.render()
        #expect(rendered.contains("role=\"tabpanel\""))
        #expect(rendered.contains("aria-label=\"Panel Description\""))
        #expect(rendered.contains("<div"))
        #expect(rendered.contains(">Tab panel content</div>"))
    }

    @Test("Interactive element with ARIA roles")
    func testInteractiveElementWithAriaRoles() async throws {
        let tabContainer = Stack(
            role: .tablist
        ) {
            Button(
                role: AriaRole.tab,
                label: "First tab"
            ) { "Tab 1" }

            Button(
                role: AriaRole.tab,
                label: "Second tab"
            ) { "Tab 2" }
        }

        let rendered = tabContainer.render()
        #expect(rendered.contains("role=\"tablist\""))
        #expect(rendered.contains("role=\"tab\""))
        #expect(rendered.contains("aria-label=\"First tab\""))
        #expect(rendered.contains("aria-label=\"Second tab\""))
        #expect(rendered.contains(">Tab 1</button>"))
        #expect(rendered.contains(">Tab 2</button>"))
    }

    // MARK: - Edge Cases Tests

    @Test("Empty elements")
    func testEmptyElements() async throws {
        let div = Stack {}
        #expect(div.render() == "<div></div>")

        let span = Text {}
        #expect(span.render() == "<span></span>")
    }

    @Test("Nested empty elements")
    func testNestedEmptyElements() async throws {
        let nested = Stack {
            Stack {}
            Stack {
                Stack {}
            }
        }

        #expect(
            nested.render() == "<div><div></div><div><div></div></div></div>")
    }

    @Test("Elements with special characters")
    func testSpecialCharacters() async throws {
        let text = Text("Special & characters < need > to be escaped")

        let rendered = text.render()
        // HTML characters should now be properly escaped in content
        #expect(
            rendered.contains(
                "Special &amp; characters &lt; need &gt; to be escaped")
        )
    }

    // MARK: - ARIA Role Tests

    @Test("All landmark ARIA roles")
    func testLandmarkAriaRoles() async throws {
        let searchElement = Stack(role: .search) { "Search content" }
        #expect(searchElement.render().contains("role=\"search\""))

        let contentinfoElement = Stack(role: .contentinfo) { "Footer content" }
        #expect(contentinfoElement.render().contains("role=\"contentinfo\""))

        let mainElement = Stack(role: .main) { "Main content" }
        #expect(mainElement.render().contains("role=\"main\""))

        let navigationElement = Stack(role: .navigation) { "Nav content" }
        #expect(navigationElement.render().contains("role=\"navigation\""))

        let complementaryElement = Stack(role: .complementary) {
            "Aside content"
        }
        #expect(
            complementaryElement.render().contains("role=\"complementary\""))

        let bannerElement = Stack(role: .banner) { "Header content" }
        #expect(bannerElement.render().contains("role=\"banner\""))
    }

    @Test("All widget ARIA roles")
    func testWidgetAriaRoles() async throws {
        let buttonElement = Stack(role: .button) { "Button content" }
        #expect(buttonElement.render().contains("role=\"button\""))

        let checkboxElement = Stack(role: .checkbox) { "Checkbox content" }
        #expect(checkboxElement.render().contains("role=\"checkbox\""))

        let dialogElement = Stack(role: .dialog) { "Dialog content" }
        #expect(dialogElement.render().contains("role=\"dialog\""))

        let linkElement = Stack(role: .link) { "Link content" }
        #expect(linkElement.render().contains("role=\"link\""))

        let tabElement = Stack(role: .tab) { "Tab content" }
        #expect(tabElement.render().contains("role=\"tab\""))

        let tablistElement = Stack(role: .tablist) { "Tablist content" }
        #expect(tablistElement.render().contains("role=\"tablist\""))

        let tabpanelElement = Stack(role: .tabpanel) { "Tabpanel content" }
        #expect(tabpanelElement.render().contains("role=\"tabpanel\""))
    }

    @Test("All document structure ARIA roles")
    func testDocumentStructureAriaRoles() async throws {
        let articleElement = Stack(role: .article) { "Article content" }
        #expect(articleElement.render().contains("role=\"article\""))

        let headingElement = Stack(role: .heading) { "Heading content" }
        #expect(headingElement.render().contains("role=\"heading\""))

        let listElement = Stack(role: .list) { "List content" }
        #expect(listElement.render().contains("role=\"list\""))

        let listitemElement = Stack(role: .listitem) { "List item content" }
        #expect(listitemElement.render().contains("role=\"listitem\""))
    }

    @Test("All live region ARIA roles")
    func testLiveRegionAriaRoles() async throws {
        let alertElement = Stack(role: .alert) { "Alert content" }
        #expect(alertElement.render().contains("role=\"alert\""))

        let statusElement = Stack(role: .status) { "Status content" }
        #expect(statusElement.render().contains("role=\"status\""))
    }

    @Test("ARIA roles with semantic elements")
    func testAriaRolesWithSemanticElements() async throws {
        let semanticHeader = Header(role: .banner) { "Site header" }
        #expect(semanticHeader.render().contains("role=\"banner\""))

        let semanticNav = Navigation(role: .navigation) { "Site navigation" }
        #expect(semanticNav.render().contains("role=\"navigation\""))

        let semanticMain = Main(role: .main) { "Main content" }
        #expect(semanticMain.render().contains("role=\"main\""))

        let semanticAside = Aside(role: .complementary) { "Sidebar content" }
        #expect(semanticAside.render().contains("role=\"complementary\""))

        let semanticFooter = Footer(role: .contentinfo) { "Site footer" }
        #expect(semanticFooter.render().contains("role=\"contentinfo\""))

        let semanticArticle = Article(role: .article) { "Article content" }
        #expect(semanticArticle.render().contains("role=\"article\""))

        let semanticSection = Section(role: .search) { "Search section" }
        #expect(semanticSection.render().contains("role=\"search\""))
    }

    @Test("Interactive elements with appropriate ARIA roles")
    func testInteractiveElementsWithAriaRoles() async throws {
        let buttonWithRole = Button(role: .button, label: "Custom button") {
            "Click me"
        }
        let buttonRendered = buttonWithRole.render()
        #expect(buttonRendered.contains("role=\"button\""))
        #expect(buttonRendered.contains("aria-label=\"Custom button\""))

        let linkWithRole = Link(to: "/test", role: .link, label: "Custom link") {
            "Test link"
        }
        let linkRendered = linkWithRole.render()
        #expect(linkRendered.contains("role=\"link\""))
        #expect(linkRendered.contains("aria-label=\"Custom link\""))

        let inputWithRole = Input(
            name: "test", role: .checkbox, label: "Custom checkbox")
        let inputRendered = inputWithRole.render()
        #expect(inputRendered.contains("role=\"checkbox\""))
        #expect(inputRendered.contains("aria-label=\"Custom checkbox\""))
    }

    @Test("Button with Onclick Attribute")
    func testButtonWithOnClickAttribute() async throws {
        let buttonWithOnClick = Button(onClick: "hello()") {
            "Click me"
        }
        let buttonRendered = buttonWithOnClick.render()
        #expect(buttonRendered.contains("onclick=\"hello()\""))
    }

    @Test("Deeply nested elements")
    func testDeeplyNestedElements() async throws {
        let nested = Stack {
            Stack {
                Stack {
                    Stack {
                        Stack {
                            Text { "Deeply nested" }
                        }
                    }
                }
            }
        }

        let rendered = nested.render()
        #expect(
            rendered.contains(
                "<div><div><div><div><div><span>Deeply nested</span></div></div></div></div></div>"
            )
        )
    }

    // MARK: - DataAttributes Tests

    @Test("Element with single data attribute")
    func testSingleDatAttribute() async throws {
        let element = Stack(
            data: ["test": "value"]
        )

        let rendered = element.render()
        #expect(rendered == "<div data-test=\"value\"></div>")
    }

    @Test("Element with multiple data attributes")
    func testMultipleDatAttributes() async throws {
        let element = Text(
            data: [
                "user-id": "123",
                "theme": "dark",
                "status": "active",
            ]
        ) { "Content" }

        let rendered = element.render()
        #expect(rendered.contains("data-user-id=\"123\""))
        #expect(rendered.contains("data-theme=\"dark\""))
        #expect(rendered.contains("data-status=\"active\""))
    }

    @Test("Element with data attributes and other attributes")
    func testDatAttributesWithOtheAttributes() async throws {
        let element = Section(
            id: "content",
            classes: ["container"],
            role: AriaRole.contentinfo,
            data: [
                "page": "home",
                "version": "1.0",
            ]
        ) {}

        let rendered = element.render()
        #expect(rendered.contains("id=\"content\""))
        #expect(rendered.contains("class=\"container\""))
        #expect(rendered.contains("role=\"contentinfo\""))
        #expect(rendered.contains("data-page=\"home\""))
        #expect(rendered.contains("data-version=\"1.0\""))
    }

    @Test("Element with empty data attributes")
    func testEmptyDatAttributes() async throws {
        let element = Stack(data: [:])

        let rendered = element.render()
        #expect(rendered == "<div></div>")
    }

    @Test("Element with nil data attributes")
    func testNilDatAttributes() async throws {
        let element = Stack(data: nil)

        let rendered = element.render()
        #expect(rendered == "<div></div>")
    }

    @Test("Element with data attributes in nested structure")
    func testDatAttributesInNestedStructure() async throws {
        let element = Stack(
            data: ["container": "main"]
        ) {
            Text(
                data: ["item": "child"]
            ) {
                "Nested content"
            }
        }

        let rendered = element.render()
        #expect(rendered.contains("<div data-container=\"main\">"))
        #expect(
            rendered.contains("<span data-item=\"child\">Nested content</span>")
        )
    }

    // MARK: - Conditional Modifier Tests

    @Test("Conditional modifier - if pattern with true condition")
    func testConditionalModifierIfTrue() async throws {
        let element = Text("Hello").if(true) { $0.addClass("highlight") }

        let rendered = element.render()
        #expect(rendered.contains("class=\"highlight\""))
        #expect(rendered.contains("Hello"))
    }

    @Test("Conditional modifier - if pattern with false condition")
    func testConditionalModifierIfFalse() async throws {
        let element = Text("Hello").if(false) { $0.addClass("highlight") }

        let rendered = element.render()
        #expect(!rendered.contains("class=\"highlight\""))
        #expect(rendered.contains("Hello"))
    }

    @Test("Conditional modifier - chained if patterns")
    func testConditionalModifierChained() async throws {
        let element = Text("Hello")
            .if(true) { $0.addClass("primary") }
            .if(false) { $0.addClass("secondary") }
            .if(true) { $0.addClass("active") }

        let rendered = element.render()
        #expect(rendered.contains("primary"))
        #expect(!rendered.contains("secondary"))
        #expect(rendered.contains("active"))
        #expect(rendered.contains("Hello"))
    }

    @Test("Conditional modifier - hidden when true")
    func testHiddenWhenTrue() async throws {
        let element = Text("Hidden content").hidden(when: true)

        let rendered = element.render()
        #expect(rendered.contains("class=\"hidden\""))
        #expect(rendered.contains("Hidden content"))
    }

    @Test("Conditional modifier - hidden when false")
    func testHiddenWhenFalse() async throws {
        let element = Text("Visible content").hidden(when: false)

        let rendered = element.render()
        #expect(!rendered.contains("class=\"hidden\""))
        #expect(rendered.contains("Visible content"))
    }

    @Test("Conditional modifier - hidden when combined with other modifiers")
    func testHiddenWhenWithOtherModifiers() async throws {
        let element = Text("Content")
            .addClass("primary")
            .hidden(when: true)
            .addClass("extra")

        let rendered = element.render()
        // The hidden class should be combined with other classes
        #expect(rendered.contains("hidden"))
        #expect(rendered.contains("primary"))
        #expect(rendered.contains("extra"))
        #expect(rendered.contains("Content"))
    }

    @Test("Conditional modifier - complex boolean expressions")
    func testConditionalModifierComplexConditions() async throws {
        let isLoggedIn = true
        let hasPermission = false
        let isAdmin = true

        let element = Text("Content")
            .if(isLoggedIn && hasPermission) { $0.addClass("user-content") }
            .if(isLoggedIn && !hasPermission) { $0.addClass("restricted") }
            .hidden(when: !isLoggedIn || (!hasPermission && !isAdmin))

        let rendered = element.render()
        #expect(!rendered.contains("user-content"))
        #expect(rendered.contains("restricted"))
        #expect(!rendered.contains("hidden"))  // isAdmin=true allows visibility
        #expect(rendered.contains("Content"))
    }

    @Test("Conditional modifier - with different element types")
    func testConditionalModifierDifferentElements() async throws {
        let button = Button("Click me").if(true) { $0.addClass("btn-primary") }
        let heading = Heading(.title, "Title").hidden(when: false)
        let link = Link("Example", destination: "#").if(false) { $0.addClass("external") }

        let buttonRendered = button.render()
        let headingRendered = heading.render()
        let linkRendered = link.render()

        #expect(buttonRendered.contains("btn-primary"))
        #expect(!headingRendered.contains("hidden"))
        #expect(!linkRendered.contains("external"))
    }

    @Test("Conditional modifier - type erasure works correctly")
    func testConditionalModifierTypeErasure() async throws {
        // This test ensures that the AnyHTML type erasure doesn't break functionality
        let elements = [
            Text("First").if(true) { $0.addClass("first") },
            Text("Second").hidden(when: false),
            Text("Third").if(false) { $0.addClass("third") }
        ]

        for element in elements {
            let rendered = element.render()
            #expect(!rendered.isEmpty)
        }

        let firstRendered = elements[0].render()
        let secondRendered = elements[1].render()
        let thirdRendered = elements[2].render()

        #expect(firstRendered.contains("first"))
        #expect(!secondRendered.contains("hidden"))
        #expect(!thirdRendered.contains("third"))
    }
}
