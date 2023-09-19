//swiftlint:disable force_try
import XCTest
@testable import CosmosKit

class TeaserWidgetTests: XCTestCase {

    func testHomePage() {

        let data = readJSONData("HomePage")

        let sut = try! JSONDecoder().decode([Teaser].self, from: data)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.count, 6)

        XCTAssertEqual(sut.first?.heading, "Nuutste uitgawe")
        XCTAssertNil(sut.first?.subHeading)
        XCTAssertEqual(sut.first?.template, "edition")
        XCTAssertNil(sut.first?.readMoreUrl)
        XCTAssertEqual(sut.first?.articles.count, 1)

        XCTAssertEqual(sut[3].heading, "Menings & Debat")
        XCTAssertEqual(sut[3].subHeading, "Hoogtepunte uit ons jongste uitgawes")
        XCTAssertEqual(sut[3].template, "carousel")
        XCTAssertEqual(sut[3].readMoreUrl, "https://www.vryeweekblad.com/menings-en-debat/")
        XCTAssertEqual(sut[3].articles.count, 12)
    }
}
