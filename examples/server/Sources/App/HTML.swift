import Hummingbird

/// Type wrapping HTML code. Will convert to HBResponse that includes the correct content-type header
struct HTMLResponse: ResponseGenerator {
    let content: String

    init(content: String) {
        self.content = content
    }

    public func response(from request: Request, context: some RequestContext) throws -> Response {
        .init(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(
                byteBuffer: ByteBuffer(
                    string: content
                )
            )
        )
    }
}
