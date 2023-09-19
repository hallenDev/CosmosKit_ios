import UIKit
import Reachability
import AMScrollingNavbar

protocol ArticleCrosswordWidgetDelegate: class {
    func handleNoConnectivityButtonTap(crossword: ArticleCrossword)
}

class ArticleCrossword: UIView {

    @IBOutlet var openButton: UIButton! {
        didSet {
            let title = LanguageManager.shared.translateUppercased(key: .playPuzzle)
            openButton.setTitle(title, for: .normal)
        }
    }
    var reachability = try? Reachability()
    var cosmos: Cosmos!
    let html: String
    var parentController: UIViewController? {
        didSet {
            for view in subviews {
                (view as? ArticleCrossword)?.parentController = parentController
            }
        }
    }

    weak var delegate: ArticleCrosswordWidgetDelegate? {
        didSet {
            for view in subviews {
                (view as? ArticleCrossword)?.delegate = delegate
            }
        }
    }

    init(_ html: String, cosmos: Cosmos) {
        self.html = html
        super.init(frame: CGRect.zero)
        self.cosmos = cosmos
        let view: ArticleCrossword? = fromNib()
        view?.html = html
        view?.cosmos = cosmos
    }

    required init?(coder aDecoder: NSCoder) {
        self.html = ""
        super.init(coder: aDecoder)
    }

    @IBAction func open(_ sender: Any) {
        guard reachability?.connection != .unavailable else {
            delegate?.handleNoConnectivityButtonTap(crossword: self)
            return
        }
        let nav: WebNavigationViewController = CosmosStoryboard.loadViewController()
        nav.modalPresentationStyle = .fullScreen
        // swiftlint:disable:next force_cast
        let webViewController = nav.viewControllers.first as! WebViewController
        webViewController.html = html
        if let parent = parentController {
            (parent.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
            parentController?.show(nav, sender: self)
        } else {
            UIApplication.shared.topViewController()?.show(nav, sender: self)
        }
    }
}
