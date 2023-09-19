import Foundation

public struct ArticleSummaryViewModel {

    public let title: String
    public let sectionTitle: String
    public let section: SectionViewModel?
    public let subSection: SectionViewModel?
    public let adSections: AdSection?
    public let synopsis: String
    public let image: Image?
    public let publication: String
    public var renderType: ArticleRenderType
    public let key: Int64
    public let slug: String?
    let publishInterval: Int64
    let modifiedInterval: Int64?
    public let shareURL: String?
    public let access: Bool
    public let commentsEnabled: Bool
    public let externalUrl: String?
    public let hasVideoContent: Bool
    public let readingTime: String?
    public let listRead: String?
    public var author: AuthorViewModel?
    public let contentType: String?

    public var isPremium: Bool { contentType == "premium" }
    public var isRegisterLocked: Bool { contentType == "registration" }
    public var isLocked: Bool { isPremium || isRegisterLocked }
    public var isSponsored: Bool

    public var isMeta: Bool {
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

    var publishedString: String? {
        switch renderType {
        case .edition, .staticPage: return nil
        default:
            return CosmosTimeFormatter.timeAgo(for: publishedDate, shortened: false)
        }
    }

    public var publishedDate: Date {
        Date(timeIntervalSince1970: TimeInterval(self.publishInterval/1000))
    }

    public var modifiedDate: Date? {
        guard let mod = modifiedInterval else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(mod/1000))
    }
}

extension ArticleSummaryViewModel {
    init(from articleSummary: ArticleSummary, as renderType: ArticleRenderType) {
        self.title = articleSummary.title ?? articleSummary.titleText ?? articleSummary.sectionTitle ?? ""
        if articleSummary.synopsis.hasPrefix("\n") {
            self.synopsis = articleSummary.synopsis.replaceFirst(of: "\n", with: "")
        } else {
            self.synopsis = articleSummary.synopsis
        }
        self.section = SectionViewModel(section: articleSummary.section)
        if let articleSubSection = articleSummary.subSection {
            self.subSection = SectionViewModel(section: articleSubSection)
        } else {
            self.subSection = nil
        }
        self.image = articleSummary.image
        self.key = articleSummary.key
        self.renderType = renderType
        self.publishInterval = articleSummary.published
        self.modifiedInterval = articleSummary.modified
        self.publication = articleSummary.publication.identifier
        self.slug = articleSummary.slug
        self.shareURL = articleSummary.shareURL
        self.commentsEnabled = articleSummary.comments ?? false
        self.hasVideoContent = (articleSummary.videoCount ?? 0) > 0
        self.externalUrl = articleSummary.externalUrl
        self.sectionTitle = articleSummary.sectionTitle ?? articleSummary.title ?? ""
        self.access = articleSummary.access ?? false
        self.adSections = articleSummary.adSections?.first
        if let author = articleSummary.author {
            self.author = AuthorViewModel(from: author)
        } else {
            self.author = AuthorViewModel(authors: articleSummary.authors)
        }
        let minRead = LanguageManager.shared.translate(key: .minutesRead)
        let minCaps = LanguageManager.shared.translateUppercased(key: .minutesRead)

        if let duration = articleSummary.readDuration {
            self.readingTime = "\(duration/60) \(minRead)"
            self.listRead = "\(duration/60) \(minCaps)"
        } else {
            self.readingTime = nil
            self.listRead = nil
        }
        self.contentType = articleSummary.contentType
        self.isSponsored = articleSummary.sponsor != nil
    }

    init(viewModel: ArticleSummaryViewModel, as renderType: ArticleRenderType) {
        self.title = viewModel.title
        if viewModel.synopsis.hasPrefix("\n") {
            self.synopsis = viewModel.synopsis.replaceFirst(of: "\n", with: "")
        } else {
            self.synopsis = viewModel.synopsis
        }
        self.section = viewModel.section
        self.subSection = viewModel.subSection
        self.image = viewModel.image
        self.key = viewModel.key
        self.renderType = renderType
        self.publishInterval = viewModel.publishInterval
        self.modifiedInterval = viewModel.modifiedInterval
        self.publication = viewModel.publication
        self.slug = viewModel.slug
        self.shareURL = viewModel.shareURL
        self.commentsEnabled = viewModel.commentsEnabled
        self.hasVideoContent = viewModel.hasVideoContent
        self.externalUrl = viewModel.externalUrl
        self.sectionTitle = viewModel.sectionTitle
        self.access = viewModel.access
        self.adSections = viewModel.adSections
        self.author = viewModel.author
        self.readingTime = viewModel.readingTime
        self.listRead = viewModel.listRead
        self.contentType = viewModel.contentType
        self.isSponsored = viewModel.isSponsored
    }

    init(article: Article, as renderType: ArticleRenderType) {
        self.title = article.title ?? ""
        if article.synopsis.hasPrefix("\n") {
            self.synopsis = article.synopsis.replaceFirst(of: "\n", with: "")
        } else {
            self.synopsis = article.synopsis
        }
        self.section = SectionViewModel(section: article.section)
        if let articleSubSection = article.subSection {
            self.subSection = SectionViewModel(section: articleSubSection)
        } else {
            self.subSection = nil
        }
        self.image = article.image
        self.key = article.key
        self.renderType = renderType
        self.publishInterval = article.published
        self.modifiedInterval = article.modified
        self.publication = article.publication.identifier
        self.commentsEnabled = article.comments
        self.shareURL = article.shareURL
        self.slug = article.slug
        self.hasVideoContent = article.videoCount > 0
        self.externalUrl = article.externalUrl
        self.sectionTitle = article.sectionTitle ?? article.title ?? ""
        self.access = article.access ?? false
        self.adSections = article.adSections?.first
        if let author = article.author {
            self.author = AuthorViewModel(from: author)
        } else {
            self.author = AuthorViewModel(authors: article.authors)
        }
        let minRead = LanguageManager.shared.translate(key: .minutesRead)
        let minCaps = LanguageManager.shared.translateUppercased(key: .minutesRead)
        self.readingTime = "\(article.readDuration/60) \(minRead)"
        self.listRead = "\(article.readDuration/60) \(minCaps)"
        self.contentType = article.contentType
        self.isSponsored = article.isSponsored
    }
}
