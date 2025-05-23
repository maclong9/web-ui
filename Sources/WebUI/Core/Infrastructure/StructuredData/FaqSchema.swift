extension StructuredData {
    /// Creates structured data for a FAQ page.
    ///
    /// - Parameter questions: Array of question-answer pairs.
    /// - Returns: A structured data object for a FAQ page.
    ///
    /// - Example:
    ///   ```swift
    ///   let faqData = StructuredData.faqPage([
    ///     ["question": "What is WebUI?", "answer": "WebUI is a Swift framework for building web interfaces."],
    ///     ["question": "Is it open source?", "answer": "Yes, WebUI is available under the MIT license."]
    ///   ])
    ///   ```
    public static func faqPage(_ questions: [[String: String]]) -> StructuredData {
        let mainEntity = questions.map { question in
            [
                "@type": "Question",
                "name": question["question"] ?? "",
                "acceptedAnswer": [
                    "@type": "Answer",
                    "text": question["answer"] ?? "",
                ],
            ]
        }

        return StructuredData(type: .faqPage, data: ["mainEntity": mainEntity])
    }
}
