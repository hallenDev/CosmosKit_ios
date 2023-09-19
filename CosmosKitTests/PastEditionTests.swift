@testable import CosmosKit
import XCTest

class PastEditionTests: XCTestCase {

    func testCreate() {

        let jsonData = readJSONData("PastEdition")

        do {
            let sut = try JSONDecoder().decode(PastEdition.self, from: jsonData)

            XCTAssertEqual(sut.title, "Friday, July 27 2018")
            XCTAssertEqual(sut.publishDate, Date(timeIntervalSince1970: TimeInterval(1532660401)))
            XCTAssertEqual(sut.articleCount, 31)
            XCTAssertNotNil(sut.image)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
