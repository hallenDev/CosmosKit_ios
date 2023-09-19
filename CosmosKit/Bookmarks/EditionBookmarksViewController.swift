import UIKit
import AMScrollingNavbar

public class EditionBookmarksViewController: CosmosBaseViewController, SearchableViewController {

    var edition: EditionViewModel? {
        didSet {
            if edition != oldValue {
                tableView?.reloadData()
            }
        }
    }

    var search: SearchButton!

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadBookmarks()
        (navigationController as? ScrollingNavigationController)?.stopFollowingScrollView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSearchButton(search, animated: false)
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
    }

    public func configureDataSource(for articles: [Article]) {
        self.edition = EditionViewModel(from: articles,
                                        section: SectionViewModel(name: headerTitle),
                                        endOfList: true)
        if articles.isEmpty {
            showContentFailure()
        } else {
            tableView?.backgroundView = nil
        }
        tableView?.isScrollEnabled = !articles.isEmpty
    }

    func reloadBookmarks() {
        self.configureDataSource(for: cosmos.getBookmarks())
    }
}
extension EditionBookmarksViewController: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        edition?.sections.count ?? 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        edition?.sections[section].articles.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditionArticleSmall", for: indexPath)
        if let article = edition?.sections[indexPath.section].articles[indexPath.row] {
            (cell as? EditionArticleCell)?.configure(with: article, cosmos: cosmos)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let article = edition?.sections[indexPath.section].articles[indexPath.row] {
            let articles = edition?.sections.flatMap { $0.articles } ?? []
            let pager = ArticlePagerViewController(cosmos: cosmos, articles: articles, currentArticle: article)
            pager.articleChanged = scrollTo
            DispatchQueue.main.async {
                self.hidesBottomBarWhenPushed = true
                self.show(pager, sender: self)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }

    func scrollTo(article: ArticleViewModel) {
        if let indexPath = edition?.indexPath(for: article) {
            tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
