import Foundation
import WebUI

@main
actor Application {
    static let metadata = Metadata(
        site: "example",
        titleSeperator: " | ",
        description: "A static website built with Swift and WebUI",
        image: "https://placehold.co/600x400/EEE/31343C",
        author: "Swift Developer",
        keywords: [
            "swift", "web development", "static site", "webui",
        ],
        type: .website,
        favicons: [
            .init("https://fav.farm/🖥", type: "image/svg")
        ],
    )

    static let routes = [
        Home().document,
        About().document,
    ]

    static func main() async {
        do {
            try Website(
                metadata: metadata,
                routes: routes,
            ).build()
        } catch {
            print("Failed to build application: \(error)")
        }
    }
}
