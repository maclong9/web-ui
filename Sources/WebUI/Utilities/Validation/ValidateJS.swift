import JavaScriptCore

/// This function checks if a piece of JavaScript code is valid.
/// It takes a string of JavaScript code, runs it in a safe environment, and returns true if it works without errors, or false if there’s a problem.
/// If an error occurs, it prints a message with details about the issue.
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
