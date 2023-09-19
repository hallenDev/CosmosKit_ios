// swiftlint:disable line_length
import Foundation

public struct DecodableError: Codable {
    public let code: Int
    public let error: String
}

protocol CosmosConnectable {
    var errorDelegate: CosmosErrorDelegate? { get set }
    init(apiConfig: CosmosConfig, localStorage: Storable?, defaults: CosmosDefaults?, errorDelegate: CosmosErrorDelegate?)
    func getArticle(slug: String, completion: @escaping (Article?, CosmosError?) -> Void)
    func getArticle(key: Int64, skipLocal: Bool, completion: @escaping (Article?, CosmosError?) -> Void)
    func getAllArticles(section: String, publication: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void)
    func getAllArticles(section: String, subSection: String, publication: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void)
    func getAllArticles(page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void)

    func getLastUpdatedDate(for key: Int64, completion: @escaping (Date?, CosmosError?) -> Void)
    func getLatestEdition(section: String, completion: @escaping (Edition?, CosmosError?) -> Void)
    func getLatestMinimalEdition(section: String, completion: @escaping (MinimalEdition?, CosmosError?) -> Void)
    func getEdition(key: Int64, skipLocal: Bool, completion: @escaping (Edition?, CosmosError?) -> Void)
    func getLocalEdition(key: Int64) -> Edition?

    func getSections(completion: @escaping ([Section]?, CosmosError?) -> Void)
    func getRequestToken(completion: @escaping (RequestToken?, CosmosError?) -> Void)
    func getAccessToken(username: String, password: String, token: String, completion: @escaping (AccessToken?, CosmosError?) -> Void)
    func register(username: String, completion: @escaping (CosmosError?) -> Void)
    func resetPassword(username: String, completion: @escaping (CosmosError?) -> Void)
    func getUserInfo(accessToken: AccessToken, completion: @escaping (CosmosUser?, CosmosError?) -> Void)
    func getPastEditions(section: String, includeLatest: Bool, limit: Int, page: Int, completion: @escaping ([PastEdition]?, Bool, CosmosError?) -> Void)
    func getOfflinePastEditions() -> [Edition]?
    func getResults(for searchTerm: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void)
    func store(_ article: Article?) -> Bool
    func store(_ edition: Edition?) -> Bool
    func removeBookmark(key: Int64?) -> Bool
    func getBookmarks() -> [Article]
    func removePersistedEditions(excluding keys: [Int64])
    func isEditionPersisted(for key: Int64) -> Bool
    func getComments(for shareUrl: String, slug: String, completion: @escaping (Int?, CosmosError?) -> Void)
    func getVideoContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void)
    func getAudioContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void)
    func getDisqusAuth(completion: @escaping (String?, CosmosError?) -> Void)
    func getEmbedableInstagramPost(postURL: String, appID: String, clientID: String, width: Int, completion: @escaping (String?, CosmosError?) -> Void)
    func getTeasers(section: String, subSection: String?, completion: @escaping ([Teaser]?, CosmosError?) -> Void)

    func getAuthors(page: Int, completion: @escaping ([Author]?, Bool, CosmosError?) -> Void)
    func getAuthorArticles(key: Int64, page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void)
    func getBibliodamUrl(url: String, completion: @escaping (String?, CosmosError?) -> Void)
    func updateUser(accessToken: AccessToken, data: UserUpdateRequest, completion: @escaping BooleanCallback)
    func updateUserProfile(accessToken: AccessToken, data: UserProfileUpdateRequest, completion: @escaping BooleanCallback)
    func deleteUser(accessToken: AccessToken, data: DeleteUserRequest, completion: @escaping BooleanCallback)
    func getNewsletters(accessToken: AccessToken, completion: @escaping ([PublicationNewslettersViewModel]?, CosmosError?) -> Void)
}

struct CosmosClient: CosmosConnectable {

    private let config: CosmosConfig
    private let localStorage: Storable
    private let defaults: CosmosDefaults
    weak var errorDelegate: CosmosErrorDelegate?

    init(apiConfig: CosmosConfig, localStorage: Storable? = nil, defaults: CosmosDefaults? = nil, errorDelegate: CosmosErrorDelegate? = nil) {
        self.config = apiConfig
        self.localStorage = localStorage ?? LocalStorage()
        self.defaults = defaults ?? CosmosDefaults()
        self.errorDelegate = errorDelegate
    }

