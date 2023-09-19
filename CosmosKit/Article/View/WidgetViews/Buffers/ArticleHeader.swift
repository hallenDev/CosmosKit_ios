import UIKit

public enum ArticleHeaderType {
    case standard
    case expanded
    case injected
}

typealias AuthorSelectedCallback = (AuthorViewModel) -> Void

open class ArticleHeader: UIView {

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 100)
    }

    @IBOutlet public var section: ArticleSectionLabel!
    @IBOutlet public var overHeadTitle: ArticleOverTitleLabel!
    @IBOutlet public var title: ArticleTitleLabel!
    @IBOutlet public var underHeadTitle: ArticleSubTitleLabel!
    @IBOutlet public var author: AuthorView?
    @IBOutlet public var headerImage: UIImageView!
    @IBOutlet public var headerImageHeight: NSLayoutConstraint!
    @IBOutlet public var intro: ArticleIntroLabel?
    @IBOutlet public var coBrandImage: UIImageView?
    @IBOutlet public var cobrandWidthConstraint: NSLayoutConstraint?
    @IBOutlet public var cobrandHeightConstraint: NSLayoutConstraint?
    @IBOutlet public var headStack: UIStackView!
    @IBOutlet public var readingTime: HeaderByline2Label?
    @IBOutlet public var articleNumber: HeaderByline2Label?
    @IBOutlet public var articleDate: ArticleDateLabel?
    @IBOutlet public var sponsor: UIImageView!

    var openAuthor: AuthorSelectedCallback?
    var authorViewModel: AuthorViewModel?

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    open func configure(_ article: ArticleViewModel, logo: UIImage?, cosmos: Cosmos) {
        if let logo = logo, article.renderType != .staticPage {
            coBrandImage?.image = logo
            section.text = nil
            cobrandHeightConstraint?.constant = cosmos.articleHeaderTheme.coBrandHeight
            let logoRatio = logo.size.width/logo.size.height
            let logoWidth = logoRatio * cosmos.articleHeaderTheme.coBrandHeight
            cobrandWidthConstraint?.constant = logoWidth
            coBrandImage?.setNeedsLayout()
            headStack.setNeedsLayout()
        } else {
            section.text = article.sectionName
            coBrandImage?.isHidden = true
            headStack.setNeedsLayout()
        }
        section.sizeToFit()
        sponsor?.isHidden = !article.isSponsored
        if let customSponsor = cosmos.uiConfig.sponsoredImage {
            sponsor?.image = customSponsor
        }
        if let overhead = article.overHeadTitle {
            overHeadTitle.text = String.attributedString(html: overhead,
                                    font: ArticleOverTitleLabel.appearance().font)?.string.trailingNewlineTrimmed
        } else {
            overHeadTitle.removeFromSuperview()
        }

        if let underhead = article.underHeadTitle {
            underHeadTitle.text = String.attributedString(html: underhead,
                                                          font: ArticleSubTitleLabel.appearance().font)?.string.trailingNewlineTrimmed
        } else {
            underHeadTitle.removeFromSuperview()
        }

        title.text = article.title

        author = author?.fromNib()
        author = author?.configure(with: article.author, date: article.datePublished, config: cosmos.uiConfig.authorConfig)
        if let imageURL = article.headerImageURL {
            headerImage.kf.setImage(with: imageURL, completionHandler: { [weak self] result in
                switch result {
                case .success(let imageResult):
                    let ratio = imageResult.image.size.width / imageResult.image.size.height
                    self?.headerImageHeight.constant = UIScreen.main.bounds.width / ratio
                case .failure(let error):
                    print(String(format: "Error trying to download image: %@", error.localizedDescription))
                    self?.headerImageHeight.constant = 0
                }
            })
        } else {
            headerImageHeight.constant = 0
        }

        if let introText = article.intro {
            intro?.text = String.attributedString(html: introText,
                                                 font: ArticleIntroLabel.appearance().font)?.string.trailingNewlineTrimmed

        } else {
            intro?.removeFromSuperview()
        }

        if cosmos.uiConfig.shouldShowReadTime {
            readingTime?.text = article.readingTime
        } else {
            readingTime?.text = nil
        }
        articleNumber?.text = article.articleIndex
        articleDate?.text = article.datePublished?.uppercased()
        articleDate?.sizeToFit()

        if cosmos.uiConfig.articleHeaderType == .expanded {
            self.author?.configureCategoryAsReadTime(article.readingTime)
        }

        if article.author != nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(authorSelected))
            self.author?.addGestureRecognizer(tap)
        }
        authorViewModel = article.author
    }

    @objc func authorSelected() {
        guard let author = authorViewModel, author.key != nil else { return }
        self.openAuthor?(author)
    }

    class func instanceFromNib(type: ArticleHeaderType) -> ArticleHeader {
        let nibName = (type == .standard ? "ArticleHeader" : "ArticleHeaderExpanded")
        // swiftlint:disable:next force_cast
        return UINib(nibName: nibName, bundle: Bundle.cosmos).instantiate(withOwner: self)[0] as! ArticleHeader
    }
}
