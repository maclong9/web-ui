/// Defines ARIA roles for accessibility.
///
/// ARIA roles help communicate the purpose of elements to assistive technologies,
/// enhancing the accessibility of web content for users with disabilities.
public enum AriaRole: String {
    // Landmark Roles
    /// Indicates a search functionality area.
    ///
    /// Use this role for search forms or search input containers.
    case search

    /// Provides metadata about the document.
    ///
    /// Typically used for page footers containing copyright information, privacy statements, etc.
    case contentinfo

    /// Identifies the main content area of the document.
    ///
    /// There should be only one main role per page.
    case main

    /// Identifies a major section of navigation links.
    ///
    /// Use for primary navigation menus.
    case navigation

    /// Identifies a section containing complementary content.
    ///
    /// Content that supplements the main content but remains meaningful on its own.
    case complementary

    /// Identifies the page banner, typically containing site branding and navigation.
    ///
    /// Usually corresponds to the page header.
    case banner

    // Widget Roles
    /// Identifies an element as a button control.
    ///
    /// Use when a non-button element needs to behave as a button.
    case button

    /// Identifies a checkbox control.
    ///
    /// Use when a custom checkbox element is created.
    case checkbox

    /// Identifies an element that displays a dialog or alert window.
    ///
    /// Modal or non-modal interactive components.
    case dialog

    /// Identifies a link that hasn't been coded as an anchor.
    ///
    /// Use when a non-anchor element needs to behave as a link.
    case link

    /// Identifies an expandable/collapsible section.
    ///
    /// Used for disclosure widgets like accordions.
    case tab

    /// Identifies a container for tab elements.
    case tablist

    /// Identifies the content panel of a tab interface.
    case tabpanel

    // Document Structure Roles
    /// Identifies an article or complete, self-contained composition.
    ///
    /// Used for blog posts, news stories, etc.
    case article

    /// Identifies a region containing the primary heading for a document.
    case heading

    /// Identifies a list of items.
    case list

    /// Identifies an individual list item.
    case listitem

    // Live Region Roles
    /// Identifies a section whose content will be updated.
    ///
    /// Used for dynamic content that should be announced by screen readers.
    case alert

    /// Identifies a status message.
    ///
    /// Used for non-critical updates and status information.
    case status

    /// Identifies a separator element.
    ///
    /// Used for visual separators like dividers or horizontal rules.
    case separator

    /// Identifies an alert dialog.
    ///
    /// Used for modal dialogs that interrupt the user with critical information.
    case alertdialog

    /// Identifies a menu of choices or commands.
    ///
    /// Used for popup menus and dropdown menus.
    case menu
}
