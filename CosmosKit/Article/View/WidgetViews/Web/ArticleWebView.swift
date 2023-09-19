// swiftlint:disable line_length
import Foundation
import WebKit
import Reachability

protocol ArticleWebWidgetDelegate: class {
    func webWidget(_ widget: ArticleWebView, didResize difference: CGFloat)
}

class ArticleWebView: WKWebView {

    var defaultHeight: CGSize {
        if let superV = superview {
            return CGSize(width: superV.frame.width, height: 210)
        } else {
            return CGSize(width: readableContentGuide.layoutFrame.width, height: 210)
        }
    }

    override var intrinsicContentSize: CGSize {
        guard reachability?.connection != .unavailable else {
            heightConstraint?.isActive = false
            delegate?.webWidget(self, didResize: CGFloat(0))
            return defaultHeight
        }
        guard viewModel.type != .giphy else { return defaultHeight }

        let oldHeight: CGFloat = frame.height
        heightConstraint?.constant = scrollView.contentSize.height
        heightConstraint?.isActive = true
        delegate?.webWidget(self, didResize: scrollView.contentSize.height - oldHeight)
        return scrollView.contentSize
    }

    var heightConstraint: NSLayoutConstraint?
    var viewModel: WebViewModel!
    var reachability = try? Reachability()
    var timer: Timer!
    var triggerCount = 0

    var cosmos: Cosmos!

    weak var delegate: ArticleWebWidgetDelegate?

    init(_ viewModel: WebViewModel, cosmos: Cosmos) {
        self.viewModel = viewModel
        self.cosmos = cosmos

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: config)

        configure(with: viewModel)
        heightConstraint = heightAnchor.constraint(equalToConstant: intrinsicContentSize.height)

        if viewModel.type == .issuu {
            let tap = UITapGestureRecognizer(target: self, action: #selector(openWidget))
            tap.delegate = self
            self.addGestureRecognizer(tap)
        }
        uiDelegate = self

        if viewModel.type == .marketData {
            backgroundColor = UIColor(color: .pampas)
        } else if viewModel.type == .url {
            backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            scrollView.delegate = self
        }
    }

    @objc func openWidget() {
        let nav: WebNavigationViewController = CosmosStoryboard.loadViewController()
        nav.modalPresentationStyle = .fullScreen
        // swiftlint:disable:next force_cast
        let webViewController = nav.viewControllers.first as! WebViewController
        if viewModel.type == .issuu, var cleanedHtml = viewModel.html {
            cleanedHtml.removingRegexMatches(pattern: "style=\".+;\"")
            webViewController.html = cleanedHtml
        }
        UIApplication.shared.topViewController()?.show(nav, sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        heightConstraint = heightAnchor.constraint(equalToConstant: intrinsicContentSize.height)
    }

    func configure(with webData: WebViewModel) {
        navigationDelegate = self
        scrollView.isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false

        DispatchQueue.main.async { [weak self] in
            if self?.reachability?.connection == .unavailable {
                self?.loadOfflineWidget(webData)
            } else {
                if webData.html == nil {
                    if let url = webData.baseURL {
                        self?.load(URLRequest(url: url))
                    } else {
                        self?.loadOfflineWidget(webData)
                    }
                } else {
                    self?.loadHTML(webData)
                }
            }
        }
    }

    func loadOfflineWidget(_ webData: WebViewModel) {
        let offline: ArticleOffline = ArticleOffline.instanceFromNib()
        let width: CGFloat
        if let superV = superview {
            width = superV.frame.width
        } else {
            width = readableContentGuide.layoutFrame.width
        }
        offline.configure(frame: CGRect(x: 0, y: 0, width: width, height: 210), type: viewModel.type, reload: { [weak self] in
            self?.configure(with: webData)
            offline.removeFromSuperview()
        })
        self.addSubview(offline)
        self.bringSubviewToFront(offline)
        self.invalidateIntrinsicContentSize()
    }

    func loadHTML(_ webData: WebViewModel) {
        if webData.isInstagram, let appID = cosmos.publication.facebookAppId,
           let clientID = cosmos.publication.facebookClientId {
            cosmos.getInstagramPost(webData, appID: appID, clientID: clientID, width: Int(UIScreen.main.bounds.width)) { html, error in
                if let html = html {
                    DispatchQueue.main.async {
                        self.loadHTMLString(html, baseURL: webData.baseURL)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        } else if webData.isFacebookPost {
            if let html = webData.html {
                let htmlWithScript = "<div id=\"fb-root\"></div><script async=\"1\" defer=\"1\" crossorigin=\"anonymous\" src=\"https://connect.facebook.net/en_US/sdk.js#xfbml=1&amp;version=v14.0\"></script>" + html
                self.loadHTMLString(htmlWithScript, baseURL: webData.baseURL)
            }

        } else if webData.isOovvuuVideo {
            if let baseURL = webData.baseURL {
                self.load(URLRequest.init(url: baseURL))
            }

        } else if let html = webData.html {
            self.loadHTMLString(html, baseURL: webData.baseURL)
        }
    }

    @objc func openWidgetURL(_ url: URL? = nil) {
        if let targetUrl = url {
            UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
        } else if let targetUrl = viewModel.baseURL {
            UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
        }
    }
}

extension ArticleWebView: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if viewModel.isInstagram && navigationAction.navigationType == .other { return nil }
        self.openWidgetURL(navigationAction.request.url)
        return nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
            self.openWidgetURL(navigationAction.request.url)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState === 'complete'", completionHandler: { [weak self] completed, _ in
            guard let state = completed as? Bool, state else { return }
            let path = Bundle.cosmos.path(forResource: "WebWidgetResize", ofType: "js")
            let jsString: String
            do {
                jsString = try String(contentsOfFile: path!, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
                return
            }

            self?.evaluateJavaScript(jsString) { [weak self] _, _ in
                self?.adjustWebHeight()
                self?.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self as Any, selector: #selector(self?.trigger), userInfo: nil, repeats: true)
            }
        })
    }

    @objc func trigger() {
        guard triggerCount <= 10 else {
            timer.invalidate()
            triggerCount = 0
            return
        }
        triggerCount += 1
        adjustWebHeight()
    }

    func adjustWebHeight() {
        DispatchQueue.main.async {
            if self.intrinsicContentSize != self.scrollView.contentSize {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}

extension ArticleWebView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ArticleWebView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
