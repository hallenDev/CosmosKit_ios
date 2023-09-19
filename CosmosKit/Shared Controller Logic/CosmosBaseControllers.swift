import UIKit
import Reachability

public class CosmosBaseViewController: UIViewController, FallbackConfigurableViewController,
                                       ReachableViewController, HeaderEnabledViewController,
                                       CosmosActivityEnabledViewController {

    // MARK: values that need to be setup before the viewcontroller is shown
    var fallback: Fallback!
    var cosmos: Cosmos!
    var headerTitle: String!
    var analyticsEvent: CosmosEvent?
    var fallbackView: UIView?
    var activityIndicator: CosmosActivityIndicator!
    var reachability: Reachable? = try? Reachability()
    var wasUnreachable = false

    @IBOutlet var tableView: UITableView?

    public override func viewDidLoad() {
        super.viewDidLoad()

        checkControllerIsReady()

        (reachability as? Reachability)?.whenReachable = { [weak self] _ in
            guard let strongSelf = self, strongSelf.wasUnreachable else { return }
            self?.handleComingBackOnline()
            self?.wasUnreachable = false
        }
        (reachability as? Reachability)?.whenUnreachable = { [weak self] _ in
            self?.wasUnreachable = true
        }
        configureActivityIndicator()
        applyTheme()
        registerCustomCells()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try (reachability as? Reachability)?.startNotifier()
        } catch {
            print("WARNING: Unable to start reachability notifier in BaseCosmosTableViewController")
        }
        configureTableHeaderView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.configureNavbar()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (reachability as? Reachability)?.stopNotifier()
    }

    /**
     This method is used for the reachability flow and should be overridden in the inheriting class to add logic
     */
    public func handleComingBackOnline() {
        removeFallback()
        activityIndicator.start()
    }

    /**
     Does a check on the required variables for the base controller and throws a fatalError if any of them are not set
     */
    func checkControllerIsReady() {
        if cosmos == nil || fallback == nil || headerTitle == nil {
            fatalError("Cosmos || Fallback || Header Title event not set")
        }
    }

    /**
     Logs the stored analytics event
     */
    public func logEvent() {
        guard let event = analyticsEvent else { return }
        cosmos.logger?.log(event: event)
    }

    /**
     Sets all the required variables for this base controllers execution
     - Parameter cosmos: The `Cosmos` instance of the consuming app
     - Parameter headerTitle: The title of this screen, if none supply an empty string ("")
     - Parameter fallback: The fallback for this screen when the content fails to load
     - Parameter event: The Analytics event that is to be logged when the screen appears
     */
    public func setupController(cosmos: Cosmos, headerTitle: String = "", fallback: Fallback, event: CosmosEvent? = nil) {
        self.cosmos = cosmos
        self.headerTitle = headerTitle
        self.fallback = fallback
        self.analyticsEvent = event
    }

    /**
     This method applies the backgroundColor of the theme to the tableView (if available) and the view
     - Note: This method is automatically called in `viewDidLoad` of this base class
     - Important
     If the theme should not be configured as usual or any additional logic be required,
     this method can be overridden with the desired functionality
     */
    func applyTheme() {
        view.backgroundColor = cosmos.theme.backgroundColor
        tableView?.backgroundColor = cosmos.theme.backgroundColor
    }

    /**
     This method configures a view header for the `UITableView`
     - Note: This method is automatically called in `viewWillAppear` of this base class
     - Precondition
     - This method uses the `headerTitle` set on the inheriting ViewController
     - This method uses the `cosmos` set on the inheriting ViewController
     - Important
     If the header should not be configured as usual or any additional logic be required,
     this method can be overridden with the desired functionality
     */
    func configureTableHeaderView() {
        guard let tableV = tableView, tableV.tableHeaderView == nil, !headerTitle.isEmpty else { return }
        addHeaderView(title: headerTitle, theme: cosmos.theme, tableView: tableView)
    }

    /**
     This method calls the `configureNav` method on the `UINavigationBar` if it is a `CosmosNavigationBar`
     - Note: This method is automatically called in `viewWillAppear` of this base class
     - Important
     If the nav bar should not be configured as usual or any additional logic be required,
     this method can be overridden with the desired functionality
     */
    func configureNavbar() {
        navigationController?.navigationBar.configureNav(cosmos: cosmos)
    }

    /**
     This method  calls the network failure fallback flow from the `FallbackConfigurableViewController` protocol
     - Precondition
     The `FallbackConfigurableViewController` protocol flow relies on a UITableView to set the fallback view
     - Important: This method can be overridden with custom functionality if needed
     */
    func showNetworkFailure() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.loadNetworkFallback()
        }
    }

    /**
     This method  calls the content failure fallback flow from the `FallbackConfigurableViewController` protocol
     - Precondition
     - The `FallbackConfigurableViewController` protocol flow relies on the `fallback` variable being set on the inheriting ViewController
     - The `FallbackConfigurableViewController` protocol flow relies on a UITableView to set the fallback view
     - Important: This method can be overridden with custom functionality if needed
     */
    func showContentFailure() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.loadFailedFallback()
        }
    }

    /**
     This method calls the content failure fallback flow from the `FallbackConfigurableViewController` protocol with a specified `Fallback`
     - Precondition
     The `FallbackConfigurableViewController` protocol flow relies on a UITableView to set the fallback view
     - Important: This method can be overridden with custom functionality if needed
     */
    func showContentFailure(fallback: Fallback) {
        self.fallback = fallback
        showContentFailure()
    }

    /**
     Registers the normal cell and featured cell for each custom publication of the cosmos config
     - Note: This method is automatically called in `viewDidLoad` of this base class
     - Important: This method can be overridden with custom functionality if needed
     */
    func registerCustomCells() {
        guard let tableV = tableView,
              let customCells = cosmos.apiConfig.customArticlePublications else { return }
        for publication in customCells {
            if let articleCell = publication.uiConfig.articleCell {
                tableV.register(articleCell.nib, forCellReuseIdentifier: articleCell.reuseId)
            }
            if let articleCell = publication.uiConfig.featuredArticleCell {
                tableV.register(articleCell.nib, forCellReuseIdentifier: articleCell.reuseId)
            }
        }
    }

    /**
     Compares a given publication ID to the custom article publications specified in cosmos and returns the entire
     Publication model if available
     - Parameter publicationID: the ID of the publication to look for
     - Returns: A `Publication` if found
     */
    func isArticlePublicationCustom(_ publicationID: String) -> Publication? {
        cosmos.apiConfig.customArticlePublications?.first { $0.id == publicationID }
    }

    /**
     Compares a given publication ID to the custom edition publications specified in cosmos and returns the entire
     Publication model if available
     - Parameter publicationID: the ID of the publication to look for
     - Returns: A `Publication` if found
     */
    func isEditionPublicationCustom(_ publicationID: String) -> Publication? {
        cosmos.apiConfig.customEditionPublications?.first { $0.id == publicationID }
    }

    /**
        Take a given article key and gets an `ArticleViewController` to display the article
     - Parameter key : The articles key to be used to fetch it from the API
     - Important: This method determines the render type based on `cosmos.isEdition`
     */
    func relatedArticleSelected(key: Int64) {
        let renderType: ArticleRenderType = cosmos.isEdition ? .edition : .live
        let relatedView = cosmos.getView(for: key,
                                         as: renderType,
                                         relatedSelected: self.relatedArticleSelected)
        DispatchQueue.main.async {
            self.show(relatedView, sender: self)
        }
    }
}
