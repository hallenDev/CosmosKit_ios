import XCTest
@testable import CosmosKit

class InfoBlockViewModelTests: XCTestCase {

    func testCreate_Full() {

        let infoData = InfoBlockWidgetData(title: "title", description: "description")

        let sut = InfoBlockViewModel(from: infoData)

        XCTAssertEqual(sut.title, "title")
        XCTAssertEqual(sut.description, "description")
    }

    func testCreate_WithoutCite() {

        let infoData = InfoBlockWidgetData(title: "title", description: nil)

        let sut = InfoBlockViewModel(from: infoData)

        XCTAssertNil(sut.description)
    }
}
