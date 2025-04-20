# WebUI

A library for generating Web User Interfaces in a simple, type-safe, and consistent manner.

No need to worry if you are not an HTML expert, this library contains extensive documentation explaining the semantic meaning for each of the elements it can render. Building off of a design system inspired by modern utility-first CSS frameworks allows you to build beautiful looking websites without overthinking your styles. Finally adding common functionality to your web application via javsacript is a nice and simple process.

## Extending the Elements List

To add a new `Element` follow the pattern below:

```swift
public final class ElementName: Element {
  // 1. Element-specific properties
  let propertyOne: Type
  let propertyTwo: Type?
  
  // 2. Public initializer with consistent parameter order
  public init(
    // Element-specific parameters first
    specificParam1: Type,
    specificParam2: Type? = nil,
    // Common parameters last
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    // 3. Set element-specific properties
    self.propertyOne = specificParam1
    self.propertyTwo = specificParam2
    
    // 4. Call super.init with appropriate tag and parameters
    super.init(
      tag: "tagname", 
      config: config, 
      isSelfClosing: false, // Only when applicable
      content: content
    )
  }
  
  // 5. Override additionalAttributes when needed
  public override func additionalAttributes() -> [String] {
    [
      attribute("attr1", propertyOne),
      attribute("attr2", propertyTwo),
    ]
    .compactMap { $0 }
  }
}
```

## Guides

- [Static Site Generation with WebUI](https://maclong9.github.io/portfolio/articles/introduction-to-webui)
- [Using WebUI with Hummingbird](./)
- [Scaling a Hummingbird Application with Cloudflare](./)

## Inspirations & Sources

- [Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10253/)
- [Hacking with Swift](https://www.hackingwithswift.com/articles/266/build-your-next-website-in-swift)
- [Elementary](https://github.com/sliemeobn/elementary/tree/main)
- [Tailwind](http://tailwindcss.com)
