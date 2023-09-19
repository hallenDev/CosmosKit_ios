//swiftlint:disable line_length force_try
import XCTest
@testable import CosmosKit

class ArticleSummaryTests: XCTestCase {

    func testCreateFromJSON() {

        let data = readJSONData("ArticleSummary")

        do {
            let sut = try JSONDecoder().decode(ArticleSummary.self, from: data)
            XCTAssertEqual(sut.title, "EFF joins DA in opposing #ZumaFees")
            XCTAssertEqual(sut.sectionTitle, "EFF joins DA in opposing #ZumaFees")
            XCTAssertEqual(sut.image?.imageURL, "https://lh3.googleusercontent.com/acNF8kWkmOihuQNjdnFAvVGXufNqJOzM4W6n1KkcspYLtO2DcsfCmF3VBWccd4vvPzB-y8hObNqKSECR2TJ7")
            XCTAssertEqual(sut.key, 6682059825217536)
            XCTAssertEqual(sut.section.name, "Politics")
            XCTAssertEqual(sut.synopsis, "The Democratic Alliance (DA) has argued that the decisions by the state attorney and the presidency to cover former president Jacob Zuma's legal costs are unlawful and should be set aside.")
            XCTAssertEqual(sut.published, 1541506740000)
            XCTAssertEqual(sut.publication.identifier, "times-live")
            XCTAssertEqual(sut.slug, "2018-11-06-eff-joins-da-in-opposing-zumafees")
            XCTAssertEqual(sut.shareURL, "/politics/2018-11-06-eff-joins-da-in-opposing-zumafees/")
            XCTAssertTrue(sut.access!)
            XCTAssertFalse(sut.comments!)
            XCTAssertEqual(sut.externalUrl, "test url")
            XCTAssertEqual(sut.videoCount, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testMarketData() {

        let data = readJSONData("MarketDataArticle")

        do {
            let sut = try JSONDecoder().decode(ArticleSummary.self, from: data)

            guard let data = sut.marketData else {
                XCTFail("May not be nil")
                return
            }

            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(data.first?.symbol, "MTM")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
