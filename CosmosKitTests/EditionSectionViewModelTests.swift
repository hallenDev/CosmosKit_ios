//swiftlint:disable force_try line_length
import XCTest
@testable import CosmosKit

class EditionSectionViewModelTests: XCTestCase {

    func testInit_section() {

        let sut = EditionSectionViewModel(from: [], section: "test")

        XCTAssertTrue(sut.articles.isEmpty)
        XCTAssertEqual(sut.heading, "test")
        XCTAssertEqual(sut.subHeading, "")
        XCTAssertEqual(sut.type, .articles)
    }

    func testInit_text() {

        let edjson = readJSONData("Edition")
        guard let edition = try? JSONDecoder().decode(Edition.self, from: edjson) else {
            XCTFail("failed to parse edition")
            return
        }
        let data = readJSONData("WidgetText")
        guard let text = try? JSONDecoder().decode(Widget.self, from: data) else {
            XCTFail("failed to parse widget")
            return
        }

        let sut = EditionSectionViewModel(content: [text], edition: edition)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.subHeading, "")
        XCTAssertEqual(sut?.heading, "<p>Seoul &mdash; Elliott Management, which announced earlier in April that had it bought about $1bn in shares of units of Hyundai Motor Group, stepped up its pressure on the South Korean conglomerate by making demands ranging from higher dividends to restructuring the group under a holding company.</p>\n<p>Elliott&rsquo;s proposals, which include combining Hyundai with Hyundai Mobis and raising dividends to as much as half of net income, have been relayed to the board of Hyundai Motor Group, it said. Group representatives weren&rsquo;t immediately available to comment.</p>")
        XCTAssertTrue(sut!.articles.isEmpty)
        XCTAssertTrue(sut!.widgets!.isEmpty)
        XCTAssertEqual(sut?.type, .widgets)
    }

    func testInit_infoBlock() {

        let edjson = readJSONData("Edition")
        guard let edition = try? JSONDecoder().decode(Edition.self, from: edjson) else {
            XCTFail("failed to parse edition")
            return
        }
        let data = readJSONData("WidgetInfoBlock")
        guard let infoblock = try? JSONDecoder().decode(Widget.self, from: data) else {
            XCTFail("failed to parse widget")
            return
        }

        let sut = EditionSectionViewModel(content: [infoblock], edition: edition)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.subHeading, "")
        XCTAssertEqual(sut?.heading, "<p>These are used to add some context to stories</p>")
        XCTAssertTrue(sut!.articles.isEmpty)
        XCTAssertTrue(sut!.widgets!.isEmpty)
        XCTAssertEqual(sut?.type, .widgets)
    }

    func testInit_fail() {

        let widgets: [Widget] = []
        let edition = Edition(title: "test", widgets: widgets, articles: [], published: 1234567, image: nil, key: 1234, modified: 1)
        let data = readJSONData("WidgetGallery")
        guard let gallery = try? JSONDecoder().decode(Widget.self, from: data) else {
            XCTFail("failed to parse widget")
            return
        }

        var sut = EditionSectionViewModel(content: widgets, edition: edition)

        XCTAssertNil(sut)

        sut = EditionSectionViewModel(content: [gallery], edition: edition)

        XCTAssertNil(sut)
    }

    func testUpdateViewModel() {

        let edjson = readJSONData("Edition")
        guard let edition = try? JSONDecoder().decode(Edition.self, from: edjson) else {
            XCTFail("failed to parse edition")
            return
        }
        let data = readJSONData("WidgetGallery")
        guard let gallery = try? JSONDecoder().decode(Widget.self, from: data) else {
            XCTFail("failed to parse widget")
            return
        }

        var sut = EditionSectionViewModel(content: edition.widgets!, edition: edition)

        XCTAssertNotNil(sut)

        XCTAssertNotNil(sut?.hybridList?.first as? ArticleViewModel)

        sut?.updateViewModel(gallery.getViewModel()!, at: 0)

        XCTAssertNotNil(sut?.hybridList?.first as? GalleryViewModel)
    }

    func testAddArticles() {

        let edjson = readJSONData("Edition")
        guard let edition = try? JSONDecoder().decode(Edition.self, from: edjson), let widgets = edition.widgets else {
            XCTFail("failed to parse edition")
            return
        }

        var sut = EditionSectionViewModel(content: widgets, edition: edition)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.articles.count, 3)

        sut?.add(articles: edition.articles)

        XCTAssertEqual(sut?.articles.count, 28)
    }
}
