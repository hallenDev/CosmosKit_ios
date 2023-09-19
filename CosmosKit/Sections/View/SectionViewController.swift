import UIKit

public class SectionViewController: CosmosBaseViewController, SearchableViewController {

    // MARK: Search Button in the top Nav

    var search: SearchButton!

    // MARK: VC Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSearchButton(search, animated: false)
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
        tableView?.separatorColor = cosmos.theme.separatorColor
    }

    // MARK: Section View Model & API Content
    var sectionsViewModel: SectionsViewModel! {
        didSet {
            if activityIndicator != nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stop()
                    self.tableView?.backgroundView = nil
                    self.tableView?.reloadData()
                }
            }
        }
    }

    func configureContent() {
        activityIndicator.start()
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            cosmos.getAllSections { sections, error in
                if let sections = sections {
                    let sectionVMs = sections.compactMap { return SectionViewModel(section: $0) }
                    let backup = self.sectionsViewModel!
                    self.sectionsViewModel = SectionsViewModel(renderType: backup.renderType, sections: sectionVMs)
                } else {
                    self.showContentFailure()
                    self.cosmos.errorDelegate?.cosmos(received: error)
                }
            }
        }
    }

    func getSectionViewModel(for indexPath: IndexPath) -> SectionViewModel? {
        if indexPath.row == 0 {
            return getSection(for: indexPath)
        } else {
            return getSubSection(for: indexPath)
        }
    }

    func getSection(for indexPath: IndexPath) -> SectionViewModel? {
        return sectionsViewModel?.sections[indexPath.section]
    }

    func getSubSection(for indexPath: IndexPath) -> SectionViewModel? {
        return getSection(for: indexPath)?.subSections?[indexPath.row - 1]
    }

    func updateCells(with update: SectionViewModel, at section: Int) {
        guard var sections = sectionsViewModel?.sections,
            section < sections.count
        else {
            return
        }

        for index in 0 ..< sections.count {
            sections[index].expanded = false
        }

        sections[section] = update
        let backup = self.sectionsViewModel.renderType
        self.sectionsViewModel = SectionsViewModel(renderType: backup, sections: sections)
    }

    // MARK: Network reachability

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        configureContent()
    }
}

// MARK: TableView Delegate and TableView Datasource methods
extension SectionViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = getSectionViewModel(for: indexPath) else {
            // fallback to an empty cell - ideally should not reach this
            let cell = UITableViewCell()
            cell.backgroundColor = cosmos.theme.backgroundColor
            cell.contentView.backgroundColor = cosmos.theme.backgroundColor
            return cell
        }

        var cell: UITableViewCell

        // main section
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath)
            (cell as? SectionTableViewCell)?.configure(with: section, theme: cosmos.theme)
            (cell as? SectionTableViewCell)?.stateChanged = { update in
                self.updateCells(with: update, at: indexPath.section)
            }
        } else { // subsection
            let hideSeperator = tableView.numberOfRows(inSection: indexPath.section) != indexPath.row + 1

            cell = tableView.dequeueReusableCell(withIdentifier: "SubSectionTableViewCell", for: indexPath)
            (cell as? SubSectionTableViewCell)?.configure(with: section, theme: cosmos.theme, hideSeperator: hideSeperator)
        }

        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsViewModel?.sections.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionVM = sectionsViewModel?.sections[section],
            sectionVM.expanded else {
                return 1 // if not expanded we only want the main section to show
        }

        return ((sectionVM.subSections?.count) ?? 0) + 1
    }

    /// handles showing the list of articles for a section
    fileprivate func showLiveSection(_ indexPath: IndexPath) {
        var section = getSection(for: indexPath)!

        if section.isAuthor {
            let articleListView = cosmos.getAuthorsListView()
            self.navigationController?.pushViewController(articleListView, animated: true)
            return
        }

        if indexPath.row == 0 {
            if section.isLinkSection, let link = section.link, let url = URL(string: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else if let slug = section.articleSlug {
                openArticle(slug: slug)
            } else {
                let articleListView = cosmos.getArticleList(section: section)
                self.navigationController?.pushViewController(articleListView, animated: true)
            }
        } else if let subSection = getSubSection(for: indexPath) {
            section.subSections = [subSection]
            if subSection.isLinkSection, let link = subSection.link, let url = URL(string: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else if let slug = subSection.articleSlug {
                openArticle(slug: slug)
            } else if subSection.isForeignSection {
                let articleListView = cosmos.getArticleList(section: subSection)
                self.navigationController?.pushViewController(articleListView, animated: true)
            } else {
                let articleListView = cosmos.getArticleList(subSection: section)
                self.navigationController?.pushViewController(articleListView, animated: true)
            }
        } else {
            showContentFailure()
        }
    }

    // for custom sections that are actually articles
    func openArticle(slug: String) {
        let article = ArticleViewModel(slug: slug, as: .live)
        openArticle(viewModel: article)
    }

    // for custom sections that are actually articles
    func openArticle(key: Int64) {
        let article = ArticleViewModel(key: key, as: .live)
        openArticle(viewModel: article)
    }

    // custom sections that are actually articles
    func openArticle(viewModel: ArticleViewModel) {
        let pager = ArticlePagerViewController(cosmos: cosmos, articles: [viewModel], currentArticle: viewModel)
        DispatchQueue.main.async {
            self.hidesBottomBarWhenPushed = true
            self.show(pager, sender: self)
            self.hidesBottomBarWhenPushed = false
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()

        guard let section = getSection(for: indexPath) else { return }

        if sectionsViewModel.renderType == .edition {
            let editionView = cosmos.getEditionList(in: section)
            self.navigationController?.pushViewController(editionView, animated: true)
        } else {
            showLiveSection(indexPath)
        }
    }
}
