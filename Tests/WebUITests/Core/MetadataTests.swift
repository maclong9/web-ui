import Foundation
import Testing

@testable import WebUI

/// Tests for the Metadata struct that verifies metadata creation and formatting.
@Suite("Metadata Tests")
struct MetadataTests {
  /// Tests that basic metadata is correctly initialized.
  @Test func testBasicMetadataInitialization() throws {
    let metadata = Metadata(
      site: "Test Site",
      title: "Test Title",
      titleSeperator: " | ",
      description: "Test description",
      themeColor: .init("#0099ff", dark: "#1c1c1c")
    )

    // Assert
    #expect(metadata.site == "Test Site")
    #expect(metadata.title == "Test Title")
    #expect(metadata.description == "Test description")
    #expect(metadata.titleSeperator == " | ")
    #expect(metadata.pageTitle == "Test Title | Test Site")
    #expect(metadata.locale == .en)
    #expect(metadata.themeColor?.light == "#0099ff")
    #expect(metadata.themeColor?.dark == "#1c1c1c")
    #expect(metadata.favicons == nil)
    #expect(metadata.structuredData == nil)
  }

  /// Tests that metadata handles null site correctly.
  @Test func testNoSiteMetadata() throws {
    let metadata = Metadata(
      title: "Just Title",
      titleSeperator: nil,
      description: "No site metadata"
    )

    #expect(metadata.site == nil)
    #expect(metadata.pageTitle == "Just Title")
  }

  /// Tests that metadata uses custom separator correctly.
  @Test func testCustomSeparator() throws {
    let metadata = Metadata(
      site: "My Site",
      title: "My Title",
      titleSeperator: " - ",
      description: "Custom separator test"
    )

    #expect(metadata.titleSeperator == " - ")
    #expect(metadata.pageTitle == "My Title - My Site")
  }

