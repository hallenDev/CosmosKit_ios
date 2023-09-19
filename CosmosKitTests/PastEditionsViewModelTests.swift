//swiftlint:disable line_length
@testable import CosmosKit
import XCTest

class PastEditionsViewModelTests: XCTestCase {

    func testCreate_PastEditionsViewModel_fromPastEditions() {

        let fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                            articleFallback: TestFallback(),
                                            searchFallback: TestFallback())
        let publication = TestPublication(fallbackConfig: fallbackConfig)
        
        let config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        let cosmos = TestableCosmos(client: client, apiConfig: config)
        let json = readJSONData("PastEditionsList")

        do {
            let editions = try JSONDecoder().decode([PastEdition].self, from: json)

            let sut = PastEditionsViewModel(from: editions, section: "editions", cosmos: cosmos)

            XCTAssertNotNil(sut.editions)
            XCTAssertEqual(sut.editions.count, 10)
            XCTAssertEqual(sut.edition(for: IndexPath(row: 0, section: 0))?.title, "Friday\nJuly 27 2018")
            XCTAssertEqual(sut.edition(for: IndexPath(row: 0, section: 0))?.articleCount, "31 articles")
            XCTAssertEqual(sut.edition(for: IndexPath(row: 0, section: 0))?.publishDate, Date(timeIntervalSince1970: TimeInterval(1532660401)))
            XCTAssertNotNil(sut.edition(for: IndexPath(row: 0, section: 0))?.image)
            XCTAssertEqual(sut.apiSection, "editions")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
