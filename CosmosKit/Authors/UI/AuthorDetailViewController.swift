import UIKit
import Reachability
import AMScrollingNavbar

public class AuthorDetailViewController: CosmosBaseViewController, InfiniteScrollable {

    // MARK: Variables

    var isScrollable = true
    var loadNextPage: (() -> Void)?
    var currentPage = 1
    var isLoadingNextPage = false
    var atEnd = false
    var cellHeights: [IndexPath: CGFloat] = [:] // Used to prevent jitter when reloading

    var authorViewModel: AuthorViewModel!
    var articleList: ArticleListViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let offset = strongSelf.tableView?.contentOffset
                strongSelf.configureView()
                strongSelf.tableView?.reloadData()
                if offset != nil {
                    strongSelf.tableView?.setContentOffset(offset!, animated: true)
                }
                strongSelf.isLoadingNextPage = false
            }
        }
    }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideBackButtonTitle()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
        tableView?.reloadData()
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

    // MARK: Configuration

    func configureView() {
        guard articleList != nil else { return }
        DispatchQueue.main.async {
            self.activityIndicator.stop()
        }
    }

    fileprivate func configureTableView() {
        if cosmos.articleListTheme.useCellSeparators {
            tableView?.separatorStyle = .singleLine
        } else {
            tableView?.separatorStyle = .none
        }
        tableView?.tableFooterView = UIView(frame: .zero)
    }

    // MARK: Actions

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        if tableView?.backgroundView != nil {
            configureDataSource(for: self.authorViewModel)
        } else {
            atEnd = false
        }
    }
}

// MARK: Datasource handling
extension AuthorDetailViewController {

    func configureDataSource(for author: AuthorViewModel) {
        activityIndicator.start()
        tableView?.backgroundView = nil
        tableView?.register(AuthorHeaderView.nib(), forHeaderFooterViewReuseIdentifier: "AuthorHeaderView")
        atEnd = false
        currentPage = 1
        authorViewModel = author
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else if let authorKey = author.key {
            isLoadingNextPage = true
            cosmos.getAuthorsArticles(key: authorKey) { [weak self] list, end, error in
                guard let strongSelf = self else { return }
                strongSelf.handleArticleNetworkResponse(articles: list, end: end, error: error)
                strongSelf.loadNextPage = { [weak self] in
                    self?.loadMoreAuthorResults()
                }
            }
        } else {
            showContentFailure()
        }
    }

    private func handleArticleNetworkResponse(articles: [Article]?, end: Bool, error: CosmosError?) {
        if let articles = articles {
            self.atEnd = end
            if articles.isEmpty {
                showContentFailure()
            } else {
                articleList = ArticleListViewModel(from: articles)
            }
        } else {
            showContentFailure()
            cosmos.errorDelegate?.cosmos(received: error)
        }
    }
}

// MARK: UITablView Datasource & Delegate
extension AuthorDetailViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AuthorHeaderView.instanceFromNib()
        header.configure(self.authorViewModel)
        return header
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = articleList?.articles {
            let showLoader = isScrollable && !atEnd
            return (showLoader ? list.count + 1 : list.count)
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleList = articleList else {
            return tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath)
        }

        if isScrollable && indexPath.row == articleList.count && !atEnd {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ArticleLoadingCell", for: indexPath)
            (cell as? EditionLoadingCell)?.set(theme: cosmos.theme)
            return cell
        }

        let articleIndex = indexPath.row

        if articleIndex >= articleList.articles.count {
            cosmos.logger?.log(event: CosmosEvents.adLoadError(articleIndex: articleIndex, articleCount: articleList.articles.count))
            return UITableViewCell()
        }

        let article = articleList.articles[articleIndex]
        var cell: UITableViewCell

        if let publication = isArticlePublicationCustom(article.publication),
            shouldFeature(indexPath), let cellId = publication.uiConfig.featuredArticleCell?.reuseId {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            (cell as? CustomArticleSummaryCell)?.configure(for: article, cosmos: cosmos)
        } else if let publication = isArticlePublicationCustom(article.publication),
            let cellId = publication.uiConfig.articleCell?.reuseId {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            (cell as? CustomArticleSummaryCell)?.configure(for: article, cosmos: cosmos)
        } else if shouldFeature(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedArticleSummaryCell", for: indexPath)
            (cell as? ArticleSummaryCell)?.configure(article: article, featured: true, cosmos: cosmos)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath)
            (cell as? ArticleSummaryCell)?.configure(article: article, cosmos: cosmos)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func shouldFeature(_ indexPath: IndexPath) -> Bool {
        return indexPath.row % 6 == 0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleList = articleList else { return }

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
extension AuthorDetailViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingNextPage else { return }

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

    private func loadMoreAuthorResults() {
        if isLoadingNextPage { return }
        guard let authorKey = authorViewModel?.key else {
            showContentFailure()
            return
        }

        isLoadingNextPage = true
        let page = currentPage + 1
        cosmos.getAuthorsArticles(key: authorKey, page: page) { [weak self] list, end, error in
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
extension AuthorDetailViewController {
    func scrollTo(article: ArticleViewModel) {
        if let indexPath = articleList?.indexPath(for: article),
            let indexPaths = tableView?.indexPathsForVisibleRows,
            !indexPaths.contains(indexPath) {
            tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    public func scrollToTop() {
        guard let tableV = tableView, tableV.numberOfSections > 0 else { return }
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
