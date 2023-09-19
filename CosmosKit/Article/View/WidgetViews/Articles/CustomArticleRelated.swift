import Foundation

public protocol RelatableArticle {
    func configureForRelated(article: ArticleSummaryViewModel)
}

class CustomArticleRelated: UIView {

    override var intrinsicContentSize: CGSize {
        if let height = customView?.frame.height {
            return CGSize(width: 375, height: height)
        }
        return CGSize(width: 375, height: 116)
    }

    var key: Int64!
    var selected: RelatedSelectedCallback?
    var customView: UIView?

    init(customView: UIView, viewModel: ArticleSummaryViewModel, selected: @escaping RelatedSelectedCallback) {
        self.key = viewModel.key
        self.selected = selected
        super.init(frame: .zero)
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(customView)
        customView.layoutAttachAll(to: self)
        self.customView = customView
        let tap = UITapGestureRecognizer(target: self, action: #selector(relatedArticleSelected(gesture:)))
        self.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func relatedArticleSelected(gesture: UITapGestureRecognizer) {
        selected?(key)
    }
}
