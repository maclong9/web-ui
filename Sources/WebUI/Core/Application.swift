struct Application {
  let routes: [Document]

  /// # Builds a minified and optimised app in `.build`
  /// 1. Creates `*.html` for each `Document` passed to ``Application`` as a ``Route``
  /// 2. Creates `*.css` for each `Document` passed to ``Application`` as a ``Route``
  func build() {

  }
}
