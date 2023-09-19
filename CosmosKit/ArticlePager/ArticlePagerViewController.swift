// swiftlint:disable line_length
import UIKit
import AMScrollingNavbar

class ArticlePagerViewController: UIPageViewController {

    enum Context {
        case standard
        case pushNotification
    }

    var viewContext: ArticlePagerViewController.Context = .standard
    var cosmos: Cosmos
    var articleChanged: ((ArticleViewModel) -> Void)?
    var bookmarkButton: UIButton!
    var commentButton: UIButton!
    var shareBarButton: UIBarButtonItem?
    var viewModel: ArticlePagerViewModel!

    private var isRegularSizeClass: Bool {
        return traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
    }

    private var shouldHideLogo: Bool {
        guard viewContext == .standard else { return false }
        return view.bounds.width < 350 || cosmos.uiConfig.shouldNavHideLogo
    }

    init(cosmos: Cosmos, articles: [ArticleViewModel], currentArticle: ArticleViewModel) {
        self.cosmos = cosmos
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        let currentView: ArticleViewController
        switch currentArticle.state {
        case .loaded:
            currentView = cosmos.getView(for: currentArticle, relatedSelected: { [weak self] key in
                self?.relatedArticleSelected(key: key)
            })
        default:
            if let slug = currentArticle.slug, currentArticle.key == -1 {
                currentView = loadArticle(from: slug, as: currentArticle.renderType)
            } else {
                currentView = loadArticle(from: currentArticle.key, as: currentArticle.renderType)
            }
        }
        viewModel = ArticlePagerViewModel(articles: articles, currentArticleView: currentView, cosmos: cosmos)
        refreshView()
        delegate = self
        dataSource = self

        setViewControllers([viewModel.currentArticleView],
                           direction: .forward,
                           animated: false, completion: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("Create only from code")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        hideBackButtonTitle()
    }

    func refreshView() {
        self.navigationItem.setRightBarButtonItems([], animated: false)
        configureArticleSharing()
        configureArticleBookmarking()
        // configureArticleComments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if commentButton != nil {
            self.configureCommentIcon()
        }
        refreshView()
        if viewContext == .pushNotification {
            addLogo()
            addClose()
            if let frame = navigationController?.navigationBar.frame {
                let progress = StatusView()
                self.navigationController?.navigationBar.addSubview(progress)
                progress.updateY(frame.height, width: frame.width)
            }
        }
    }

    @objc func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func addLogo() {
        let newTitleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        newTitleView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        newTitleView.image = cosmos.theme.logo
        newTitleView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = newTitleView
    }

