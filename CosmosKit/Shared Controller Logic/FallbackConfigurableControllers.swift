import UIKit

protocol FallbackConfigurableViewController: UIViewController {
    var fallback: Fallback! { get }
    var cosmos: Cosmos! { get }
    var tableView: UITableView? { get }
    var fallbackView: UIView? { get set }
}

extension FallbackConfigurableViewController {

    func loadFailedFallback() {
        guard let fallback = self.fallback else { fatalError("Fallback needs to be set on the inheriting ViewController") }
        load(fallback)
    }

    func loadNetworkFallback() {
        load(cosmos.fallbackConfig.noNetworkFallback)
    }

    func removeFallback() {
        fallbackView?.removeFromSuperview()
    }

    fileprivate func load(_ fallback: Fallback) {
        let viewc: FallbackViewController = CosmosStoryboard.loadViewController()
        fallbackView = viewc.view
        if let tableView = tableView {
            tableView.backgroundView = fallbackView!
        } else {
            fallbackView?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(fallbackView!)
            NSLayoutConstraint.activate([
                fallbackView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                fallbackView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                fallbackView!.topAnchor.constraint(equalTo: view.topAnchor),
                fallbackView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        }
        viewc.configure(fallback: fallback, cosmos: cosmos)
    }
}
