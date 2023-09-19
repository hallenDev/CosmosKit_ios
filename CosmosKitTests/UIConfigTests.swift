@testable import CosmosKit
import XCTest

struct TestFallback: FallbackConfigurable {
    var fallback: Fallback {
        return Fallback(title: "test", body: "test", image: nil)
    }
}

class UIConfigTests: XCTestCase {

    func testCreate_default() {

        let sut = CosmosUIConfig(logo: UIImage(), shouldNavHideLogo: true)

        XCTAssertNil(sut.payWallView)
        XCTAssertNil(sut.subscriptionWallView)
        XCTAssertNil(sut.registrationWallView)
        XCTAssertNil(sut.searchRenderType)
        XCTAssertNil(sut.titleConfig)
        XCTAssertFalse(sut.dropDownTitle)
        XCTAssertNotNil(sut.logo)
        XCTAssertNotNil(sut.articleLogo)
        XCTAssertNil(sut.featuredArticleCell)
        XCTAssertNil(sut.articleCell)
        XCTAssertEqual(sut.articleHeaderType, .standard)
        XCTAssertEqual(sut.relatedArticleType, .full)
        XCTAssertTrue(sut.shouldNavHideLogo)
    }

    func testCreate_nonDefault() {

        let (paywall, subwall, regwall) = (UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self)), UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self)), UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self)))
        let customPair = CustomUIPair(nib: UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self)), reuseId: "test")

        let sut = CosmosUIConfig(logo: UIImage(),
                                 articleLogo: UIImage(),
                                 shouldNavHideLogo: false,
                                 titleConfig: TitleConfig([TitlePublication(id: "test",
                                                                            logo: UIImage(),
                                                                            selectable: true,
                                                                            backgroundColor: .white)]),
                                 registrationWallView: regwall,
                                 subscriptionWallView: subwall,
                                 payWallView: paywall,
                                 featuredArticleCell: customPair,
                                 articleCell: customPair,
                                 searchRenderType: .live,
                                 relatedArticleType: .minimalLeft,
                                 articleHeaderType: .expanded)

        XCTAssertNotNil(sut.payWallView)
        XCTAssertNotNil(sut.subscriptionWallView)
        XCTAssertNotNil(sut.registrationWallView)
        XCTAssertEqual(sut.searchRenderType, .live)
        XCTAssertNotNil(sut.titleConfig)
        XCTAssertTrue(sut.dropDownTitle)
        XCTAssertNotNil(sut.logo)
        XCTAssertNotNil(sut.articleLogo)
        XCTAssertNotNil(sut.featuredArticleCell)
        XCTAssertNotNil(sut.articleCell)
        XCTAssertEqual(sut.relatedArticleType, RelatedArticleType.minimalLeft)
        XCTAssertEqual(sut.articleHeaderType, ArticleHeaderType.expanded)
        XCTAssertFalse(sut.shouldNavHideLogo)
    }
}
