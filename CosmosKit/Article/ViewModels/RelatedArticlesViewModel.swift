import Foundation

struct RelatedArticlesViewModel: WidgetViewModel {

    var type: WidgetType = .relatedArticles

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? RelatedArticlesWidgetData else {
            fatalError("failed to parse data")
        }
        return RelatedArticlesViewModel(from: data, as: .edition)
    }

    let title: String
    let articles: [ArticleSummaryViewModel]

    init(from related: RelatedArticlesWidgetData, as renderType: ArticleRenderType) {
        self.title = related.meta.title
        self.articles = related.articles?.compactMap { ArticleSummaryViewModel(from: $0, as: renderType) } ?? []
    }

    init(from viewModel: RelatedArticlesViewModel, as renderType: ArticleRenderType) {
        self.title = viewModel.title
        self.articles = viewModel.articles.map { ArticleSummaryViewModel(viewModel: $0, as: renderType) }
    }

    func filterArticles(cosmos: Cosmos) -> [ArticleSummaryViewModel] {
        return articles.filter { article -> Bool in
            if let filters = cosmos.apiConfig.filteredPublications,
               filters.contains(where: { $0.id == article.publication }) {
                return false
            }
            return true
        }
    }
}
