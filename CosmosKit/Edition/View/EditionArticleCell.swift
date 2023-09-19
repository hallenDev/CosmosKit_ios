import UIKit
import Kingfisher

open class EditionArticleCell: UITableViewCell, GradientCell, ContentSpecifiedCell {

    @IBOutlet var backgroundContainer: UIView!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var section: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var synopsis: EditionListArticleSynopsisLabel!
    @IBOutlet var readTime: ReadTimeLabel?
    @IBOutlet public var authorView: AuthorView!
    @IBOutlet public var contentLock: UIImageView?
    @IBOutlet public var contentLockWidthConstraint: NSLayoutConstraint?
    @IBOutlet public var contentLockHeightConstraint: NSLayoutConstraint?
    @IBOutlet var sponsor: UIImageView!

    var key: Int64!
    var theme: Theme!
    var addGradient: Bool = true

    open func configure(with article: ArticleViewModel, imageGradient: Bool = true, cosmos: Cosmos) {
        title.text = article.sectionTitle ?? article.title
        synopsis.text = String.attributedString(html: article.synopsis,
                                                font: synopsis.font!)?.string.trailingNewlineTrimmed
        key = article.key
        sponsor.isHidden = !article.isSponsored
        if let customSponsor = cosmos.uiConfig.sponsoredImage {
            sponsor?.image = customSponsor
        }
        section.text = article.sectionName
        headerImage.image = article.listImage?.blurImage
        if let imageURL = article.listImage?.imageURL,
            let url = URL(string: imageURL) {
            headerImage.kf.setImage(with: url, placeholder: article.listImage?.blurImage)
        }
        authorView = authorView.configure(with: article.author, config: cosmos.uiConfig.authorConfig)
        readTime?.text = article.listRead

        addGradient = imageGradient
        theme = cosmos.theme
        if imageGradient {
            addGradient(to: headerImage, theme: cosmos.theme)
        }

        applyContentImage(locked: article.isPremium, featured: false, cosmos: cosmos)
        applyTheme(cosmos.theme)
    }

    private func applyTheme(_ theme: Theme) {
        backgroundColor = .none
        contentView.backgroundColor = theme.editionTheme?.articleCellTheme.separatorColor
        backgroundContainer.backgroundColor = theme.backgroundColor
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard addGradient, headerImage != nil else { return }
        addGradient(to: headerImage, theme: theme)
    }

    public func getExtraWideFrameForGradient() -> CGRect {
        return CGRect(x: headerImage.bounds.origin.x,
                      y: headerImage.bounds.origin.y,
                      width: UIScreen.main.bounds.width,
                      height: headerImage.bounds.height)
    }
}
