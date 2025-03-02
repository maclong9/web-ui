import JavaScriptCore

func validateJS(_ jsCode: String) -> Bool {
  let context = JSContext()!

  // Set up exception handler for debugging
  let exceptionHandler: @convention(block) (JSContext?, JSValue?) -> Void = { _, exception in
    if let exception = exception {
      print("JS Error: \(exception)")
    }
  }
  context.exceptionHandler = exceptionHandler

  // Wrap the code in an IIFE to force parsing and execution
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

  // Evaluate the wrapped code
  let result = context.evaluateScript(wrappedCode)

  // If result is undefined or nil, assume invalid; otherwise, use the boolean result
  return result?.toBool() ?? false
}
