// swiftlint:disable force_cast
import Foundation
import Kingfisher

public struct EditionViewModel: Equatable {

    public static func == (lhs: EditionViewModel, rhs: EditionViewModel) -> Bool {
        return lhs.sections == rhs.sections && lhs.key == rhs.key && lhs.lastModified == rhs.lastModified
    }

    let title: String
    var sections: [EditionSectionViewModel]!
    let articleOrder: [Int64]
    let doesInfiniteScroll: Bool
    var editionDate: Date?
    let key: Int64?
    let lastModified: Date

    init(from edition: Edition) {
        self.title = edition.title.uppercased()
        self.articleOrder = edition.articles.map { $0.key }
        self.doesInfiniteScroll = false
        self.editionDate = Date(timeIntervalSince1970: Double(edition.published/1000))
        self.key = edition.key
        self.lastModified = edition.lastModified
        self.sections = computeSections(from: edition)
        prefetchImages()
    }

    init(from articles: [Article], section: SectionViewModel, endOfList: Bool) {
        self.title = ""
        let articleViewModels = articles.enumerated().compactMap { article in
            ArticleViewModel(from: article.element, as: .edition, number: article.offset + 1, total: articles.count)
        }
        self.sections = [EditionSectionViewModel(from: articleViewModels, section: section.name ?? "")]
        self.articleOrder = articles.map { $0.key }
        self.doesInfiniteScroll = true
        self.lastModified = Date()
        self.key = nil
    }

    func computeSections(from edition: Edition) -> [EditionSectionViewModel] {
        var sectionModels = [EditionSectionViewModel]()

        let widgetList = createContentList(with: edition.widgets)
        for section in widgetList {
            if let viewModel = EditionSectionViewModel(content: section, edition: edition) {
                sectionModels.append(viewModel)
            }
        }

        return sectionModels
    }

    func createContentList(with widgets: [Widget]?) -> [[Widget]] {
        var widgetLists = [[Widget]]()
        guard let widgets = widgets else { return widgetLists }

        let cleanedWidgets = widgets.filter { $0.type != .unsupported && $0.type != .divider && $0.type != .iframely }
        var currentSection = -1

        for widget in cleanedWidgets {
            if widget.type == .text {
                if ((widget.data as? TextWidgetData)?.html?.starts(with: "<h2") ?? false) ||
                    ((widget.data as? TextWidgetData)?.html?.starts(with: "<h3") ?? false) ||
                    widgetLists.count == 0 {
                    currentSection += 1
                    widgetLists.append([Widget]())
                    widgetLists[currentSection].append(widget)
                } else {
                    widgetLists[currentSection].append(widget)
                }
            } else if widget.type == .infoblock {
                currentSection += 1
                widgetLists.append([widget])
            } else if widget.type != .articleList {
                if widgetLists.count == 0 {
                    widgetLists.append([Widget]())
                    currentSection += 1
                    let data = TextWidgetData(html: "", text: "")
                    let text = Widget(data)
                    widgetLists[currentSection].append(text)
                }
                widgetLists[currentSection].append(widget)
            } else if widget.type == .articleList {
                currentSection += 1
                widgetLists.append([widget])
            }
        }

        return widgetLists
    }

    func indexPath(for article: ArticleViewModel) -> IndexPath? {
        for sectionIndex in sections.enumerated() {
            for articleIndex in sectionIndex.1.articles.enumerated()
                where articleIndex.1.key == article.key {
                    return IndexPath(row: articleIndex.0, section: sectionIndex.0)
            }
        }
        return nil
    }

    mutating func add(articles: [Article], page: Int) {
        sections[0].add(articles: articles)
    }

    func isToday() -> Bool {
        if let publishedDate = self.editionDate {
            return Calendar.current.compare(Date(), to: publishedDate, toGranularity: .day) == .orderedSame
        } else {
            return false
        }
    }

    func prefetchImages() {
        let articles = sections.flatMap { $0.articles }.compactMap { $0.listImage }
        var urls = [URL]()

        let listImages = articles.compactMap { URL(string: $0.imageURL) }.compactMap { $0 }
        urls += listImages

        let widgetImages = sections.compactMap { $0.widgets }
            .flatMap { $0 }
            .filter { $0.type == .image }
            .map { $0 as! ImageViewModel }
            .compactMap { $0.imageURL }
        urls += widgetImages

        let galleries = sections.compactMap { $0.widgets }
            .flatMap { $0 }
            .filter { $0.type == .gallery }
            .map { $0 as! GalleryViewModel }
        let galleryImages = galleries.compactMap { $0.images }
            .flatMap { $0 }
            .compactMap { $0.imageURL }
        urls += galleryImages

        ImagePrefetcher(resources: urls).start()
    }
}
