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

extension Element {
    func button(primary: Bool = false) -> Element {
        self
            .padding(EdgeInsets(vertical: 2, horizontal: 4))
            .background(color: primary ? .blue(._500) : .gray(._700))
            .background(color: primary ? .blue(._700) : .gray(._900), on: .hover)
            .font(weight: .bold, color: .gray(._100))
            .transition(of: .colors)
            .cursor(.pointer)
            .rounded(.lg)
    }
}
