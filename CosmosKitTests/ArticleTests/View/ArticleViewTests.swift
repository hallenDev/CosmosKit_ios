//swiftlint:disable line_length function_body_length
import XCTest
@testable import CosmosKit

class ArticleViewTests: XCTestCase {

    var articleWidgets: [Widget] = [Widget(ImageWidgetData(image: Image(filepath: "/url",
                                                                        title: "test",
                                                                        description: "test",
                                                                        author: "test",
                                                                        height: 320,
                                                                        width: 320,
                                                                        blur: nil))),

                                    Widget(TextWidgetData(html: "text", text: "text")),
                                    Widget(WebWidgetData(meta: WebViewWidgetMetaData(html: "html"), url: "")),
                                    Widget(WebWidgetData(meta: WebViewWidgetMetaData(html: "instagram"), url: "")),
                                    Widget(WebWidgetData(meta: WebViewWidgetMetaData(html: "twitter"), url: "")),
                                    Widget(WebWidgetData(meta: WebViewWidgetMetaData(html: "facebook_post"), url: "")),
                                    Widget(WebWidgetData(meta: WebViewWidgetMetaData(html: "facebook_video"), url: "")),
                                    Widget(.divider),
                                    Widget(YoutubeWidgetData(id: nil, pid: "id", meta: YoutubeMetaData(title: "test", thumbnail: "test"), url: "test")),
                                    Widget(QuoteWidgetData(quote: "quote", cite: nil)),
                                    Widget(InfoBlockWidgetData(title: "title", description: nil)),
                                    Widget(RelatedArticlesWidgetData(articles: [ ArticleSummary(title: "",
                                                                                                titleText: nil,
                                                                                                sectionTitle: "section ittle",
                                                                                                section: Section(name: "Section", id: "section"),
                                                                                                subSection: nil,
                                                                                                adSections: nil,
                                                                                                synopsis: "",
                                                                                                image: Image(),
                                                                                                published: 1,
                                                                                                modified: 2,
                                                                                                author: nil,
                                                                                                authors: ["Tom Test"],
                                                                                                publication: ArticlePublication(identifier: "test"),
                                                                                                key: 1,
                                                                                                slug: "slug",
                                                                                                shareURL: "test",
                                                                                                access: true,
                                                                                                comments: true,
                                                                                                externalUrl: nil,
                                                                                                videoCount: 0,
                                                                                                readDuration: 100,
                                                                                                contentType: nil,
                                                                                                sponsor: nil,
                                                                                                marketData: nil),
                                                                                 ArticleSummary(title: "",
                                                                                                titleText: nil,
                                                                                                sectionTitle: "section ittle",
                                                                                                section: Section(name: "Section", id: "section"),
                                                                                                subSection: nil,
                                                                                                adSections: nil,
                                                                                                synopsis: "",
                                                                                                image: Image(),
                                                                                                published: 1,
                                                                                                modified: 2,
                                                                                                author: nil,
                                                                                                authors: ["Tom Test"],
                                                                                                publication: ArticlePublication(identifier: "test"),
                                                                                                key: 2,
                                                                                                slug: "slug",
                                                                                                shareURL: "test",
                                                                                                access: true,
                                                                                                comments: true,
                                                                                                externalUrl: nil,
                                                                                                videoCount: 0,
                                                                                                readDuration: 100,
                                                                                                contentType: nil,
                                                                                                sponsor: nil,
                                                                                                marketData: nil) ],
                                                                     meta: RelatedArticlesMetaData(title: "related")))]

