import WebUI

extension Link {
    func styled(weight: Weight = .bold) -> Element {
        self
            .cursor(.pointer)
            .transition(of: .colors)
            .font(weight: weight, family: "system-ui")
            .font(color: .teal(._600), on: .hover)
    }
}
