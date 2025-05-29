public func applyClasses(params: Parameters) -> [String] {
    var classes: [String] = []

    let hasLayoutParams = params.direction != nil || params.justify != nil || params.align != nil
    let hasGrowOnly = params.grow != nil && !hasLayoutParams

    if hasLayoutParams {
        classes.append("flex")
    }

    if let direction = params.direction {
        classes.append("flex-\(direction.rawValue)")
    }

    if let justify = params.justify {
        classes.append("justify-\(justify.rawValue)")
    }

    if let align = params.align {
        classes.append("items-\(align.rawValue)")
    }

    if let grow = params.grow {
        classes.append("flex-\(grow.rawValue)")
    }

    return classes
}
