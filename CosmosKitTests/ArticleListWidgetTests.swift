import XCTest
@testable import CosmosKit

class ArticleListWidgetTests: XCTestCase {

    func testCreateFromJSON() {

        let data = readJSONData("WidgetArticleList")

        do {
            let sut = try JSONDecoder().decode(Widget.self, from: data)

            let result = sut.data as? ArticleListWidgetData
            XCTAssertEqual(result?.articleIds.count, 5)
            XCTAssertEqual(result?.heading, "THE BIG STORIES")
            XCTAssertEqual(result?.subHeading, "LEADING THE AGENDA")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
