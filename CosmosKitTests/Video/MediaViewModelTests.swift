//swiftlint:disable force_try
import XCTest
@testable import CosmosKit

class VideoViewModelTests: XCTestCase {

    func testCreate() {

        do {
            let video = try JSONDecoder().decode(Media.self, from: readJSONData("Video"))

            guard let sut = MediaViewModel(video) else {
                XCTFail("failed to init video")
                return
            }

            XCTAssertEqual(sut.articleKey, 6199336700477440)
            XCTAssertEqual(sut.id, "WSwy3BZ3Wok")
            XCTAssertEqual(sut.pid, nil)
            XCTAssertEqual(sut.section, "POLITICS")
            XCTAssertEqual(sut.thumbnail, "https://i.ytimg.com/vi/WSwy3BZ3Wok/hqdefault.jpg")
            XCTAssertEqual(sut.title, "‘I don’t want to incriminate myself’: Dudu Myeni refuses to answer commission questions")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
