//swiftlint:disable line_length
@testable import CosmosKit
import XCTest

class TestableCosmosClient: CosmosConnectable {
    var errorDelegate: CosmosErrorDelegate?
    var article: Article?
    var articles: [Article]?
    var pastEditions: [PastEdition]?
    var edition: Edition?
    var config: CosmosConfig
    var sections: [Section]?
    var requestToken: RequestToken?
    var accessToken: AccessToken?
    var testError: CosmosError?
    var testError2: CosmosError?
    var authors: [Author]?
    var user: CosmosUser?
    var getAllArticlesForSectionCalled = false
    var searchResults: [Article]?
    var storeArticleCalled = false
    var storeEditionCalled = false
    var removeBookmarkCalled = false
    var getBookmarksCalled = false
    var getOfflinePastEditionsCalled = false
    var cleanPastEditionsCalled = false
    var isEditionPersistedCalled = false
    var getAllArticlesForSubSectionCalled = false
    var getAllArticlesCalled = false
    var getCommentsCalled = false
    var getVideosCalled = false
    var getResultsCalled = false
    var getDisqusAuthCalled = false
    var getEmbedableInstagramPostCalled = false
    var getTeasersCalled = false

    func getBookmarks() -> [Article] {
        getBookmarksCalled = true
        return articles ?? [Article]()
    }

    func store(_ article: Article?) -> Bool {
        storeArticleCalled = true
        return true
    }

    func store(_ edition: Edition?) -> Bool {
        storeEditionCalled = true
        return true
    }

    func removeBookmark(key: Int64?) -> Bool {
        removeBookmarkCalled = true
        return true
    }

    required init(apiConfig: CosmosConfig, localStorage: Storable? = nil, defaults: CosmosDefaults? = nil, errorDelegate: CosmosErrorDelegate? = nil) {
        self.config = apiConfig
    }

    func getArticle(slug: String, completion: @escaping (Article?, CosmosError?) -> Void) {
        completion(article, testError)
    }

    func getAllArticles(page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        getAllArticlesCalled = true
        completion(articles, true, testError)
    }

    var getArticleCalled = false
    func getArticle(key: Int64, skipLocal: Bool, completion: @escaping (Article?, CosmosError?) -> Void) {
        getArticleCalled = true
        completion(article, testError)
    }

    var getLastUpdatedDateCalled = false
    func getLastUpdatedDate(for key: Int64, completion: @escaping (Date?, CosmosError?) -> Void) {
        getLastUpdatedDateCalled = true
        completion(Date(), testError)
    }

    var getLatestEditionCalled = false
    func getLatestEdition(section: String, completion: @escaping (Edition?, CosmosError?) -> Void) {
        getLatestEditionCalled = true
        completion(edition, testError)
    }

    var getLatestMinimalEditionCalled = false
    func getLatestMinimalEdition(section: String, completion: @escaping (MinimalEdition?, CosmosError?) -> Void) {
        getLatestMinimalEditionCalled = true
        let min = MinimalEdition(key: 1234, modified: 1234)
        completion(min, testError)
    }

    var getEditionForKeyCalled = false
    func getEdition(key: Int64, skipLocal: Bool, completion: @escaping (Edition?, CosmosError?) -> Void) {
        getEditionForKeyCalled = true
        completion(edition, testError)
    }

    var getLocalEditionCalled = false
    func getLocalEdition(key: Int64) -> Edition? {
        getLocalEditionCalled = true
        return edition
    }

    func getRequestToken(completion: @escaping (RequestToken?, CosmosError?) -> Void) {
        completion(requestToken, testError)
    }

    func getAccessToken(username: String, password: String, token: String, completion: @escaping (AccessToken?, CosmosError?) -> Void) {
        completion(accessToken, testError2)
    }

    func register(username: String, completion: @escaping (CosmosError?) -> Void) {
        completion(testError)
    }

    func resetPassword(username: String, completion: @escaping (CosmosError?) -> Void) {
        completion(testError)
    }

    func getSections(completion: @escaping ([Section]?, CosmosError?) -> Void) {
        completion(sections, testError)
    }

    func getAllArticles(section: String, publication: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        getAllArticlesForSectionCalled = true
        completion(articles, true, testError)
    }

    func getAllArticles(section: String, subSection: String, publication: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        getAllArticlesForSubSectionCalled = true
        completion(articles, true, testError)
    }

    var getUserInfoCalled = false
    func getUserInfo(accessToken: AccessToken, completion: @escaping (CosmosUser?, CosmosError?) -> Void) {
        getUserInfoCalled = true
        completion(user, testError)
    }

    func getPastEditions(section: String, includeLatest: Bool, limit: Int, page: Int, completion: @escaping ([PastEdition]?, Bool, CosmosError?) -> Void) {
        completion(pastEditions, false, testError)
    }

    func getResults(for searchTerm: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        getResultsCalled = true
        completion(searchResults, true, testError)
    }

    func getOfflinePastEditions() -> [Edition]? {
        getOfflinePastEditionsCalled = true
        return nil
    }

    func removePersistedEditions(excluding keys: [Int64]) {
        cleanPastEditionsCalled = true
    }

    func isEditionPersisted(for key: Int64) -> Bool {
        isEditionPersistedCalled = true
        return true
    }

    func getComments(for shareUrl: String, slug: String, completion: @escaping (Int?, CosmosError?) -> Void) {
        getCommentsCalled = true
        completion(0, nil)
    }

    func getVideoContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void) {
        getVideosCalled = true
        completion(nil, true, nil)
    }

    func getDisqusAuth(completion: @escaping (String?, CosmosError?) -> Void) {
        getDisqusAuthCalled = true
        completion("secret", nil)
    }

    func getEmbedableInstagramPost(postURL: String, appID: String, clientID: String, width: Int, completion: @escaping (String?, CosmosError?) -> Void) {
        getEmbedableInstagramPostCalled = true
        completion("success", nil)
    }

    func getTeasers(section: String, subSection: String? = nil, completion: @escaping ([Teaser]?, CosmosError?) -> Void) {
        getTeasersCalled = true
        completion([], nil)
    }

    var getAuthorsCalled = false
    func getAuthors(page: Int, completion: @escaping ([Author]?, Bool, CosmosError?) -> Void) {
        getAuthorsCalled = true
        completion(authors, false, testError)
    }

    var getAuthorArticlesCalled = false
    func getAuthorArticles(key: Int64, page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        getAuthorArticlesCalled = true
        completion(articles, false, testError)
    }

    var getBibliodamUrlCalled = false
    func getBibliodamUrl(url: String, completion: @escaping (String?, CosmosError?) -> Void) {
        getBibliodamUrlCalled = true
        completion("teststring", testError)
    }

    var getAudioContentCalled = false
    func getAudioContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void) {
        getAudioContentCalled = true
        completion(nil, true, nil)
    }

    var updateUserCalled = false
    func updateUser(accessToken: AccessToken, data: UserUpdateRequest, completion: @escaping BooleanCallback) {
        updateUserCalled = true
        completion(true)
    }

    var updateUserProfileCalled = false
    func updateUserProfile(accessToken: AccessToken, data: UserProfileUpdateRequest, completion: @escaping BooleanCallback) {
        updateUserProfileCalled = true
        completion(true)
    }

    var getNewslettersCalled = false
    func getNewsletters(accessToken: AccessToken, completion: @escaping ([PublicationNewslettersViewModel]?, CosmosError?) -> Void) {
        getNewslettersCalled = true
        completion(nil, nil)
    }
}
