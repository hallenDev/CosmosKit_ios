@testable import CosmosKit
import XCTest

class FallbackConfigTests: XCTestCase {

    func testCreate_default() {

        let sut = FallbackConfig(noNetworkFallback: TestFallback(),
                                 articleFallback: TestFallback(),
                                 searchFallback: TestFallback())

        XCTAssertEqual(sut.noNetworkFallback, TestFallback().fallback)
        XCTAssertEqual(sut.articleFallback, TestFallback().fallback)
        XCTAssertEqual(sut.searchFallback, TestFallback().fallback)
        XCTAssertEqual(sut.editionFallback, FallbackConfig.defaultFallback)
        XCTAssertEqual(sut.sectionFallback, FallbackConfig.defaultFallback)
        XCTAssertEqual(sut.bookmarksFallback, FallbackConfig.defaultFallback)
        XCTAssertEqual(sut.pastEditionFallback, FallbackConfig.defaultFallback)
        XCTAssertEqual(sut.articleListFallback, FallbackConfig.defaultFallback)
    }

    func testCreate_nonDefault() {

        let testFallback = TestFallback()

        let sut = FallbackConfig(noNetworkFallback: testFallback,
                                 articleFallback: testFallback,
                                 searchFallback: testFallback,
                                 editionFallback: testFallback,
                                 sectionFallback: testFallback,
                                 bookmarksFallback: testFallback,
                                 pastEditionFallback: testFallback,
                                 articleListFallback: testFallback)

        XCTAssertEqual(sut.noNetworkFallback, testFallback.fallback)
        XCTAssertEqual(sut.articleFallback, testFallback.fallback)
        XCTAssertEqual(sut.searchFallback, testFallback.fallback)
        XCTAssertEqual(sut.editionFallback, testFallback.fallback)
        XCTAssertEqual(sut.sectionFallback, testFallback.fallback)
        XCTAssertEqual(sut.bookmarksFallback, testFallback.fallback)
        XCTAssertEqual(sut.pastEditionFallback, testFallback.fallback)
        XCTAssertEqual(sut.articleListFallback, testFallback.fallback)
    }
}
