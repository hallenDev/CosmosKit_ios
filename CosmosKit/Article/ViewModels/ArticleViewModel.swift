// swiftlint:disable function_body_length
import Foundation
import Kingfisher

enum ViewControllerState {
    case loading
    case done
    case loaded
    case accessCheck
    case error
    case offline
}

enum ScrollType {
    case article
    case ad
}

protocol ScrollableArticleItem {
    var scrollType: ScrollType { get }
    var key: Int64 { get set }
}

public struct AdArticle: ScrollableArticleItem {
    var scrollType: ScrollType = .ad
    var adPlacement: AdPlacement
    var key: Int64

    init(key: Int, adPlacement: AdPlacement) {
        self.adPlacement = adPlacement
        self.key = Int64(key)
    }
}

public struct ArticleViewModel: Equatable, EditionItem, ScrollableArticleItem {

    public var displayType: EditionItemType = .article
    var scrollType: ScrollType = .article

    public static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.key == rhs.key
    }

    static let dateFormatter = DateFormatter()

    var state: ViewControllerState
    let section: SectionViewModel?
    let subSection: SectionViewModel?
    let adSections: AdSection?
    let overHeadTitle: String?
    public let title: String?
    let sectionTitle: String?
    let underHeadTitle: String?
    public let datePublished: String?
    public let dateModified: String?
    let publication: String
    public var author: AuthorViewModel?
    let headerImageURL: URL?
    public let listImage: Image?
    let intro: String?
    let synopsis: String?
    var widgets: [WidgetViewModel]?
    let firstImageURL: String?
    var key: Int64
    let slug: String?
    public let readingTime: String?
    let listRead: String?
    var articleIndex: String?
    let renderType: ArticleRenderType
    let contentType: String?
    let shareURL: String?
    let access: Bool
    var commentsEnabled: Bool
    let externalUrl: String?
    let article: Article?
    public var isSponsored: Bool
    public var customAdTag: String?

    var isMeta: Bool {
        return externalUrl != nil
    }

    public var sectionName: String {
        if let sub = subSection, let name = sub.name {
            return name.uppercased()
        } else if let section = section, let name = section.name {
            return name.uppercased()
        }
        return ""
    }

    public var isPremium: Bool {
        return contentType == "premium"
    }

    var isBookmarked: Bool {
        return LocalStorage().isBookmark(key: self.key)
    }

    public mutating func set(index: String?) {
        if self.articleIndex == nil, let newIndex = index {
            self.articleIndex = newIndex
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    init(from article: Article, as renderType: ArticleRenderType, number: Int? = nil, total: Int? = nil) {
        self.access = article.access ?? (article.contentType == "free")
        self.renderType = renderType
        self.overHeadTitle = article.title2
        self.underHeadTitle = article.title3
        self.title = article.title
        self.externalUrl = article.externalUrl
        self.sectionTitle = article.sectionTitle
        self.listImage = article.images.first
        self.firstImageURL = article.images.first?.imageURL
        self.key = article.key
        self.state = .loaded
        self.publication = article.publication.identifier

        var initRender = renderType
        if renderType == .pushNotification(render: .live) {
            initRender = .live
        }
        if renderType == .pushNotification(render: .staticPage) {
            initRender = .staticPage
        }
        if  renderType == .pushNotification(render: .edition) {
            initRender = .edition
        }

        var convertedWidgets: [WidgetViewModel]?
        let minRead = LanguageManager.shared.translate(key: .minutesRead)
        let minCaps = LanguageManager.shared.translateUppercased(key: .minutesRead)

        switch initRender {
        case .edition, .live, .pushNotification:
            self.readingTime = "\(article.readDuration/60) \(minRead)"
            self.listRead = "\(article.readDuration/60) \(minCaps)"

            self.section = SectionViewModel(section: article.section)
            if let articleSubSection = article.subSection {
                self.subSection = SectionViewModel(section: articleSubSection)
            } else {
                self.subSection = nil
            }
            self.adSections = article.adSections?.first

            let pubDate = Date(timeIntervalSince1970: TimeInterval(article.published/1000))
            self.datePublished = ArticleViewModel.dateFormatter.string(from: pubDate)
            if let mod = article.modified {
                let modDate = Date(timeIntervalSince1970: TimeInterval(mod/1000))
                self.dateModified = ArticleViewModel.dateFormatter.string(from: modDate)
            } else {
                self.dateModified = nil
            }

            convertedWidgets = article.widgets?.compactMap { $0.getViewModel() }

            if let marketData = article.marketData {
                for marketWidget in marketData {
                    convertedWidgets?.insert(WebViewModel(from: marketWidget), at: 0)
                }
            }

            self.widgets = convertedWidgets

            self.intro = article.intro
            self.synopsis = article.synopsis

            if let author = article.author {
                self.author = AuthorViewModel(from: author)
            } else {
                self.author = AuthorViewModel(authors: article.authors)
            }
            self.isSponsored = article.isSponsored
        case .staticPage:
            self.readingTime = nil
            self.listRead = nil
            self.datePublished = nil
            self.dateModified = nil
            self.author = nil
            self.intro = nil
            self.synopsis = nil
            self.widgets = article.widgets?.compactMap { $0.getViewModel() }
            self.section = nil
            self.subSection = nil
            self.adSections = nil
            self.isSponsored = false
        }

        if let number = number {
            var index = "\(number)"
            if let total = total {
                index += " of \(total)"
            }
            self.articleIndex = "Article \(index)"
        } else {
            self.articleIndex = nil
        }
        self.shareURL = article.shareURL
        self.slug = article.slug
        self.contentType = article.contentType
        self.commentsEnabled = article.comments
        self.article = article

        if let urlString = article.headerImage?.imageURL,
            let url = URL(string: urlString) {
            self.headerImageURL = url
        } else {
            self.headerImageURL = nil
        }
        self.customAdTag = article.customAdTag
    }

    public init(article: ArticleSummaryViewModel, as renderType: ArticleRenderType) {
        self.renderType = renderType
        self.key = article.key
        self.state = .loading
        self.section = article.section
        self.subSection = article.subSection
        self.title = article.title
        self.author = AuthorViewModel(authors: [])
        self.synopsis = article.synopsis
        self.widgets = []
        self.shareURL = article.shareURL
        self.slug = article.slug
        self.commentsEnabled = article.commentsEnabled
        self.publication = article.publication
        self.sectionTitle = article.sectionTitle
        self.access = article.access
        self.adSections = article.adSections
        self.externalUrl = article.externalUrl
        self.contentType = article.contentType
        self.firstImageURL = article.image?.imageURL
        self.readingTime = article.readingTime
        self.listRead = article.listRead
        self.articleIndex = nil
        self.headerImageURL = nil
        self.listImage = article.image
        self.intro = nil
        self.underHeadTitle = nil
        self.datePublished = ArticleViewModel.dateFormatter.string(from: article.publishedDate)
        if let modDate = article.modifiedDate {
            self.dateModified = ArticleViewModel.dateFormatter.string(from: modDate)
        } else {
            self.dateModified = nil
        }
        self.overHeadTitle = nil
        self.article = nil
        self.author = article.author
        self.isSponsored = article.isSponsored
    }

    public init(key: Int64, slug: String?, as renderType: ArticleRenderType) {
        self.renderType = renderType
        self.key = key
        self.state = .loading
        self.section = nil
        self.subSection = nil
        self.overHeadTitle = nil
        self.title = nil
        self.underHeadTitle = nil
        self.datePublished = nil
        self.author = AuthorViewModel(authors: [])
        self.headerImageURL = nil
        self.listImage = nil
        self.intro = nil
        self.synopsis = nil
        self.widgets = []
        self.firstImageURL = nil
        self.readingTime = nil
        self.listRead = nil
        self.articleIndex = nil
        self.access = true
        self.shareURL = nil
        self.slug = slug
        self.contentType = nil
        self.commentsEnabled = false
        self.externalUrl = nil
        self.publication = ""
        self.sectionTitle = nil
        self.adSections = nil
        self.article = nil
        self.dateModified = nil
        self.isSponsored = false
    }

    public init(key: Int64, as renderType: ArticleRenderType) {
        self.init(key: key, slug: nil, as: renderType)
    }

    public init(slug: String, as renderType: ArticleRenderType) {
        self.init(key: -1, slug: slug, as: renderType)
    }
}