  /// Tests that all optional metadata fields are correctly initialized.
  @Test func testFullMetadata() throws {
    let testDate = Date()
    let keywords = ["swift", "testing", "metadata"]

    let metadata = Metadata(
      site: "Full Site",
      title: "Full Title",
      titleSeperator: " : ",
      description: "Full metadata description",
      date: testDate,
      image: "/images/test.jpg",
      author: "Test Author",
      keywords: keywords,
      twitter: "twitterhandle",
      locale: .ja,
      type: .profile
    )

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

  /// Tests favicon initialization and properties.
  @Test func testFaviconInitialization() throws {
    // Test with light mode only
    let lightFavicon = Favicon("/favicon.png", size: "32x32")
    #expect(lightFavicon.light == "/favicon.png")
    #expect(lightFavicon.dark == nil)
    #expect(lightFavicon.type == "image/png")
    #expect(lightFavicon.size == "32x32")

    // Test with both light and dark mode
    let dualFavicon = Favicon("/favicon-light.png", dark: "/favicon-dark.png", type: "image/svg+xml")
    #expect(dualFavicon.light == "/favicon-light.png")
    #expect(dualFavicon.dark == "/favicon-dark.png")
    #expect(dualFavicon.type == "image/svg+xml")
    #expect(dualFavicon.size == nil)
  }

  /// Tests initialization of metadata with favicons.
  @Test func testMetadataWithFavicons() throws {
    let favicons: [Favicon] = [
      Favicon("/favicon-32.png", dark: "/favicon-dark-32.png", size: "32x32"),
      Favicon("/favicon-16.png", size: "16x16"),
      Favicon("/favicon.ico", type: "image/x-icon"),
    ]

    let metadata = Metadata(
      title: "Favicon Test",
      description: "Testing favicons",
      favicons: favicons
    )

    #expect(metadata.favicons?.count == 3)
    #expect(metadata.favicons?[0].light == "/favicon-32.png")
    #expect(metadata.favicons?[0].dark == "/favicon-dark-32.png")
    #expect(metadata.favicons?[1].size == "16x16")
    #expect(metadata.favicons?[2].type == "image/x-icon")
  }

  /// Tests that favicon is preserved when extending metadata.
  @Test func testExtendingMetadataWithFavicons() throws {
    let baseFavicons: [Favicon] = [
      Favicon("/base-favicon.png", size: "32x32")
    ]

    let baseMetadata = Metadata(
      site: "Base Site",
      description: "Base description",
      favicons: baseFavicons
    )

    // Extend without overriding favicons
    let extendedMetadata = Metadata(
      from: baseMetadata,
      title: "Extended"
    )

    #expect(extendedMetadata.favicons?.count == 1)
    #expect(extendedMetadata.favicons?[0].light == "/base-favicon.png")

    // Extend with new favicons
    let newFavicons: [Favicon] = [
      Favicon("/new-favicon.png", dark: "/new-dark.png", size: "64x64")
    ]

    let overriddenMetadata = Metadata(
      from: baseMetadata,
      favicons: newFavicons
    )

    #expect(overriddenMetadata.favicons?.count == 1)
    #expect(overriddenMetadata.favicons?[0].light == "/new-favicon.png")
    #expect(overriddenMetadata.favicons?[0].dark == "/new-dark.png")
  }

  /// Tests structured data generation for an article.
  @Test func testStructuredDataArticle() throws {
    let publishDate = Date()

    let articleData = StructuredData.article(
      headline: "Test Article",
      image: "https://example.com/image.jpg",
      author: "Test Author",
      publisher: "Test Publisher",
      datePublished: publishDate,
      description: "A test article"
    )

    #expect(articleData.type == .article)

    let json = articleData.toJSON()
    #expect(json.contains("\"@context\" : \"https://schema.org\""))
    #expect(json.contains("\"@type\" : \"Article\""))
    #expect(json.contains("\"headline\" : \"Test Article\""))
    #expect(json.contains("\"image\" : \"https://example.com/image.jpg\""))
    #expect(json.contains("\"name\" : \"Test Author\""))
    #expect(json.contains("\"description\" : \"A test article\""))
  }

  /// Tests structured data generation for a product.
  @Test func testStructuredDataProduct() throws {
    let productData = StructuredData.product(
      name: "Test Product",
      image: "https://example.com/product.jpg",
      description: "A test product",
      sku: "PROD-123",
      brand: "Test Brand",
      offers: ["price": "99.99", "priceCurrency": "USD", "availability": "InStock"]
    )

    #expect(productData.type == .product)

    let json = productData.toJSON()
    #expect(json.contains("\"@type\" : \"Product\""))
    #expect(json.contains("\"name\" : \"Test Product\""))
    #expect(json.contains("\"image\" : \"https://example.com/product.jpg\""))
    #expect(json.contains("\"sku\" : \"PROD-123\""))
    #expect(json.contains("\"price\" : \"99.99\""))
    #expect(json.contains("\"priceCurrency\" : \"USD\""))
  }

  /// Tests structured data generation for FAQ.
  @Test func testStructuredDataFAQ() throws {
    let questions = [
      ["question": "What is this?", "answer": "A test"],
      ["question": "How does it work?", "answer": "Very well"],
    ]

    let faqData = StructuredData.faqPage(questions)

    #expect(faqData.type == .faqPage)

    let json = faqData.toJSON()
    #expect(json.contains("\"@type\" : \"FAQPage\""))
    #expect(json.contains("\"@type\" : \"Question\""))
    #expect(json.contains("\"name\" : \"What is this?\""))
    #expect(json.contains("\"text\" : \"A test\""))
    #expect(json.contains("\"name\" : \"How does it work?\""))
  }

  /// Tests structured data in metadata.
  @Test func testMetadataWithStructuredData() throws {
    let structuredData = StructuredData.organization(
      name: "Test Org",
      logo: "https://example.com/logo.png",
      url: "https://example.com"
    )

    let metadata = Metadata(
      title: "Organization Page",
      description: "About our organization",
      structuredData: structuredData
    )

    #expect(metadata.structuredData != nil)
    #expect(metadata.structuredData?.type == .organization)

    // Test metadata extension with structured data
    let extendedMetadata = Metadata(
      from: metadata,
      title: "Extended Page"
    )

    #expect(extendedMetadata.structuredData != nil)
    #expect(extendedMetadata.structuredData?.type == .organization)
  }
}