    fileprivate func decode<T: Decodable>(endpoint: Endpoint, completion: @escaping (T?, CosmosError?) -> Void) {
        endpoint.get { data, apiError in
            if let data = data {
                do {
                    let content = try JSONDecoder().decode(T.self, from: data)
                    completion(content, nil)
                } catch {
                    errorDelegate?.cosmos(raise: error, endpointUrl: endpoint.sanitizedUrl)
                    completion(nil, .parsingError(error.localizedDescription))
                }
            } else {
                completion(nil, apiError)
            }
        }
    }

    // MARK: GET

    func getBookmarks() -> [Article] {
        var articles = [Article]()
        if let articleKeys = localStorage.getBookmarks() {
            for key in articleKeys {
                if let article = localStorage.article(key: key) {
                    articles.append(article)
                }
            }
        }
        return articles
    }

    func store(_ article: Article?) -> Bool {
        localStorage.persist(article)
    }

    func store(_ edition: Edition?) -> Bool {
        localStorage.persist(edition)
    }

    func removeBookmark(key: Int64?) -> Bool {
        localStorage.removeArticle(key: key)
    }

    func getArticle(slug: String, completion: @escaping (Article?, CosmosError?) -> Void) {
        let endpoint = ArticleEndpoint(config: config, slug: slug)
        decode(endpoint: endpoint, completion: completion)
    }

    func getArticle(key: Int64, skipLocal: Bool, completion: @escaping (Article?, CosmosError?) -> Void) {
        if !skipLocal, let article = localStorage.article(key: key) {
            completion(article, nil)
        } else {
            let endpoint = ArticleEndpoint(config: config, key: key)
            decode(endpoint: endpoint, completion: completion)
        }
    }

