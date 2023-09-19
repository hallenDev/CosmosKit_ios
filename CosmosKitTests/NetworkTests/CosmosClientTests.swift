//swiftlint:disable line_length
import XCTest
@testable import CosmosKit
import SwiftKeychainWrapper

class CosmosClientTests: XCTestCase {

    let article = Article(title: "title",
                          sectionTitle: "section title",
                          title2: "title2",
                          title3: "title3",
                          section: Section(name: "section", id: "section"),
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
                          key: 123,
                          slug: "slug",
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

    var sut: CosmosClient!
    let testSession = TestableURLSession()
    let task = TestableTask()
    let storage = TestableStorage()
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!
    var testKeyChain = TestableKeyChainWrapper()

    override func tearDown() {
        super.tearDown()
        Keychain.keychain = KeychainWrapper.standard
    }

    override func setUp() {
        super.setUp()
        Keychain.keychain = testKeyChain
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(liveDomain: "cosmos-stage-qa.appspot.com", id: "times-select", fallbackConfig: fallbackConfig)
        
        config = CosmosConfig(publication: publication,
                              session: testSession)
        sut = CosmosClient(apiConfig: config, localStorage: storage)
    }

    func testArticleEndpoint_UsingSlug() {

        let exp = expectation(description: "Getting article")
        task.testData = readJSONData("Article")
        testSession.testTasks = [task]

        sut.getArticle(slug: "2018-04-23-article-for-app-testing-widgets") { article, error in
            XCTAssertEqual(article?.title, "Article for app testing widgets...")
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testArticleEndpoint_UsingSlug_fail() {

        let exp = expectation(description: "testArticleEndpoint_UsingSlug_fail")
        task.testError = CosmosError.noResponse
        testSession.testTasks = [task]

        sut.getArticle(slug: "2018-04-23-article-for-app-testing-widgets") { article, _ in
            XCTAssertNil(article)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testArticleEndpoint_UsingKey() {

        let exp = expectation(description: "Getting article")
        task.testData = readJSONData("Article")
        testSession.testTasks = [task]

        sut.getArticle(key: 5688160465977344, skipLocal: false) { article, _ in
            XCTAssertEqual(article?.title, "Article for app testing widgets...")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleList() {

        let exp = expectation(description: "Get article list")
        task.testData = readJSONData("ArticleList")
        testSession.testTasks = [task]

        sut.getAllArticles(page: 1) { list, _, _ in
            XCTAssertEqual(list?.count, 24)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleList_fail() {

        let exp = expectation(description: "testGetArticleList_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getAllArticles(page: 1) { list, _, _ in
            XCTAssertNil(list)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSection() {

        let exp = expectation(description: "Get article list for section")
        task.testData = readJSONData("SectionArticleList")
        testSession.testTasks = [task]

        sut.getAllArticles(section: "news", publication: "times-select") { list, _, _ in
            XCTAssertEqual(list?.count, 25)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSection_fail() {

        let exp = expectation(description: "testGetArticleListForSection_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getAllArticles(section: "news", publication: "times-select") { list, _, _ in
            XCTAssertNil(list)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSection_UsesPage() {

        let exp = expectation(description: "Get article list for section")
        task.testData = readJSONData("SectionArticleList")
        testSession.testTasks = [task]

        sut.getAllArticles(section: "news", publication: "times-select", page: 3) { list, _, _ in
            XCTAssertEqual(list?.count, 25)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetCurrentEdition() {

        let exp = expectation(description: "Get current edition")
        task.testData = readJSONData("Edition")
        testSession.testTasks = [task]

        sut.getEdition(key: 5872305980833792, skipLocal: false) { edition, error in
            XCTAssertEqual(edition?.title, "Monday, July 16 2018")
            XCTAssertEqual(edition?.widgets?.count, 22)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetCurrentEdition_fails() {

        let exp = expectation(description: "Get current edition")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getEdition(key: 5872305980833792, skipLocal: true) { edition, error in
            XCTAssertNil(edition?.title, "Monday, July 16 2018")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetPastEditions() {

        let exp = expectation(description: "Get past editions")
        task.testData = readJSONData("PastEditionsList")
        testSession.testTasks = [task]

        sut.getPastEditions(section: "editions", includeLatest: true, limit: 10, page: 1) { editions, _, error in
            XCTAssertNotNil(editions)
            XCTAssertEqual(editions?.count, 10)
            XCTAssertEqual(editions?.first?.articleCount, 31)
            XCTAssertEqual(editions?.first?.title, "Friday, July 27 2018")
            XCTAssertEqual(editions?.first?.published, 1532660400000)
            XCTAssertEqual(editions?.first?.publishDate, Date(timeIntervalSince1970: TimeInterval(1532660401)))
            XCTAssertNotNil(editions?.first?.image)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRegister() {
        let exp = expectation(description: "Register user")
        task.testData = readJSONData("Success")
        testSession.testTasks = [task]

        sut.register(username: "piet@pompies.com") { error in
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testResetPassword() {
        let exp = expectation(description: "Reset password user")
        task.testData = readJSONData("Success")
        testSession.testTasks = [task]

        sut.resetPassword(username: "piet@pompies.com") { error in
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetSections() {

        let exp = expectation(description: "Get sections")
        task.testData = readJSONData("Sections")
        testSession.testTasks = [task]

        sut.getSections { sections, error in
            XCTAssertNil(error)
            XCTAssertNotNil(sections)
            XCTAssertEqual(sections?.count, 13)
            XCTAssertEqual(sections?.first?.subSections?.count, 6)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetSections_fails() {

        let exp = expectation(description: "testGetSections_fails")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getSections { sections, error in
            XCTAssertNil(sections)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetRequestToken() {

        let exp = expectation(description: "testGetRequestToken")
        task.testData = readJSONData("requestToken")
        testSession.testTasks = [task]

        sut.getRequestToken { token, error in
            XCTAssertNotNil(token)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetRequestToken_fails() {

        let exp = expectation(description: "testGetRequestToken_fails")

        sut.getRequestToken { token, error in
            XCTAssertNil(token)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAccessToken() {

        let exp = expectation(description: "testGetAccessToken")
        task.testData = readJSONData("accessToken")
        testSession.testTasks = [task]

        sut.getAccessToken(username: "test", password: "test", token: "test") { token, error in
            XCTAssertNotNil(token)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAccessToken_fails() {

        let exp = expectation(description: "testGetAccessToken")

        sut.getAccessToken(username: "test", password: "test", token: "test") { token, error in
            XCTAssertNil(token)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetUserInfo() {

        let exp = expectation(description: "Get user info")
        task.testData = readJSONData("User")
        testSession.testTasks = [task]
        let token = AccessToken(token: "1234", expires: "Jun 10, 2028")

        sut.getUserInfo(accessToken: token) { user, _ in
            XCTAssertEqual(user?.firstname, "Flat")
            XCTAssertEqual(user?.lastname, "Circle")
            XCTAssertEqual(user?.email, "flatcircle@guerrillamail.info")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetUserInfo_fails() {

        let exp = expectation(description: "testGetUserInfo_fails")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]
        let token = AccessToken(token: "1234", expires: "Jun 10, 2028")

        sut.getUserInfo(accessToken: token) { user, _ in
            XCTAssertNil(user)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetResults() {

        let exp = expectation(description: "Get search results")
        task.testData = readJSONData("SearchResults")
        testSession.testTasks = [task]

        sut.getResults(for: "zuma") { list, _, error in
            XCTAssertNil(error)
            XCTAssertNotNil(list)
            XCTAssertEqual(list?.count, 2)
            XCTAssertEqual(list?.first?.title, "No, Zuma was not worse than Verwoerd. But you have the right to say so")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetResults_fails() {

        let exp = expectation(description: "testGetResults_fails")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getResults(for: "zuma") { list, _, error in
            XCTAssertNil(list)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetEdition_SavesToStorage() {

        let exp = expectation(description: "Get current edition saves to storage")
        task.testData = readJSONData("Edition")
        testSession.testTasks = [task]

        sut.getEdition(key: 5149503652888576, skipLocal: false) { edition, error in
            XCTAssertNotNil(edition)
            XCTAssertTrue(self.storage.persistEditionCalled)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testIsEditionPersisted() {

        _ = sut.isEditionPersisted(for: 1234)

        XCTAssertTrue(storage.isPersistedCalled)
    }

    func testGetEdition_LoadsFromStorage() {

        storage.testEdition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1)
        let exp = expectation(description: "Get persisted edition")
        task.testData = nil

        sut.getEdition(key: 1234, skipLocal: false) { edition, error in
            XCTAssertNil(error)
            XCTAssertEqual(edition?.title, "1")
            XCTAssertTrue(self.storage.getEditionCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticle_LoadsFromStorage() {

        storage.testArticle = article
        let exp = expectation(description: "Get persisted article")
        task.testData = nil

        sut.getArticle(key: 123, skipLocal: false) { article, error in
            XCTAssertNil(error)
            XCTAssertNotNil(article)
            XCTAssertEqual(article?.title, "title")
            XCTAssertTrue(self.storage.getArticleCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticle_forced_LoadsFromAPI() {

        let exp = expectation(description: "Don't get persisted article")
        task.testData = nil

        sut.getArticle(key: 123, skipLocal: true) { _, _ in
            XCTAssertFalse(self.storage.getArticleCalled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticle_forced_LoadsFromAPI_fail() {

        let exp = expectation(description: "testGetArticle_forced_LoadsFromAPI_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getArticle(key: 123, skipLocal: true) { edition, error in
            XCTAssertNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRemovePersistedEditions() {

        CosmosDefaults().setLastStoredEditionKey(1234)
        XCTAssertNotNil(CosmosDefaults().getLastStoredEditionKey())

        sut.removePersistedEditions(excluding: [])

        XCTAssertTrue(storage.removePersistedEditionsCalled)
        XCTAssertNil(CosmosDefaults().getLastStoredEditionKey())
    }

    func testStoreEdition_callsStorage() {

        let edition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1)

        XCTAssertTrue(sut.store(edition))
        XCTAssertTrue(storage.persistEditionCalled)
    }

    func testStoreArticle_callsStorage() {

        XCTAssertTrue(sut.store(article))
        XCTAssertTrue(storage.persistArticleCalled)
    }

    func testRemoveBookmark_callsStorage() {

        XCTAssertTrue(sut.removeBookmark(key: 123))
        XCTAssertTrue(storage.removeArticleCalled)
    }

    func testGetBookmarks() {

        storage.testBookmarks = [123]
        storage.testArticle = article

        XCTAssertEqual(sut.getBookmarks().count, 1)
        XCTAssertEqual(sut.getBookmarks().first?.key, 123)
        XCTAssertTrue(storage.getBookmarksCalled)
    }

    func testGetOfflinePastEditions_callsStorage() {

        _ = sut.getOfflinePastEditions()

        XCTAssertTrue(storage.getPersistedEditionsCalled)
    }

    func testGetArticleListForSubSection() {

        let exp = expectation(description: "Get article list for sub section")
        task.testData = readJSONData("GetSubSection")
        testSession.testTasks = [task]

        sut.getAllArticles(section: "sport", subSection: "soccer", publication: "times-select", page: 1) { list, _, _ in
            XCTAssertEqual(list?.count, 25)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetArticleListForSubSection_fail() {

        let exp = expectation(description: "testGetArticleListForSubSection_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getAllArticles(section: "sport", subSection: "soccer", publication: "times-select", page: 1) { list, _, _ in
            XCTAssertNil(list)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLastUpdatedDate() {

        let exp = expectation(description: "testGetLastUpdatedDate")
        task.testData = readJSONData("lastupdated")
        testSession.testTasks = [task]

        sut.getLastUpdatedDate(for: 1234) { date, error in
            XCTAssertNotNil(date)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLastUpdatedDate_fail() {

        let exp = expectation(description: "testGetLastUpdatedDate_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getLastUpdatedDate(for: 1234) { date, error in
            XCTAssertNil(date)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLatestMinimalEdition() {

        let exp = expectation(description: "testGetLatestMinimalEdition")
        task.testData = readJSONData("GetSubSection")
        testSession.testTasks = [task]

        sut.getLatestMinimalEdition(section: "test") { edition, error in
            XCTAssertNotNil(edition)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLatestMinimalEdition_fail() {

        let exp = expectation(description: "testGetLatestMinimalEdition_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getLatestMinimalEdition(section: "test") { edition, error in
            XCTAssertNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLatestEdition() {

        let exp = expectation(description: "testGetLatestEdition")
        task.testData = readJSONData("Edition2")
        testSession.testTasks = [task]

        sut.getLatestEdition(section: "test") { edition, error in
            XCTAssertNotNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetLatestEdition_fail() {

        let exp = expectation(description: "testGetLatestEdition_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getLatestEdition(section: "test"){ edition, error in
            XCTAssertNil(edition)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetThreadComments() {

        let exp = expectation(description: "Getting comment count for thread")
        task.testData = readJSONData("DisqusThreadResponse")
        testSession.testTasks = [task]

        sut?.getComments(for: "test", slug: "test-slug") { comments, error in
            XCTAssertEqual(comments, 6)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetThreadComments_fails() {

        let exp = expectation(description: "testGetThreadComments_fails")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut?.getComments(for: "test", slug: "test-slug") { comments, error in
            XCTAssertNil(comments)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetVideoContent() {

        let exp = expectation(description: "Getting videos")
        task.testData = readJSONData("VideoResponse")
        testSession.testTasks = [task]

        sut.getVideoContent(page: 1) { videos, _, error in
            XCTAssertEqual(videos?.count, 25)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetVideoContent_fail() {

        let exp = expectation(description: "testGetVideoContent_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getVideoContent(page: 1) { videos, _, error in
            XCTAssertNil(videos)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAudioContent() {

        let exp = expectation(description: "testGetAudioContent")
        task.testData = readJSONData("audios")
        testSession.testTasks = [task]

        sut.getAudioContent(page: 1) { audio, _, error in
            XCTAssertEqual(audio?.count, 25)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAudioContent_fail() {

        let exp = expectation(description: "testGetAudioContent_fail")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        sut.getAudioContent(page: 1) { audio, _, error in
            XCTAssertNil(audio)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetDisqusAuth_valid_token() {

        let exp = expectation(description: "Getting disqus secret")
        task.testData = readJSONData("DisqusAuthResponse")
        testSession.testTasks = [task]
        Keychain.setAccessToken(AccessToken(token: "test", expires: "123456"))

        sut.getDisqusAuth { secret, error in
            XCTAssertEqual(secret, "eyJ1c2VybmFtZSI6ICJBbmRyZWFzIHZvbiBIb2x5IiwgImlkIjogImFuZHJlYXNAZmxhdGNpcmNsZS5pbyIsICJlbWFpbCI6ICJhbmRyZWFzQGZsYXRjaXJjbGUuaW8ifQ== beb51a94121c1491af833ee4415140277c586b0b 1537969119")
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetDisqusAuth_no_token() {

        let exp = expectation(description: "Getting disqus secret no token")

        sut.getDisqusAuth { secret, error in
            XCTAssertNil(secret)
            XCTAssertNotNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetDisqusAuth_fails() {

        let exp = expectation(description: "testGetDisqusAuth_fails")
        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]
        Keychain.setAccessToken(AccessToken(token: "test", expires: "123456"))

        sut.getDisqusAuth { secret, error in
            XCTAssertNil(secret)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetInstagramEmbedHTML() {

        task.testData = readJSONData("InstagramEmbed")
        testSession.testTasks = [task]

        let exp = expectation(description: "Get instagram embeddable html")

        sut.getEmbedableInstagramPost(postURL: "www.instagram.com/p/Br3FKiDAqCs/", appID: "1234", clientID: "123456", width: 375) { html, error in
            XCTAssertNotNil(html)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetInstagramEmbedHTML_fail() {

        task.testData = readJSONData("InstagramEmbed")
        task.testError = CosmosError.invalidURL

        let exp = expectation(description: "testGetInstagramEmbedHTML_fail")

        sut.getEmbedableInstagramPost(postURL: "www.instagram.com/p/Br3FKiDAqCs/", appID: "1234", clientID: "123456", width: 375) { html, error in
            XCTAssertNil(html)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAuthorArticles() {

        task.testData = readJSONData("authorarticles")
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetAuthorArticles")

        sut.getAuthorArticles(key: 1234, page: 1) { articles, end, error in
            XCTAssertNotNil(articles)
            XCTAssertFalse(end)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAuthorArticles_fail() {

        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetAuthorArticles_fail")

        sut.getAuthorArticles(key: 1234, page: 1) { articles, end, error in
            XCTAssertNil(articles)
            XCTAssertTrue(end)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAuthors() {

        task.testData = readJSONData("authors")
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetAuthors")

        sut.getAuthors(page: 1) { authors, end, error in
            XCTAssertNotNil(authors)
            XCTAssertFalse(end)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetAuthors_fail() {

        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetAuthors_fail")

        sut.getAuthors(page: 1) { authors, end, error in
            XCTAssertNil(authors)
            XCTAssertTrue(end)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetTeasers() {

        task.testData = readJSONData("HomePage")
        testSession.testTasks = [task]

        let exp = expectation(description: "Get teasers")

        sut.getTeasers(section: "home") { teasers, error in
            XCTAssertNotNil(teasers)
            XCTAssertEqual(teasers?.count, 6)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetTeasers_fail() {

        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        let exp = expectation(description: "testGetTeasers_fail")

        sut.getTeasers(section: "home") { teasers, error in
            XCTAssertNil(teasers)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
    
    func testGetBibliodamUrl(){
        
        task.testData = "https://tisojw-cdn.baobabsuite.com/98xLK6WJ.m3u8".data(using: .utf8)
        testSession.testTasks = [task]
        
        let exp = expectation(description: "Get instagram embeddable html")
        
        sut.getBibliodamUrl(url: "https://tisojw-cdn.baobabsuite.com/98xLK6WJ.mp4") { url, error in
            XCTAssertEqual(url, "https://tisojw-cdn.baobabsuite.com/98xLK6WJ.m3u8")
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetBibliodamUrl_fail(){

        task.testError = CosmosError.invalidURL
        testSession.testTasks = [task]

        let exp = expectation(description: "testGetBibliodamUrl_fail")

        sut.getBibliodamUrl(url: "https://tisojw-cdn.baobabsuite.com/98xLK6WJ.mp4") { url, error in
            XCTAssertNil(url)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testFiltering() {

        let pubs = [FilteredPublication(id: "bl"), FilteredPublication(id: "ft")]

        config = CosmosConfig(publication: publication,
                              filteredPublications: pubs,
                              session: testSession)
        sut = CosmosClient(apiConfig: config, localStorage: storage)

        let exp = expectation(description: "Get filtering is applied")
        task.testData = readJSONData("FilterResults")
        testSession.testTasks = [task]

        sut.getResults(for: "zuma") { list, done, error in
            guard let unwrapped = list else {
                XCTFail("List should not be nil")
                return
            }
            XCTAssertNil(error)
            XCTAssertFalse(done)
            XCTAssertFalse(unwrapped.contains { $0.key == 6709211360657408 })
            XCTAssertFalse(unwrapped.contains { $0.key == 5482726879657984 })
            XCTAssertFalse(unwrapped.contains { $0.key == 5610615134486528 })
            XCTAssertFalse(unwrapped.contains { $0.key == 5029129477947392 })
            XCTAssertFalse(unwrapped.contains { $0.key == 4758172741926912 })
            XCTAssertEqual(unwrapped.count, 15) //5 should have been filtered (2 hide in app, 2 ft, 1 bl)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetNewsletters() {

        guard FeatureFlag.newWelcomeFlow.isEnabled else { return }
        
        task.testData = readJSONData("newsletters")
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetNewsletters")
        let token = AccessToken(token: "meh", expires: "123456789")

        sut.getNewsletters(accessToken: token) { result, error in
            XCTAssertTrue(result?.count ?? 0 > 0)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetNewsletters_fail() {

        guard FeatureFlag.newWelcomeFlow.isEnabled else { return }

        task.testError = CosmosError.invalidURL
        task.testResponse = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 600, httpVersion: nil, headerFields: nil)!
        testSession.testTasks = [task]
        let exp = expectation(description: "testGetNewsletters_fail")
        let token = AccessToken(token: "meh", expires: "123456789")

        sut.getNewsletters(accessToken: token) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testUpdateUser() {

        task.testData = readJSONData("UpdateUserResponse")
        testSession.testTasks = [task]
        let exp = expectation(description: "testUpdateUser")
        let token = AccessToken(token: "meh", expires: "123456789")
        let data = UserUpdateRequest(firstName: "test", lastName: "test", newsletters: ["1"], email: "test@test", telNumber: "1234567")

        sut.updateUser(accessToken: token, data: data) { result in
            XCTAssertTrue(result)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testUpdateUser_fail() {

        task.testError = CosmosError.invalidURL
        task.testResponse = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 600, httpVersion: nil, headerFields: nil)!
        testSession.testTasks = [task]
        let exp = expectation(description: "testUpdateUser_fail")
        let token = AccessToken(token: "meh", expires: "123456789")
        let data = UserUpdateRequest(firstName: "test", lastName: "test", newsletters: ["1"], email: "test@test", telNumber: "1234567")

        sut.updateUser(accessToken: token, data: data) { result in
            XCTAssertFalse(result)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testUpdateUserProfile() {
        guard FeatureFlag.newWelcomeFlow.isEnabled else { return }

        testSession.testTasks = [task]
        let exp = expectation(description: "testUpdateUserProfile")
        let token = AccessToken(token: "meh", expires: "123456789")
        let data = UserProfileUpdateRequest(firstName: "test", lastName: "tester", password: "testing")

        sut.updateUserProfile(accessToken: token, data: data) { result in
            XCTFail("Still need to parse a proper response")
            XCTAssertTrue(result)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testUpdateUserProfile_fail() {

        task.testError = CosmosError.invalidURL
        task.testResponse = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 600, httpVersion: nil, headerFields: nil)!
        testSession.testTasks = [task]
        let exp = expectation(description: "testUpdateUserProfile_fail")
        let token = AccessToken(token: "meh", expires: "123456789")
        let data = UserProfileUpdateRequest(firstName: "test", lastName: "tester", password: "testing")

        sut.updateUserProfile(accessToken: token, data: data) { result in
            XCTAssertFalse(result)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
}