    var premiumArticle: Article!
    var freeArticle: Article!
    let sut = ArticleViewController()
    let paywall = UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self))
    let registrationWall = UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self))
    let subWall = UINib(nibName: "TestView", bundle: Bundle(for: ArticleViewTests.self))
    var cosmos: TestableCosmos!
    var narratiive: TestableNarratiiveLogger!

    override func setUp() {
        super.setUp()
        sut.container = UIStackView()
        sut.relatedSelected = { _ in }

        let uiconfig = CosmosUIConfig(logo: UIImage(), shouldNavHideLogo: false,
                                      registrationWallView: registrationWall,
                                      subscriptionWallView: subWall,
                                      payWallView: paywall)
        let fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                            articleFallback: TestFallback(),
                                            searchFallback: TestFallback())
        
        let config = CosmosConfig(publication: TestPublication(fallbackConfig: fallbackConfig, uiConfig: uiconfig))
        let nconfig = NarratiiveConfig(baseUrl: "",
                                       host: "",
                                       hostKey: "")
        narratiive = TestableNarratiiveLogger(config: nconfig)
        cosmos = TestableCosmos(client: TestableCosmosClient(apiConfig: config), apiConfig: config, narratiiveLogger: narratiive)
        sut.activityIndicator = CosmosActivityIndicator(cosmos: cosmos, frame: .zero)
        sut.setupController(cosmos: cosmos, fallback: fallbackConfig.articleFallback, event: CosmosEvents.article(articleKey: "text"))

        premiumArticle = Article(title: "test",
                                 sectionTitle: "section title",
                                 title2: "test2",
                                 title3: "title3",
                                 section: Section(name: "Section", id: "section"),
                                 subSection: nil,
                                 adSections: nil,
                                 published: 0,
                                 modified: 2,
                                 publication: ArticlePublication(identifier: "times-live"),
                                 authors: [],
                                 author: Author(name: "author",
                                                title: "cat",
                                                image: Image()),
                                 intro: "intro",
                                 synopsis: "synopsis",
                                 headerImage: Image(),
                                 widgets: articleWidgets,
                                 images: [],
                                 key: 0,
                                 slug: "test",
                                 readDuration: 1,
                                 contentType: "premium",
                                 shareURL: "/test",
                                 access: false,
                                 comments: true,
                                 externalUrl: nil,
                                 videoCount: 0,
                                 hideInApp: false,
                                 sponsor: nil,
                                 marketData: nil)
        freeArticle = Article(title: "test",
                              sectionTitle: "section title",
                              title2: "test2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: 0,
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: [],
                              author: Author(name: "author",
                                             title: "cat",
                                             image: Image()),
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: Image(),
                              widgets: articleWidgets,
                              images: [],
                              key: 0,
                              slug: "/test",
                              readDuration: 1,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)
        sut.backgroundView = ArticleBackground()
    }

    func testSetArticle_ChecksAccess() {

        sut.backgroundView = ArticleBackground()
        sut.article = ArticleViewModel(from: premiumArticle, as: .live)
        sut.cosmos.user = CosmosUser(firstname: "piet", lastname: "pompies", email: "piet@pompies.com", guid: "test")

        sut.refreshUI()

        XCTAssertTrue(sut.container!.arrangedSubviews[0] is ArticleHeader)
        XCTAssertTrue(cosmos.getArticleCalled)
    }

    func testSetArticle_WithSupportedWidgets_registrationWall() {

        sut.article = ArticleViewModel(from: premiumArticle, as: .live)
        sut.refreshUI()
        sut.article.state = .accessCheck
        sut.cosmos.user = nil

        sut.refreshUI()

        XCTAssertTrue(sut.container!.arrangedSubviews[0] is ArticleHeader)
    }

    func testSetArticle_WithSupportedWidgets_paywall() {

        sut.article = ArticleViewModel(from: premiumArticle, as: .live)
        sut.refreshUI()
        sut.article.state = .accessCheck
        sut.cosmos.user = CosmosUser(firstname: "piet", lastname: "pompies", email: "piet@pompies.com", guid: "test")
        sut.refreshUI()

        XCTAssertTrue(sut.container!.arrangedSubviews[0] is ArticleHeader)
    }

    func testSetArticle_WithSupportedWidgets_free_noheader() {

        freeArticle = Article(title: "test",
                              sectionTitle: "section title",
                              title2: "test2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: 0,
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: [],
                              author: Author(name: "author",
                                             title: "cat",
                                             image: Image()),
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: nil,
                              widgets: articleWidgets,
                              images: [],
                              key: 0,
                              slug: "test",
                              readDuration: 1,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)
        sut.article = ArticleViewModel(from: freeArticle, as: .live)
        sut.scroll = UIScrollView()

        sut.refreshUI()

        XCTAssertEqual(sut.container!.arrangedSubviews.count, 26)
        XCTAssertTrue(sut.container!.arrangedSubviews[0] is ArticleImage)
        XCTAssertTrue(sut.container!.arrangedSubviews[1] is ArticleHeader)
        XCTAssertTrue(sut.container!.arrangedSubviews[2] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[3] is ArticleText)
        XCTAssertTrue(sut.container!.arrangedSubviews[4] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[5] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[6] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[7] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[8] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[9] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[10] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[11] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[12] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[13] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[14] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[15] is ArticleDivider)
        XCTAssertTrue(sut.container!.arrangedSubviews[16] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[17] is ArticleYoutube)
        XCTAssertTrue(sut.container!.arrangedSubviews[18] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[19] is ArticleQuote)
        XCTAssertTrue(sut.container!.arrangedSubviews[20] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[21] is ArticleQuote)
        XCTAssertTrue(sut.container!.arrangedSubviews[22] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[23] is ArticleRelatedArticles)
        XCTAssertTrue(sut.container!.arrangedSubviews[24] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[25] is ArticleFooter)
    }
    
    func testSetArticle_WithSupportedWidgets_free_headerImage() {

        sut.article = ArticleViewModel(from: freeArticle, as: .live)
        sut.scroll = UIScrollView()

        sut.refreshUI()

        XCTAssertEqual(sut.container!.arrangedSubviews.count, 27)
        XCTAssertTrue(sut.container!.arrangedSubviews[0] is ArticleHeader)
        XCTAssertTrue(sut.container!.arrangedSubviews[1] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[2] is ArticleImage)
        XCTAssertTrue(sut.container!.arrangedSubviews[3] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[4] is ArticleText)
        XCTAssertTrue(sut.container!.arrangedSubviews[5] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[6] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[7] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[8] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[9] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[10] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[11] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[12] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[13] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[14] is ArticleWebView)
        XCTAssertTrue(sut.container!.arrangedSubviews[15] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[16] is ArticleDivider)
        XCTAssertTrue(sut.container!.arrangedSubviews[17] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[18] is ArticleYoutube)
        XCTAssertTrue(sut.container!.arrangedSubviews[19] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[20] is ArticleQuote)
        XCTAssertTrue(sut.container!.arrangedSubviews[21] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[22] is ArticleQuote)
        XCTAssertTrue(sut.container!.arrangedSubviews[23] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[24] is ArticleRelatedArticles)
        XCTAssertTrue(sut.container!.arrangedSubviews[25] is ArticleSpacer)
        XCTAssertTrue(sut.container!.arrangedSubviews[26] is ArticleFooter)
    }

    func testGetContentLockView_subscription() {

        sut.cosmos.user = nil
        sut.article = ArticleViewModel(from: premiumArticle, as: .live)

        let view = sut.getContentLockView()

        XCTAssertNotNil(view)
    }

    func testGetContentLockView_register() {

        sut.cosmos.user = nil
        sut.article = ArticleViewModel(from: freeArticle, as: .live)

        let view = sut.getContentLockView()

        XCTAssertNotNil(view)
    }

    func testGetContentLockView_pay() {

        cosmos.testIsLoggedIn = true
        sut.article = ArticleViewModel(from: freeArticle, as: .live)

        let view = sut.getContentLockView()

        XCTAssertNotNil(view)
    }
    
    func testnarratiiveSendEvent_UsesCorrectPath() {

        sut.article = ArticleViewModel(from: freeArticle, as: .live)

        sut.narratiiveSendEvent()
        
        XCTAssertEqual(narratiive.path, "/test")
    }
}

class TestableNarratiiveLogger: NarratiiveLogger {
    var path: String?
    
    override func sendEvent(path: String, completion: ((Bool) -> Void)?) {
        self.path = path
        completion?(true)
    }
    
}
