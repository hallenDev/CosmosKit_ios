// swiftlint:disable line_length force_cast
import UIKit
import Reachability

public class PastEditionsViewController: CosmosBaseViewController, InfiniteScrollable, SearchableViewController {

    var loadNextPage: (() -> Void)?
    var cellHeights: [IndexPath: CGFloat] = [:]
    var isScrollable: Bool = true
    var currentPage: Int = 1
    var atEnd: Bool = false {
        didSet {
            if atEnd != oldValue {
                if atEnd {
                    collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInterItemSpacing, bottom: 32, right: horizontalInterItemSpacing)
                } else {
                    collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInterItemSpacing, bottom: 0, right: horizontalInterItemSpacing)
                }
                collectionViewLayout.invalidateLayout()
            }
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerLabel: HeaderLabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!

    var isLoadingNextPage: Bool = false
    var search: SearchButton!

    var viewModel: PastEditionsViewModel!

    private var isRegularSizeClass: Bool {
        return traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
    }
    private var horizontalInterItemSpacing: CGFloat = 8
    private var horizontalContentInset: CGFloat {
        return isRegularSizeClass ? 64 : 8
    }
    private var totalHorizontalContentSpacing: CGFloat {
        return horizontalInterItemSpacing * 4 + horizontalContentInset * 2
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCustomHeader()
        configureLoadingFooter()
        loadViewModel()
        loadNextPage = loadMoreEditions
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSearchButton(search, animated: false)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    public override func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        super.setupController(cosmos: cosmos, headerTitle: headerTitle, fallback: fallback, event: event)
        search = SearchButton(cosmos)
    }

    override func applyTheme() {
        super.applyTheme()
        collectionView.backgroundColor = cosmos.theme.backgroundColor
    }

    func configureCollectionView() {
        collectionViewLayout.sectionHeadersPinToVisibleBounds = false
        collectionViewLayout.sectionFootersPinToVisibleBounds = false
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInterItemSpacing, bottom: 0, right: horizontalInterItemSpacing)
        collectionViewLayout.footerReferenceSize = .zero
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalContentInset, bottom: 0, right: horizontalContentInset)
    }

    override func configureTableHeaderView() {
        // nothing as this class manages its own header
    }

    func configureCustomHeader() {
        headerLabel.text = headerTitle
        headerLabel.backgroundColor = cosmos.viewHeaderTheme.backgroundColor
        headerView.backgroundColor = cosmos.viewHeaderTheme.backgroundColor
        if cosmos.viewHeaderTheme.style == .compressed {
            self.headerViewHeightConstraint.constant /= 2
        }
    }

    override func showContentFailure() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.loadFallback(fallback: self.fallback)
        }
    }

    override func showNetworkFailure() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.loadFallback(fallback: self.cosmos.fallbackConfig.noNetworkFallback)
        }
    }

    fileprivate func loadFallback(fallback: Fallback) {
        let viewc: FallbackViewController = CosmosStoryboard.loadViewController()
        collectionView.backgroundView = viewc.view
        viewc.configure(fallback: fallback, cosmos: cosmos)
    }

    func configureLoadingFooter() {
        self.collectionView.register(UINib(nibName: "LoadingFooter", bundle: Bundle.cosmos),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: "LoadingFooter")

    }

    public override func handleComingBackOnline() {
        super.handleComingBackOnline()
        loadViewModel()
    }

    func loadViewModel() {
        activityIndicator.start()
        currentPage = 1
        if reachability?.connection == .unavailable {
            atEnd = true
            loadOfflineViewModel()
            if collectionView.backgroundView == nil {
                cosmos.errorDelegate?.cosmos(received: CosmosError.networkError(nil))
            }
        } else {
            atEnd = false
            loadOnlineViewModel()
        }
    }

    func loadOfflineViewModel() {
        guard let oldVM = self.viewModel else { return }

        if let editions = cosmos.getOfflinePastEditions(),
            !editions.isEmpty {
            self.viewModel = PastEditionsViewModel(from: editions, section: oldVM.apiSection, cosmos: cosmos)
            self.loadCollectionView()
        } else {
            self.showNetworkFailure()
        }
    }

    func loadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stop()
            self?.collectionView?.backgroundView = nil
            self?.collectionView?.reloadData()
        }
    }

    func loadOnlineViewModel() {
        guard let oldVM = self.viewModel, let include = cosmos.editionConfig?.showAllPastEditions else { return }

        cosmos.getPastEditions(section: oldVM.apiSection, includeLatest: include, limit: 11, page: 1) { [weak self] editions, atEnd, error in
            guard let strongSelf = self else { return }
            strongSelf.atEnd = atEnd
            if let editions = editions {
                strongSelf.viewModel = PastEditionsViewModel(from: editions,
                                                             section: oldVM.apiSection,
                                                             cosmos: strongSelf.cosmos)
                strongSelf.loadCollectionView()
            } else {
                strongSelf.cosmos.errorDelegate?.cosmos(received: error)
                strongSelf.showContentFailure()
            }
        }
    }

    func readEdition(_ edition: PastEditionViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let editionView = strongSelf.cosmos.getEditionView(for: edition.key)
            strongSelf.navigationController?.pushViewController(editionView, animated: true)
        }
    }
}

