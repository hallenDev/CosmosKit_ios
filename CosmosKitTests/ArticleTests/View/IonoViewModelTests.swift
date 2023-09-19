@testable import CosmosKit
import XCTest

class IonoViewModelTests: XCTestCase {

    func testCreate_widgetViewModel() {

        let data = IonoWidgetData(html: "test", provider: "test2", title: "test3", thumbnail: "testhtml", height: 123)

        let sut = IonoViewModel(from: data)

        XCTAssertEqual(sut.html, "test")
        XCTAssertEqual(sut.provider, "test2")
    }
}