    func getAllArticles(page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        let endpoint = AllArticlesEndpoint(config: config, page: page)
        decode(endpoint: endpoint) { (response: [Article]?, error) in
            if let list = response {
                completion(filterContent(list), list.count == 0, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getAllArticles(section: String, publication: String, page: Int? = nil, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        let endpoint = AllArticlesEndpoint(config: config, section: section, publication: publication, page: page)
        decode(endpoint: endpoint) { (response: [Article]?, error) in
            if let list = response {
                completion(filterContent(list), list.count < 10, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getAllArticles(section: String, subSection: String, publication: String, page: Int?, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        let endpoint = AllArticlesEndpoint(config: config, section: section, subSection: subSection, publication: publication, page: page)
        decode(endpoint: endpoint) { (response: [Article]?, error) in
            if let list = response {
                completion(filterContent(list), list.count < 10, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getLastUpdatedDate(for key: Int64, completion: @escaping (Date?, CosmosError?) -> Void) {
        let endpoint = LastUpdatedEndpoint(config: config, key: key)
        decode(endpoint: endpoint) { (response: LastUpdate?, error) in
            if let lastUpdated = response {
                completion(lastUpdated.date, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func getLatestMinimalEdition(section: String, completion: @escaping (MinimalEdition?, CosmosError?) -> Void) {
        let endpoint = MinimalEditionEndpoint(config: config, date: Date(), section: section)
        decode(endpoint: endpoint) { (response: [MinimalEdition]?, error) in
            if let editions = response {
                completion(editions.first, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func getLatestEdition(section: String, completion: @escaping (Edition?, CosmosError?) -> Void) {
        let endpoint = EditionEndpoint(config: config, date: Date(), section: section)
        decode(endpoint: endpoint) { (response: [Edition]?, error) in
            if let edition = response?.first {
                _ = self.store(edition)
                self.defaults.setLastStoredEditionKey(edition.key)
                completion(edition, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func getLocalEdition(key: Int64) -> Edition? {
        return localStorage.edition(key: key)
    }

    func getEdition(key: Int64, skipLocal: Bool, completion: @escaping (Edition?, CosmosError?) -> Void) {
        if !skipLocal,
            let edition = getLocalEdition(key: key) {
            completion(edition, nil)
        } else {
            let endpoint = EditionEndpoint(config: config, key: key)
            decode(endpoint: endpoint) { (response: Edition?, error) in
                if let edition = response {
                    _ = self.store(edition)
                    completion(edition, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }

    func removePersistedEditions(excluding keys: [Int64]) {
        localStorage.removePersistedEditions(excluding: keys)
        defaults.removeLastStoredEditionKey()
    }

    func getPastEditions(section: String, includeLatest: Bool, limit: Int, page: Int, completion: @escaping ([PastEdition]?, Bool, CosmosError?) -> Void) {
        let endpoint = PastEditionsEndpoint(config: config, section: section, limit: limit, page: page)
        decode(endpoint: endpoint) { (response: [PastEdition]?, error) in
            if var editions = response {
                let atEnd = editions.count < limit
                if !includeLatest {
                    editions.remove(at: 0)
                }
                completion(editions, atEnd, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getOfflinePastEditions() -> [Edition]? {
        return localStorage.getPersistedEditions()
    }

    func getSections(completion: @escaping ([Section]?, CosmosError?) -> Void) {
        let endpoint = SectionsEndpoint(config: config)
        decode(endpoint: endpoint) { (response: [[Section]]?, error) in
            if let sections = response?.first {
                completion(sections, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func getRequestToken(completion: @escaping (RequestToken?, CosmosError?) -> Void) {
        let endpoint = RequestTokenEndpoint(config: config)
        decode(endpoint: endpoint, completion: completion)
    }

    func getAccessToken(username: String, password: String, token: String, completion: @escaping (AccessToken?, CosmosError?) -> Void) {
        let endpoint = AccessTokenEndpoint(config: config, username: username, password: password, requestToken: token)
        decode(endpoint: endpoint, completion: completion)
    }

    func register(username: String, completion: @escaping (CosmosError?) -> Void) {
        RegisterUserEndpoint(config: config, username: username).get { _, error in
            completion(error)
        }
    }

    func resetPassword(username: String, completion: @escaping (CosmosError?) -> Void) {
        ResetPasswordEndpoint(config: config, username: username).get { _, error in
            completion(error)
        }
    }

    func getUserInfo(accessToken: AccessToken, completion: @escaping (CosmosUser?, CosmosError?) -> Void) {
        let endpoint = UserInfoEndpoint(config: config, accessToken: accessToken.token)
        decode(endpoint: endpoint, completion: completion)
    }

    public func getResults(for searchTerm: String, page: Int? = nil, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        let endpoint = SearchEndpoint(config: config, searchTerm: searchTerm, page: page)
        decode(endpoint: endpoint) { (response: [Article]?, error) in
            if let list = response {
                completion(filterContent(list), list.count < 10, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    public func isEditionPersisted(for key: Int64) -> Bool {
        return localStorage.isPersisted(key: key)
    }

    public func getComments(for shareUrl: String, slug: String, completion: @escaping (Int?, CosmosError?) -> Void) {
        guard let disqusConfig = config.publication.commentConfig as? DisqusConfig else {
            completion(nil, CosmosError.invalidURL )
            return
        }
        let endpoint = DisqusThreadEndpoint(config: config, disqusConfig: disqusConfig, shareUrl: shareUrl, slug: slug)
        decode(endpoint: endpoint) { (response: DisqusResponse?, error) in
            if let thread = response {
                completion(thread.response.first?.posts, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    public func getVideoContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void) {
        let endpoint = VideoContentEndpoint(config: config, page: page)
        decode(endpoint: endpoint) { (response: VideoList?, error) in
            if let videos = response {
                completion(videos.videos, videos.videos.count < 25, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    public func getAudioContent(page: Int, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void) {
        let endpoint = AudioEndpoint(config: config, page: page)
        decode(endpoint: endpoint) { (response: AudioList?, error) in
            if let audio = response {
                completion(audio.audio, audio.audio.count < 25, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    public func getDisqusAuth(completion: @escaping (String?, CosmosError?) -> Void) {
        if let token = Keychain.getAccessTokenValue() {
            let endpoint = DisqusAuthEndpoint(config: config, token: token)
            decode(endpoint: endpoint) { (response: DisqusAuth?, error) in
                if let auth = response {
                    completion(auth.token, nil)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            completion(nil, CosmosError.parsingError("No Access Token Set"))
        }
    }

    public func getEmbedableInstagramPost(postURL: String, appID: String, clientID: String, width: Int, completion: @escaping (String?, CosmosError?) -> Void) {
        let endpoint = InstagramEmbedEndpoint(config: config, appID: appID, clientID: clientID, postURL: postURL, width: width)
        decode(endpoint: endpoint) { (response: InstagramPost?, error) in
            if let response = response {
                completion(response.html, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    public func getTeasers(section: String, subSection: String? = nil, completion: @escaping ([Teaser]?, CosmosError?) -> Void) {
        let endpoint = TeaserEndpoint(config: config, section: section)
        decode(endpoint: endpoint, completion: completion)
    }

    func getAuthors(page: Int, completion: @escaping ([Author]?, Bool, CosmosError?) -> Void) {
        let endpoint = AuthorListEndpoint(config: config, page: page)
        decode(endpoint: endpoint) { (response: [Author]?, error) in
            if let authors = response {
                completion(authors, authors.count < 25, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getAuthorArticles(key: Int64, page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        let endpoint = AuthorArticlesEndpoint(config: config, author: key, page: page)
        decode(endpoint: endpoint) { (response: [Article]?, error) in
            if let articles = response {
                completion(filterContent(articles), articles.count < 10, nil)
            } else {
                completion(nil, true, error)
            }
        }
    }

    func getBibliodamUrl(url: String, completion: @escaping (String?, CosmosError?) -> Void) {
        BibliodamExchangeEndpoint(config: config, url: url).get { data, error in
            if let data = data {
                let url = String(data: data, encoding: .utf8)
                completion(url, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func getNewsletters(accessToken: AccessToken, completion: @escaping ([PublicationNewslettersViewModel]?, CosmosError?) -> Void) {
        let endpoint = NewsletterEndpoint(config: config, token: accessToken.token)
        decode(endpoint: endpoint) { (response: NewsletterResponse?, error) in
            if let newsletters = response {
                completion(remapNewsletters(from: newsletters), nil)
            } else {
                completion(nil, error)
            }
        }
    }

    private func remapNewsletters(from response: NewsletterResponse) -> [PublicationNewslettersViewModel] {
        var publications = [PublicationNewslettersViewModel]()
        for key in response.keys {
            guard let element = response[key] else { continue }
            let newsletters: [NewsletterViewModel?] = element.data.map { dict in
                guard let key = dict.keys.first, let elem = dict[key] else { return nil }
                return NewsletterViewModel(id: key, name: elem.name, visible: elem.visible)
            }
            let newElement = PublicationNewslettersViewModel(description: element.text, name: element.name, id: key, newsletters: newsletters.compactMap {$0})
            publications.append(newElement)
        }
        return filterNewsletters(publications)
    }

    private func filterNewsletters(_ newsletters: [PublicationNewslettersViewModel]) -> [PublicationNewslettersViewModel] {
        newsletters.filter { newsletter -> Bool in
            if let filters = config.filteredPublications,
               filters.contains(where: { $0.id == newsletter.id }) {
                return false
            }
            return true
        }
    }

    // MARK: POST

    func updateUser(accessToken: AccessToken, data: UserUpdateRequest, completion: @escaping BooleanCallback) {
        UpdateUserEndpoint(config: config, accessToken: accessToken.token).post(data: data) { _, error in
            completion(error == nil)
        }
    }

    func updateUserProfile(accessToken: AccessToken, data: UserProfileUpdateRequest, completion: @escaping BooleanCallback) {
        UpdateUserProfileEndpoint(config: config, accessToken: accessToken.token).post(data: data) { _, error in
            completion(error == nil)
        }
    }
    
    func deleteUser(accessToken: AccessToken, data: DeleteUserRequest, completion: @escaping BooleanCallback) {
        DeleteUserEndpoint(config: config, accessToken: accessToken.token).post(data: data) { _, error in
            completion(error == nil)
        }
    }

    // MARK: Filtering

    fileprivate func filterContent(_ articles: [Article]) -> [Article] {
        articles.filter { article -> Bool in
            if let filters = config.filteredPublications,
               filters.contains(where: { $0.id == article.publication.identifier }) {
                return false
            }
            return (article.hideInApp ?? false) == false
        }
    }
}
