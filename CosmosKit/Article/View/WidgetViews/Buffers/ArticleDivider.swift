import Foundation

class ArticleDividerLine: UIView {}

class ArticleDivider: UIView {

    init() {
        super.init(frame: CGRect.zero)
        let _: ArticleDivider? = fromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
