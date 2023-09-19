//swiftlint:disable line_length function_body_length
import XCTest
import CosmosKit

class ArticleTests: XCTestCase {

    func testBaseArticle() {

        let jsonData = readJSONData("Article")

        do {
            let sut = try JSONDecoder().decode(Article.self, from: jsonData)

            XCTAssertEqual(sut.title, "Article for app testing widgets...")
            XCTAssertEqual(sut.title2, "Over head Title")
            XCTAssertEqual(sut.title3, "Under head, sub-heading")
            XCTAssertEqual(sut.published, 1524488220000)
            XCTAssertEqual(sut.authors, ["Sohee Kim", "Bloomberg"])
            XCTAssertEqual(sut.intro, "This is an into, it is not always used, but if used will be the first paragraph of the sorty")
            XCTAssertEqual(sut.headerImage?.imageURL, "https://lh3.googleusercontent.com/Y3D2uYKldpJwY1a51MlYvH4cOtl0oryycLLijSTmW_tXpqKQbSgUG4kvXCnBMZDz2FyMTFQvjsKxUyyTX4DND53oKNur")
            XCTAssertEqual(sut.section.name, "Markets")
            XCTAssertEqual(sut.publication.identifier, "bl")
            XCTAssertEqual(sut.videoCount, 3)
            XCTAssertTrue(sut.comments)
            XCTAssertTrue(sut.access!)
            XCTAssertNil(sut.externalUrl)
            XCTAssertEqual(sut.shareURL, "/markets/2018-04-23-article-for-app-testing-widgets/")
            XCTAssertEqual(sut.contentType, "free")
            XCTAssertEqual(sut.key, 5688160465977344)
            XCTAssertEqual(sut.slug, "2018-04-23-article-for-app-testing-widgets")

            XCTAssertEqual(sut.widgets?.count, 22)
            XCTAssertEqual(sut.widgets?[0].type, .image)
            XCTAssertEqual(sut.widgets?[1].type, .text)
            XCTAssertEqual(sut.widgets?[2].type, .gallery)
            XCTAssertEqual(sut.widgets?[3].type, .quote)
            XCTAssertEqual(sut.widgets?[4].type, .text)
            XCTAssertEqual(sut.widgets?[5].type, .divider)
            XCTAssertEqual(sut.widgets?[6].type, .infoblock)
            XCTAssertEqual(sut.widgets?[7].type, .text)
            XCTAssertEqual(sut.widgets?[8].type, .googleMaps)
            XCTAssertEqual(sut.widgets?[9].type, .text)
            XCTAssertEqual(sut.widgets?[10].type, .youtube)
            XCTAssertEqual(sut.widgets?[11].type, .text)
            XCTAssertEqual(sut.widgets?[12].type, .jwplayer)
            XCTAssertEqual(sut.widgets?[13].type, .text)
            XCTAssertEqual(sut.widgets?[14].type, .tweet)
            XCTAssertEqual(sut.widgets?[15].type, .text)
            XCTAssertEqual(sut.widgets?[16].type, .relatedArticles)
            XCTAssertEqual(sut.widgets?[17].type, .facebookPost)
            XCTAssertEqual(sut.widgets?[18].type, .facebookVideo)
            XCTAssertEqual(sut.widgets?[19].type, .instagram)
            XCTAssertEqual(sut.widgets?[20].type, .iframely)
            XCTAssertTrue(sut.isSponsored)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRealArticle() {

        let jsonData = readJSONData("Article2")

        do {
            let sut = try JSONDecoder().decode(Article.self, from: jsonData)

            XCTAssertEqual(sut.title, "Oh baby: When shopping for sperm, it's best to go overseas")
            XCTAssertNil(sut.title2)
            XCTAssertEqual(sut.title3, "South African sperm donors are so rare that most moms-to-be seek overseas variety")
            XCTAssertEqual(sut.published, 1534302000000)
            XCTAssertEqual(sut.authors, ["Tania Broughton"])
            XCTAssertEqual(sut.intro, "")
            XCTAssertNil(sut.headerImage?.imageURL)
            XCTAssertEqual(sut.section.name, "News")
            XCTAssertEqual(sut.publication.identifier, "times-select")
            XCTAssertEqual(sut.videoCount, 0)
            XCTAssertTrue(sut.comments)
            XCTAssertFalse(sut.access!)
            XCTAssertEqual(sut.externalUrl, "test url")
            XCTAssertEqual(sut.shareURL, "/news/2018-08-15-oh-baby-when-shopping-for-sperm-its-best-to-go-overseas/")
            XCTAssertEqual(sut.contentType, "premium")
            XCTAssertEqual(sut.key, 4870003975258112)
            XCTAssertEqual(sut.slug, "2018-08-15-oh-baby-when-shopping-for-sperm-its-best-to-go-overseas")
            XCTAssertEqual(sut.widgets?.count, 1)
            XCTAssertFalse(sut.isSponsored)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testMarketArticle() {

        let jsonData = readJSONData("MarketDataArticleFull")

        do {
            let sut = try JSONDecoder().decode(Article.self, from: jsonData)

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

func readJSONData(_ fileName: String) -> Data {
    guard let path = Bundle(for: ArticleTests.classForCoder()).path(forResource: fileName, ofType: "json") else {
        XCTFail("failed to get path for file: \(fileName)")
        return Data()
    }
    do {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    } catch {
        XCTFail("failed to convert file \(fileName) into Data")
        return Data()
    }
}
