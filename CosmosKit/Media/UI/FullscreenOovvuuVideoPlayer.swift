import Foundation
import WebKit

class FullscreenOovvuuVideoPlayer: UIViewController, MediaPlayable {

    var viewModel: MediaViewModel!
    private var webView: WKWebView!
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(cosmosName: .sectionClose), for: .normal)
        return button
    }()

    private struct Config {
        static let playerTopOffset: CGFloat = 20
        static let closeLeadingOffset: CGFloat = 16
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        configureCloseButton()

        addWebPlayer()
        configureWebPlayer()
    }

    fileprivate func addWebPlayer() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Config.playerTopOffset),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        webView.allowsBackForwardNavigationGestures = false
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func configureWebPlayer() {
        if let url = URL(string: viewModel.url ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
            return
        }
    }

    fileprivate func configureCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.closeLeadingOffset),
                                     closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }

    @objc func hide() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
}
