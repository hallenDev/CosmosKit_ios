import UIKit

class ArticleListWidget: UIView {

    override var intrinsicContentSize: CGSize {
        if stackView != nil {
            return CGSize(width: 375, height: stackView.frame.height)
        }
        return CGSize(width: 375, height: 400)
    }

    @IBOutlet var stackView: UIStackView!

    init(viewModel: ArticleListViewModel, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) {
        super.init(frame: CGRect.zero)
        let view: ArticleListWidget? = fromNib()
        view?.configure(viewModel: viewModel, cosmos: cosmos, selected: selected)
    }

    func configure(viewModel: ArticleListViewModel, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) {
        for article in viewModel.articles.enumerated() {
            var shouldFeature = false
            if let frequency = cosmos.uiConfig.articleWidgetFeatureFrequency {
                shouldFeature = article.offset % frequency == 0
            }
            let articleView = CosmosViewConstructor.getArticleWidgetView(article: article.element,
                                                                         feature: shouldFeature,
                                                                         cosmos: cosmos,
                                                                         selected: selected)
            stackView.addArrangedSubview(articleView)
            stackView.addArrangedSubview(RelatedSpacer())
        }
        stackView.arrangedSubviews.last?.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
