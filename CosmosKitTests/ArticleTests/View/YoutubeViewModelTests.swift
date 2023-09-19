import XCTest
@testable import CosmosKit

class YoutubeViewModelTests: XCTestCase {

    func testCreate_video_id() {

        let youtube = YoutubeWidgetData(id: "youtubeID", pid: nil, meta: YoutubeMetaData(title: "test", thumbnail: "test"), url: "youtube.com")

        let sut = YoutubeViewModel(from: youtube)

        XCTAssertEqual(sut.id, "youtubeID")
        XCTAssertNil(sut.playlistId)
    }

    func testCreate_video_pid() {

        let youtube = YoutubeWidgetData(id: nil, pid: "pid", meta: YoutubeMetaData(title: "test", thumbnail: "test"), url: "youtube.com")

        let sut = YoutubeViewModel(from: youtube)

        XCTAssertEqual(sut.playlistId, "pid")
        XCTAssertNil(sut.id)
    }
}
