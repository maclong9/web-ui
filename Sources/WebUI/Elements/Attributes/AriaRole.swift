/// Enumeration of common ARIA roles for accessibility
///
/// Possible roles include:
/// - button: Indicates an interactive element that triggers an action
/// - checkbox: Identifies content that can be checked or unchecked
/// - main: Marks an element as containing the main content of the document
/// - navigation: Indicates a navigation region
/// - search: Defines a section that contains a search interface
/// - listbox: Identifies an element containing a list of options
/// - menu: Marks an element as a menu of commands
/// - contentinfo: Indicates content that provides additional context
/// - dialog: Defines a dialog or modal window
/// - article: Identifies a region as an article
/// - heading: Marks a section as a heading
/// - complementary: Indicates a region containing complementary content
public enum AriaRole: String {
  case button, checkbox, main, navigation, search, listbox, menu,
    contentinfo, dialog, article, heading, complementary
}
