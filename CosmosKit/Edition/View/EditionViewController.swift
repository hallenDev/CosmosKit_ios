// swiftlint:disable force_cast
import UIKit
import Reachability
import Kingfisher
import AMScrollingNavbar

enum EditionViewContext {
    case search
    case section
    case edition
    case pastEdition
}

public class EditionViewController: CosmosBaseViewController, InfiniteScrollable, SearchableViewController {

    @IBOutlet var titleLabelView: UIView!
    @IBOutlet var titleLabel: UILabel!

    var search: SearchButton!
    var edition: EditionViewModel!
    var viewContext: EditionViewContext!

    var currentPage = 1
    var cellHeights: [IndexPath: CGFloat] = [:] // Used to prevent jitter when reloading
    var isScrollable = false
    var loadingNextPage = false
    var loadNextPage: (() -> Void)?
    var atEnd = false
    var editionsSectionName: String?

    var showSearch: Bool {
        return viewContext == .edition || viewContext == .section
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
        tableView?.reloadData()
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
    }

    func setEdition(_ edition: EditionViewModel) {
        DispatchQueue.main.async {
            if self.edition != edition {
                self.edition = edition
                self.isScrollable = edition.doesInfiniteScroll
                self.configureView()
                self.tableView?.reloadData()
                if !(self.edition?.sections.isEmpty ?? true) {
                    self.tableView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            } else {
                self.configureView()
            }
            self.loadingNextPage = false
        }
        if viewContext == .edition {
            NotificationCenter.default.removeObserver(self,
                                                      name: UIApplication.willEnterForegroundNotification,
                                                      object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(refreshTodaysEdition),
                                                   name: UIApplication.willEnterForegroundNotification,
                                                   object: nil)
        }
    }

    override func configureTableHeaderView() {
        // doing nothing as this is only used for searching in edition mode
    }

    func configureTableView() {
        let nib = UINib(nibName: "EditionSectionHeader", bundle: Bundle.cosmos)
        tableView?.register(nib, forHeaderFooterViewReuseIdentifier: "EditionSectionHeader")
    }

    private func configureEditionCustomCells() {
            guard let customCells = cosmos.apiConfig.customEditionPublications else { return }
            for publication in customCells {
                if let config = publication.editionConfig,
                    let editionCell = config.editionCell {
                    tableView?.register(editionCell.nib, forCellReuseIdentifier: editionCell.reuseId)
                }
            }
    }

    private func customizedPublication(_ articlePub: String) -> Publication? {
        if viewContext == .edition {
            return isEditionPublicationCustom(articlePub)
        } else {
            return isArticlePublicationCustom(articlePub)
        }
    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        if tableView?.backgroundView != nil,
            viewContext == .edition,
            let name = self.editionsSectionName {
            configureDataSource(section: name)
        } else {
            tableView?.reloadData()
        }
    }

    func fallbackToLatestStoredEdition() {
        if let lastLocalEdition = cosmos.getLastStoredEdition() {
            self.setEdition(EditionViewModel(from: lastLocalEdition))
        } else {
            self.showContentFailure()
        }
    }

    func fallbackToLatestEdition() {
        guard let sectionName = editionsSectionName else { return }
        cosmos.getLatestEdition(section: sectionName) { latest, _ in
            if let latestEdition = latest {
                self.setEdition(EditionViewModel(from: latestEdition))
            } else {
                self.fallbackToLatestStoredEdition()
            }
        }
    }

    func forceRefreshEdition(for key: Int64) {
        cosmos.getEdition(for: key, skipLocal: true) { newLocal, _ in
            if let latestEdition = newLocal {
                self.setEdition(EditionViewModel(from: latestEdition))
            } else {
                self.fallbackToLatestEdition()
            }
        }
    }

    func loadEdition(section: String) {
        if let lastLocalEdition = cosmos.getLastStoredEdition() {
            cosmos.getLastUpdated(for: lastLocalEdition.key) { updatedDate, _ in
                if let localUpdate = updatedDate {
                    self.cosmos.getLatestMinimalEdition(section: section, completion: { minimalEdition, _ in
                        if let minimalEdition = minimalEdition {
                            self.determineEditionFreshness(local: lastLocalEdition, localUpdate: localUpdate, latest: minimalEdition)
                        } else {
                            self.fallbackToLatestEdition()
                        }
                    })
                } else {
                    self.fallbackToLatestEdition()
                }
            }
        } else {
            fallbackToLatestEdition()
        }
    }

    func determineEditionFreshness(local: Edition, localUpdate: Date, latest: MinimalEdition) {
        if local.key != latest.key {
            fallbackToLatestEdition()
        } else if localUpdate > local.lastModified {
            forceRefreshEdition(for: local.key)
        } else {
            fallbackToLatestStoredEdition()
        }
    }

    @objc func refreshTodaysEdition() {
        if viewContext == .edition, let sectionName = self.editionsSectionName, UIApplication.shared.topViewController() is Self {
            self.configureDataSource(section: sectionName)
        }
    }

    func configureView() {
        guard let edition = edition else {
            titleLabel.isHidden = true
            titleLabelView.isHidden = true
            return
        }
        if edition.title.isEmpty {
            tableView?.tableHeaderView = nil
        } else {
            titleLabelView.isHidden = false
            titleLabel.isHidden = false
            titleLabel.text = edition.title
        }
        activityIndicator.stop()
        if showSearch {
            self.addSearchButton(search, animated: false)
        }
        if cosmos.editionTheme?.headerTheme.titleStyle == .compressed {
            titleLabelView.frame = CGRect(x: 0, y: 0, width: titleLabelView.frame.width, height: 32.5)
        }
    }
}

// MARK: Configure data source
extension EditionViewController {

