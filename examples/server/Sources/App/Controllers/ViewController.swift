import Hummingbird
import WebUI

struct ViewController {
    func addRoutes(to router: Router<some RequestContext>) {
        router.get("/", use: self.home)
        router.post("/", use: self.post)
    }

    @Sendable func home(request: Request, context: some RequestContext) -> HTMLResponse {
        HTMLResponse(content: HomeView(info: ["Hello": "World"]).document.render())
    }

    @Sendable func post(request: Request, context: some RequestContext) async throws -> HTMLResponse {
        let user = try await request.decode(as: User.self, context: context)
        return HTMLResponse(
            content: HomeView(info: ["Hello": "World"], greeting: "Welcome \(user.name)").document.render()
        )
    }
}
