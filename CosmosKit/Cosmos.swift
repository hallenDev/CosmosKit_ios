// swiftlint:disable line_length
import Foundation
import AVFoundation

public class Cosmos {

    static var sharedInstance: Cosmos?

    // notification for tracking
    public enum Notification: String {
        case articleLoaded = "ArticleLoaded"
        case articleExited = "ArticleExited"
    }

    // swiftlint:disable identifier_name
    struct ErrorHelper {
        static let ERROR_DECODE_DOMAIN = "CosmosDecodeError"
        static let ERROR_DECODE_CODE = -1010
        static let ERROR_GENERAL_DOMAIN = "CosmosError"
        static let ERROR_GENERAL_CODE = -2020
        static let PARAM_URL = "endpoint_url"
        static let PARAM_DECODE_ERROR = "decode_error"
        static let PARAM_ERROR = "error"
    }
    // swiftlint:enable identifier_name

    // MARK: Private properties
    private var client: CosmosConnectable
    private let defaults: CosmosDefaults
    let narratiiveLogger: NarratiiveLogger

    // MARK: Public properties
    public var pushNotifications: FirebasePushNotifications
    public let logger: AnalyticsLogable?
    public let apiConfig: CosmosConfig
    public weak var errorDelegate: CosmosErrorDelegate?
    public weak var eventDelegate: CosmosEventDelegate?
    public weak var multiPublicationDelegate: CosmosMultiPublicationDelegate?

    // MARK: Cosmos User

    public var user: CosmosUser? {
        get {
            let user = Keychain.getUser()
            if let unwrapped = user, unwrapped.guid == nil {
                migrateUserGUID()
            }
            return user
        }
        set {
            Keychain.setUser(newValue)
        }
    }

    public var isLoggedIn: Bool {
        user != nil && Keychain.getAccessTokenValue() != nil
    }

    // MARK: Themes

    public var theme: Theme { publication.theme }
    public var articleTheme: ArticleTheme { theme.articleTheme }
    public var articleHeaderTheme: ArticleHeaderTheme { theme.articleHeaderTheme }
    public var quoteTheme: QuoteTheme { theme.quoteTheme }
    public var authorTheme: AuthorTheme { theme.authorTheme }
    public var relatedArticleTheme: RelatedArticleTheme { theme.relatedArticleTheme }
    public var articleListTheme: ArticleListTheme { theme.articleListTheme }
    public var sectionsTheme: SectionsTheme { theme.sectionsTheme }
    public var searchTheme: SearchTheme { theme.searchTheme }
    public var viewHeaderTheme: ViewHeaderTheme { theme.viewHeaderTheme }
    public var settingsTheme: SettingsTheme { theme.settingsTheme }
    public var authTheme: AuthorizationTheme { theme.authTheme }
    public var legacyAuthTheme: LegacyAuthorizationTheme { theme.legacyAuthTheme ?? LegacyAuthorizationTheme() }
    public var navigationTheme: NavigationTheme { theme.navigationTheme }
    public var fallbackTheme: FallbackTheme { theme.fallbackTheme }
    public var editionTheme: EditionTheme? { theme.editionTheme }
    public var videosTheme: VideosTheme? { theme.videosTheme }
    public var authorsTheme: AuthorsTheme? { theme.authorsTheme }

    // MARK: Publication
    public var isEdition: Bool { apiConfig.publication.isEdition }
    public var publication: Publication { apiConfig.publication }

    // MARK: Ads

    public var adConfig: AdConfig? { publication.adConfig }
    public var adsEnabled: Bool {
        guard adConfig != nil else { return false }
//        return !user.premium
        return true
    }

    // MARK: Configs

    public var settingsConfig: SettingsConfig { publication.settingsConfig }
    public var editionConfig: EditionConfig? { publication.editionConfig }
    public var uiConfig: CosmosUIConfig { publication.uiConfig }
    public var fallbackConfig: FallbackConfig { publication.fallbackConfig }
    public var authorConfig: ArticleAuthorConfig { uiConfig.authorConfig }

