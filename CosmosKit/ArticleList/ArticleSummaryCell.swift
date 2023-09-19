import UIKit
import Kingfisher

public class AdContainerView: UIView {}

open class ArticleSummaryCell: UITableViewCell, AdInjectableCell, GradientCell, ContentSpecifiedCell {

    @IBOutlet var wrapperViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            wrapperViewHeightConstraint.constant = CGFloat.maximum(285, UIScreen.main.bounds.height * 0.30)
        }
    }
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var articleSection: ArticleListSectionLabel!
    @IBOutlet var articleTitle: ArticleListTitleLabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var videoTreatment: UIImageView!
    @IBOutlet public var topAdView: AdContainerView!
    @IBOutlet public var topAdViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet public var bottomAdView: AdContainerView!
    @IBOutlet public var bottomAdViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet public var contentLock: UIImageView?
    @IBOutlet public var contentLockWidthConstraint: NSLayoutConstraint?
    @IBOutlet public var contentLockHeightConstraint: NSLayoutConstraint?
    @IBOutlet var sponsor: UIImageView!

    public var interscrollerTapped: EmptyCallBack!
    lazy var placeholder = UIImage(cosmosName: .videoPlaceholder)
    var theme: Theme!
    var featured = false

    public override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.image = nil
        articleTitle.text = nil
        articleSection.text = nil
        videoTreatment.isHidden = false
        bottomAdViewHeightConstraint.constant = 0
        bottomAdView.subviews.forEach { $0.removeFromSuperview() }
        topAdViewHeightConstraint.constant = 0
        topAdView.subviews.forEach { $0.removeFromSuperview() }
        contentLock?.image = nil
    }

    public func configure(article: ArticleSummaryViewModel, featured: Bool = false, cosmos: Cosmos) {
        videoTreatment.image = cosmos.articleListTheme.videoIcon
        articleSection.text = article.sectionName
        articleTitle.text = article.sectionTitle
        videoTreatment.isHidden = !article.hasVideoContent
        sponsor?.isHidden = !article.isSponsored
        if let customSponsor = cosmos.uiConfig.sponsoredImage {
            sponsor?.image = customSponsor
        }
        applyContentImage(locked: article.isLocked, featured: featured, cosmos: cosmos)

        if let url = article.image?.imageURL,
            let imageURL = URL(string: url) {
            articleImage.kf.setImage(with: imageURL, placeholder: article.image?.blurImage ?? placeholder)
        } else {
            articleImage.image = placeholder
        }

        theme = cosmos.theme
        self.featured = featured
        if featured {
            addGradient(to: articleImage, theme: cosmos.theme)
        }

        contentView.backgroundColor = cosmos.theme.backgroundColor
        topAdView.backgroundColor = cosmos.theme.backgroundColor
        bottomAdView.backgroundColor = cosmos.theme.backgroundColor
        wrapperView.backgroundColor = cosmos.theme.backgroundColor
    }

    public func configureAd(placement: AdPlacement, ad: CosmosAd) {
        if placement.isBanner {
            configureBannerAd(placement: placement, ad: ad)
        } else if let height = placement.sizes.first?.size.height {
            configureInterscroller(height: height, placement: placement, ad: ad)
            contentView.backgroundColor = .clear
            backgroundColor = .clear
        }
    }

    public func insertInterscrollerButton(for targetView: UIView) {
        let button = createInterScrollerButton(for: targetView)
        button.addTarget(self, action: #selector(interscrollerSelected(_:)), for: .touchUpInside)
    }

    @objc func interscrollerSelected(_ sender: Any) {
        interscrollerTapped?()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard featured, articleImage != nil else { return }
        addGradient(to: articleImage, theme: theme)
    }

    public func getExtraWideFrameForGradient() -> CGRect {
        return CGRect(x: articleImage.bounds.origin.x,
                      y: articleImage.bounds.origin.y,
                      width: UIScreen.main.bounds.width,
                      height: wrapperViewHeightConstraint.constant)
    }
}
