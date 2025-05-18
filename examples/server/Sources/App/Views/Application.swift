import Foundation
import WebUI

actor ViewConfiguration {
    static let metadata = Metadata(
        site: "example",
        titleSeperator: " | ",
        description: "A simple hummingbird server example with WebUI.",
        keywords: ["Swift", "Server", "Hummingbird", "WebUI"],
        locale: .en,
        type: .website,
        favicons: [Favicon("https://fav.farm/🌊")],
    )
}
