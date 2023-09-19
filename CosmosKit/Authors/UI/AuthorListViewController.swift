import UIKit
import AMScrollingNavbar

public class AuthorListViewController: CosmosBaseViewController, InfiniteScrollable {

    var cellHeights: [IndexPath: CGFloat] = [:] // Used to prevent jitter when reloading
    var isScrollable = true
    var currentPage = 1
    var loadingNextPage = false
    var atEnd = false
    var loadNextPage: (() -> Void)?

    var refreshController: CosmosRefreshControl!
    var viewModel: AuthorsViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        configureDataSource()
    }

    @objc func configureDataSource() {
        activityIndicator.start()
        loadNextPage = loadNextAuthorsPage
        if reachability?.connection == .unavailable {
            tableView?.bounces = false
            showNetworkFailure()
        } else {
            tableView?.bounces = true
            cosmos.getAuthors { [weak self] authors, _, error in
                if let authors = authors {
                    self?.setDataSource(authors)
                } else {
                    self?.showContentFailure()
                    self?.cosmos.errorDelegate?.cosmos(received: error)
                }
            }
        }
    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        configureDataSource()
    }

    func configureRefreshControl() {
        refreshController = CosmosRefreshControl(tintColor: cosmos.theme.accentColor)
        refreshController.addTarget(self, action: #selector(configureDataSource), for: .valueChanged)
        tableView?.refreshControl = refreshController
    }

    func setDataSource(_ authors: [Author]) {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.viewModel = AuthorsViewModel(authors: authors.map { AuthorViewModel(from: $0) })
            self.tableView?.reloadData()
            self.refreshController.endRefreshing()
        }
    }

    func loadNextAuthorsPage() {
        guard !atEnd else { return }
        loadingNextPage = true
        let page = currentPage + 1
        cosmos.getAuthors(page: page) { authors, atEnd, error in
            if let authors = authors,
                !authors.isEmpty {
                self.viewModel?.add(authors: authors.map { AuthorViewModel(from: $0) })
                self.currentPage += 1
                self.atEnd = atEnd
            } else {
                self.atEnd = true
                self.cosmos.errorDelegate?.cosmos(received: error)
            }

            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.loadingNextPage = false
            }
        }
    }
}

extension AuthorListViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let author = viewModel?.authors[indexPath.row] else { return }
        let viewController = cosmos.getAuthorsArticlesView(author: author)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 100 }
        return height
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let contentCount = viewModel.count
        return (isScrollable && !atEnd) ? contentCount + 1 : contentCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }

        if isScrollable,
            indexPath.row == viewModel.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorLoadingCell", for: indexPath)
            (cell as? EditionLoadingCell)?.set(theme: cosmos.theme)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath)
        (cell as? AuthorCell)?.configure(viewModel: viewModel.authors[indexPath.row], theme: cosmos.theme)
        return cell
    }
}
// MARK: Scrolling delegate methods
extension AuthorListViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.scrolledToBottom,
            isScrollable,
            !loadingNextPage {
            loadNextPage?()
        }
    }
}
