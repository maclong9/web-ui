import Foundation

/// The schema types supported for structured data in JSON-LD format.
///
/// This enum defines the various schema.org types that can be used to create
/// structured data for rich snippets in search results.
public enum SchemaType: String {
  /// Represents an article.
  case article = "Article"

  /// Represents a blog posting.
  case blogPosting = "BlogPosting"

  /// Represents a breadcrumb list for navigation.
  case breadcrumbList = "BreadcrumbList"

  /// Represents an educational course.
  case course = "Course"

  /// Represents an event.
  case event = "Event"

  /// Represents a FAQ page with questions and answers.
  case faqPage = "FAQPage"

  /// Represents a how-to guide or instructions.
  case howTo = "HowTo"

  /// Represents a local business.
  case localBusiness = "LocalBusiness"

  /// Represents an organization.
  case organization = "Organization"

  /// Represents a person.
  case person = "Person"

  /// Represents a product.
  case product = "Product"

  /// Represents a recipe.
  case recipe = "Recipe"

  /// Represents a review.
  case review = "Review"

  /// Represents a website.
  case website = "WebSite"
}
