import XCTest
@testable import CosmosKit

class TweetViewModelTests: XCTestCase {

    func testCreate() {

        let meta = WebViewWidgetMetaData(html: "html")
        let tweet = WebWidgetData(meta: meta, url: "")

        let sut = WebViewModel(from: tweet, type: .tweet)

        XCTAssertEqual(sut.html, "html")
    }

    func testCreate_InsertsMissingHTTPS() {

        let meta = WebViewWidgetMetaData(html: "<script async defer src=\"//www.instagram.com/embed.js\"></script>")
        let tweet = WebWidgetData(meta: meta, url: "")

        let sut = WebViewModel(from: tweet, type: .tweet)

        XCTAssertEqual(sut.html, "<script async defer src=\"https://www.instagram.com/embed.js\"></script>")
    }
}
