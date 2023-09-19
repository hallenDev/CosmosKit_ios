import UIKit

class ArticleFooter: UIView {

    @IBOutlet var dividerLine: ArticleFooterDividerLine!
    var scrollToTop: (() -> Void)?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 90)
    }

    @IBAction func scrollToTop(_ sender: Any) {
        scrollToTop?()
    }
}
