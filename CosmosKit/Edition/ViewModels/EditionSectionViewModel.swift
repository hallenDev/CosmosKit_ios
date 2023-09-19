// swiftlint:disable force_cast
import Foundation

public enum SectionType {
    case articles
    case widgets
    case hybrid
}

public struct EditionSectionViewModel: Equatable {

    public static func == (lhs: EditionSectionViewModel, rhs: EditionSectionViewModel) -> Bool {
        return lhs.articles == rhs.articles
    }

    var articles: [ArticleViewModel]
    let heading: String
    let subHeading: String?
    var widgets: [WidgetViewModel]?
    var hybridList: [EditionItem]?
    var type: SectionType

    var contentCount: Int {
        switch type {
        case .hybrid: return hybridList!.count
        case .widgets: return widgets!.count
        case .articles: return articles.count
        }
    }

    init(content: ArticleListWidgetData, articles: [Article]) {
        self.heading = content.heading ?? ""
        self.subHeading = content.subHeading
        self.articles = articles.enumerated().map {  article in
            ArticleViewModel(from: article.element,
                             as: .edition,
                             number: article.offset + 1,
                             total: articles.count)
            }.filter { content.articleIds.contains($0.key) }
        self.type = .articles
    }

    init(content: [Widget], articles: [Article]) {
        let sectionData = (content.filter { $0.type == .articleList }.first?.data as! ArticleListWidgetData)
        self.widgets = content.compactMap { $0.getViewModel() }
        self.heading = sectionData.heading ?? ""
        self.subHeading = sectionData.subHeading
        self.articles = articles.enumerated().map {  article in
            ArticleViewModel(from: article.element,
                             as: .edition,
                             number: article.offset + 1,
                             total: articles.count)
            }.filter { sectionData.articleIds.contains($0.key) }
        self.type = .hybrid

        hybridList = [EditionItem]()
        for item in content {
            if item.type == .articleList {
                for article in self.articles {
                    hybridList?.append(article)
                }
            } else if let widget = item.getViewModel() {
                hybridList?.append(widget)
            }
        }
    }

    init(from viewmodels: [ArticleViewModel], section: String) {
        self.articles = viewmodels
        self.heading = section
        self.subHeading = ""
        self.type = .articles
    }

    init(widgets: [Widget]) {
        self.widgets = widgets.compactMap { $0.getViewModel() }
        self.subHeading = ""
        if let widgetData = widgets.first?.data as? TextWidgetData {
            self.heading = widgetData.html ?? widgetData.text ?? ""
        } else if let widgetData = widgets.first?.data as? InfoBlockWidgetData {
            self.heading = widgetData.description ?? widgetData.title ?? ""
        } else {
            self.heading = ""
        }
        self.type = .widgets
        self.articles = []
        self.widgets?.removeFirst()
    }

    init?(content: [Widget], edition: Edition) {
        guard let firstWidget = content.first else {
            return nil
        }

        switch firstWidget.type {
        case .articleList:
            if content.count > 1 {
                self.init(content: content, articles: edition.articles)
            } else {
                self.init(content: firstWidget.data as! ArticleListWidgetData, articles: edition.articles)
            }
        case .text, .infoblock:
            self.init(widgets: content)
        default:
            return nil
        }
    }

    mutating func updateViewModel(_  model: WidgetViewModel, at index: Int) {
        if self.type == .hybrid {
            hybridList?[index] = model
        } else {
            widgets?[index] = model
        }
    }

    mutating func add(articles: [Article]) {
        self.articles += articles.map { ArticleViewModel(from: $0, as: .edition) }
    }
}