    func addClose() {
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismiss(_:))), animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.closeDropdownIfNeeded()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        articleChanged?(viewModel.currentArticle)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard viewContext == .standard else { return }
        if shouldHideLogo {
            navigationController?.navigationBar.items?.last?.titleView = nil
        } else if navigationController?.navigationBar.items?.last?.titleView == nil {
            navigationController?.navigationBar.configureNav(cosmos: cosmos)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        refreshView()
    }

    func configureArticleComments() {
        guard viewModel.currentCommentsEnabled else { return }

        commentButton = UIButton(type: .custom)
        commentButton.titleEdgeInsets = UIEdgeInsets(top: -6, left: 0, bottom: 0, right: 0)

        commentButton.setBackgroundImage(UIImage(cosmosName: .comments), for: .normal)
        commentButton.tintColor = cosmos.navigationTheme.buttonTextColor
        if isRegularSizeClass {
            commentButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        } else {
            commentButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        commentButton.sizeToFit()
        commentButton.addTarget(self, action: #selector(self.openComments), for: .touchUpInside)
        commentButton.tintColor = cosmos.navigationTheme.buttonColor

        configureCommentIcon()
        let commentBarButton = UIBarButtonItem(customView: commentButton)
        self.navigationItem.rightBarButtonItems?.append(commentBarButton)
    }

    func configureArticleBookmarking() {
        guard viewModel.showBookmarks else { return }

        let barImage = getBookmarkIcon(selected: viewModel.currentBookmarked)
        bookmarkButton = UIButton(type: .custom)
        if isRegularSizeClass {
            bookmarkButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        } else {
            bookmarkButton.frame = CGRect(x: 0, y: 0, width: 26, height: 30)
        }
        bookmarkButton.setImage(barImage, for: .normal)
        bookmarkButton.addTarget(self, action: #selector(self.bookmarkArticle), for: .touchUpInside)
        bookmarkButton.tintColor = cosmos.navigationTheme.buttonColor
        let bookmarkBarBtn = UIBarButtonItem(customView: bookmarkButton)

        self.navigationItem.rightBarButtonItems?.append(bookmarkBarBtn)
    }

    func configureArticleSharing() {
        guard viewModel.showSharing else { return }
        let button = UIButton(type: .custom)
        if isRegularSizeClass {
            button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        } else {
            button.frame = CGRect(x: 0, y: 0, width: 26, height: 30)
        }
        button.setImage(UIImage(cosmosName: .share), for: .normal)
        button.addTarget(self, action: #selector(self.shareArticle), for: .touchUpInside)
        button.tintColor = cosmos.navigationTheme.buttonColor
        let barBtn = UIBarButtonItem(customView: button)
        self.shareBarButton = barBtn

        self.navigationItem.rightBarButtonItems?.append(barBtn)
    }

    @objc public func openComments() {
        if cosmos.isLoggedIn {
            let commentView: CommentViewController = CosmosStoryboard.loadViewController()
            commentView.setupController(cosmos: cosmos,
                                        fallback: cosmos.fallbackConfig.apiErrorFallback,
                                        event: CosmosEvents.comments(slug: viewModel.currentArticle.slug ?? "NA"))
            commentView.configureComments(for: viewModel.currentArticle)
            self.hidesBottomBarWhenPushed = true
            self.show(commentView, sender: self)
        } else {
            let login = cosmos.getAuthorisationView()
            login.didFinish = {
                DispatchQueue.main.async {
                    if self.cosmos.isLoggedIn {
                        self.openComments()
                    } else {
                        print("error")
                    }
                }
            }
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true, completion: nil)
        }
    }

    @objc public func shareArticle() {
        let url = URL(string: "\(cosmos.publication.domain)\(viewModel.currentShareURL ?? "")")
        cosmos.eventDelegate?.cosmosShareArticle?(articleTitle: viewModel.currentTitle, articleUrl: url, sender: shareBarButton)
    }

    @objc public func bookmarkArticle() {
        if viewModel.currentBookmarked {
            _ = cosmos.removeBookmark(key: viewModel.currentArticle.article?.key)
            let slug = viewModel.currentArticle.article?.slug ?? "NA"
            cosmos.logger?.log(event: CosmosEvents.bookmarkRemoved(slug: slug))
        } else {
            _ = cosmos.bookmark(viewModel.currentArticle.article)
            let slug = viewModel.currentArticle.article?.slug ?? "NA"
            cosmos.logger?.log(event: CosmosEvents.bookmarked(slug: slug))
        }
        switchBookmarkIcon()
    }

    func switchBookmarkIcon() {
        let barImage = getBookmarkIcon(selected: viewModel.currentBookmarked)
        bookmarkButton?.setImage(barImage, for: .normal)
        bookmarkButton?.tintColor = cosmos.navigationTheme.buttonColor
    }

    private func getBookmarkIcon(selected: Bool) -> UIImage {
        selected ? UIImage(cosmosName: .bookmarkSelected) : UIImage(cosmosName: .bookmarkUnselected)
    }

    func configureCommentIcon() {
        guard viewModel.currentCommentsEnabled,
              cosmos.publication.commentConfig is DisqusConfig,
              let url = viewModel.currentShareURL,
              let slug = viewModel.currentSlug else {
            return
        }
        cosmos.getComments(for: url, slug: slug) { comments, _ in
            DispatchQueue.main.async {
                var amount = ""
                if let commentAmount = comments {
                    switch commentAmount {
                    case 1...99: amount = "\(commentAmount)"
                    case 0 : amount = ""
                    default: amount = "99+"
                    }
                }
                self.addCommentTitle(amount)
            }
        }
    }

    func addCommentTitle(_ title: String) {
        commentButton.setTitle(title, for: .normal)
        commentButton.setTitleColor(cosmos.navigationTheme.buttonTextColor, for: .normal)
        let backupFont = commentButton.titleLabel?.font
        commentButton.titleLabel?.font = UIFont(descriptor: backupFont!.fontDescriptor, size: 13)
    }

    func loadArticle(from slug: String, as renderType: ArticleRenderType) -> ArticleViewController {
        return cosmos.getView(for: slug,
                              as: renderType,
                              relatedSelected: { [weak self] key in
                                self?.relatedArticleSelected(key: key)
        })
    }

    func loadArticle(from key: Int64, as renderType: ArticleRenderType) -> ArticleViewController {
        return cosmos.getView(for: key,
                              as: renderType,
                              relatedSelected: { [weak self] key in
                                self?.relatedArticleSelected(key: key)
        })
    }

    func refreshArticles(with freshArticle: ArticleViewModel) {
        viewModel.updateContent(freshArticle)
        self.refreshView()
    }
}

extension ArticlePagerViewController: UIPageViewControllerDataSource {

    fileprivate func getView(at index: Int) -> UIViewController? {
        let content = viewModel.getContent(at: index)

        if let adContent = content as? AdArticle {
            let viewC: PagerAdViewController = CosmosStoryboard.loadViewController()
            viewC.cosmos = cosmos
            viewC.placement = adContent.adPlacement
            viewC.identifier = adContent
            return viewC
        } else if let article = content as? ArticleViewModel {
            if article.state == .loading {
                return cosmos.getView(for: article.key,
                                      as: article.renderType,
                                      relatedSelected: { [weak self] key in
                                        self?.relatedArticleSelected(key: key)
                })
            } else if article.state == .loaded {
                return cosmos.getView(for: article, relatedSelected: { [weak self] key in
                    self?.relatedArticleSelected(key: key)
                })
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewModel.contentCount > 1,
            let current = viewModel.currentIndex(viewController),
            (current - 1) >= 0
            else { return nil }

        return getView(at: current - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewModel.contentCount > 1,
            let current = viewModel.currentIndex(viewController),
            (current + 1) < viewModel.contentCount
            else { return nil }

        return getView(at: current + 1)
    }

    func relatedArticleSelected(key: Int64) {
        let renderType = viewModel.currentArticle.renderType
        let relatedArticle = ArticleViewModel(key: key, as: renderType)
        let pager = ArticlePagerViewController(cosmos: cosmos, articles: [relatedArticle], currentArticle: relatedArticle)
        DispatchQueue.main.async {
            (self.navigationController as? ScrollingNavigationController)?.showNavbar()
            self.hidesBottomBarWhenPushed = true
            self.show(pager, sender: self)
        }
    }
}

extension ArticlePagerViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let currentConverted = pageViewController.viewControllers?.first as? ArticleViewController {
                viewModel.setCurrentArticleView(currentConverted)
            } else if let pagerView = pageViewController.viewControllers?.first as? PagerAdViewController {
                viewModel.setCurrentIndex(pagerView.identifier.key)
            }
            refreshView()
        }
    }
}
