@testable import CosmosKit
import XCTest

class PastEditionViewModelTests: XCTestCase {

    func testCreate_PastEditionViewModel_fromPastEdition() {

        let json = readJSONData("PastEdition")

        do {
            let edition = try JSONDecoder().decode(PastEdition.self, from: json)

            let sut = PastEditionViewModel(from: edition, theme: Theme())

            XCTAssertEqual(sut.title, "Friday\nJuly 27 2018")
            XCTAssertEqual(sut.articleCount, "31 articles")
            XCTAssertEqual(sut.publishDate, Date(timeIntervalSince1970: TimeInterval(1532660401)))
            XCTAssertNotNil(sut.image)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