    public func configureDataSource(fallback: Fallback) {
        configureActivityIndicator()
        activityIndicator.start()
        if viewContext == .edition {
            configureEditionCustomCells()
        }
        self.fallback = fallback
    }

    public func configureDataSource(section: String) {
        viewContext = .edition
        editionsSectionName = section
        configureDataSource(fallback: cosmos.fallbackConfig.editionFallback)
        tableView?.backgroundView = nil

        if reachability?.connection == .unavailable {
            if cosmos.getLastStoredEdition() != nil {
               fallbackToLatestStoredEdition()
            } else {
                showNetworkFailure()
            }
        } else {
            loadNextPage = nil
            loadingNextPage = true
            loadEdition(section: section)
        }
    }

    public func configureDataSource(key: Int64) {
        viewContext = .edition
        configureDataSource(fallback: cosmos.fallbackConfig.editionFallback)
        tableView?.backgroundView = nil

        if reachability?.connection == .unavailable {
            if cosmos.isEditionPersisted(key: key) {
                cosmos.getEdition(for: key, skipLocal: false) { [weak self] localEdition, _ in
                    if let localEdition = localEdition {
                        self?.setEdition(EditionViewModel(from: localEdition))
                    } else {
                        self?.showNetworkFailure()
                    }
                }
            } else {
                showNetworkFailure()
            }
        } else {
            loadNextPage = nil
            loadingNextPage = true
            loadPastEdition(key: key)
        }
    }

    func loadPastEdition(key: Int64) {
        if let local = cosmos.getStoredPastEdition(key: key) {
            cosmos.getLastUpdated(for: key) { updatedDate, _ in
                if let localUpdate = updatedDate {
                    if local.lastModified != localUpdate {
                        self.fallbackToFreshPastEdition(key: key)
                    } else {
                        self.setEdition(EditionViewModel(from: local))
                    }
                } else {
                    self.setEdition(EditionViewModel(from: local))
                }
            }
        } else {
            fallbackToFreshPastEdition(key: key)
        }
    }

    func fallbackToFreshPastEdition(key: Int64) {
        fallback = self.cosmos.fallbackConfig.editionFallback
        cosmos.getEdition(for: key, skipLocal: true) { [weak self] localEdition, _ in
            if let localEdition = localEdition {
                self?.setEdition(EditionViewModel(from: localEdition))
            } else {
                self?.showContentFailure()
            }
        }
    }

