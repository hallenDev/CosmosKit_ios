//swiftlint:disable line_length file_length type_body_length function_body_length
import XCTest
@testable import CosmosKit
import SwiftKeychainWrapper

class CosmosTests: XCTestCase {

    var sampleArticle = Article(title: "title",
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

    var sut: Cosmos!
    var client: TestableCosmosClient!
    var keychain = TestableKeyChainWrapper()
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!
    var testdefaults: TestableCosmosDefaults!

    override func setUp() {
        super.setUp()
        Keychain.keychain = keychain
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)
        testdefaults = TestableCosmosDefaults()
        
        config = CosmosConfig(publication: publication)
        client = TestableCosmosClient(apiConfig: config)
        sut = Cosmos(client: client, apiConfig: config, defaults: testdefaults, errorDelegate: nil, eventDelegate: nil)
        client.articles = [sampleArticle]
        client.searchResults = [sampleArticle]
    }

    override func tearDown() {
        super.tearDown()
        Keychain.keychain = KeychainWrapper.standard
    }

    func testCreate_FromConfig() {

        XCTAssertNotNil(sut)
    }

    func testGetAtricle_returnsNoArticle_ForEmptySlug() {

        let exp = expectation(description: "Get Article")

        sut.getArticle(slug: "something") { article, _ in
            XCTAssertNil(article)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAtricle_returnsArticle_ForValidSlug() {

        let article = Article(title: "test",
                              sectionTitle: "section title",
                              title2: "",
                              title3: "",
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
                              intro: "",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "",
                                                 title: "",
                                                 description: "",
                                                 author: "author",
                                                 height: 100,
                                                 width: 200,
                                                 blur: nil),
                              widgets: [],
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
        client.article = article
        let exp = expectation(description: "Get Article")

        sut.getArticle(slug: "validSlug") { returnedArticle, _ in
            XCTAssertEqual(returnedArticle?.title, article.title)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleView() {
        let article = Article(title: "test",
                              sectionTitle: "section title",
                              title2: "",
                              title3: "",
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
                              intro: "",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "",
                                                 title: "",
                                                 description: "",
                                                 author: "author",
                                                 height: 100,
                                                 width: 200,
                                                 blur: nil),
                              widgets: [],
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
        let view = sut.getView(for: article, relatedSelected: { _ in })

        XCTAssertNotNil(view)
    }

    func testGetArticleList() {
        let list = [Article(title: "title",
                            sectionTitle: "section title",
                            title2: "title2",
                            title3: "title3",
                            section: Section(name: "Section", id: "section"),
                            subSection: nil,
                            adSections: nil,
                            published: Int64(1524488220000.0),
                            modified: 2,
                            publication: ArticlePublication(identifier: "test"),
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
        client.articles = list

        let exp = expectation(description: "Getting list of articles")

        sut.getAllArticles(page: 1) { list, _, _ in
            XCTAssertEqual(list!.count, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSection() {
        let list = [sampleArticle]
        client.articles = list

        let exp = expectation(description: "Getting list of articles for news section")

        sut.getAllArticles(section: "news") { list, _, _ in
            XCTAssertEqual(list?.count, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSection_Page2() {
        let list = [sampleArticle]
        client.articles = list

        let exp = expectation(description: "Getting list of articles for news section")

        sut.getAllArticles(section: "news", page: 2) { list, _, _ in
            XCTAssertEqual(list?.count, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListView() {

        let view = sut.getLiveView()

        XCTAssertNotNil(view)
    }

    func testGetAllSections() {

        let exp = expectation(description: "Getting all sections for publication")

        let subSections: [Section] = [Section(name: "pls", id: "news2"),
                                      Section(name: "South Africa", id: "south-africa"),
                                      Section(name: "Africa", id: "africa"),
                                      Section(name: "World", id: "world"),
                                      Section(name: "Consumer Live", id: "consumer-live") ]
        let sections = [Section(name: "News", subSections: subSections)]
        client.sections = sections

        sut.getAllSections { sections, error in
            XCTAssertEqual(sections?.count, 1)
            XCTAssertEqual(sections?.first?.subSections?.count, 5)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetSectionView() {

        let view = sut.getSectionView(renderType: .live)

        XCTAssertNotNil(view)
        XCTAssertNotNil(view.sectionsViewModel)
        XCTAssertEqual(view.sectionsViewModel.renderType, .live)
    }

    func testGetEditionList() {

        let section = Section(name: "test", id: "test.com")
        let view = sut.getEditionList(in: SectionViewModel(section: section)!)

        XCTAssertNotNil(view)
    }

    func testLogin_success() {

        let exp = expectation(description: "Logging in success")
        client.requestToken = RequestToken(token: "12345")
        client.accessToken = AccessToken(token: "1234567", expires: "18 May 2019")

        sut.login(username: "test", password: "test") { error in
            XCTAssertNil(error)
            XCTAssertTrue(self.keychain.setStringCalled)
            XCTAssertEqual(self.keychain.stringKeys.first, Keychain.Keys.accessToken.rawValue)
            XCTAssertEqual(self.keychain.setStringValues.first, "1234567")
            XCTAssertEqual(self.keychain.stringKeys[1], Keychain.Keys.accessTokenExpiry.rawValue)
            XCTAssertEqual(self.keychain.setStringValues[1], "18 May 2019")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLogin_requestTokenError() {

        let exp = expectation(description: "Log in failure with error on the requestToken call")
        client.testError = CosmosError.authenticationError

        sut.login(username: "test", password: "test") { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLogin_accessTokenError() {

        let exp = expectation(description: "Log in failure with error on the accessToken call")
        client.requestToken = RequestToken(token: "12345")
        client.testError2 = CosmosError.authenticationError

        sut.login(username: "test", password: "test") { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRegister() {
        let exp = expectation(description: "Register user")

        sut.register(username: "test") { error in
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testResetPassword() {

        let exp = expectation(description: "Reset password for user")

        sut.resetPassword(username: "test") { error in
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetPastEditions() {

        client.pastEditions = [PastEdition(key: 1234, title: "test", articleCount: 10, published: 1529463600000, image: nil, modified: 1),
                               PastEdition(key: 1234, title: "test2", articleCount: 10, published: 1526463600000, image: nil, modified: 1)]
        let exp = expectation(description: "Get past editions data")

        sut.getPastEditions(section: "editions", includeLatest: true, limit: 10, page: 1) { editions, _, error in
            XCTAssertNil(error)
            XCTAssertNotNil(editions)
            XCTAssertEqual(editions?.count, 2)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetPastEditions_error() {

        client.testError = CosmosError.authenticationError
        let exp = expectation(description: "Get past editions data with error")

        sut.getPastEditions(section: "editions", includeLatest: true, limit: 10, page: 1) { editions, _, error in
            XCTAssertNotNil(error)
            XCTAssertNil(editions)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetEditionForDate() {

        client.edition = Edition(title: "test", widgets: nil, articles: [sampleArticle], published: 1, image: nil, key: 1234, modified: 1)
        let exp = expectation(description: "Get edition for date")
        sut = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)

        sut.getEdition(for: 1234, skipLocal: true) { edition, error in
            XCTAssertNil(error)
            XCTAssertNotNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetEditionForDate_error() {

        client.testError = CosmosError.authenticationError
        let exp = expectation(description: "Get edition for date")

        sut.getEdition(for: 1234, skipLocal: true) { edition, error in
            XCTAssertNotNil(error)
            XCTAssertNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetEditionView() {

        let view = sut.getEditionView(for: 1234)

        XCTAssertNotNil(view)
        XCTAssertTrue(client.getEditionForKeyCalled)
    }

    func testGetLatestEditionView() {

        let view = sut.getLatestEditionView(apiSection: "editions")

        XCTAssertNotNil(view)
        XCTAssertTrue(client.getLatestEditionCalled)
    }

    func testGetPastEditionsView_default() {

        let view = sut.getPastEditionsView()

        XCTAssertEqual(view.viewModel.apiSection, "editions")
        XCTAssertNotNil(view)
    }

    func testGetPastEditionsView_specified() {

        let view = sut.getPastEditionsView(section: "uitgawes")

        XCTAssertEqual(view.viewModel.apiSection, "uitgawes")
        XCTAssertNotNil(view)
    }

    func testGetResults() {

        client.searchResults = [Article(title: "first",
                                        sectionTitle: "section title",
                                        title2: nil,
                                        title3: nil,
                                        section: Section(name: "Section", id: "section"),
                                        subSection: nil,
                                        adSections: nil,
                                        published: 1,
                                        modified: 2,
                                        publication: ArticlePublication(identifier: "times-live"),
                                        authors: [],
                                        author: nil,
                                        intro: "",
                                        synopsis: "",
                                        headerImage: nil,
                                        widgets: [],
                                        images: [],
                                        key: 1,
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
                                        marketData: nil),
                                Article(title: "second",
                                        sectionTitle: "section title",
                                        title2: nil,
                                        title3: nil,
                                        section: Section(name: "Section", id: "section"),
                                        subSection: nil,
                                        adSections: nil,
                                        published: 1,
                                        modified: 2,
                                        publication: ArticlePublication(identifier: "times-live"),
                                        authors: [],
                                        author: nil,
                                        intro: "",
                                        synopsis: "",
                                        headerImage: nil,
                                        widgets: [],
                                        images: [],
                                        key: 2,
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
        ]
        let exp = expectation(description: "Get edition for date")

        sut.getResults(for: "zuma") { list, _, error in
            XCTAssertNil(error)
            XCTAssertEqual(list?.count, 2)
            exp .fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetEditionView_ForSearchResults() {

        let view = sut.getEditionView(for: "zuma")

        XCTAssertNotNil(view)
    }

    func testGetArticleListView_ForSearchResults() {

        let view = sut.getArticleListView(for: "zuma")

        XCTAssertNotNil(view)
    }

    func testGetView_ForBookmarks() {

        let view = sut.getEditionBookmarksView()

        XCTAssertNotNil(view)
    }

    func testGetVideoView() {

        let view = sut.getVideoView(translatedTitle: "test")

        XCTAssertNotNil(view)
    }

    func testGetAudioView() {

        let view = sut.getAudioView(translatedTitle: "test")

        XCTAssertNotNil(view)
    }

    func testGetArticleList_section() {

        let view = sut.getArticleList(section: SectionViewModel(name: "test"))

        XCTAssertNotNil(view)
    }

    func testGetArticleList_subsection() {

        let view = sut.getArticleList(subSection: SectionViewModel(name: "test"))

        XCTAssertNotNil(view)
    }

    func testGetView_ForBookmarksList() {

        let view = sut.getArticleListBookmarksView()

        XCTAssertNotNil(view)
    }

    func testBookmarkArticle() {

        XCTAssertTrue(sut.bookmark(sampleArticle))

        XCTAssertTrue(client.storeArticleCalled)
    }

    func testRemoveBookmark() {

        XCTAssertTrue(sut.removeBookmark(key: 0))

        XCTAssertTrue(client.removeBookmarkCalled)
    }

    func testGetBookmarks_callClient() {

        _ = sut.getBookmarks()

        XCTAssertTrue(client.getBookmarksCalled)
    }

    func testGetOfflinePastEditions_callClient() {

        _ = sut.getOfflinePastEditions()

        XCTAssertTrue(client.getOfflinePastEditionsCalled)
    }

    func testGetComments_callClient() {

        let exp = expectation(description: "Get comments calls client")

        sut.getComments(for: "zuma", slug: "zuma-slug") { _, error in
            XCTAssertTrue(self.client.getCommentsCalled)
            XCTAssertNil(error)
            exp .fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetVideos_callClient() {

        let exp = expectation(description: "Get comments calls client")

        sut.getMedia(audio: false) { _, _, error in
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getVideosCalled)
            exp .fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAudio_callClient() {

        let exp = expectation(description: "Get comments calls client")

        sut.getMedia(audio: true) { _, _, error in
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getAudioContentCalled)
            exp .fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetDisqusAuth_callsKeychain() {

        let exp = expectation(description: "Secret for Disqus")

        sut.getDisqusAuth { secret in
            XCTAssertEqual(secret, "secret")
            XCTAssertTrue(self.client.getDisqusAuthCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetInstagramEmbed_callClient() {
        let exp = expectation(description: "html for Instagram post")

        sut.getInstagramPost(WebViewModel(html: "Hello", url: "www.instagram.com/p/Br3FKiDAqCs/", type: .instagram), appID: "12345", clientID: "123467", width: 375) { html, error in
            XCTAssertEqual("success", html)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getEmbedableInstagramPostCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetTeasers_callClient() {

        let exp = expectation(description: "teasers for vwb home page")

        sut.getTeasers(section: "home") { teasers, error in
            XCTAssertNotNil(teasers)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getTeasersCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetWidgetStackViewController() {

        let widgets = [WebViewModel(url: URL(string: "www.google.com")!, type: .url), WebViewModel(url: URL(string: "www.google.de")!, type: .url)]

        let view = sut.getWidgetStackViewController(viewModel: WidgetStackViewModel(widgets: widgets, renderType: .live, fallback: TestFallback().fallback, event: CosmosEvents.authors, forceLightMode: false))

        XCTAssertNotNil(view)
    }

    func testGetAuthorsArticlesView() {

        let vm = AuthorViewModel(authors: ["test","yest2","yest3"])

        let view = sut.getAuthorsArticlesView(author: vm)

        XCTAssertNotNil(view)
    }

    func testGetAuthorsListView() {

        let view = sut.getAuthorsListView()

        XCTAssertNotNil(view)
    }

    func testGetAuthors_callsClient() {

        let exp = expectation(description: "testGetAuthors_callsClient")
        self.client.authors = [Author(name: "meh", title: "y", image: Image())]

        sut.getAuthors { authors, next, error in
            XCTAssertNotNil(authors)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getAuthorsCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAuthorsArticles_callClient() {

        let exp = expectation(description: "testGetAuthorsArticles_callClient")

        sut.getAuthorsArticles(key: 1234) { response, next, error in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getAuthorArticlesCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetBibliodamUrl_callClient() {

        let exp = expectation(description: "testGetBibliodamUrl_callClient")

        sut.getBibliodamUrl(url: "test") { response, error in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getBibliodamUrlCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetSettings() {

        let view = sut.getSettingsView()

        XCTAssertNotNil(view)
    }

    func testGetAuthorizationView() {

        let view = sut.getAuthorisationView()

        XCTAssertNotNil(view)
    }

    func testGetSingleArticleView() {

        let view = sut.getSingleArticleView(for: ArticleViewModel(from: sampleArticle, as: .live))

        XCTAssertNotNil(view)
    }

    func testGetAllArticlesSubsection_callsClient() {

        let exp = expectation(description: "testGetAllArticlesSubsection_callsClient")

        sut.getAllArticles(section: "test", subSection: "test", publication: "tester", page: 1) { articles, next, error in
            XCTAssertNotNil(articles)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getAllArticlesForSubSectionCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticle_callsClient() {

        let article = Article(title: "test",
                              sectionTitle: "section title",
                              title2: "",
                              title3: "",
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
                              intro: "",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "",
                                                 title: "",
                                                 description: "",
                                                 author: "author",
                                                 height: 100,
                                                 width: 200,
                                                 blur: nil),
                              widgets: [],
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
        client.article = article
        let exp = expectation(description: "testGetAllArticlesSubsection_callsClient")

        sut.getArticle(key: 12345) { article, error in
            XCTAssertNotNil(article)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getArticleCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRemovePersistedEditions_callsClient() {

        sut.removePersistedEditions()

        XCTAssertTrue(self.client.cleanPastEditionsCalled)
    }

    func testArticleView_key() {

        let view = sut.getView(for: 1345, as: .live, relatedSelected: relatedCallback)

        XCTAssertNotNil(view)
    }

    func testArticleView_slug() {

        let view = sut.getView(for: "slug", as: .live, relatedSelected: relatedCallback)

        XCTAssertNotNil(view)
    }

    func testGetLatestMinimalEdition() {

        let exp = expectation(description: "testGetLatestMinimalEdition")

        sut.getLatestMinimalEdition(section: "test") { edition, error in
            XCTAssertNotNil(edition)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getLatestMinimalEditionCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }


    func testIsEditionPersisted() {

        XCTAssertTrue(sut.isEditionPersisted(key: 1234))

        XCTAssertTrue(self.client.isEditionPersistedCalled)
    }

    func testGetLastUpdated() {

        let exp = expectation(description: "testGetLastUpdated")

        sut.getLastUpdated(for: 1234) { date, error in
            XCTAssertNotNil(date)
            XCTAssertNil(error)
            XCTAssertTrue(self.client.getLastUpdatedDateCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLogout() {

        Keychain.setUser(CosmosUser(firstname: "test", lastname: "tester", email: "test@test.com", guid: "test"))

        XCTAssertNotNil(sut.user)

        sut.logout()


        XCTAssertTrue(keychain.removeCalled)
        for key in Keychain.Keys.allCases {
            XCTAssertTrue(keychain.removeKeys.contains(key.rawValue))
        }
        XCTAssertEqual(HTTPCookieStorage.shared.cookies?.count, 0)
    }

    func testGetLastStoredEdition_none() {

        XCTAssertNil(sut.getLastStoredEdition())
    }

    func testGetLastStoredEdition() {

        testdefaults.lastStoredEditionKey = 1234
        client.edition = Edition(title: "test", widgets: nil, articles: [sampleArticle], published: 1, image: nil, key: 1234, modified: 1)

        XCTAssertNotNil(sut.getLastStoredEdition())
        
        XCTAssertTrue(client.getLocalEditionCalled)
    }

    func relatedCallback(key: Int64) {
        print("test related callback")
    }

    func testGetNewsletters() {

        if FeatureFlag.newWelcomeFlow.isEnabled {
            XCTFail("implement")
        }
    }

    func testIsLoggedIn_nothingset() {

        XCTAssertFalse(sut.isLoggedIn)
    }

    func testIsLoggedIn_onlyuser() {

        Keychain.setUser(CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: "testguid"))

        XCTAssertFalse(sut.isLoggedIn)
    }

    func testIsLoggedIn_onlytoken() {

        Keychain.setAccessToken(AccessToken(token: "meh", expires: "1234567890"))

        XCTAssertFalse(sut.isLoggedIn)
    }

    func testIsLoggedIn_true() {

        Keychain.setUser(CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: "testguid"))
        Keychain.setAccessToken(AccessToken(token: "meh", expires: "1234567890"))

        XCTAssertTrue(sut.isLoggedIn)
    }

    func testUserGUIDMigration() {

        Keychain.setAccessToken(AccessToken(token: "meh", expires: "1234567890"))
        Keychain.setUser(CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: nil))
        client.user = CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: "testguid")

        XCTAssertNil(sut.user!.guid)
        XCTAssertTrue(client.getUserInfoCalled)
        XCTAssertTrue(keychain.setStringCalled)
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.guid.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userFirstName.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userLastName.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userEmail.rawValue))
        XCTAssertTrue(keychain.setStringValues.contains("test name"))
        XCTAssertTrue(keychain.setStringValues.contains("test surname"))
        XCTAssertTrue(keychain.setStringValues.contains("test@test.com"))
        XCTAssertTrue(keychain.setStringValues.contains("testguid"))
    }

    func testUserGUIDMigration_notcalled() {

        Keychain.setAccessToken(AccessToken(token: "meh", expires: "1234567890"))
        Keychain.setUser(CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: "testguid"))

        XCTAssertNotNil(sut.user!.guid)
        XCTAssertFalse(client.getUserInfoCalled)
    }

    func testRunGUIDMigration_allowed() {

        Keychain.setAccessToken(AccessToken(token: "meh", expires: "1234567890"))
        Keychain.setUser(CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: nil))
        client.user = CosmosUser(firstname: "test name", lastname: "test surname", email: "test@test.com", guid: "testguid")
        testdefaults.testhasRunGUIDMigration = false

        sut.runGUIDMigration()

        XCTAssertTrue(testdefaults.hasRunGUIDMigrationCalled)
        XCTAssertNotNil(sut.user!.guid)
        XCTAssertTrue(client.getUserInfoCalled)
        XCTAssertTrue(keychain.setStringCalled)
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.guid.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userFirstName.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userLastName.rawValue))
        XCTAssertTrue(keychain.stringKeys.contains(Keychain.Keys.userEmail.rawValue))
        XCTAssertTrue(keychain.setStringValues.contains("test name"))
        XCTAssertTrue(keychain.setStringValues.contains("test surname"))
        XCTAssertTrue(keychain.setStringValues.contains("test@test.com"))
        XCTAssertTrue(keychain.setStringValues.contains("testguid"))
        XCTAssertTrue(testdefaults.markGUIDMigrationAsDoneCalled)
    }

    func testRunGUIDMigration_notallowed() {

        testdefaults.testhasRunGUIDMigration = true

        sut.runGUIDMigration()

        XCTAssertTrue(testdefaults.hasRunGUIDMigrationCalled)
        XCTAssertFalse(client.getUserInfoCalled)
        XCTAssertFalse(testdefaults.markGUIDMigrationAsDoneCalled)
    }
}
