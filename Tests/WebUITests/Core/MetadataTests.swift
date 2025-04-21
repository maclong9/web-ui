import Foundation
import Testing

@testable import WebUI

/// Tests for the Metadata struct that verifies metadata creation and formatting.
@Suite("Metadata Tests")
struct MetadataTests {
  /// Tests that basic metadata is correctly initialized.
  @Test func testBasicMetadataInitialization() throws {
    // Act
    let metadata = Metadata(
      site: "Test Site",
      title: "Test Title",
      description: "Test description"
    )

    // Assert
    #expect(metadata.site == "Test Site")
    #expect(metadata.title == "Test Title")
    #expect(metadata.description == "Test description")
    #expect(metadata.titleSeperator == "|")  // Default value
    #expect(metadata.pageTitle == "Test Title | Test Site")
    #expect(metadata.locale == .en)  // Default value
  }

  /// Tests that metadata handles null site correctly.
  @Test func testNoSiteMetadata() throws {
    // Act
    let metadata = Metadata(
      title: "Just Title",
      description: "No site metadata"
    )

    // Assert
    #expect(metadata.site == nil)
    #expect(metadata.pageTitle == "Just Title")
  }

  /// Tests that metadata uses custom separator correctly.
  @Test func testCustomSeparator() throws {
    // Act
    let metadata = Metadata(
      site: "My Site",
      title: "My Title",
      titleSeperator: "-",
      description: "Custom separator test"
    )

    // Assert
    #expect(metadata.titleSeperator == "-")
    #expect(metadata.pageTitle == "My Title - My Site")
  }

  /// Tests that all optional metadata fields are correctly initialized.
  @Test func testFullMetadata() throws {
    // Arrange
    let testDate = Date()
    let keywords = ["swift", "testing", "metadata"]

    // Act
    let metadata = Metadata(
      site: "Full Site",
      title: "Full Title",
      titleSeperator: ":",
      description: "Full metadata description",
      date: testDate,
      image: "/images/test.jpg",
      author: "Test Author",
      keywords: keywords,
      twitter: "twitterhandle",
      locale: .ja,
      type: .profile
    )

    // Assert
    #expect(metadata.date == testDate)
    #expect(metadata.image == "/images/test.jpg")
    #expect(metadata.author == "Test Author")
    #expect(metadata.keywords == keywords)
    #expect(metadata.twitter == "twitterhandle")
    #expect(metadata.locale == .ja)
    #expect(metadata.type == .profile)
    #expect(metadata.pageTitle == "Full Title : Full Site")
  }

  /// Tests all available locale options.
  @Test func testLocaleOptions() throws {
    #expect(Locale.en.rawValue == "en")
    #expect(Locale.sp.rawValue == "sp")
    #expect(Locale.fr.rawValue == "fr")
    #expect(Locale.de.rawValue == "de")
    #expect(Locale.ja.rawValue == "ja")
  }

  /// Tests all available content type options.
  @Test func testContentTypeOptions() throws {
    #expect(ContentType.website.rawValue == "website")
    #expect(ContentType.article.rawValue == "article")
    #expect(ContentType.video.rawValue == "video")
    #expect(ContentType.profile.rawValue == "profile")
  }
}
