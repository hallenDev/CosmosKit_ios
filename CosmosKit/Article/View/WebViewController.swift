import UIKit
import WebKit

class WebNavigationViewController: UINavigationController {}

class WebViewController: UIViewController {

    var html = ""
    var webView: WKWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.frame, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        html = html.replacingOccurrences(of: "src=\"//", with: "src=\"https://")
        webView.loadHTMLString(html, baseURL: nil)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {

    // swiftlint:disable:next line_length
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        self.openWidgetURL(navigationAction.request.url)
        return nil
    }

    // swiftlint:disable:next line_length
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
            self.openWidgetURL(navigationAction.request.url)
        } else {
            decisionHandler(.allow)
        }
    }

    @objc func openWidgetURL(_ url: URL? = nil) {
        if let targetUrl = url {
            UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let path = Bundle.cosmos.path(forResource: "WebWidgetResize", ofType: "js")
        let jsString: String
        do {
            jsString = try String(contentsOfFile: path!, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return
        }

        webView.evaluateJavaScript(jsString) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                webView.evaluateJavaScript("window.scrollTo(0, 0)") { _, _ in
                    DispatchQueue.main.async {
                        self.view.addSubview(webView)
                    }
                }
            }
        }
    }
}
