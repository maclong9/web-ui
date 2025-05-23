import Foundation

struct ConcreteWebsite: Website {
    let metadata: Metadata
    let theme: Theme?
    let stylesheets: [String]?
    let scripts: [Script]?
    let head: String?
    let routes: [any Document]
    let baseURL: String?
    let sitemapEntries: [SitemapEntry]?
    let generateSitemap: Bool
    let generateRobotsTxt: Bool
    let robotsRules: [RobotsRule]?

    func build(
        to outputDirectory: URL,
        assetsPath: String
    ) throws {
        // Create output directory if it doesn't exist
        try FileManager.default.createDirectory(
            at: outputDirectory,
            withIntermediateDirectories: true
        )

        // Copy assets if they exist
        let assetsURL = URL(filePath: assetsPath)
        if FileManager.default.fileExists(atPath: assetsURL.path()) {
            let publicURL = outputDirectory.appending(path: "public")
            try FileManager.default.copyItem(at: assetsURL, to: publicURL)
        }

        // Build each route
        for route in routes {
            try buildRoute(route, in: outputDirectory)
        }

        // Generate sitemap if enabled
        if generateSitemap, let baseURL = baseURL {
            try generateSitemapXML(in: outputDirectory, baseURL: baseURL)
        }

        // Generate robots.txt if enabled
        if generateRobotsTxt {
            try generateRobotsTxt(in: outputDirectory)
        }
    }

    private func buildRoute(_ route: any Document, in directory: URL) throws {
        // Get the route's path, defaulting to index for root
        let path = route.path ?? "index"

        // Create the full path for the HTML file
        var components = path.split(separator: "/")
        let filename = components.removeLast()
        let fullPath = directory.appending(path: components.joined(separator: "/"))

        // Create intermediate directories
        try FileManager.default.createDirectory(
            at: fullPath,
            withIntermediateDirectories: true
        )

        // Generate HTML content by building document tree
        let mergedMetadata = route.metadata
        let _ = route.theme ?? theme
        let mergedStylesheets = (route.stylesheets ?? []) + (stylesheets ?? [])
        let mergedScripts = (route.scripts ?? []) + (scripts ?? [])

        let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>\(String(describing: mergedMetadata.title))</title>
                \(mergedMetadata.description.map { "<meta name=\"description\" content=\"\($0)\">" } ?? "")
                \(mergedStylesheets.map { "<link rel=\"stylesheet\" href=\"\($0)\">" }.joined(separator: "\n"))
                \(mergedScripts.map { $0.render() }.joined(separator: "\n"))
                \(head ?? "")
            </head>
            <body>
                \(route.body.render())
            </body>
            </html>
            """

        // Write the HTML file
        guard let data = html.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "WebUI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode HTML"])
        }
        try data.write(to: fullPath.appending(path: "\(filename).html"), options: .atomic)
    }

    private func generateSitemapXML(in directory: URL, baseURL: String) throws {
        var entries = routes.compactMap { route -> SitemapEntry? in
            guard let path = route.path else { return nil }
            return SitemapEntry(
                url: "\(baseURL)/\(path).html",
                lastModified: route.metadata.date,
                changeFrequency: .monthly,
                priority: 0.5
            )
        }

        // Add custom sitemap entries
        if let customEntries = sitemapEntries {
            entries.append(contentsOf: customEntries)
        }

        // Generate sitemap XML
        let sitemap = """
            <?xml version="1.0" encoding="UTF-8"?>
            <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
                \(entries.map { entry in
                """
                <url>
                    <loc>\(entry.url)</loc>
                    \(entry.lastModified.map { "<lastmod>\($0.ISO8601Format())</lastmod>" } ?? "")
                    \(entry.changeFrequency.map { "<changefreq>\($0.rawValue)</changefreq>" } ?? "")
                    \(entry.priority.map { "<priority>\($0)</priority>" } ?? "")
                </url>
                """
            }.joined(separator: "\n"))
            </urlset>
            """

        // Write sitemap.xml
        guard let data = sitemap.data(using: String.Encoding.utf8) else {
            throw NSError(
                domain: "WebUI",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to encode sitemap.xml"]
            )
        }
        try data.write(to: directory.appending(path: "sitemap.xml"), options: .atomic)
    }

    private func generateRobotsTxt(in directory: URL) throws {
        var rules = robotsRules ?? []

        // Add default allow all rule if no rules specified
        if rules.isEmpty {
            rules = [RobotsRule(userAgent: "*", allow: ["/"])]
        }

        // Generate robots.txt content
        let ruleStrings = rules.map { rule in
            [
                "User-agent: \(rule.userAgent)",
                rule.allow?.map { "Allow: \($0)" }.joined(separator: "\n") ?? "",
                (rule.disallow ?? []).map { "Disallow: \($0)" }.joined(separator: "\n"),
            ].filter { !$0.isEmpty }.joined(separator: "\n")
        }

        let sitemapLine = generateSitemap && baseURL != nil ? "\nSitemap: \(baseURL!)/sitemap.xml" : ""
        let robotsTxt = ruleStrings.joined(separator: "\n\n") + sitemapLine

        // Write robots.txt
        guard let data = robotsTxt.data(using: String.Encoding.utf8) else {
            throw NSError(
                domain: "WebUI",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to encode robots.txt"]
            )
        }
        try data.write(to: directory.appending(path: "robots.txt"), options: [.atomic])
    }
}
