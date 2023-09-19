import UIKit
import Reachability
import AMScrollingNavbar
import Lottie
import GoogleMobileAds

public class ArticleViewController: CosmosBaseViewController {

    @IBOutlet var container: UIStackView!
    @IBOutlet var scroll: UIScrollView! {
        didSet {
            scroll.delegate = self
        }
    }
    @IBOutlet var backgroundView: ArticleBackground!

    var relatedSelected: RelatedSelectedCallback!
    var article: ArticleViewModel!
    var topBanner: CosmosBannerAd?
    var relatedTopBanner: CosmosBannerAd?
    var relatedBottomBanner: CosmosBannerAd?
    var interscroller: CosmosNativeAdView?
    var interscrollerSpacer: ArticleSpacer?

    deinit {
        cleanup()
    }

    func cleanup() {
        if let container = self.container {
            for subview in container.subviews where (subview is ArticleImage || subview is ArticleGallery) {
                (subview as? ArticleImage)?.parentView = nil
                (subview as? ArticleGallery)?.parentView = nil
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = .clear
        hideBackButtonTitle()
    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        if article.state == .error || article.state == .offline {
            article.state = .loading
            refreshUI()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(Cosmos.Notification.articleExited.rawValue), object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
        (navigationController as? ScrollingNavigationController)?.followScrollView(scroll)
    }

    public override func logEvent() {
        let articleKey = "\(article.key)"
        if article.renderType.isPushNotification {
            let articleSlug = article.slug ?? "NA"
            let articleHeadline = article.title ?? "NA"
            cosmos.logger?.log(event: CosmosEvents.notificationOpen(slug: articleSlug, headline: articleHeadline))
        } else {
            cosmos.logger?.log(event: CosmosEvents.article(articleKey: articleKey))
        }
        narratiiveSendEvent()
    }

    func narratiiveSendEvent() {
        if let path = article.shareURL ?? article.slug {
            cosmos.narratiiveLogger.sendEvent(path: path) { _ in }
        }
    }

    override func configureNavbar() {
        if view.bounds.width >= 350 && !cosmos.uiConfig.shouldNavHideLogo {
            super.configureNavbar()
        }
    }

    fileprivate func addWidget(_ widget: WidgetViewModel, offset: Int, addSpacer: Bool = true) {

        let view = widget.getView(cosmos: cosmos,
                                  as: article.renderType,
                                  relatedSelected: relatedSelected)
        if let imageWidget = view as? ArticleImage {
            imageWidget.parentView = (container, offset)
        } else if let galleryWidget = view as? ArticleGallery {
            galleryWidget.parentView = (container, offset)
        } else if let crossword = view as? ArticleCrossword {
            crossword.delegate = self
            crossword.parentController = self
        } else if let webWidget = view as? ArticleWebView {
            webWidget.delegate = self
            webWidget.cosmos = cosmos
        }

        if widget.type != .marketData {
            view.backgroundColor = cosmos.theme.backgroundColor
            view.subviews.forEach { $0.backgroundColor = cosmos.theme.backgroundColor }
        }

        container.addArrangedSubview(view)
        if addSpacer {
            container.addArrangedSubview(createArticleWidgetSpacer())
        }
    }

    fileprivate func addFirstWidget(_ widgets: inout [WidgetViewModel]) {
        if let first = widgets.first {
            addWidget(first, offset: 1)
            widgets.removeFirst()
        }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func loadWidgets() {
        guard var widgets = article.widgets else { return }
        activityIndicator.stop()
        loadAds()

        container.addArrangedSubview(createArticleWidgetSpacer())

        if cosmos.adsEnabled, !(widgets.first?.isVideoType ?? false) {
            if let first = widgets.first,
                first.type != .text {
                addFirstWidget(&widgets)
            }

            if let topBannerAd = topBanner {
                container.addArrangedSubview(topBannerAd)
                container.addArrangedSubview(createArticleWidgetSpacer())
                topBanner?.isHidden = true
            }
        }

        addFirstWidget(&widgets)

        var relatedIndex = widgets.count
        if let lastRelatedWidget = widgets.lastIndex(where: { $0.type == .relatedArticles }) {
            relatedIndex = widgets.distance(from: 0, to: lastRelatedWidget)
        }

        for index in 0..<relatedIndex {
            let widget = widgets[index]
            addWidget(widget, offset: index + 2)
        }

        if relatedIndex != widgets.count, cosmos.adsEnabled, let bannerAd = relatedTopBanner {
            container.addArrangedSubview(bannerAd)
            container.addArrangedSubview(createArticleWidgetSpacer())
            relatedTopBanner?.isHidden = true
        }

        if relatedIndex < widgets.count {
            addWidget(widgets[relatedIndex], offset: relatedIndex + 2)
        }

        if relatedIndex + 1 < widgets.count {
            for remaining in relatedIndex+1..<widgets.count where remaining < widgets.count {
                let widget = widgets[remaining]
                addWidget(widget, offset: remaining + 2)
            }
        }

        if cosmos.adsEnabled, let bannerAd = relatedBottomBanner {
            container.addArrangedSubview(bannerAd)
            container.addArrangedSubview(createArticleWidgetSpacer())
            relatedBottomBanner?.isHidden = true
        }

        if let footer = ArticleFooter().fromNib() {
            (footer as? ArticleFooter)?.scrollToTop = { [weak self] in
                (self?.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
                self?.scroll.setContentOffset(.zero, animated: true)
            }
            container.addArrangedSubview(footer)
        }

        if cosmos.adsEnabled, let interscroller = interscroller {
            self.view.insertSubview(interscroller, at: 0)
            interscroller.translatesAutoresizingMaskIntoConstraints = false
            interscroller.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            interscroller.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            interscroller.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            interscroller.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            let frameWidth = self.view.frame.width
            interscrollerSpacer = ArticleSpacer(width: frameWidth, height: 250, color: .clear)
            container.insertArrangedSubview(interscrollerSpacer!, at: container.arrangedSubviews.count/2)
            self.interscroller?.isHidden = true
            self.interscrollerSpacer?.isHidden = true
        }

        if reachability?.connection == .unavailable {
            article.state = .offline
        } else {
            article.state = .done
            self.refreshUI()
        }
    }

    fileprivate func createArticleWidgetSpacer() -> ArticleSpacer {
        let frameWidth = self.view.frame.width
        return ArticleSpacer(width: frameWidth, height: 16, color: cosmos.theme.backgroundColor)
    }

    func loadAds() {
        guard cosmos.adsEnabled,
            let adSections = article.adSections,
            let factory = CosmosAdFactory(cosmos: cosmos),
            let placements = cosmos.adConfig?.articlePlacements else { return }

        var path = adSections.section + "/"

        if let subSection = adSections.subsection,
            subSection != "" {
            path += "\(subSection)/"
        }

        topBanner = factory.create(from: placements[0], path: path,
                                   target: article.customAdTag, root: self, delegate: self) as? CosmosBannerAd
        relatedTopBanner = factory.create(from: placements[1], path: path,
                                          target: article.customAdTag, root: self, delegate: self) as? CosmosBannerAd
        relatedBottomBanner = factory.create(from: placements[2], path: path,
                                             target: article.customAdTag, root: self, delegate: self) as? CosmosBannerAd
        if placements.contains(where: { $0.isInterscroller }) {
            interscroller = factory.create(from: placements[3], path: path,
                                           target: article.customAdTag, root: self, delegate: self) as? CosmosNativeAdView
        }
    }

    func handleArticleFromAPI(_ loadedArticle: Article?, as renderType: ArticleRenderType, _ error: CosmosError?) {
        if let loadedArticle = loadedArticle {
            self.cosmos.narratiiveLogger.sendEvent(path: loadedArticle.shareURL ?? loadedArticle.slug, completion: nil)
            let articleIndex = self.article.articleIndex
            self.article = ArticleViewModel(from: loadedArticle, as: renderType)
            self.article.set(index: articleIndex)
            DispatchQueue.main.async {
                (self.parent as? ArticlePagerViewController)?.refreshArticles(with: self.article)
                self.refreshUI()
            }
        } else {
            self.cosmos.errorDelegate?.cosmos(received: error)
            self.displayFallback(networkError: false)
        }
    }

    func loadArticle() {
        if reachability?.connection == .unavailable {
            displayFallback(networkError: true)
        } else {
            if let slug = article.slug {
                cosmos.getArticle(slug: slug) { loadedArticle, error in
                    self.handleArticleFromAPI(loadedArticle, as: self.article.renderType, error)
                }
            } else {
                cosmos.getArticle(key: article.key) { loadedArticle, error in
                    self.handleArticleFromAPI(loadedArticle, as: self.article.renderType, error)
                }
            }
        }
    }

    fileprivate func addArticleHeader() {
        container.subviews.forEach { $0.removeFromSuperview() }
        let coBranding = self.customizedPublication(article.publication)?.uiConfig.articleLogo

        if let image = article.widgets?.first as? ImageViewModel,
            article.headerImageURL == nil {
            addWidget(image, offset: 0, addSpacer: false)
            _ = article.widgets?.removeFirst()
        }

        let header: ArticleHeader
        switch cosmos.uiConfig.articleHeaderType {
        case .injected:
            if let injectedHeader = cosmos.uiConfig.articleHeader,
               let convertedHeader = CosmosViewConstructor.extractInjectedArticleHeader(from: injectedHeader) {
                header = convertedHeader
            } else {
                print("WARNING: Failed to parse injected article header")
                header = ArticleHeader.instanceFromNib(type: .standard)
            }
        default:
            header = ArticleHeader.instanceFromNib(type: cosmos.uiConfig.articleHeaderType)
        }
        if cosmos.uiConfig.authorConfig.shouldOpenAuthorPage {
            header.openAuthor = { [weak self] author in
                guard let strongSelf = self else { return }
                let viewController = strongSelf.cosmos.getAuthorsArticlesView(author: author)
                DispatchQueue.main.async {
                    strongSelf.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
        header.configure(article, logo: coBranding, cosmos: self.cosmos)

        container.addArrangedSubview(header)
        header.backgroundColor = cosmos.theme.backgroundColor
        header.subviews.forEach { $0.backgroundColor = cosmos.theme.backgroundColor }
    }

    func refreshUI() {
        switch article.state {
        case .loading:
            activityIndicator.start()
            loadArticle()
        case .loaded:
            activityIndicator.start()

            addArticleHeader()

            if article.access {
                loadWidgets()
            } else {
                checkAccess()
            }

            DispatchQueue.main.async {
                self.view.setNeedsLayout()
            }

            let trackData: [String: Any] = [
                "view": self.view!,
                "url": self.article.shareURL ?? "",
                "title": self.article.title ?? "",
                "author": self.article.author?.name ?? ""
            ]
            NotificationCenter.default.post(
                name: Notification.Name(Cosmos.Notification.articleLoaded.rawValue),
                object: nil,
                userInfo: trackData
            )

        case .accessCheck:
            if article.access {
                cosmos.clearLocalStorage()
                loadWidgets()
            } else {
                displayRoadBlock()
            }
        case .done:
            scroll.layoutIfNeeded()
        case .offline: break
        case .error:
            self.article.state = article.datePublished == nil ? .loading : .loaded
            self.refreshUI()
        }
    }

    private func checkAccess() {
        cosmos.getArticle(key: article.key, skipLocal: true) { loadedArticle, _ in
            DispatchQueue.main.async {
                if let loadedArticle = loadedArticle,
                    loadedArticle.access ?? true {
                    self.article = ArticleViewModel(from: loadedArticle, as: self.article.renderType)
                }
                self.article.state = .accessCheck
                self.refreshUI()
            }
        }
    }

    func getContentLockView() -> UIView? {
        var nib: UINib?
        if !cosmos.isLoggedIn && article.isPremium {
            nib = cosmos.uiConfig.subscriptionWallView
        } else if !cosmos.isLoggedIn {
            nib = cosmos.uiConfig.registrationWallView
        } else {
            nib = cosmos.uiConfig.payWallView
        }
        let view = nib?.instantiate(withOwner: nil)[0] as? UIView
        return view
    }

    private func displayRoadBlock() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            let contentLock = self.getContentLockView() ?? UIView()
            (contentLock as? RoadBlock)?.configure(for: self.article.publication)
            self.container.addArrangedSubview(contentLock)
            self.article.state = .error
            (self.navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
        }
    }

    private func displayFallback(networkError: Bool) {
        if article.renderType.isPushNotification {
            let articleKey = "\(article.key)"
            cosmos.logger?.log(event: CosmosEvents.notificationFailed(articleKey: articleKey))
        }

        DispatchQueue.main.async {
            self.container.subviews.forEach { $0.removeFromSuperview()}
            let errorVC: FallbackViewController = CosmosStoryboard.loadViewController()
            let fallbackView = errorVC.view

            if networkError {
                errorVC.configure(fallback: self.cosmos.fallbackConfig.noNetworkFallback, cosmos: self.cosmos)
            } else {
                errorVC.configure(fallback: self.cosmos.fallbackConfig.articleFallback, cosmos: self.cosmos)
            }

            fallbackView?.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            fallbackView?.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.container.addArrangedSubview(fallbackView!)

            self.activityIndicator.stop()
            self.view.setNeedsLayout()
            self.article.state = .error
        }
    }

    private func customizedPublication(_ articlePub: String) -> Publication? {
        guard let customPubs = cosmos.apiConfig.customArticlePublications else { return nil }

        for publication in customPubs where publication.id == articlePub && publication.id != cosmos.publication.id {
            return publication
        }
        return nil
    }
}

extension ArticleViewController: UIScrollViewDelegate {
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        (navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
        return true
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        _ = 0
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _ = 0
    }
}

extension ArticleViewController: ArticleCrosswordWidgetDelegate {
    func handleNoConnectivityButtonTap(crossword: ArticleCrossword) {
        cosmos.errorDelegate?.cosmos(received: CosmosError.networkError(nil))
    }
}

extension ArticleViewController: ArticleWebWidgetDelegate {
    func webWidget(_ widget: ArticleWebView, didResize difference: CGFloat) {
        if widget.frame.maxY < self.scroll.contentOffset.y {
            DispatchQueue.main.async {
                self.scroll.contentOffset = CGPoint(x: self.scroll.contentOffset.x,
                                                    y: self.scroll.contentOffset.y + difference)
            }
        }
    }
}

extension ArticleViewController: CosmosAdDelegate {

    func bannerAdReceived(_ ad: CosmosBannerAd) {
        if ad == topBanner {
            topBanner?.isHidden = false
        } else if ad == relatedTopBanner {
            relatedTopBanner?.isHidden = false
        } else if ad == relatedBottomBanner {
            relatedBottomBanner?.isHidden = false
        }
    }

    func nativeAdReceived() {
        interscrollerSpacer?.isHidden = false
        interscroller?.isHidden = false
    }
}

extension UIScrollView {

    var scrolledToTop: Bool {
        let topEdge = 0 - contentInset.top
        return contentOffset.y <= topEdge
    }

    var scrolledToBottom: Bool {
        let bottomEdge = contentSize.height + contentInset.bottom - bounds.height
        return Int(contentOffset.y) >= Int(bottomEdge)
    }
}

class TestView: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 375, height: 100)
    }
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        self.backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
