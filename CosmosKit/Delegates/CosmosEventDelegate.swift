import Foundation

@objc
public protocol CosmosEventDelegate: AnyObject {
    @objc optional func cosmosTitleSelected()
    @objc optional func cosmosShareArticle(articleTitle: String?, articleUrl: URL?, sender: UIBarButtonItem?)
    @objc optional func cosmosMetaArticle(articleUrl: String)
}

// MARK: Default implementations for CosmosEventDelegate
extension Cosmos: CosmosEventDelegate {
    public func cosmosMetaArticle(articleUrl: String) {
        if let url = URL(string: articleUrl) {
            UIApplication.shared.open(url)
        }
    }

    public func cosmosTitleSelected() {
        popToMainTab()
    }

    public func cosmosShareArticle(articleTitle: String?, articleUrl: URL?, sender: UIBarButtonItem?) {
        let shareVC = UIActivityViewController(activityItems: [articleTitle ?? "", articleUrl as Any], applicationActivities: [])
        let root = UIApplication.shared.topViewController()
        if let popOver = shareVC.popoverPresentationController, let view = root?.view {
            if sender != nil {
                popOver.barButtonItem = sender
            } else {
                popOver.sourceView = view
                popOver.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popOver.permittedArrowDirections = []
            }
        }
        root?.present(shareVC, animated: true)
    }
}
