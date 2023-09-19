import Foundation
import UIKit

public struct CosmosUIConfig {

    // MARK: title/logo

    let logo: UIImage
    let articleLogo: UIImage
    let shouldNavHideLogo: Bool
    let titleConfig: TitleConfig?

    var dropDownTitle: Bool {
        return titleConfig != nil
    }

    // MARK: Blockers

    let registrationWallView: UINib?
    let subscriptionWallView: UINib?
    let payWallView: UINib?

    // MARK: Custom cells

    let featuredArticleCell: CustomUIPair?
    let articleCell: CustomUIPair?
    let relatedArticle: UINib?
    let articleWidgetArticleSmall: UINib?
    let articleWidgetArticleFeatured: UINib?
    let articleWidgetFeatureFrequency: Int?

    // MARK: Custom styles

    let searchRenderType: ArticleRenderType?
    let relatedArticleType: RelatedArticleType

    // MARK: Article Header
    let articleHeaderType: ArticleHeaderType
    let articleHeader: UINib?
    let authorConfig: ArticleAuthorConfig
    let shouldShowReadTime: Bool

    // MARK: Content list specs
    let freeImage: UIImage?
    let lockImage: UIImage?
    let featuredLockImage: UIImage?
    let sponsoredImage: UIImage?
    let contentLockHeight: CGFloat = 13

    public init(logo: UIImage,
                articleLogo: UIImage? = nil,
                shouldNavHideLogo: Bool,
                titleConfig: TitleConfig? = nil,
                registrationWallView: UINib? = nil,
                subscriptionWallView: UINib? = nil,
                payWallView: UINib? = nil,
                featuredArticleCell: CustomUIPair? = nil,
                articleCell: CustomUIPair? = nil,
                searchRenderType: ArticleRenderType? = nil,
                relatedArticleType: RelatedArticleType? = nil,
                relatedArticle: UINib? = nil,
                articleWidgetArticleSmall: UINib? = nil,
                articleWidgetArticleFeatured: UINib? = nil,
                articleWidgetFeatureFrequency: Int? = nil,
                articleHeaderType: ArticleHeaderType? = nil,
                articleHeader: UINib? = nil,
                authorConfig: ArticleAuthorConfig? = nil,
                shouldShowReadTime: Bool = false,
                freeImage: UIImage? = nil,
                lockImage: UIImage? = nil,
                featuredLockImage: UIImage? = nil,
                sponsoredImage: UIImage? = nil) {

        self.logo = logo
        self.articleLogo = articleLogo ?? logo
        self.shouldNavHideLogo = shouldNavHideLogo
        self.titleConfig = titleConfig
        self.registrationWallView = registrationWallView
        self.subscriptionWallView = subscriptionWallView
        self.payWallView = payWallView
        self.featuredArticleCell = featuredArticleCell
        self.articleCell = articleCell
        self.searchRenderType = searchRenderType
        self.authorConfig = authorConfig ?? ArticleAuthorConfig()
        self.shouldShowReadTime = shouldShowReadTime
        self.freeImage = freeImage
        self.lockImage = lockImage
        self.featuredLockImage = featuredLockImage ?? lockImage
        self.sponsoredImage = sponsoredImage
        self.articleWidgetArticleSmall = articleWidgetArticleSmall
        self.articleWidgetArticleFeatured = articleWidgetArticleFeatured
        self.articleWidgetFeatureFrequency = articleWidgetFeatureFrequency

        self.relatedArticleType = relatedArticleType ?? .full
        if relatedArticleType == .injected {
            guard let injected = relatedArticle else {
                fatalError("No injected related article provided")
            }
            self.relatedArticle = injected
        } else {
            self.relatedArticle = nil
        }

        self.articleHeaderType = articleHeaderType ?? .standard
        if articleHeaderType == .injected {
            guard let injected = articleHeader else {
                fatalError("No injected article header provided.")
            }
            self.articleHeader = injected
        } else {
            self.articleHeader = nil
        }
    }
}
