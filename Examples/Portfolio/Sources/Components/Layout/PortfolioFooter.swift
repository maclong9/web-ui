import Foundation
import WebUI

/// Footer component for the portfolio
struct PortfolioFooter: Markup {
    var body: some Markup {
        Footer(classes: ["border-t", "border-zinc-200", "dark:border-zinc-700", "bg-zinc-50", "dark:bg-zinc-900"]) {
            Stack {
                Text("© \(Calendar.current.component(.year, from: Date())) Mac Long. Built with Swift WebUI.", classes: ["max-w-4xl", "mx-auto", "px-4", "py-8", "text-center", "text-sm", "text-zinc-500", "dark:text-zinc-400"])
            }
        }
    }
}