    init(defaultLanguage: Languages = .en,
         client: CosmosConnectable,
         apiConfig: CosmosConfig,
         defaults: CosmosDefaults? = nil,
         logger: AnalyticsLogable? = nil,
         narratiiveLogger: NarratiiveLogger? = nil,
         errorDelegate: CosmosErrorDelegate?,
         eventDelegate: CosmosEventDelegate?,
         multiPublicationDelegate: CosmosMultiPublicationDelegate? = nil) {

        try? AVAudioSession.sharedInstance().setCategory(.playback)
        LanguageManager.shared.defaultLanguage = defaultLanguage
        self.client = client
        self.apiConfig = apiConfig
        self.defaults = defaults ?? CosmosDefaults()
        self.logger = logger
        self.pushNotifications = FirebasePushNotifications()
        self.narratiiveLogger = narratiiveLogger ?? NarratiiveLogger(config: apiConfig.publication.narratiiveConfig)

        self.errorDelegate = errorDelegate ?? self
        self.narratiiveLogger.errorDelegate = self.errorDelegate
        self.narratiiveLogger.getToken(completion: nil)
        self.client.errorDelegate = self.errorDelegate

        self.eventDelegate = eventDelegate ?? self

        self.multiPublicationDelegate = multiPublicationDelegate

        theme.apply()
        runMigrations()

        Cosmos.sharedInstance = self
    }

    public convenience init(defaultLanguage: Languages = .en,
                            apiConfig: CosmosConfig,
                            logger: AnalyticsLogable?,
                            errorDelegate: CosmosErrorDelegate?,
                            eventDelegate: CosmosEventDelegate?,
                            multiPublicationDelegate: CosmosMultiPublicationDelegate? = nil) {
        self.init(defaultLanguage: defaultLanguage,
                 client: CosmosClient(apiConfig: apiConfig),
                 apiConfig: apiConfig,
                 logger: logger,
                 errorDelegate: errorDelegate,
                 eventDelegate: eventDelegate,
                 multiPublicationDelegate: multiPublicationDelegate)
    }

    // MARK: Migrations

    /// Runs all migrations as needed on startup so they don't have to be called individually
    public func runMigrations() {
        runGUIDMigration()
        runPushNotificationMigration()
    }

    // TODO: can be removed after a version of migration has been released
    private func migrateUserGUID() {
        guard let token = Keychain.getAccessToken() else { return }
        client.getUserInfo(accessToken: token) { user, _ in
            if let newUser = user {
                Keychain.setUser(newUser)
            }
        }
    }

    // TODO: can be removed after a version of migration has been released
    public func runGUIDMigration() {
        guard !defaults.hasRunGUIDMigration() else { return }
        migrateUserGUID()
        if user?.guid != nil {
            defaults.markGUIDMigrationAsDone()
        }
    }

    // TODO: can be removed after a version of migration has been released
    public func runPushNotificationMigration(override: Bool = false) {
        if override {
            guard !defaults.hasRunForcedPNMigration() else { return }
            defaults.markForcedPNMigrationAsDone()
        } else {
            guard !defaults.hasRunPNMigration() else { return }
        }
        pushNotifications.setupDefaultsOnFirstRun()
    }

    public func clearLocalStorage() {
        _ = LocalStorage().removeAll()
    }

    public func bookmark(_ article: Article?) -> Bool {
        return client.store(article)
    }

    public func removeBookmark(key: Int64?) -> Bool {
        return client.removeBookmark(key: key)
    }

    public func getBookmarks() -> [Article] {
        return client.getBookmarks()
    }

    public func getEditionBookmarksView() -> EditionBookmarksViewController {
        let bookmarksView: EditionBookmarksViewController = CosmosStoryboard.loadViewController()
        let title = LanguageManager.shared.translateUppercased(key: .headingBookmarks)
        bookmarksView.setupController(cosmos: self, headerTitle: title,
                                      fallback: fallbackConfig.bookmarksFallback,
                                      event: CosmosEvents.bookmarks)
        return bookmarksView
    }