    public func configureDataSource(for section: SectionViewModel) {
        viewContext = .section
        configureDataSource(fallback: cosmos.fallbackConfig.sectionFallback)
        if reachability?.connection == .unavailable {
            self.showNetworkFailure()
        } else if let sectionUrl = section.id {
            loadingNextPage = true
            cosmos.getAllArticles(section: sectionUrl) { [weak self] list, endOfList, error in
                guard let strongSelf = self else { return }
                if let list = list {
                    strongSelf.setEdition(EditionViewModel(from: list, section: section, endOfList: endOfList))
                    strongSelf.loadNextPage = {
                        strongSelf.loadNextSection()
                    }
                } else {
                    strongSelf.showContentFailure()
                    strongSelf.cosmos.errorDelegate?.cosmos(received: error)
                }
            }
        } else {
            showContentFailure()
        }
    }

    public func configureDataSource(for searchTerm: String) {
        viewContext = .search
        configureDataSource(fallback: cosmos.fallbackConfig.searchFallback)
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            loadingNextPage = true
            cosmos.getResults(for: searchTerm) { [weak self] list, endOfList, error in
                guard let strongSelf = self else { return }
                strongSelf.atEnd = endOfList
                if let list = list {
                    if list.isEmpty {
                        strongSelf.showContentFailure()
                        strongSelf.configureStickyHeader(title: "\(searchTerm)")
                    } else {
                        let viewmodel = EditionViewModel(from: list,
                                                         section: SectionViewModel(name: "\(searchTerm)"),
                                                         endOfList: endOfList)
                        strongSelf.setEdition(viewmodel)
                        strongSelf.loadNextPage = { [weak self] in
                            self?.loadNextSearch()
                        }
                    }
                } else {
                    strongSelf.showContentFailure()
                    strongSelf.cosmos.errorDelegate?.cosmos(received: error)
                }
            }
        }
    }
}

