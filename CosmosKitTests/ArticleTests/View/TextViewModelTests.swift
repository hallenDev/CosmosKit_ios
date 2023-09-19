//swiftlint:disable line_length
import XCTest
@testable import CosmosKit

class TextViewModelTests: XCTestCase {

    func testCreate() {

        let text = TextWidgetData(html: "test text", text: "test text")

        let sut = TextViewModel(from: text, type: .text)

        XCTAssertEqual(sut.html, "test text")
        XCTAssertEqual(sut.text, "test text")
        XCTAssertFalse(sut.isCrossword)
    }

    func testCreate_DoublesNewLines() {

        let text = TextWidgetData(html: "test\ntext", text: "test\ntext")

        let sut = TextViewModel(from: text, type: .text)

        XCTAssertEqual(sut.html, "test\ntext")
        XCTAssertEqual(sut.text, "test\ntext")
        XCTAssertFalse(sut.isCrossword)
    }

    func testCrossword() {

        let text = TextWidgetData(html: "Cryptic:\n<iframe height=\"700\" width=\"100%\" allowfullscreen=\"true\" \n        style=\"border:none;width: 100% !important;position: static;display: block !important;margin: 0 !important;\"  \n        name=\"tiso\" src=\"https://cdn2.amuselabs.com/tb/date-picker?set=tiso-cryptic&theme=tb\"></iframe>", text: nil)

        let sut = TextViewModel(from: text, type: .text)

        XCTAssertTrue(sut.isCrossword)
    }
}
