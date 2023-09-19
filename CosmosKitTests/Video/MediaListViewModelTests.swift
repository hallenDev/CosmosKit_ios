//swiftlint:disable force_try line_length
@testable import CosmosKit
import XCTest

class VideoListViewModelTests: XCTestCase {

    func testCreate() {

        let sut = MediaListViewModel(title: "test", type: .videos)

        XCTAssertEqual(sut.mediaCount(), 0)
        XCTAssertEqual(sut.title, "test")
    }

    func testAddVideos() {

        let video1 = try! JSONDecoder().decode(Media.self, from: readJSONData("Video"))
        let video2 = try! JSONDecoder().decode(Media.self, from: readJSONData("Video"))

        var sut = MediaListViewModel(type: .videos)

        XCTAssertEqual(sut.mediaCount(), 0)

        sut.add(media: [video2, video1, video2])

        XCTAssertEqual(sut.mediaCount(), 3)
        guard let first = sut.getMedia(at: IndexPath(row: 0, section: 0)) else {
            XCTFail("Failed to get first video")
            return
        }
        XCTAssertEqual(first.articleKey, 6199336700477440)
        XCTAssertEqual(first.id, "WSwy3BZ3Wok")
        XCTAssertEqual(first.pid, nil)
        XCTAssertEqual(first.section, "POLITICS")
        XCTAssertEqual(first.thumbnail, "https://i.ytimg.com/vi/WSwy3BZ3Wok/hqdefault.jpg")
        XCTAssertEqual(first.title, "‘I don’t want to incriminate myself’: Dudu Myeni refuses to answer commission questions")

        XCTAssertNil(sut.getMedia(at: IndexPath(row: 3, section: 0)))
        XCTAssertNil(sut.getMedia(at: IndexPath(row: -1, section: 0)))
    }
}
