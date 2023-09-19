//swiftlint:disable line_length identifier_name
import XCTest
@testable import CosmosKit

class ArticlePagerTests: XCTestCase {
    
    let article = Article(title: "title",
                          sectionTitle: "section title",
                          title2: "title2",
                          title3: "title3",
                          section: Section(name: "Section", id: "section"),
                          subSection: nil,
                          adSections: nil,
                          published: Int64(1524488220000.0),
                          modified: 2,
                          publication: ArticlePublication(identifier: "times-live"),
                          authors: ["author1"],
                          author: Author(name: "author",
                                         title: "cat",
                                         image: Image(filepath: "//path",
                                                      title: "",
                                                      description: "",
                                                      author: "",
                                                      height: 1,
                                                      width: 1,
                                                      blur: "/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAUDBAQEAQUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx4BBQUFBwYHDggIDhIUERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eFR4eHh4eEv/AABEIAAsAEAMBIgACEQEDEQH/xAAVAAEBAAAAAAAAAAAAAAAAAAAGB//EACUQAAEDAgUEAwAAAAAAAAAAAAECAxEEBQAHEhMxBiGBoRZBUf/EABUBAQEAAAAAAAAAAAAAAAAAAAUE/8QAHBEAAQMFAAAAAAAAAAAAAAAAAQMhMQACEROh/9oADAMBAAIRAxEAPwBhdbcHsrrt8fS29eKFvQEogKSrsookiJI9xxgXdOo7RY8g6TqK+Wl56tqK1VAkJ0bzWkQrdUTCQIPP1AOFfUyjT5i6GIbS+85uhIjXCUqE+VE+cQrP29XWozSrLM9XOqoAyzWbEwkvLDepRjuZ/OJJPJxCkReo4jNJr26k2M4PK//Z")),
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
                          key: 1234,
                          slug: "test",
                          readDuration: 1,
                          contentType: "premium",
                          shareURL: "/test",
                          access: true,
                          comments: true,
                          externalUrl: nil,
                          videoCount: 0,
                          hideInApp: false,
                          sponsor: nil,
                          marketData: nil)
    
    var testCosmos: TestableCosmos!
    var sut: ArticlePagerViewController!
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!
    
    override func setUp() {
        super.setUp()
        let vm = ArticleViewModel(from: article, as: .live)
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)
        config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        testCosmos = TestableCosmos(client: client, apiConfig: config)
        sut = ArticlePagerViewController(cosmos: testCosmos, articles: [vm], currentArticle: vm)
    }
    
    func testBookmark_unbookmarkedArticle() {
        
        sut.bookmarkArticle()
        
        XCTAssertTrue(testCosmos.bookmarkCalled)
    }
    
    func testBookmark_bookmarkedArticle() {
        
        _ = LocalStorage().persist(article)
        
        sut.bookmarkArticle()
        
        XCTAssertTrue(testCosmos.removeBookmarkCalled)
        _ = LocalStorage().removeArticle(key: 1234)
    }
    
    func testShare_callsCosmosCallback() {
        
        sut.shareArticle()
        
        XCTAssertTrue(testCosmos.articleShareCallbackCalled)
    }
}
