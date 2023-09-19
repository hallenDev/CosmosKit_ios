import UIKit
import Reachability
import AMScrollingNavbar
import GoogleMobileAds

public class ArticleListViewController: CosmosBaseViewController, InfiniteScrollable, SearchableViewController {

    var search: SearchButton!
    var viewContext: ArticleListViewContext!
    var isScrollable = true
    var loadNextPage: (() -> Void)?
    var currentPage = 1
    var isLoadingNextPage = false
    var atEnd = false
    var listViewPlacements: [AdPlacement]?
    var listViewAds: [CosmosAd]?
    var interscrollerAd: CosmosNativeAdView?

    var cellHeights: [IndexPath: CGFloat] = [:] // Used to prevent jitter when reloading

    var articleList: ArticleListViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let offset = strongSelf.tableView?.contentOffset ?? .zero
                strongSelf.configureView()
                strongSelf.tableView?.reloadData()
                strongSelf.tableView?.setContentOffset(offset, animated: true)
                strongSelf.isLoadingNextPage = false
            }
        }
    }

    var showSearch: Bool {
        switch viewContext {
        case .search, .bookmarksFromSettings: return false
        default: return true
        }
    }

    var isContextBookmarks: Bool {
        viewContext == .bookmarksFromSettings || viewContext == .bookmarksFromTab
    }

    var refreshControl: CosmosRefreshControl!
    var sectionViewModel: SectionViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideBackButtonTitle()
        activityIndicator.start()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
        tableView?.reloadData()
        if showSearch {
            self.addSearchButton(self.search, animated: false)
        }
        configureRefresh()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isContextBookmarks {
            configureBookmarks()
        } else if viewContext == .normal {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshList),
                                                   name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
    }

    public override func logEvent() {
        switch viewContext! {
        case .search:
            cosmos.logger?.log(event: CosmosEvents.search(term: sectionViewModel?.name ?? "NA"))
        case .bookmarksFromTab, .bookmarksFromSettings:
            cosmos.logger?.log(event: CosmosEvents.bookmarks)
        case .normal:
            cosmos.logger?.log(event: CosmosEvents.homePage)
        case .section:
            cosmos.logger?.log(event: CosmosEvents.section(section: sectionViewModel?.name ?? "NA"))
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.closeDropdownIfNeeded()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }

    override func applyTheme() {
        view.backgroundColor = cosmos.theme.backgroundColor
        tableView?.backgroundColor = .clear
    }

    fileprivate func configureTableView() {
        if cosmos.articleListTheme.useCellSeparators {
            tableView?.separatorStyle = .singleLine
        } else {
            tableView?.separatorStyle = .none
        }
        tableView?.tableFooterView = UIView(frame: .zero)
    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        if tableView?.backgroundView != nil {
            switch viewContext! {
            case .normal:
                configureDataSource()
            case .section:
                guard let sectionViewModel = sectionViewModel else {
                    showContentFailure(fallback: cosmos.fallbackConfig.articleListFallback)
                    return
                }
                if sectionViewModel.subSections?.first == nil {
                    configureDataSource(section: sectionViewModel)
                } else {
                    configureDataSource(subSection: sectionViewModel)
                }
            case .search:
                configureDataSource(searchTerm: sectionViewModel?.name ?? "")
            default: break
            }
        } else {
            switch viewContext! {
            case .normal, .section, .search:
                atEnd = false
            default: break
            }
        }
    }

    func configureRefresh() {
        guard viewContext == .normal && refreshControl == nil else { return }
        refreshControl = CosmosRefreshControl(tintColor: cosmos.theme.accentColor)
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }

    @objc func refreshList() {
        guard viewContext == .normal, let tableView = tableView else { return }
        if let control = refreshControl,
           !control.isRefreshing {
            refreshControl!.beginRefreshing()
            let offset = CGPoint(x: 0, y: tableView.contentOffset.y - (refreshControl!.frame.size.height))
            tableView.setContentOffset(offset,
                                       animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.configureDataSource()
        }
    }

    func configureAds() {
        guard !isContextBookmarks,
              let factory = CosmosAdFactory(cosmos: cosmos),
              let listViewPlacements = cosmos.adConfig?.articleListPlacements else { return }

        self.listViewPlacements = listViewPlacements
        if listViewAds == nil {
            self.listViewAds = [CosmosAd]()
        }

        for placement in listViewPlacements {
            let path = viewContext.adPath(section: sectionViewModel?.id,
                                          subSection: sectionViewModel?.subSections?.first?.id)
            let ad = factory.create(from: placement,
                                    path: path,
                                    target: nil,
                                    root: self,
                                    frame: self.view.frame,
                                    delegate: self)
            listViewAds?.append(ad)
        }
    }

    func configureView() {
        guard articleList != nil else { return }
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.refreshControl?.endRefreshing()
        }
    }

    override func configureTableHeaderView() {
        guard viewContext != .normal else { return }

        if let subSection = sectionViewModel?.subSections?.first?.name {
            headerTitle = subSection
        } else if let section = sectionViewModel?.name {
            headerTitle = section
        } else {
            headerTitle = LanguageManager.shared.translateUppercased(key: .headingBookmarks)
        }
        super.configureTableHeaderView()
    }
}

