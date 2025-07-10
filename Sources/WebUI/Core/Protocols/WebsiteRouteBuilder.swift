/// A result builder for creating website routes.
@resultBuilder
public struct WebsiteRouteBuilder {
  public static func buildBlock(_ components: [any Document]...)
    -> [any Document]
  {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [any Document]?)
    -> [any Document]
  {
    component ?? []
  }

  public static func buildEither(first component: [any Document])
    -> [any Document]
  {
    component
  }

  public static func buildEither(second component: [any Document])
    -> [any Document]
  {
    component
  }

  public static func buildArray(_ components: [[any Document]])
    -> [any Document]
  {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: any Document)
    -> [any Document]
  {
    [expression]
  }
}