// MARK: UICollectionView Delegate & UICollectionView DataSource

extension PastEditionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard viewModel.featuredContent else { return .zero }
        return CGSize(width: self.view.frame.width, height: 380)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let edition = viewModel?.edition(for: indexPath) {
            self.readEdition(edition)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowCount()
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionCount()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastEditionCell", for: indexPath) as! PastEditionCell
        if let edition = viewModel?.edition(for: indexPath) {
            cell.configure(with: edition)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: UICollectionReusableView

        if kind == UICollectionView.elementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeaturedPastEdition", for: indexPath)
            if let first = viewModel.editions.first, let featured = view as? FeaturedPastEditionHeader {
                featured.configure(with: first, theme: cosmos.editionTheme, openFeature: { [weak self] in
                    if let edition = self?.viewModel?.featuredEdition {
                        self?.readEdition(edition)
                    }
                })
            }
        } else {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingFooter", for: indexPath)
            (view as? LoadingFooter)?.configure(theme: cosmos.theme)
        }
        return view
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PastEditionsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - (totalHorizontalContentSpacing / 2), height: 320)
    }
}

// MARK: Infinite scrolling
extension PastEditionsViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel?.editions.count ?? 0 > 0, scrollView.scrolledToBottom, !atEnd {
            if reachability?.connection == .unavailable {
                atEnd = true
                if collectionView.backgroundView == nil {
                    cosmos.errorDelegate?.cosmos(received: CosmosError.networkError(nil))
                }
            } else {
                loadNextPage?()
            }
        }
    }

    private func loadMoreEditions() {
        guard let include = cosmos.editionConfig?.showAllPastEditions else { return }
        if !isLoadingNextPage, !atEnd {
            isLoadingNextPage = true
            DispatchQueue.main.async { [weak self] in
                self?.collectionViewLayout?.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
                self?.collectionViewLayout.invalidateLayout()
            }
            let page = currentPage + 1
            cosmos.getPastEditions(section: self.viewModel.apiSection, includeLatest: include, limit: 10, page: page) { editions, atEnd, _ in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    if let editions = editions {
                        strongSelf.viewModel?.add(editions, theme: strongSelf.cosmos.theme)
                        strongSelf.currentPage += 1
                    }
                    strongSelf.atEnd = atEnd
                    strongSelf.collectionViewLayout.footerReferenceSize = .zero
                    strongSelf.collectionViewLayout.invalidateLayout()
                    strongSelf.collectionView.reloadData()
                    strongSelf.isLoadingNextPage = false
                }
            }
        }
    }
}
