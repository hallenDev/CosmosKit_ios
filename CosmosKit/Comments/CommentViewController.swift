// swiftlint:disable block_based_kvo
import UIKit
import WebKit
import Reachability

class CommentViewController: CosmosBaseViewController, WKNavigationDelegate, WKUIDelegate {

    private let progressKey = "estimatedProgress"
    private enum DisqusConfigKeys: String {
        case shortname = "INJECT_SHORTNAME"
        case apiKey = "INJECT_API_KEY"
        case pageURL = "INJECT_PAGEURL"
        case auth = "INJECT_AUTH"
        case slug = "INJECT_PAGEID"
    }

    var webView: WKWebView!
    var currentSlug: String?
    var article: ArticleViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        if reachability?.connection == .unavailable {
            showNetworkFailure()
        } else if article == nil {
            showContentFailure()
        } else {
            loadComments()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentSlug = nil
    }

    override func handleComingBackOnline() {
        super.handleComingBackOnline()
        loadComments()
    }

    func configureComments(for article: ArticleViewModel) {
        self.article = article
    }

    func loadComments() {
        if let config = cosmos.publication.commentConfig as? DisqusConfig {
            loadDisqusComments(config: config)
        } else {
            loadViafouraComments()
        }
    }

    func configureWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        view.addSubview(webView)

        webView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(self, forKeyPath: self.progressKey, options: .new, context: nil)
    }

    // MARK: Viafoura

    private func loadViafouraComments() {
        if let key = article?.key, let userToken = Keychain.getAccessTokenValue() {
            let path = String(format: "%@/viafoura/comments/%lld/?access_token=%@", cosmos.publication.domain, key, userToken)
            if let url = URL(string: path) {
                let request = URLRequest(url: url)
                webView.load(request)
                return
            }
        }
        showContentFailure()
    }

    // MARK: Disqus

    private func loadDisqusComments(config: DisqusConfig) {
        let path = Bundle.cosmos.path(forResource: "disqus_template", ofType: "html")
        view.bringSubviewToFront(webView)
        cosmos.getDisqusAuth { [weak self] auth in
            if let auth = auth,
               let content = try? String(contentsOfFile: path!, encoding: .utf8),
               let configuredHTML = self?.configureDisqusConfig(config: config, content: content, auth: auth) {
                DispatchQueue.main.async {
                    self?.webView.loadHTMLString(configuredHTML, baseURL: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    private func configureDisqusConfig(config: DisqusConfig, content: String, auth: String) -> String {
        guard let slug = article?.slug, let shareURL = article?.shareURL else {
            showContentFailure()
            return ""
        }
        let disqusPageURL = String(format: "%@%@", cosmos.publication.domain, shareURL)
        var webContent = content
        webContent = webContent.replacingOccurrences(of: DisqusConfigKeys.shortname.rawValue,
                                             with: config.shortname)
        webContent = webContent.replacingOccurrences(of: DisqusConfigKeys.pageURL.rawValue,
                                             with: disqusPageURL)
        webContent = webContent.replacingOccurrences(of: DisqusConfigKeys.apiKey.rawValue,
                                             with: config.apiKey)
        webContent = webContent.replacingOccurrences(of: DisqusConfigKeys.auth.rawValue,
                                             with: auth)
        webContent = webContent.replacingOccurrences(of: DisqusConfigKeys.slug.rawValue,
                                             with: slug)
        return webContent
    }

    // MARK: Web View navigation

    // swiftlint:disable:next line_length
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        showConfirmation(message: message) { result in
            completionHandler(result)
        }
    }

    // swiftlint:disable:next line_length
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let url = url, url.absoluteString.contains("mailto") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

            decisionHandler(.allow)
        } else if let link = url?.valueOfParameter("url"),
            link.starts(with: cosmos.publication.domain),
            let slug = URL(string: link)?.lastPathComponent {
            showPushedArticle(slug: slug)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            let popup = WKWebView(frame: frame, configuration: configuration)
            popup.uiDelegate = self
            popup.navigationDelegate = self
            view.addSubview(popup)
            return popup
        } else {
            webView.load(navigationAction.request)
        }
        return nil
    }

    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        fitToScreen(webView)
    }

    // MARK: Cosmos actions

    func showPushedArticle(slug: String) {
        guard currentSlug == nil, let article = self.article
            else { return }

        currentSlug = slug
        let alsoOnArticle = ArticleViewModel(slug: slug, as: article.renderType)
        let pager = ArticlePagerViewController(cosmos: cosmos, articles: [alsoOnArticle], currentArticle: alsoOnArticle)
        DispatchQueue.main.async {
            self.hidesBottomBarWhenPushed = true
            self.show(pager, sender: self)
        }
    }

    func showConfirmation(message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LanguageManager.shared.translate(key: .yes),
                                      style: .default,
                                      handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }))

        alert.addAction(UIAlertAction(title: LanguageManager.shared.translate(key: .no),
                                      style: .cancel,
                                      handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func fitToScreen(_ webView: WKWebView) {
        let path = Bundle.cosmos.path(forResource: "WebWidgetResize", ofType: "js")
        let jsString: String
        do {
            jsString = try String(contentsOfFile: path!, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return
        }

        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: self.progressKey)
    }
}

extension CommentViewController {
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == progressKey,
            self.webView.estimatedProgress == 1.0 {
            self.activityIndicator.stop()
        }
    }
}

extension URL {
    func valueOfParameter(_ name: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems?.first { $0.name == name }?.value
    }
}
