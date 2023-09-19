import XCTest
@testable import CosmosKit

class JWPlayerViewModelTests: XCTestCase {

    func testCreate() {

        let widgetData = JWPlayerWidgetData(meta: JWPlayerMetaData(html: "test:///", description: "a video"), url: "test://", id: "123456")

        let sut = JWPlayerViewModel(from: widgetData)

        XCTAssertEqual(sut.webData, "test:///")
        XCTAssertEqual(sut.url, "test://")
        XCTAssertEqual(sut.description, "a video")
    }
}