// MARK: configure datasource
extension ArticleListViewController {
    func configureDataSource() {
        atEnd = false
        viewContext = .normal
        currentPage = 1
        configureAds()
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            isLoadingNextPage = true
            cosmos.getAllArticles(page: 1) { [weak self] list, end, error in
                DispatchQueue.main.async {
                    self?.refreshControl?.endRefreshing()
                }
                guard let strongSelf = self else { return }
                strongSelf.handleArticleNetworkResponse(articles: list, end: end, error: error)
                strongSelf.loadNextPage = { [weak self] in
                    self?.loadMoreArticles()
                }
            }
        }
    }

    func configureDataSource(section: SectionViewModel) {
        tableView?.backgroundView = nil
        atEnd = false
        viewContext = .section
        currentPage = 1
        sectionViewModel = section
        sectionViewModel?.subSections = nil
        configureAds()
        fallback = cosmos.fallbackConfig.articleListFallback
        guard let sectionURL = section.id else {
            showContentFailure()
            return
        }
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            isLoadingNextPage = true
            cosmos.getAllArticles(section: sectionURL, publication: section.publication, page: 1) { [weak self] list, end, error in
                guard let strongSelf = self else { return }
                strongSelf.handleArticleNetworkResponse(articles: list, end: end, error: error)
                strongSelf.loadNextPage = { [weak self] in
                    self?.loadMoreSectionResults()
                }
            }
        }
    }

    func configureDataSource(subSection: SectionViewModel) {
        tableView?.backgroundView = nil
        atEnd = false
        viewContext = .section
        currentPage = 1
        sectionViewModel = subSection
        configureAds()
        fallback = cosmos.fallbackConfig.articleListFallback
        guard let sectionURL = subSection.id,
            let subsectionURL = subSection.subSections?.first?.id
            else {
                showContentFailure()
                return
        }
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            isLoadingNextPage = true
            // swiftlint:disable:next line_length
            cosmos.getAllArticles(section: sectionURL, subSection: subsectionURL, publication: subSection.publication, page: 1) { [weak self] list, end, error in
                guard let strongSelf = self else { return }
                strongSelf.handleArticleNetworkResponse(articles: list, end: end, error: error)
                strongSelf.loadNextPage = { [weak self] in
                    self?.loadMoreSubSectionResults()
                }
            }
        }
    }

    func configureDataSource(searchTerm: String) {
        tableView?.backgroundView = nil
        atEnd = false
        viewContext = .search
        currentPage = 1
        sectionViewModel = SectionViewModel(name: searchTerm)
        configureAds()
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else if searchTerm.isEmpty {
            showContentFailure(fallback: cosmos.fallbackConfig.searchFallback)
        } else {
            isLoadingNextPage = true
            cosmos.getResults(for: searchTerm) { [weak self] list, end, error in
                guard let strongSelf = self else { return }
                strongSelf.handleArticleNetworkResponse(articles: list, end: end, error: error,
                                                        fallback: strongSelf.cosmos.fallbackConfig.searchFallback,
                                                        apiFallback: strongSelf.cosmos.fallbackConfig.apiErrorFallback)
                strongSelf.loadNextPage = { [weak self] in
                    self?.loadMoreSearchResults()
                }
            }
        }
    }

    func configureDataSourceForBookmarks(context: ArticleListViewContext) {
        viewContext = context
        configureBookmarks()
    }

    private func configureBookmarks() {
        tableView?.bounces = false
        loadNextPage = nil
        currentPage = 1
        let articles = cosmos.getBookmarks()
        self.articleList = ArticleListViewModel(from: articles)
        fallback = cosmos.fallbackConfig.bookmarksFallback
        if articles.isEmpty {
            showContentFailure()
        } else {
            tableView?.backgroundView = nil
        }
    }

    private func handleArticleNetworkResponse(articles: [Article]?,
                                              end: Bool, error: CosmosError?,
                                              fallback: Fallback? = nil, apiFallback: Fallback? = nil) {
        self.fallback = fallback ?? cosmos.fallbackConfig.articleListFallback
        if let articles = articles {
            self.atEnd = end
            if articles.isEmpty {
                showContentFailure()
            } else {
                articleList = ArticleListViewModel(from: articles)
            }
        } else {
            showContentFailure(fallback: apiFallback ?? self.fallback)
            cosmos.errorDelegate?.cosmos(received: error)
        }
    }
}

extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return articleList == nil ? 0 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = articleList?.articles {
            let showLoader = isScrollable && !atEnd && !isContextBookmarks
            return (showLoader ? list.count + 1 : list.count)
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleList = articleList else {
            return tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath)
        }

        if !isContextBookmarks,
           isScrollable,
           indexPath.row == articleList.count,
           !atEnd {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ArticleLoadingCell", for: indexPath)
            (cell as? EditionLoadingCell)?.set(theme: cosmos.theme)
            return cell
        }

        let articleIndex = indexPath.row

        if articleIndex >= articleList.articles.count {
            // Really should not end up here but we do sometimes end up here because Mobile Ads
            // return multiple times that they are ready
            cosmos.logger?.log(event: CosmosEvents.adLoadError(articleIndex: articleIndex, articleCount: articleList.articles.count))
            return UITableViewCell()
        }

        let article = articleList.articles[articleIndex]
        var cell: UITableViewCell

        if let publication = isArticlePublicationCustom(article.publication),
           let cellId = getCustomCell(publication: publication, indexPath: indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            (cell as? CustomArticleSummaryCell)?.configure(for: article, cosmos: cosmos)
        } else if !isContextBookmarks && shouldFeature(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedArticleSummaryCell", for: indexPath)
            (cell as? ArticleSummaryCell)?.configure(article: article, featured: true, cosmos: cosmos)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath)
            (cell as? ArticleSummaryCell)?.configure(article: article, cosmos: cosmos)
        }

        // configure cell for ads
        if let adInfo = shouldShowAd(indexPath), var adCell = cell as? AdInjectableCell {
            adCell.configureAd(placement: adInfo.0, ad: adInfo.1)
            if adInfo.0.isInterscroller {
                adCell.interscrollerTapped = { [weak self] in
                    self?.interscrollerAd?.performClickOnAsset(with: NativeAdFields.mainImage.rawValue)
                }
            }
        }

        return cell
    }

    fileprivate func getCustomCell(publication: Publication, indexPath: IndexPath) -> String? {
        var cellId: String?
        if isContextBookmarks {
            cellId = publication.uiConfig.articleCell?.reuseId
        } else if shouldFeature(indexPath), let cellIdentifier = publication.uiConfig.featuredArticleCell?.reuseId {
            cellId = cellIdentifier
        } else {
            cellId = publication.uiConfig.articleCell?.reuseId
        }
        return cellId
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if let placement = shouldShowAd(indexPath),
            placement.0.isInterscroller,
            let existing = interscrollerAd {
            print("###########: showing interscroller")
            existing.isHidden = false
            existing.recordImpression()
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let placement = shouldShowAd(indexPath),
            placement.0.isInterscroller,
            let existing = interscrollerAd {
            print("###########: hiding interscroller")
            existing.isHidden = true
        }
    }

    func shouldFeature(_ indexPath: IndexPath) -> Bool {
        return indexPath.row % 6 == 0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleList = articleList else { return }

        if let adInfo = shouldShowAd(indexPath), adInfo.0.type == .interscroller {
            print("We tapped the interscroller")
        }

        let article = articleList.articles[indexPath.row]

        if let extUrl = article.externalUrl {
            cosmos.eventDelegate?.cosmosMetaArticle?(articleUrl: extUrl)
        } else {
            let articleVM = ArticleViewModel(article: article, as: article.renderType)
            let articles = articleList.articles
                .filter { !$0.isMeta }
                .map { ArticleViewModel(article: $0, as: article.renderType) }

            let pager = ArticlePagerViewController(cosmos: cosmos, articles: articles, currentArticle: articleVM)
            pager.articleChanged = { [weak self] article in
                self?.scrollTo(article: article)
            }
            DispatchQueue.main.async {
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(pager, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
}

// MARK: Infinite scroll
extension ArticleListViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isContextBookmarks, !isLoadingNextPage else { return }
        if articleList?.count ?? 0 > 0, scrollView.scrolledToBottom, isScrollable, !atEnd {
            loadNextPage?()
        }
    }

    private func loadMoreArticles() {
        if isLoadingNextPage { return }

        isLoadingNextPage = true
        let page = currentPage + 1
        cosmos.getAllArticles(page: page) { [weak self] articles, atEnd, error in
            self?.handleNextPageResults(articles: articles, page: page, atEnd: atEnd, error: error)
        }
    }

    private func loadMoreSearchResults() {
        if isLoadingNextPage { return }
        guard let searchTerm = sectionViewModel?.name else {
            showContentFailure(fallback: cosmos.fallbackConfig.searchFallback)
            return
        }

        isLoadingNextPage = true
        let page = currentPage + 1
        cosmos.getResults(for: searchTerm, page: page) { [weak self] list, end, error in
            self?.handleNextPageResults(articles: list, page: page, atEnd: end, error: error)
        }
    }

    private func loadMoreSectionResults() {
        if isLoadingNextPage { return }
        guard let section = self.sectionViewModel, let sectionURL = section.id else {
            showContentFailure(fallback: cosmos.fallbackConfig.articleListFallback)
            return
        }

        isLoadingNextPage = true
        let page = currentPage + 1
        cosmos.getAllArticles(section: sectionURL,
                              publication: section.publication,
                              page: page) { [weak self] list, end, error in
                                self?.handleNextPageResults(articles: list, page: page, atEnd: end, error: error)
        }
    }

    private func loadMoreSubSectionResults() {
        if isLoadingNextPage { return }
        guard let subSection = sectionViewModel,
            let sectionURL = subSection.id,
            let subsectionURL = subSection.subSections?.first?.id else {
                showContentFailure(fallback: cosmos.fallbackConfig.articleListFallback)
                return
        }

        isLoadingNextPage = true
        let page = currentPage + 1
        cosmos.getAllArticles(section: sectionURL,
                              subSection: subsectionURL,
                              publication: subSection.publication, page: page) { [weak self] list, end, error in
                                self?.handleNextPageResults(articles: list, page: page, atEnd: end, error: error)
        }
    }

    private func handleNextPageResults(articles: [Article]?, page: Int, atEnd: Bool, error: CosmosError?) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if let articles = articles {
                strongSelf.atEnd = atEnd
                strongSelf.currentPage = page
                strongSelf.articleList?.add(articles)
            } else {
                strongSelf.atEnd = true
            }
            if let error = error {
                strongSelf.atEnd = true
                strongSelf.cosmos.errorDelegate?.cosmos(received: error)
            }
            strongSelf.tableView?.reloadData()
            strongSelf.isLoadingNextPage = false
        }
    }
}

