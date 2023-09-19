import XCTest
import GoogleMobileAds
@testable import CosmosKit

class ArticleListViewTests: XCTestCase {

    let sut = ArticleListViewController()
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!
    var client: TestableCosmosClient!
    var cosmos: Cosmos!

    var testArticle = Article(title: "title",
                              sectionTitle: "section title",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: [],
                              author: nil,
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "//filepath",
                                                 title: "image",
                                                 description: "description",
                                                 author: "author",
                                                 height: 100,
                                                 width: 200,
                                                 blur: nil),
                              widgets: [],
                              images: [],
                              key: 0,
                              slug: "test",
                              readDuration: 120,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

    override func setUp() {
        super.setUp()
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)
        
        config = CosmosConfig(publication: publication)
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        sut.setupController(cosmos: cosmos, headerTitle: "", fallback: fallbackConfig.articleFallback, event: CosmosEvents.homePage)
        client.articles = [testArticle]
        sut.tableView = UITableView()
        _ = sut.view
    }

    func testGetArticleList() {

        sut.configureDataSource()

        XCTAssertTrue(client.getAllArticlesCalled)
    }

    func testSetArticleList_Section() {

        let section = Section(name: "test", id: "test")
        let sectionVM = SectionViewModel(section: section)

        sut.configureDataSource(section: sectionVM!)

        XCTAssertTrue(client.getAllArticlesForSectionCalled)
    }

    func testSetArticleList_SubSection() {

        let section = Section(name: "test", id: "test")
        var sectionVM = SectionViewModel(section: section)
        sectionVM?.subSections = [SectionViewModel(section: section)!]

        sut.configureDataSource(subSection: sectionVM!)

        XCTAssertTrue(client.getAllArticlesForSubSectionCalled)
    }

    func testSetArticleList_search() {

        client.searchResults = [Article(title: "title",
                                        sectionTitle: "section title",
                                        title2: "title2",
                                        title3: "title3",
                                        section: Section(name: "Section", id: "section"),
                                        subSection: nil,
                                        adSections: nil,
                                        published: Int64(1524488220000.0),
                                        modified: 2,
                                        publication: ArticlePublication(identifier: "times-live"),
                                        authors: [],
                                        author: nil,
                                        intro: "intro",
                                        synopsis: "synopsis",
                                        headerImage: Image(filepath: "//filepath",
                                                           title: "image",
                                                           description: "description",
                                                           author: "author",
                                                           height: 100,
                                                           width: 200,
                                                           blur: nil),
                                        widgets: [],
                                        images: [],
                                        key: 0,
                                        slug: "test",
                                        readDuration: 120,
                                        contentType: "free",
                                        shareURL: "/test",
                                        access: true,
                                        comments: true,
                                        externalUrl: nil,
                                        videoCount: 0,
                                        hideInApp: false,
                                        sponsor: nil,
                                        marketData: nil)]

        sut.configureDataSource(searchTerm: "test")

        XCTAssertTrue(client.getResultsCalled)
    }

    func testSetArticleList_bookmarks() {

        sut.tableView = UITableView()
        _ = sut.view
        
        sut.configureDataSourceForBookmarks(context: .bookmarksFromTab)

        XCTAssertTrue(client.getBookmarksCalled)
    }

    func testShouldFeature() {

        XCTAssertTrue(sut.shouldFeature(IndexPath(row: 0, section: 0)))
        XCTAssertFalse(sut.shouldFeature(IndexPath(row: 3, section: 0)))
        XCTAssertTrue(sut.shouldFeature(IndexPath(row: 6, section: 0)))
        XCTAssertFalse(sut.shouldFeature(IndexPath(row: 10, section: 0)))
        XCTAssertTrue(sut.shouldFeature(IndexPath(row: 12, section: 0)))
        XCTAssertFalse(sut.shouldFeature(IndexPath(row: 14, section: 0)))
    }

    func testShouldShowAd_false_bookmarks() {
        
        let listConfig = AdConfig(base: "base", articleListPlacements: [CosmosAdPlacement(adId: "test", type: .banner, featured: false, position: .below, placement: 0, sizes: [GADAdSizeBanner])])
        publication = TestPublication(fallbackConfig: fallbackConfig, adConfig: listConfig)
        
        config = CosmosConfig(publication: publication,
                              customArticlePublications: [publication])
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        sut.cosmos = cosmos

        sut.viewContext = .bookmarksFromTab

        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 0, section: 0)))
    }

    func testShouldShowAd_false_adsDisabled() {

        var pub = TestPublication(fallbackConfig: fallbackConfig)
        pub.adConfig = nil
        
        config = CosmosConfig(publication: pub)
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)

        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 0, section: 0)))
    }

    func testShouldShowAd_false_adsNotSet() {

        let listConfig = AdConfig(base: "base")
        publication = TestPublication(fallbackConfig: fallbackConfig, adConfig: listConfig)
        
        config = CosmosConfig(publication: publication, customArticlePublications: [publication])
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        sut.cosmos = cosmos

        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 0, section: 0)))
    }

    func testShouldShowAd_true() {

        sut.articleList = ArticleListViewModel(from: [testArticle])
        for _ in 0..<20 {
            sut.articleList?.add([testArticle])
        }
        let listConfig = AdConfig(base: "base", articleListPlacements: [CosmosAdPlacement(adId: "test", type: .banner, featured: false, position: .below, placement: 0, sizes: [GADAdSizeBanner]),
                                                                        CosmosAdPlacement(adId: "test", type: .banner, featured: false, position: .below, placement: 5, sizes: [GADAdSizeBanner]),
                                                                        CosmosAdPlacement(adId: "test", type: .banner, featured: false, position: .below, placement: 10, sizes: [GADAdSizeBanner]),
                                                                        CosmosAdPlacement(adId: "test", type: .banner, featured: false, position: .below, placement: 12, sizes: [GADAdSizeBanner])])
        publication = TestPublication(fallbackConfig: fallbackConfig, adConfig: listConfig)
        
        config = CosmosConfig(publication: publication, customArticlePublications: [publication])
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        sut.cosmos = cosmos
        sut.viewContext = .normal
        
        sut.configureAds()

        XCTAssertNotNil(sut.shouldShowAd(IndexPath(row: 0, section: 0)))
        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 1, section: 0)))
        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 4, section: 0)))
        XCTAssertNotNil(sut.shouldShowAd(IndexPath(row: 5, section: 0)))
        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 11, section: 0)))
        XCTAssertNotNil(sut.shouldShowAd(IndexPath(row: 10, section: 0)))
        XCTAssertNotNil(sut.shouldShowAd(IndexPath(row: 12, section: 0)))
        XCTAssertNil(sut.shouldShowAd(IndexPath(row: 16, section: 0)))
    }

    func testCustomizedPublication_none() {

        XCTAssertNil(sut.isArticlePublicationCustom("test"))
    }

    func testCustomizedPublication_some() {
        
        config = CosmosConfig(publication: publication,
                              customArticlePublications: [publication])
        client = TestableCosmosClient(apiConfig: config)
        cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        sut.cosmos = cosmos

        XCTAssertNotNil(sut.isArticlePublicationCustom("test"))
        XCTAssertNil(sut.isArticlePublicationCustom("hello"))
    }
}
