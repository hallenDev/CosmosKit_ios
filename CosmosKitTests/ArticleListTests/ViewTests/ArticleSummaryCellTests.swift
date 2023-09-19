import XCTest
@testable import CosmosKit

class ArticleSummaryCellTests: XCTestCase {

    let sut = TestableListTable().createArticleSummaryCell()
    var testCosmos: TestableCosmos!
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!

    override func setUp() {
        super.setUp()
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)
        
        config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        testCosmos = TestableCosmos(client: client, apiConfig: config)
    }

    func testPrepareForReuse_ClearsEverything() {

        sut.prepareForReuse()

        XCTAssertNil(sut.articleImage.image)
        XCTAssertNil(sut.articleSection.text)
        XCTAssertNil(sut.articleTitle.text)
    }

    func testConfigure_SetsText() {
        let summary = ArticleSummary(title: "title",
                                    titleText: nil,
                                    sectionTitle: "sectionTitle",
                                    section: Section(name: "section", id: "section"),
                                    subSection: nil,
                                    adSections: nil,
                                    synopsis: "s1",
                                    image: Image(),
                                    published: 1,
                                    modified: 2,
                                    author: nil,
                                    authors: ["Tom Test"],
                                    publication: ArticlePublication(identifier: "test"),
                                    key: 0,
                                    slug: "slug",
                                    shareURL: "test",
                                    access: true,
                                    comments: true,
                                    externalUrl: nil,
                                    videoCount: 0,
                                    readDuration: 100,
                                    contentType: nil,
                                    sponsor: nil,
                                    marketData: nil)

        let article = ArticleSummaryViewModel(from: summary, as: .edition)
        sut.wrapperView = UIView()

        sut.configure(article: article, cosmos: testCosmos)

        XCTAssertEqual(sut.articleTitle.text, "sectionTitle")
        XCTAssertEqual(sut.articleSection.text, "SECTION")
    }

}
