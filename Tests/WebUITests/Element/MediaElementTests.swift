// MediaElementsTests.swift
import Testing

@testable import WebUI

@Suite("Media Elements Tests")
struct MediaElementsTests {
  // From NewElementsTests
  @Test("Image renders with full attributes")
  func testImageFullAttributes() throws {
    let image = Image(source: "img.png", alt: "Description", width: 300, height: 200, id: "main-img")
    let html = image.render()
    #expect(html == "<img id=\"main-img\" src=\"img.png\" alt=\"Description\" width=\"300\" height=\"200\">")
  }

  @Test("Video renders with source and controls")
  func testVideoWithAttributes() throws {
    let video = Video(source: "movie.mp4", controls: true, autoplay: false)
    let html = video.render()
    #expect(html == "<video src=\"movie.mp4\" controls></video>")
  }

  @Test("Audio renders with source, controls, and loop")
  func testAudioWithAttributes() throws {
    let audio = Audio(source: "song2.mp3", controls: true, loop: true)
    let html = audio.render()
    #expect(html == "<audio src=\"song2.mp3\" controls loop></audio>")
  }
}