    public func getArticleListBookmarksView(context: ArticleListViewContext = .bookmarksFromTab) -> ArticleListViewController {
        let articleListView: ArticleListViewController = CosmosStoryboard.loadViewController()
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.bookmarksFallback, event: CosmosEvents.bookmarks)
        _ = articleListView.view
        articleListView.configureDataSourceForBookmarks(context: context)
        return articleListView
    }

    public func getArticle(slug: String, completion: @escaping ((Article?, CosmosError?) -> Void)) {
        client.getArticle(slug: slug, completion: completion)
    }

    public func getArticle(key: Int64, skipLocal: Bool = false, completion: @escaping ((Article?, CosmosError?) -> Void)) {
        client.getArticle(key: key, skipLocal: skipLocal, completion: completion)
    }

    public func getAllArticles(page: Int, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        client.getAllArticles(page: page, completion: completion)
    }

    public func getAllArticles(section: String, publication: String? = nil, page: Int? = nil, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        client.getAllArticles(section: section, publication: publication ?? self.publication.id, page: page, completion: completion)
    }

    public func getAllArticles(section: String, subSection: String, publication: String? = nil, page: Int? = nil, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        client.getAllArticles(section: section, subSection: subSection, publication: publication ?? self.publication.id, page: page, completion: completion)
    }

    public func getView(for article: Article, relatedSelected: @escaping RelatedSelectedCallback) -> ArticleViewController {
        let articleVM = ArticleViewModel(from: article, as: self.isEdition ? .edition : .live)
        return self.getView(for: articleVM, relatedSelected: relatedSelected)
    }

    public func getView(for article: ArticleViewModel, relatedSelected: @escaping RelatedSelectedCallback) -> ArticleViewController {
        let articleView: ArticleViewController = CosmosStoryboard.loadViewController()
        articleView.setupController(cosmos: self, fallback: fallbackConfig.articleFallback, event: CosmosEvents.article(articleKey: "\(article.key)"))
        articleView.relatedSelected = relatedSelected
        articleView.article = article
        return articleView
    }

    public func getView(for key: Int64, as renderType: ArticleRenderType, relatedSelected: @escaping RelatedSelectedCallback) -> ArticleViewController {
        let viewmodel = ArticleViewModel(key: key, as: renderType)
        return getView(for: viewmodel, relatedSelected: relatedSelected)
    }

    public func getView(for slug: String, as renderType: ArticleRenderType, relatedSelected: @escaping RelatedSelectedCallback) -> ArticleViewController {
        let viewmodel = ArticleViewModel(slug: slug, as: renderType)
        return getView(for: viewmodel, relatedSelected: relatedSelected)
    }

    public func getLiveView() -> ArticleListViewController {
        let articleListView: ArticleListViewController = CosmosStoryboard.loadViewController()
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.articleListFallback, event: CosmosEvents.homePage)
        _ = articleListView.view
        articleListView.configureDataSource()
        return articleListView
    }

    public func getLatestEdition(section: String, completion: @escaping (Edition?, CosmosError?) -> Void) {
        client.getLatestEdition(section: section, completion: completion)
    }

    public func getLatestMinimalEdition(section: String, completion: @escaping (MinimalEdition?, CosmosError?) -> Void) {
        client.getLatestMinimalEdition(section: section, completion: completion)
    }

    public func getEdition(for key: Int64, skipLocal: Bool, completion: @escaping (Edition?, CosmosError?) -> Void) {
        client.getEdition(key: key, skipLocal: skipLocal, completion: completion)
    }

    public func getLastStoredEdition() -> Edition? {
        guard let lastKey = defaults.getLastStoredEditionKey() else { return nil }
        return client.getLocalEdition(key: lastKey)
    }

    public func getStoredPastEdition(key: Int64) -> Edition? {
        return client.getLocalEdition(key: key)
    }

    public func getLastUpdated(for key: Int64, completion: @escaping (Date?, CosmosError?) -> Void) {
        client.getLastUpdatedDate(for: key, completion: completion)
    }

    public func getEditionList(in section: SectionViewModel) -> EditionViewController {
        let editionView: EditionViewController = CosmosStoryboard.loadViewController()
        editionView.setupController(cosmos: self, fallback: fallbackConfig.editionFallback, event: CosmosEvents.section(section: section.name ?? "NA"))
        editionView.configureDataSource(for: section)
        return editionView
    }

    public func getArticleList(section: SectionViewModel) -> ArticleListViewController {
        let articleListView: ArticleListViewController = CosmosStoryboard.loadViewController()
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.articleListFallback, event: CosmosEvents.section(section: "NA"))
        _ = articleListView.view
        articleListView.configureDataSource(section: section)
        return articleListView
    }

    public func getArticleList(subSection: SectionViewModel) -> ArticleListViewController {
        let articleListView: ArticleListViewController = CosmosStoryboard.loadViewController()
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.articleListFallback, event: CosmosEvents.section(section: "NA"))
        _ = articleListView.view
        articleListView.configureDataSource(subSection: subSection)
        return articleListView
    }

    public func getEditionView(for key: Int64) -> EditionViewController {
        let editionView: EditionViewController = CosmosStoryboard.loadViewController()
        editionView.setupController(cosmos: self, fallback: fallbackConfig.editionFallback, event: CosmosEvents.edition(key: "\(key)"))
        editionView.configureDataSource(key: key)
        return editionView
    }

    public func getLatestEditionView(apiSection: String) -> EditionViewController {
        let editionView: EditionViewController = CosmosStoryboard.loadViewController()
        editionView.setupController(cosmos: self, fallback: fallbackConfig.editionFallback, event: CosmosEvents.edition(key: "latest"))
        editionView.configureDataSource(section: apiSection)
        return editionView
    }

    public func getEditionView(for searchTerm: String) -> EditionViewController {
        let editionView: EditionViewController = CosmosStoryboard.loadViewController()
        editionView.setupController(cosmos: self, fallback: fallbackConfig.searchFallback, event: CosmosEvents.search(term: searchTerm))
        editionView.configureDataSource(for: searchTerm)
        return editionView
    }

    public func getArticleListView(for searchTerm: String) -> ArticleListViewController {
        let articleListView: ArticleListViewController = CosmosStoryboard.loadViewController()
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.apiErrorFallback, event: CosmosEvents.search(term: searchTerm))
        _ = articleListView.view
        articleListView.configureDataSource(searchTerm: searchTerm)
        return articleListView
    }

    public func getSectionView(renderType: ArticleRenderType) -> SectionViewController {
        let sectionView: SectionViewController = CosmosStoryboard.loadViewController()
        let title = LanguageManager.shared.translateUppercased(key: .headingSections)
        sectionView.setupController(cosmos: self,
                                    headerTitle: title,
                                    fallback: fallbackConfig.sectionFallback,
                                    event: CosmosEvents.sections)
        sectionView.sectionsViewModel = SectionsViewModel(renderType: renderType)
        return sectionView
    }

    public func getAllSections(completion: @escaping ([Section]?, CosmosError?) -> Void) {
        client.getSections(completion: completion)
    }

    public func isEditionPersisted(key: Int64) -> Bool {
        client.isEditionPersisted(for: key)
    }

    public func login(username: String, password: String, completion: @escaping (CosmosError?) -> Void) {
        client.getRequestToken { requestToken, error in
            if let requestToken = requestToken?.token {
                self.client.getAccessToken(username: username,
                                           password: password,
                                           token: requestToken) { accessToken, error in
                                            if let accessToken = accessToken {
                                                Keychain.setAccessToken(accessToken)
                                                self.client.getUserInfo(accessToken: accessToken) { user, _ in
                                                    self.user = user
                                                    completion(nil)
                                                }
                                            } else {
                                                completion(error)
                                            }
                }
            } else {
                completion(error)
            }
        }
    }

    public func register(username: String, completion: @escaping (CosmosError?) -> Void) {
        client.register(username: username) { error in
            completion(error)
        }
    }

    public func resetPassword(username: String, completion: @escaping (CosmosError?) -> Void) {
        client.resetPassword(username: username) { error in
            completion(error)
        }
    }

    public func logout() {
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        clearLocalStorage()
        user = nil
    }

    public func getPastEditions(section: String, includeLatest: Bool, limit: Int, page: Int, completion: @escaping ([PastEdition]?, Bool, CosmosError?) -> Void) {
        client.getPastEditions(section: section, includeLatest: includeLatest, limit: limit, page: page, completion: completion)
    }

    public func getOfflinePastEditions() -> [Edition]? {
        return client.getOfflinePastEditions()
    }

    public func getPastEditionsView(section: String = "editions") -> PastEditionsViewController {
        let pastEditionView: PastEditionsViewController = CosmosStoryboard.loadViewController()
        let title = LanguageManager.shared.translateUppercased(key: .headingPastEditions)
        pastEditionView.setupController(cosmos: self,
                                        headerTitle: title,
                                        fallback: fallbackConfig.pastEditionFallback,
                                        event: CosmosEvents.pastEditions)
        pastEditionView.viewModel = PastEditionsViewModel(section: section, cosmos: self)
        return pastEditionView
    }

    public func getResults(for searchTerm: String, page: Int? = nil, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        client.getResults(for: searchTerm, page: page, completion: completion)
    }

    public func removePersistedEditions() {
        client.removePersistedEditions(excluding: [])
    }

    public func getComments(for shareUrl: String, slug: String, completion: @escaping (Int?, CosmosError?) -> Void) {
        client.getComments(for: shareUrl, slug: slug, completion: completion)
    }

    public func getMedia(audio: Bool, page: Int = 1, completion: @escaping ([Media]?, Bool, CosmosError?) -> Void) {
        if audio {
            return client.getAudioContent(page: page, completion: completion)
        } else {
            return client.getVideoContent(page: page, completion: completion)
        }
    }

    public func getVideoView(translatedTitle: String?) -> MediaViewController {
        let videoView: MediaViewController = CosmosStoryboard.loadViewController()
        videoView.setupController(cosmos: self,
                                  headerTitle: translatedTitle ?? "",
                                  fallback: fallbackConfig.videoFallback,
                                  event: CosmosEvents.videos)
        videoView.viewModel = MediaListViewModel(title: translatedTitle, type: .videos)
        return videoView
    }

    public func getAudioView(translatedTitle: String?) -> MediaViewController {
        let videoView: MediaViewController = CosmosStoryboard.loadViewController()
        videoView.setupController(cosmos: self,
                                  headerTitle: translatedTitle ?? "",
                                  fallback: fallbackConfig.videoFallback,
                                  event: CosmosEvents.audio)
        videoView.viewModel = MediaListViewModel(title: translatedTitle, type: .audio)
        return videoView
    }

    public func getSingleArticleView(for article: ArticleViewModel) -> UINavigationController {
        let push: ArticlePushNavigationViewController = CosmosStoryboard.loadViewController()
        (push.viewControllers.first as? ArticlePushViewController)?.cosmos = self
        (push.viewControllers.first as? ArticlePushViewController)?.article = article
        return push
    }

    public func getAuthorisationView(theme: Theme? = nil) -> LoginContainerViewController {
        if FeatureFlag.newWelcomeFlow.isEnabled {
            fatalError("Route not implemented")
        } else {
            let loginController: LoginContainerViewController = CosmosStoryboard.loadViewController()
            loginController.cosmos = self
            loginController.theme = theme ?? self.theme
            return loginController
        }
    }

    public func getSettingsView() -> SettingsViewController {
        let settingsView: SettingsViewController = CosmosStoryboard.loadViewController()
        settingsView.cosmos = self
        return settingsView
    }
    
    public func getWelcomeView() -> WelcomeNavController {
        let welcome: WelcomeNavController = CosmosStoryboard.loadViewController()
        welcome.cosmos = self
        return welcome
    }

    public func getDisqusAuth(completion: @escaping (String?) -> Void) {
        client.getDisqusAuth { secret, _ in
            completion(secret)
        }
    }

    public func getInstagramPost(_ webViewModel: WebViewModel, appID: String, clientID: String, width: Int, completion: @escaping (String?, CosmosError?) -> Void) {
        guard let urlString = webViewModel.baseURL?.absoluteString else {
            completion(nil, CosmosError.invalidURL)
            return
        }
        var cleanString: String
        if let index = urlString.firstIndex(of: "?") {
            cleanString = String(urlString[urlString.startIndex...urlString.index(before: index)])
        } else {
            cleanString = urlString
        }
        cleanString = cleanString.replacingOccurrences(of: "https", with: "http")

        client.getEmbedableInstagramPost(postURL: cleanString, appID: appID, clientID: clientID, width: width, completion: completion)
    }

    public func getTeasers(section: String, subSection: String? = nil, completion: @escaping ([Teaser]?, CosmosError?) -> Void) {
        client.getTeasers(section: section, subSection: subSection, completion: completion)
    }

    public func getAuthors(page: Int = 1, completion: @escaping ([Author]?, Bool, CosmosError?) -> Void) {
        client.getAuthors(page: page, completion: completion)
    }

    public func getAuthorsListView() -> AuthorListViewController {
        let authors: AuthorListViewController = CosmosStoryboard.loadViewController()
        authors.cosmos = self
        let title = LanguageManager.shared.translateUppercased(key: .headingAuthors)
        authors.setupController(cosmos: self,
                                headerTitle: title,
                                fallback: fallbackConfig.authorsFallback,
                                event: CosmosEvents.authors)
        return authors
    }

    public func getAuthorsArticles(key: Int64, page: Int = 1, completion: @escaping ([Article]?, Bool, CosmosError?) -> Void) {
        client.getAuthorArticles(key: key, page: page, completion: completion)
    }

    public func getAuthorsArticlesView(author: AuthorViewModel) -> AuthorDetailViewController {
        let articleListView: AuthorDetailViewController = CosmosStoryboard.loadViewController()
        let event = CosmosEvents.author(key: "\(author.key ?? -1)")
        articleListView.setupController(cosmos: self, fallback: fallbackConfig.authorFallback, event: event)
        _ = articleListView.view
        articleListView.configureDataSource(for: author)
        return articleListView
    }

    func getBibliodamUrl(url: String, completion: @escaping (String?, CosmosError?) -> Void) {
        client.getBibliodamUrl(url: url, completion: completion)
    }

    public func getWidgetStackViewController(viewModel: WidgetStackViewModel) -> WidgetStackViewController {
        let stackview: WidgetStackViewController = CosmosStoryboard.loadViewController()
        stackview.setupController(cosmos: self, viewModel: viewModel)
        return stackview
    }

    // TDOO: remove
    private func readJSONData(_ fileName: String) -> Data {
        guard let path = Bundle.cosmos.path(forResource: fileName, ofType: "json") else {
            fatalError("file not found")
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func getNewsletters(completion: @escaping ([PublicationNewslettersViewModel]?, CosmosError?) -> Void) {
//        guard let token = Keychain.getAccessToken() else {
//            completion(nil, CosmosError.authenticationError)
//            return
//        }
        client.getNewsletters(accessToken: AccessToken(token: "", expires: ""), completion: completion)
    }
    
    func updateUserProfile(data: UserProfileUpdateRequest, completion: @escaping BooleanCallback) {
        guard let token = Keychain.getAccessToken() else {
            completion(false)
            return
        }
        client.updateUserProfile(accessToken: token, data: data, completion: completion)
    }
    
    func deleteUser(data: DeleteUserRequest, completion: @escaping BooleanCallback) {
        guard let token = Keychain.getAccessToken() else {
            completion(false)
            return
        }
        client.deleteUser(accessToken: token, data: data, completion: completion)
    }
    
    func updateUser(data: UserUpdateRequest, completion: @escaping BooleanCallback) {
        guard let token = Keychain.getAccessToken() else {
            completion(false)
            return
        }

        client.updateUser(accessToken: token, data: data) { result in
            if (result) {
                self.client.getUserInfo(accessToken: token) { user, _ in
                    self.user = user
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    public func popToMainTab() {
        if let root = UIApplication.shared.topViewController()?.parent?.parent as? UITabBarController {
            if root.selectedIndex == 0 {
                if let nav = root.selectedViewController as? UINavigationController {
                    nav.popToRootViewController(animated: true)
                } else if let nav = root.selectedViewController?.navigationController {
                    nav.popToRootViewController(animated: true)
                }
            }
            popToFirstPage(root)
        } else {
            if let nav = UIApplication.shared.topViewController() as? UINavigationController {
                nav.popToRootViewController(animated: false)
                self.popToMainTab()
            } else {
                UIApplication.shared.topViewController()?.dismiss(animated: true, completion: {
                    self.popToMainTab()
                })
            }
        }
    }

    private func popToFirstPage(_ controller: UITabBarController) {
        controller.selectedIndex = 0
        if let nav = controller.selectedViewController as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }

    public func showPushNotification(for info: [AnyHashable: Any], renderType: ArticleRenderType = .pushNotification(render: .live)) {
        if let key = extractPushNotificationArticleKey(from: info) {
            showArticle(key: key, renderType: renderType)
        } else {
            logger?.log(event: CosmosEvents.notificationMalformed)
            popToMainTab()
        }
    }

    public func extractPushNotificationArticleKey(from info: [AnyHashable: Any]) -> Int64? {
        pushNotifications.extractArticleKey(from: info)
    }

    public func getArticleKey(for slug: String, completion: @escaping (Int64?) -> Void) {
        getArticle(slug: slug) { article, _ in
            completion(article?.key)
        }
    }

    public func showArticleFromSlug(slug: String,
                                    renderType: ArticleRenderType,
                                    completion: ((CosmosError?) -> Void)? = nil) {
        getArticleKey(for: slug) { [weak self] key in
            if let key = key {
                self?.showArticle(key: key, renderType: renderType)
            } else {
                completion?(CosmosError.parsingError("Invalid Key"))
            }
        }
    }

    public func showArticle(key: Int64, renderType: ArticleRenderType) {
        DispatchQueue.main.async { [weak self] in
            guard let cosmos = self else { return }
            let article = ArticleViewModel(key: key, as: renderType)
            let nav = cosmos.getSingleArticleView(for: article)
            nav.modalPresentationStyle = .fullScreen
            let topVC = UIApplication.shared.topViewController()
            if topVC is ArticlePushViewController {
                topVC?.dismiss(animated: false) {
                    UIApplication.shared.topViewController()?.present(nav, animated: true)
                }
            } else {
                topVC?.present(nav, animated: true)
            }
        }
    }
}
