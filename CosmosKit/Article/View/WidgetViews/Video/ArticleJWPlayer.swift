import UIKit
import Foundation
import WebKit
import Reachability

class ArticleJWPlayer: UIView {

    @IBOutlet var webContainer: UIView!
    @IBOutlet var videoDescription: JWPlayerLabel!
    var webView: WKWebView?
    var reachability = try? Reachability()
    var timer: Timer!
    var triggerCount = 0

    init(_ viewModel: JWPlayerViewModel) {
        super.init(frame: CGRect.zero)
        let view: ArticleJWPlayer? = fromNib()
        view?.configure(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with model: JWPlayerViewModel) {
        DispatchQueue.main.async {
            if self.reachability?.connection == .unavailable {
                self.loadOfflineWidget(model)
                self.videoDescription.text = nil
            } else {
                self.configureWebView(model)
                self.videoDescription.text = model.description
            }
        }
    }

    func loadOfflineWidget(_ model: JWPlayerViewModel) {
        let offline: ArticleOffline = ArticleOffline.instanceFromNib()
        offline.configure(frame: self.frame, type: .jwplayer, reload: {
            self.configure(with: model)
            offline.removeFromSuperview()
        })
        webContainer.addSubview(offline)
    }

    func configureWebView(_ model: JWPlayerViewModel) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: webContainer.frame.height)
        webView = WKWebView(frame: frame, configuration: config)

        webContainer.addSubview(webView!)

        webView?.navigationDelegate = self
        webView?.scrollView.isScrollEnabled = false
        webView?.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.webView?.loadHTMLString(model.webData, baseURL: URL(string: model.url))
        }
    }
}

extension ArticleJWPlayer: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState === 'complete'",
                                   completionHandler: { [weak self] completed, _ in
            guard let state = completed as? Bool, state else { return }
            let path = Bundle.cosmos.path(forResource: "WebWidgetResize", ofType: "js")
            let jsString: String
            do {
                jsString = try String(contentsOfFile: path!, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
                return
            }

            webView.evaluateJavaScript(jsString) { [weak self] _, _ in
                self?.adjustWebHeight()
                self?.timer = Timer.scheduledTimer(timeInterval: 2.0,
                                                   target: self as Any,
                                                   selector: #selector(self?.trigger),
                                                   userInfo: nil,
                                                   repeats: true)
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
        guard let webView = webView else {
            return
        }
        print(webView.scrollView.contentSize)
        DispatchQueue.main.async {
            if webView.intrinsicContentSize != webView.scrollView.contentSize {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}
