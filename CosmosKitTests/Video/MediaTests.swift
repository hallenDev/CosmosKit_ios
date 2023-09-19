@testable import CosmosKit
import XCTest

class VideoTests: XCTestCase {

    func testCreate_youtube() {

        let json = readJSONData("Video")

        do {
            let sut = try JSONDecoder().decode(Media.self, from: json)

            XCTAssertEqual(sut.articleKey, "6199336700477440")
            XCTAssertEqual(sut.articleSection, "politics")
            XCTAssertEqual(sut.widgetData.type, .youtube)
            guard let data = sut.widgetData.data as? YoutubeWidgetData else {
                XCTFail("Failed to cast data")
                return
            }
            XCTAssertEqual(data.id, "WSwy3BZ3Wok")
            XCTAssertEqual(data.meta.title, "‘I don’t want to incriminate myself’: Dudu Myeni refuses to answer commission questions")
            XCTAssertEqual(data.meta.thumbnail, "https://i.ytimg.com/vi/WSwy3BZ3Wok/hqdefault.jpg")
            XCTAssertNil(data.pid)
            XCTAssertEqual(sut.published, 1604492396000)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testCreate_bibliodam() {

        let json = readJSONData("BibliodamVideo")

        do {
            let sut = try JSONDecoder().decode(Media.self, from: json)

            XCTAssertEqual(sut.articleKey, "5283960088166400")
            XCTAssertEqual(sut.articleSection, "markets")
            XCTAssertEqual(sut.widgetData.type, .bibliodam)
            guard let data = sut.widgetData.data as? BibliodamWidgetData else {
                XCTFail("Failed to cast data")
                return
            }
            XCTAssertEqual(data.url, "https://tiso-baobab-prod-eu-west-1.s3.amazonaws.com/public/tiso/muli/media/video/2020/11/04/115780/0/TSW22EP24APIck.mp4")
            XCTAssertEqual(data.title, "WATCH: Stock picks — Ferrari and cash")
            XCTAssertEqual(data.thumbnail, "https://tiso-baobab-prod-eu-west-1.s3.amazonaws.com/public/tiso/muli/media/video/2020/11/04/115780/0/TSW22EP24APIck.0000003.jpg")
            XCTAssertEqual(sut.published, 1604556430000)
        } catch {
            XCTFail(String(describing: error))
        }
    }
}
