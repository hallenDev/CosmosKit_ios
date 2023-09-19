import UIKit
import Reachability
import Lottie
import AMScrollingNavbar

public class WidgetStackViewController: CosmosBaseViewController, SearchableViewController {

    @IBOutlet var container: UIStackView!
    @IBOutlet var scroll: UIScrollView!

    var search: SearchButton!
    var viewModel: WidgetStackViewModel!
    private var lastDifference: CGFloat = 0

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
        loadWidgets()
        if #available(iOS 13.0, *), viewModel.forceLightMode {
            overrideUserInterfaceStyle = .light
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSearchButton(search, animated: false)
    }

    public func setupController(cosmos: Cosmos, viewModel: WidgetStackViewModel) {
        setupController(cosmos: cosmos, headerTitle: viewModel.title, fallback: viewModel.fallback, event: viewModel.event)
        self.viewModel = viewModel
        search = SearchButton(cosmos)
    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        loadWidgets()
    }

    func loadWidgets() {
        activityIndicator.start()
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else {
            container.arrangedSubviews.forEach { $0.removeFromSuperview() }
            container.addArrangedSubview(createArticleWidgetSpacer())
            for widget in viewModel.widgets {
                addWidget(widget)
            }
        }
    }

    fileprivate func addWidget(_ widget: WidgetViewModel, addSpacer: Bool = true) {

        let view = widget.getView(cosmos: cosmos,
                                  as: viewModel.renderType,
                                  relatedSelected: relatedArticleSelected)
        if let imageWidget = view as? ArticleImage {
            imageWidget.parentView = (container, 0)
        } else if let galleryWidget = view as? ArticleGallery {
            galleryWidget.parentView = (container, 0)
        } else if let crossword = view as? ArticleCrossword {
            crossword.delegate = self
            crossword.parentController = self
        } else if let webWidget = view as? ArticleWebView {
            webWidget.delegate = self
            webWidget.cosmos = cosmos
        }

        if widget.type != .marketData && widget.type != .url {
            view.backgroundColor = cosmos.theme.backgroundColor
            view.subviews.forEach { $0.backgroundColor = cosmos.theme.backgroundColor }
        }

        container.addArrangedSubview(view)
        if addSpacer {
            container.addArrangedSubview(createArticleWidgetSpacer())
        }
    }

    fileprivate func createArticleWidgetSpacer() -> ArticleSpacer {
        let frameWidth = self.view.frame.width
        return ArticleSpacer(width: frameWidth, height: 16, color: cosmos.theme.backgroundColor)
    }

    override func relatedArticleSelected(key: Int64) {
        let renderType = viewModel.renderType
        let relatedArticle = ArticleViewModel(key: key, as: renderType)
        let pager = ArticlePagerViewController(cosmos: cosmos, articles: [relatedArticle], currentArticle: relatedArticle)
        DispatchQueue.main.async {
            (self.navigationController as? ScrollingNavigationController)?.showNavbar()
            self.hidesBottomBarWhenPushed = true
            self.show(pager, sender: self)
        }
    }
}

extension WidgetStackViewController: ArticleCrosswordWidgetDelegate {
    func handleNoConnectivityButtonTap(crossword: ArticleCrossword) {
        cosmos.errorDelegate?.cosmos(received: CosmosError.networkError(nil))
    }
}

extension WidgetStackViewController: ArticleWebWidgetDelegate {
    func webWidget(_ widget: ArticleWebView, didResize difference: CGFloat) {
        if difference == 0 {
            activityIndicator.stop()
        }
        if widget.frame.maxY < self.scroll.contentOffset.y {
            DispatchQueue.main.async {
                self.scroll.contentOffset = CGPoint(x: self.scroll.contentOffset.x,
                                                    y: self.scroll.contentOffset.y + difference)
            }
        }
    }
}
