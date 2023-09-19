// swiftlint:disable line_length
import Foundation

class CosmosViewConstructor {

    static func getRelatedArticleView(article: ArticleSummaryViewModel, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) -> UIView {
        if let related = cosmos.apiConfig.customRelatedPublications {
            for pub in related where pub.id == article.publication {
                let type = pub.uiConfig.relatedArticleType
                if type == .injected,
                    let relatedView = pub.uiConfig.relatedArticle?.instantiate(withOwner: nil)[0] as? UIView {
                    (relatedView as? RelatableArticle)?.configureForRelated(article: article)
                    let finalView = (relatedView as? UITableViewCell)?.contentView.subviews.first ?? relatedView
                    return CustomArticleRelated(customView: finalView, viewModel: article, selected: selected)
                } else {
                    return getDefaultRelatedArticleView(article: article, type: type, selected: selected)
                }
            }
        }
        return getDefaultRelatedArticleView(article: article, type: .full, selected: selected)
    }

    static func getArticleWidgetView(article: ArticleSummaryViewModel, feature: Bool, cosmos: Cosmos, selected: @escaping RelatedSelectedCallback) -> UIView {
        if let viablePublications = cosmos.apiConfig.customArticleWidgetPublications {
            for publication in viablePublications where publication.id == article.publication {
                if feature,
                    let featuredView = cosmos.uiConfig.articleWidgetArticleFeatured?.instantiate(withOwner: nil)[0] as? UIView {
                    (featuredView as? RelatableArticle)?.configureForRelated(article: article)
                    let finalView = (featuredView as? UITableViewCell)?.contentView.subviews.first ?? featuredView
                    return CustomArticleRelated(customView: finalView, viewModel: article, selected: selected)
                } else if !feature, let customView = cosmos.uiConfig.articleWidgetArticleSmall?.instantiate(withOwner: nil)[0] as? UIView {
                    (customView as? RelatableArticle)?.configureForRelated(article: article)
                    let finalView = (customView as? UITableViewCell)?.contentView.subviews.first ?? customView
                    return CustomArticleRelated(customView: finalView, viewModel: article, selected: selected)
                }
            }
        }
        if feature {
            return ArticleListWidgetFeaturedArticle(viewModel: article, selected: selected)
        }
        return getDefaultRelatedArticleView(article: article, type: .minimalLeft, selected: selected)
    }

    static func getDefaultRelatedArticleView(article: ArticleSummaryViewModel, type: RelatedArticleType, selected: @escaping RelatedSelectedCallback) -> UIView {
        return ArticleRelated(article, type: type, selected: selected)
    }

    static func extractInjectedArticleHeader(from nib: UINib) -> ArticleHeader? {
        guard let view = nib.instantiate(withOwner: nil)[0] as? UIView else {
            print("WARNING: Failed to instantiate injected Header")
            return nil
        }
        guard let parsed = view as? ArticleHeader else {
            fatalError("Injected Headers should inherit from ArticleHeader")
        }
        return parsed
    }
}
