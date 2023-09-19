import UIKit

public protocol CustomPublicationCell {
    static func nib() -> UINib
    static var reuseID: String { get }
}

public protocol CustomArticleSummaryCell: CustomPublicationCell {
    func configure(for article: ArticleSummaryViewModel, cosmos: Cosmos)
}

public protocol CustomArticleCell: CustomPublicationCell {
    func configure(for article: ArticleViewModel, imageGradient: Bool, separator: Bool, cosmos: Cosmos)
}
