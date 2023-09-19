import UIKit
import AMScrollingNavbar
import Reachability

public class MediaViewController: CosmosBaseViewController, SearchableViewController, InfiniteScrollable {

    var cellHeights: [IndexPath: CGFloat] = [:] // Used to prevent jitter when reloading
    var isScrollable = true
    var currentPage = 1
    var loadingNextPage = false
    var atEnd = false
    var loadNextPage: (() -> Void)?

    var search: SearchButton!
    var viewModel: MediaListViewModel!
    var refreshController: CosmosRefreshControl!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDataSource()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSearchButton(search, animated: false)
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
    }

    override func configureTableHeaderView() {
        guard viewModel.title != nil else { return }
        super.configureTableHeaderView()
    }

    @objc func configureDataSource() {
        activityIndicator.start()
        loadNextPage = loadNextMediaPage
        if reachability?.connection == .unavailable {
            tableView?.bounces = false
            showNetworkFailure()
        } else {
            tableView?.bounces = true
            cosmos.getMedia(audio: viewModel.type == .audio) { [weak self] media, _, error in
                if let media = media {
                    self?.setDataSource(media)
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

    func configureView() {
        configureRefreshControl()
        addSearchButton(search, animated: false)
    }

    func configureRefreshControl() {
        refreshController = CosmosRefreshControl(tintColor: cosmos.theme.accentColor)
        refreshController.addTarget(self, action: #selector(configureDataSource), for: .valueChanged)
        tableView?.refreshControl = refreshController
    }

    func setDataSource(_ media: [Media]) {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.viewModel.add(media: media)
            self.tableView?.reloadData()
            self.refreshController.endRefreshing()
        }
    }

    func loadNextMediaPage() {
        guard !atEnd else { return }
        loadingNextPage = true
        let page = currentPage + 1
        cosmos.getMedia(audio: viewModel.type == .audio, page: page) { [weak self] media, atEnd, error in
            if let media = media,
                !media.isEmpty {
                self?.viewModel.add(media: media)
                self?.currentPage += 1
                self?.atEnd = atEnd
            } else {
                self?.atEnd = true
                self?.cosmos.errorDelegate?.cosmos(received: error)
            }

            DispatchQueue.main.async {
                self?.tableView?.reloadData()
                self?.loadingNextPage = false
            }
        }
    }
}

extension MediaViewController: UITableViewDataSource, UITableViewDelegate {

    fileprivate func addCustomTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
    }

    fileprivate func loadVideoPlayer(viewModel: MediaViewModel, viewController: MediaPlayable) {
        cosmos.logger?.log(event: CosmosEvents.videoPlayed(key: "\(viewModel.articleKey)", url: viewModel.url ?? "NA"))
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        addCustomTransition()
        present(viewController, animated: false, completion: nil)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let media = viewModel.getMedia(at: indexPath) else { return }
        switch media.mediaType {
        case .bibliodam:
            loadVideoPlayer(viewModel: media, viewController: FullscreenVideoPlayer())
        case .youtube:
            let viewcontroller = FullscreenYoutubeVideoPlayer()
            viewcontroller.setupController(cosmos: cosmos, fallback: cosmos.fallbackConfig.apiErrorFallback)
            loadVideoPlayer(viewModel: media, viewController: viewcontroller)
        case .iono:
            cosmos.logger?.log(event: CosmosEvents.audioArticleOpened(key: "\(media.articleKey)", title: media.title))
            let rendertype: ArticleRenderType = cosmos.isEdition ? .edition : .live
            let audioArticle = ArticleViewModel(key: media.articleKey, as: rendertype)
            let pager = ArticlePagerViewController(cosmos: cosmos, articles: [audioArticle], currentArticle: audioArticle)
            DispatchQueue.main.async {
                self.hidesBottomBarWhenPushed = true
                self.show(pager, sender: self)
                self.hidesBottomBarWhenPushed = false
            }
        case .oovvuu:
            loadVideoPlayer(viewModel: media, viewController: FullscreenOovvuuVideoPlayer())
            break
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = viewModel.mediaCount()
        guard contentCount != 0 else { return 0 }
        return (isScrollable && !atEnd) ? contentCount + 1 : contentCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let media = viewModel.getMedia(at: indexPath) else {
            return UITableViewCell()
        }

        if isScrollable,
            indexPath.row == viewModel.mediaCount() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoLoadingCell", for: indexPath)
            let background = cosmos.videosTheme?.backgroundColor ?? cosmos.theme.backgroundColor
            (cell as? EditionLoadingCell)?.set(theme: cosmos.theme, backgroundColor: background)
            return cell
        }

        switch media.mediaType {
        case .iono:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)
            (cell as? AudioCell)?.configure(for: media, cosmos: cosmos)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
            (cell as? VideoCell)?.configure(for: media, cosmos: cosmos) { [weak self] key in
                guard let strongSelf = self else { return }
                let rendertype: ArticleRenderType = strongSelf.cosmos.isEdition ? .edition : .live
                let videoArticle = ArticleViewModel(key: key, as: rendertype)
                let pager = ArticlePagerViewController(cosmos: strongSelf.cosmos, articles: [videoArticle], currentArticle: videoArticle)
                DispatchQueue.main.async {
                    strongSelf.hidesBottomBarWhenPushed = true
                    strongSelf.show(pager, sender: strongSelf)
                    strongSelf.hidesBottomBarWhenPushed = false
                }

            }
            return cell
        }
    }
}

extension MediaViewController {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.scrolledToBottom,
            isScrollable,
            !loadingNextPage {
            loadNextPage?()
        }
    }
}
