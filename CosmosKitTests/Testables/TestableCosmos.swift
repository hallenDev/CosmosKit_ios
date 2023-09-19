import Foundation
@testable import CosmosKit

class TestableCosmos: Cosmos {

    var articleShareCallbackCalled = false
    var removeBookmarkCalled = false
    var bookmarkCalled = false
    var accessCalled = false
    var access = false
    var getOfflinePastEditionsCalled = false
    var getPastEditionsCalled = false
    var article: Article?
    var getArticleCalled = false
    var testIsLoggedIn = false
    var metaArticleCalled = false
    var titleTappedCalled = false
    var switchPubCalled = false
    var testUser: CosmosUser? = CosmosUser(firstname: "test",
                                           lastname: "test",
                                           email: "tester@test.com",
                                           guid: "testguid")

    override var isLoggedIn: Bool {
        return testIsLoggedIn
    }

    override var user: CosmosUser? {
        get { testUser }
        set { testUser = newValue }
    }

    init() {
        let fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        let publication = TestPublication(fallbackConfig: fallbackConfig)
        let config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        super.init(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        pushNotifications = TestableFirebasePushNotifications(defaults: TestableCosmosDefaults(location: UserDefaults.init(suiteName: "test")))
    }

    init(client: CosmosConnectable, apiConfig: CosmosConfig, narratiiveLogger: NarratiiveLogger? = nil, logger: AnalyticsLogable? = nil) {
        super.init(client: client, apiConfig: apiConfig, logger: logger, narratiiveLogger: narratiiveLogger, errorDelegate: nil, eventDelegate: nil)
    }

    override func removeBookmark(key: Int64?) -> Bool {
        removeBookmarkCalled = true
        return true
    }

    override func bookmark(_ article: Article?) -> Bool {
        bookmarkCalled = true
        return true
    }

    override func getArticle(key: Int64, skipLocal: Bool, completion: @escaping ((Article?, CosmosError?) -> Void)) {
        getArticleCalled = true
        completion(article, nil)
    }

    override func getOfflinePastEditions() -> [Edition]? {
        getOfflinePastEditionsCalled = true
        return [Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1)]
    }

    override func getPastEditions(section: String, includeLatest: Bool, limit: Int, page: Int, completion: @escaping ([PastEdition]?, Bool, CosmosError?) -> Void) {
        getPastEditionsCalled = true
        completion(nil, false, nil)
    }

    override func cosmosShareArticle(articleTitle: String?, articleUrl: URL?, sender: UIBarButtonItem?) {
        articleShareCallbackCalled = true
    }

    override func cosmosTitleSelected() {
        titleTappedCalled = true
    }

    override func cosmosMetaArticle(articleUrl: String) {
        metaArticleCalled = true
    }
}
