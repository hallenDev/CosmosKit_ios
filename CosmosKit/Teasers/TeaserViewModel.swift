import Foundation

struct TeaserViewModel {

    var type: WidgetType = .teaser
    let key: Int64
    let heading: String
    let subHeading: String?
    let template: String
    let readMoreUrl: URL?
    let articles: [ArticleSummaryViewModel]

    init(from model: Teaser) {
        self.key = model.key
        self.heading = model.heading
        self.subHeading = model.subHeading
        self.template = model.template
        self.readMoreUrl = URL(string: model.readMoreUrl ?? "")
        self.articles = model.articles.map { ArticleSummaryViewModel(article: $0, as: .edition) }
    }
}

extension TeaserViewModel: WidgetViewModel {
    static func create(from widget: Widget) -> WidgetViewModel {
        guard let teaser = widget.data as? Teaser else {
            fatalError("failed to parse data")
        }
        return TeaserViewModel(from: teaser)
    }
}
