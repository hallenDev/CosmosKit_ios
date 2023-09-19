//swiftlint:disable force_try
@testable import CosmosKit
import XCTest

class SectionsViewModelTests: XCTestCase {

    func testCreate() {

        let data = readJSONData("section5")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionsViewModel(renderType: .edition, sections: [SectionViewModel(section: section)!])

        XCTAssertEqual(sut.total, 2)
        XCTAssertEqual(sut.renderType, .edition)
    }
}
