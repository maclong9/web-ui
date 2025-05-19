import Hummingbird

struct URLFormRequestDecoder: RequestDecoder {
    let decoder = URLEncodedFormDecoder()

    func decode<T>(_ type: T.Type, from request: Request, context: some RequestContext) async throws -> T
    where T: Decodable {
        if request.headers[.contentType] == "application/x-www-form-urlencoded" {
            return try await self.decoder.decode(type, from: request, context: context)
        }
        throw HTTPError(.unsupportedMediaType)
    }
}
