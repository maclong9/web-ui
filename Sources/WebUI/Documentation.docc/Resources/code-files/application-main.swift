import Foundation
import WebUI

@main
actor Application {
    static let metadata = Metadata(
        site: "My WebUI Site",
        description: "A static website built with Swift and WebUI",
        author: "Swift Developer",
        keywords: [
            "swift", "web development", "static site", "webui",
        ],
        type: .website
    )

    static let routes = [
        HomePage().document,
        AboutPage().document,
    ]

    static func main() async {
        do {
            try Website(
                metadata: metadata,
                theme: theme,
                stylesheets: stylesheets,
                routes: routes,
            ).build()
        } catch {
            print("Failed to build application: \(error)")
        }
    }
}
