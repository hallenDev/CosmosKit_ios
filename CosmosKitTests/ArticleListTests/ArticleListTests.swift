import XCTest
@testable import CosmosKit

class ArticleListTests: XCTestCase {

    func testCreateFromJSON() {

        let data = readJSONData("ArticleList")

        do {
            let sut = try JSONDecoder().decode([Article].self, from: data)

            XCTAssertEqual(sut.count, 24)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