// MARK: Scroll to article
extension ArticleListViewController {
    func scrollTo(article: ArticleViewModel) {
        if let indexPath = articleList?.indexPath(for: article),
            let indexPaths = tableView?.indexPathsForVisibleRows,
            !indexPaths.contains(indexPath) {
            tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    public func scrollToTop() {
        guard let tabView = tableView, tabView.numberOfSections > 0 else { return }
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: Ads
extension ArticleListViewController: CosmosAdDelegate {

    func shouldShowAd(_ indexPath: IndexPath) -> (AdPlacement, CosmosAd)? {
        guard cosmos.adsEnabled,
              !isContextBookmarks,
              let listViewPlacements = listViewPlacements,
              let listViewAds = listViewAds else { return nil }

        for placement in listViewPlacements.enumerated() where placement.element.placement == indexPath.row {
            return (placement.element, listViewAds[placement.offset])
        }
        return nil
    }

    func bannerAdReceived(_ ad: CosmosBannerAd) {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }

    func constrainInterscroller() {
        guard let interscrollerAd = self.interscrollerAd else { return }
        interscrollerAd.translatesAutoresizingMaskIntoConstraints = false
        interscrollerAd.isHidden = true

        self.view.insertSubview(interscrollerAd, at: 0)
        interscrollerAd.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        interscrollerAd.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        interscrollerAd.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        interscrollerAd.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }

    func nativeAdReceived() {
        guard let listViewPlacements = listViewPlacements, let listViewAds = listViewAds else { return }
        DispatchQueue.main.async {
            for placement in listViewPlacements.enumerated() where placement.element.isInterscroller {
                if let ad = listViewAds[placement.offset] as? CosmosNativeAdView {
                    self.interscrollerAd = ad
                    self.constrainInterscroller()
                }
            }
        }
    }
}
