import Foundation

struct ArticlePagerViewModel {
    var content: [ScrollableArticleItem]
    var currentArticleView: ArticleViewController
    var currentContentIndex: Int = 0
    var cosmos: Cosmos!

    var currentArticle: ArticleViewModel {
        return currentArticleView.article
    }

    var showSharing: Bool {
        return getContent(at: currentContentIndex).scrollType == .article
    }

    var showBookmarks: Bool {
        return getContent(at: currentContentIndex).scrollType == .article
    }

    var currentCommentsEnabled: Bool {
        guard getContent(at: currentContentIndex).scrollType == .article else { return false }
        return currentArticle.commentsEnabled
    }

    var currentShareURL: String? {
        guard getContent(at: currentContentIndex).scrollType == .article else { return nil }
        return currentArticle.shareURL
    }

    var currentSlug: String? {
        guard getContent(at: currentContentIndex).scrollType == .article else { return nil }
        return currentArticle.slug
    }

    var currentBookmarked: Bool {
        guard getContent(at: currentContentIndex).scrollType == .article else { return false }
        return currentArticle.isBookmarked
    }

    var currentTitle: String? {
        guard getContent(at: currentContentIndex).scrollType == .article else { return nil }
        return currentArticle.title
    }

    var contentCount: Int {
        return content.count
    }

    init(articles: [ArticleViewModel], currentArticleView: ArticleViewController, cosmos: Cosmos) {
        self.currentArticleView = currentArticleView
        self.content = [ScrollableArticleItem]()
        self.cosmos = cosmos
        content.append(contentsOf: articles)
        setCurrentArticleView(currentArticleView)
        addInitialPagerAd()
    }

    mutating func addInitialPagerAd() {
        if cosmos.adsEnabled,
            let config = cosmos.adConfig,
            let pagerPlacement = config.articlePagerInitialPlacement,
            currentContentIndex + 2 < content.count {

            let insert = AdArticle(key: currentContentIndex + 2, adPlacement: pagerPlacement)
            content.insert(insert, at: currentContentIndex + 2)
            addReccuringPagerAds(startIndex: currentContentIndex, offset: pagerPlacement.placement + 1)
        } else {
            addReccuringPagerAds(startIndex: currentContentIndex, offset: 0)
        }
    }

    mutating func addReccuringPagerAds(startIndex: Int, offset: Int) {
        if cosmos.adsEnabled, let config = cosmos.adConfig, let pagerPlacement = config.articlePagerPlacement {
            content = insert(content: content, start: startIndex + offset, step: pagerPlacement.placement, placement: pagerPlacement)
            content = insert(content: content, start: startIndex, step: -(pagerPlacement.placement - 1), placement: pagerPlacement)
        }
    }

    func insert(content: [ScrollableArticleItem], start: Int, step: Int, placement: AdPlacement) -> [ScrollableArticleItem] {
        var arrayContent = content
        var index = start + step
        while index < arrayContent.count && index >= 0 {
            let insert = AdArticle(key: index, adPlacement: placement)
            arrayContent.insert(insert, at: index)
            if step < 0 {
                index += step - 1
            } else {
                index += step + 1
            }
        }
        return arrayContent
    }

    mutating func setCurrentArticleView(_ view: ArticleViewController) {
        self.currentArticleView = view
        self.setCurrentIndex(view.article.key)
    }

    mutating func setCurrentIndex(_ key: Int64) {
        let found = content.firstIndex { $0.key == key }
        self.currentContentIndex = found ?? self.currentContentIndex
    }

    mutating func updateContent(_ freshArticle: ArticleViewModel) {
        for stale in content.enumerated() where stale.element.scrollType == .article {
            if let converted = stale.element as? ArticleViewModel,
                converted.key == freshArticle.key {
                content[stale.offset] = freshArticle
            }
        }
    }

    func getContent(at index: Int) -> ScrollableArticleItem {
        return content[index]
    }

    mutating func currentIndex(_ viewController: UIViewController) -> Int? {
        if let adView = viewController as? PagerAdViewController {
            let lookup = adView.identifier.key
            let found = content.firstIndex { $0.key == lookup }
            self.currentContentIndex = found ?? self.currentContentIndex
            return found
        } else if let articleView = viewController as? ArticleViewController {
            let lookup = articleView.article.key
            let found = content.firstIndex { $0.key == lookup }
            self.currentContentIndex = found ?? self.currentContentIndex
            return found
        }
        return nil
    }
}