extension EditionViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return edition?.sections.count ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let edition = edition, 0..<edition.sections.count ~= section else { return nil }

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EditionSectionHeader") as? EditionSectionHeader
        header?.configure(with: edition.sections[section], theme: cosmos.theme)
        return header
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let edition = edition else { return 0 }

        let contentCount = edition.sections[section].contentCount
        return (edition.doesInfiniteScroll && !atEnd) ? contentCount + 1 : contentCount
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let edition = edition, indexPath.section < edition.sections.count else {
            return UITableViewCell()
        }

        let section = edition.sections[indexPath.section]

        if edition.doesInfiniteScroll,
            indexPath.row == section.articles.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditionArticleLoading", for: indexPath) as! EditionLoadingCell
            cell.set(theme: cosmos.theme)
            return cell
        }

        switch section.type {
        case .hybrid:
            guard let list = section.hybridList else {
                return UITableViewCell()
            }

            let item = list[indexPath.row]

            switch item.displayType {
            case .article:
                if let article = item as? ArticleViewModel {
                    return getArticleCell(tableView, indexPath: indexPath, article: article)
                } else {
                    return UITableViewCell()
                }
            case .widget:
                if let widget = item as? WidgetViewModel {
                    return getWidgetCell(tableView, indexPath: indexPath, widget: widget)
                } else {
                    return UITableViewCell()
                }
            }
        case .articles:
            guard indexPath.row < section.articles.count else { return UITableViewCell() }
            return getArticleCell(tableView, indexPath: indexPath, article: section.articles[indexPath.row])
        case .widgets:
            guard let widgets = section.widgets,
                  indexPath.row < widgets.count else { return UITableViewCell() }
            return getWidgetCell(tableView, indexPath: indexPath, widget: widgets[indexPath.row])
        }
    }

    func getArticleCell(_ tableView: UITableView, indexPath: IndexPath, article: ArticleViewModel) -> UITableViewCell {
        if viewContext == .edition,
            let config = customizedPublication(article.publication)?.editionConfig,
            let editionCell = config.editionCell, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: editionCell.reuseId, for: indexPath)
            (cell as? CustomArticleCell)?.configure(for: article, imageGradient: true, separator: false, cosmos: cosmos)
            return cell
        } else if let publication = customizedPublication(article.publication),
            let articleCell = publication.uiConfig.articleCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleCell.reuseId, for: indexPath)
            (cell as? CustomArticleCell)?.configure(for: article, imageGradient: true, separator: true, cosmos: cosmos)
            return cell
        } else {
            var cell: EditionArticleCell
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "EditionArticle", for: indexPath) as! EditionArticleCell
                cell.configure(with: article, cosmos: cosmos)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "EditionArticleSmall", for: indexPath) as! EditionArticleCell
                if #available(iOS 13.0, *) {
                    cell.configure(with: article, imageGradient: traitCollection.userInterfaceStyle == .light, cosmos: cosmos)
                } else {
                    cell.configure(with: article, cosmos: cosmos)
                }
            }
            return cell
        }
    }

    func getWidgetCell(_ tableView: UITableView, indexPath: IndexPath, widget: WidgetViewModel) -> UITableViewCell {

        if widget.type == .accordion {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccordionWidgetCell", for: indexPath) as! AccordionWidgetCell
            cell.configure(with: widget as! AccordionViewModel, cosmos: cosmos)
            cell.resize = { [weak self] viewModel in
                self?.edition?.sections[indexPath.section].updateViewModel(viewModel, at: indexPath.row)
                UIView.performWithoutAnimation {
                    self?.tableView?.reloadData()
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericWidgetCell", for: indexPath) as! GenericWidgetCell
            cell.configure(cosmos: cosmos, with: widget, relatedSelected: self.relatedArticleSelected)
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let edition = edition,
            indexPath.section < edition.sections.count,
            indexPath.row < edition.sections[indexPath.section].articles.count
        else {
            return
        }

        let article = edition.sections[indexPath.section].articles[indexPath.row]

        if let extUrl = article.externalUrl,
           let url = URL(string: extUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let articles = edition.sections.flatMap { $0.articles }.filter { !$0.isMeta }
            let pager = ArticlePagerViewController(cosmos: cosmos, articles: articles, currentArticle: article)
            pager.articleChanged = scrollTo
            DispatchQueue.main.async {
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(pager, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let edition = edition else { return nil }
        if edition.sections[indexPath.section].type == .widgets {
            return nil
        } else {
            return indexPath
        }
    }
}

extension EditionViewController {

    func scrollTo(article: ArticleViewModel) {
        if let indexPath = edition?.indexPath(for: article),
            let indexPaths = tableView?.indexPathsForVisibleRows,
            !indexPaths.contains(indexPath) {
            tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loadingNextPage, scrollView.scrolledToBottom, isScrollable, !atEnd, edition?.sections[0].articles.count ?? 0 > 0 {
            loadNextPage?()
        }
    }

    func loadNextSection() {
        if !loadingNextPage {
            loadingNextPage = true
            if let section = edition?.sections.first?.heading.lowercased() {
                let page = currentPage + 1
                cosmos.getAllArticles(section: section, page: page) { [weak self] articles, atEnd, error in
                    self?.handleNextPageResults(articles: articles, page: page, atEnd: atEnd, error: error)
                }
            }
        }
    }

    func loadNextSearch() {
        if !loadingNextPage {
            loadingNextPage = true
            if let searchTerm = edition?.sections.first?.heading.lowercased() {
                let page = currentPage + 1
                cosmos.getResults(for: searchTerm, page: page) { [weak self] articles, atEnd, error in
                    self?.handleNextPageResults(articles: articles, page: page, atEnd: atEnd, error: error)
                }
            }
        }
    }

    private func handleNextPageResults(articles: [Article]?, page: Int, atEnd: Bool, error: CosmosError?) {
        DispatchQueue.main.async { [weak self] in
            if let articles = articles,
                !articles.isEmpty {
                self?.currentPage = page
                self?.atEnd = atEnd
                self?.edition?.add(articles: articles, page: page)
            } else {
                self?.atEnd = true
            }
            self?.tableView?.reloadData()
            self?.loadingNextPage = false
        }
    }

    func configureStickyHeader(title: String) {
        DispatchQueue.main.async {
            self.addHeaderView(title: title, theme: self.cosmos.theme, tableView: self.tableView)
        }
    }
}
