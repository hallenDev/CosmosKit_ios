import Foundation

protocol Themable {
    func applyTheme(theme: Theme)
}

class AuthBaseViewController: UIViewController, CosmosActivityEnabledViewController {
    var theme: Theme!
    var cosmos: Cosmos!
    var activityIndicator: CosmosActivityIndicator!

    func configure(cosmos: Cosmos, theme: Theme? = nil) {
        self.cosmos = cosmos
        self.theme = theme ?? cosmos.theme
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        configureActivityIndicator()
    }

    func applyTheme() {
        view.backgroundColor = theme.authTheme.backgroundColor
    }

    func applyTheme(_ views: [Themable]) {
        views.forEach { $0.applyTheme(theme: theme) }
    }
}
