@testable import CosmosKit
import XCTest

class AccordionViewModelTests: XCTestCase {

    func testCreate_widgetViewModel() {

        let widgetData = AccordionWidgetData(accordions: [AccordionData(text: "test123", title: "test")],
                                             title: "testTitle")

        let sut = AccordionViewModel(from: widgetData)

        XCTAssertEqual(sut.accordions.first?.title, "test")
        XCTAssertEqual(sut.accordions.first?.text, "test123")
        XCTAssertEqual(sut.accordions.count, 1)
        XCTAssertEqual(sut.title, "testTitle")
    }

    func testCreate_viewModel() {

        let widgetData = AccordionData(text: "test123", title: "test")

        let sut = AccordionItemViewModel(from: widgetData)

        XCTAssertEqual(sut.text, "test123")
        XCTAssertEqual(sut.title, "test")
        XCTAssertFalse(sut.open)
    }
}
