import XCTest
@testable import CosmosKit

class EditionTests: XCTestCase {

    func testEdition_CreateEditionFromJSON() {
        let json = readJSONData("Edition")

        do {
            let sut = try JSONDecoder().decode(Edition.self, from: json)

            XCTAssertEqual(sut.widgets?.filter { $0.type == .articleList }.count, 8)
            XCTAssertEqual(sut.widgets?.count, 22)
            XCTAssertEqual(sut.articles.count, 25)
            XCTAssertEqual(sut.widgets?[0].type, .articleList)
            XCTAssertEqual(sut.widgets?[1].type, .articleList)
            XCTAssertEqual(sut.widgets?[2].type, .articleList)
            XCTAssertEqual(sut.widgets?[3].type, .articleList)
            XCTAssertEqual(sut.widgets?[4].type, .divider)
            XCTAssertEqual(sut.widgets?[5].type, .text)
            XCTAssertEqual(sut.widgets?[6].type, .iframely)
            XCTAssertEqual(sut.widgets?[7].type, .gallery)
            XCTAssertEqual(sut.widgets?[8].type, .divider)
            XCTAssertEqual(sut.widgets?[9].type, .text)
            XCTAssertEqual(sut.widgets?[10].type, .image)
            XCTAssertEqual(sut.widgets?[11].type, .accordion)
            XCTAssertEqual(sut.widgets?[12].type, .divider)
            XCTAssertEqual(sut.widgets?[13].type, .articleList)
            XCTAssertEqual(sut.widgets?[14].type, .text)
            XCTAssertEqual(sut.widgets?[15].type, .accordion)
            XCTAssertEqual(sut.widgets?[16].type, .image)
            XCTAssertEqual(sut.widgets?[17].type, .divider)
            XCTAssertEqual(sut.widgets?[18].type, .articleList)
            XCTAssertEqual(sut.widgets?[19].type, .articleList)
            XCTAssertEqual(sut.widgets?[20].type, .articleList)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testEdition_CreateArticleFromJSON() {
        let json = readJSONData("EditionArticle")

        do {
            let sut = try JSONDecoder().decode(Article.self, from: json)

            XCTAssertEqual(sut.title, "Exclusive: Top-secret police codes up for sale")
            XCTAssertEqual(sut.key, 6200429704642560)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEdition_CreateEditionFromStagingJSON() {
        let json = readJSONData("Staging")

        do {
            let sut = try JSONDecoder().decode(Array<Edition>.self, from: json).first!

            XCTAssertEqual(sut.widgets?.filter { $0.type == .articleList }.count, 3)
            XCTAssertEqual(sut.widgets?.count, 6)
            XCTAssertEqual(sut.articles.count, 10)
        } catch {
            XCTFail(String(describing: error))
        }
    }
}
