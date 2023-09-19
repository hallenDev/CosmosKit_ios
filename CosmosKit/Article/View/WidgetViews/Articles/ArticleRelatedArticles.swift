import Foundation

class ArticleRelatedArticles: UIView {
    let stack = UIStackView()
    let cosmos: Cosmos

    init(_ viewModel: RelatedArticlesViewModel, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) {
        self.cosmos = cosmos
        super.init(frame: CGRect.zero)
        stack.axis = .vertical
        stack.spacing = 0
        addSubview(stack)
        stack.layoutAttachAll(to: self, topC: -8)
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = cosmos.theme.backgroundColor
        configure(with: viewModel, cosmos: cosmos, selected: selected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Can't create from coder")
    }

    private func configure(with related: RelatedArticlesViewModel, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) {
        let filtered = related.filterArticles(cosmos: cosmos)
        for article in filtered {
            let spacer = RelatedSpacer()
            let relatedView = CosmosViewConstructor.getRelatedArticleView(article: article, cosmos: cosmos, selected: selected)
            self.stack.addArrangedSubview(relatedView)
            self.stack.addArrangedSubview(spacer)
        }
        stack.arrangedSubviews.last?.removeFromSuperview()
    }
}
