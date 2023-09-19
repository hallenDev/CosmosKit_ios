import Foundation

public struct ArticleListViewModel: WidgetViewModel {

    public var type = WidgetType.articleList
    var articles: [ArticleSummaryViewModel]
    var articleIds: [Int64]
    var count: Int {
        return articleIds.count
    }

    public static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? ArticleListWidgetData else {
            fatalError("failed to parse data")
        }
        return ArticleListViewModel(widgetData: data)
    }

    init(widgetData: ArticleListWidgetData) {
        self.init(from: widgetData.articles ?? [])
        self.articleIds = widgetData.articleIds
    }

    init(from list: [ArticleSummary]) {
        self.articles = list.map { ArticleSummaryViewModel(from: $0, as: .live)}
        self.articleIds = list.map { $0.key }
    }

    init(from list: [Article]) {
        self.articles = list.map { ArticleSummaryViewModel(article: $0, as: .live)}
        self.articleIds = list.map { $0.key }
    }

    mutating func add(_ list: [Article]) {
        articles.append(contentsOf: list.map { ArticleSummaryViewModel(article: $0, as: .live) })
        articleIds.append(contentsOf: list.map { $0.key })
    }

    func indexPath(for article: ArticleViewModel) -> IndexPath? {
        for articleIndex in articles.enumerated() where articleIndex.1.key == article.key {
            return IndexPath(row: articleIndex.0, section: 0)
        }
        return nil
    }
}
