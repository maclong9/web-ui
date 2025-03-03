import JavaScriptCore

func validateJS(_ jsCode: String) -> Bool {
  let context = JSContext()!

  let exceptionHandler: @convention(block) (JSContext?, JSValue?) -> Void = { _, exception in
    if let exception = exception {
      print("JS Error: \(exception)")
    }
  }
  context.exceptionHandler = exceptionHandler

  let wrappedCode = """
    (function() {
        try {
            \(jsCode)
            return true;
        } catch (e) {
            return false;
        }
    })();
    """

  let result = context.evaluateScript(wrappedCode)
  return result?.toBool() ?? false
}
