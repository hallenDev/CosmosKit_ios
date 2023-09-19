import Foundation

public enum RelatedArticleType: String {
    case full = "ArticleRelated"
    case minimalRight = "ArticleRelatedMinimalRight"
    case minimalLeft = "ArticleRelatedMinimalLeft"
    case injected = ""
}

class ArticleRelated: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 375, height: 116)
    }

    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: RelatedArticleTitle!
    @IBOutlet var articleSummary: BodyLabel? {
        didSet {
            articleSummary?.adjustsFontSizeToFitWidth = false
            articleSummary?.lineBreakMode = .byTruncatingTail
        }
    }
    @IBOutlet var articleSection: RelatedArticleSection!
    @IBOutlet var articleDate: RelatedArticleDate?
    @IBOutlet var articleReadTime: RelatedArticleReadTime?
    @IBOutlet var articleAuthor: RelatedArticleAuthor?

    var key: Int64!
    var selected: RelatedSelectedCallback!

    init(_ viewModel: ArticleSummaryViewModel, type: RelatedArticleType, selected: @escaping RelatedSelectedCallback) {
        super.init(frame: CGRect.zero)
        let view = fromNib(type: type)
        view?.selected = selected
        view?.configure(with: viewModel, type: type)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configure(with viewModel: ArticleSummaryViewModel, type: RelatedArticleType) {
        key = viewModel.key
        articleTitle.text = viewModel.title

        if let font = articleSummary?.font {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail

            let synopsis = String.attributedString(html: viewModel.synopsis,
                                                   font: font)
            synopsis?.addAttributes([.paragraphStyle: paragraphStyle],
                                    range: NSRange(location: 0, length: synopsis?.length ?? 0))
            articleSummary?.attributedText = synopsis
        }

        articleSection.text = viewModel.sectionName

        if let date = viewModel.publishedString {
            articleDate?.text = date
        } else {
            articleDate?.removeFromSuperview()
        }

        if let url = viewModel.image?.imageURL,
            let imageURL = URL(string: url) {
            articleImage.kf.setImage(with: imageURL, placeholder: viewModel.image?.blurImage)
        } else {
            articleImage.image = UIImage(cosmosName: .videoPlaceholder)
        }

        if let author = viewModel.author?.name {
            articleAuthor?.text = author
        } else {
            articleAuthor?.removeFromSuperview()
        }

        if let readingTime = viewModel.readingTime {
            articleReadTime?.text = readingTime
        } else {
            articleReadTime?.removeFromSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(showArticle))
        addGestureRecognizer(tap)
    }

    @objc func showArticle() {
        selected(key)
    }

    func fromNib(type: RelatedArticleType) -> ArticleRelated? {
        guard let contentView = Bundle.cosmos.loadNibNamed(type.rawValue,
                                                           owner: self,
                                                           options: nil)?.first as? ArticleRelated else {
                                                            return nil
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.layoutAttachAll(to: self)
        return contentView
    }
}

class RelatedSpacer: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 1)
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
