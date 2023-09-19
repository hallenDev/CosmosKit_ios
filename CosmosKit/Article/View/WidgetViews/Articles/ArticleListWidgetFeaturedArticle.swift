import Foundation

class ArticleListWidgetFeaturedArticle: UIView, GradientCell {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 375, height: 230)
    }

    @IBOutlet var videoIcon: UIImageView!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleSection: ArticleListFeaturedSectionLabel!
    @IBOutlet var articleTitle: ArticleListFeaturedTitleLabel!
    @IBOutlet var coBrandImage: UIImageView!

    var selected: RelatedSelectedCallback?
    var key: Int64!

    init(viewModel: ArticleSummaryViewModel, selected: @escaping RelatedSelectedCallback) {
        super.init(frame: CGRect.zero)
        let view: ArticleListWidgetFeaturedArticle? = fromNib()
        view?.configure(viewModel: viewModel, selected: selected)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure(viewModel: ArticleSummaryViewModel, selected: @escaping RelatedSelectedCallback) {
        if let urlString = viewModel.image?.imageURL, let url = URL(string: urlString) {
            articleImage.kf.setImage(with: url)
        }
        articleTitle.text = viewModel.title
        articleSection.text = viewModel.sectionName
        key = viewModel.key
        self.selected = selected
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectArticle))
        addGestureRecognizer(tap)
        addGradient(to: articleImage, theme: nil)
    }

    @objc func selectArticle() {
        selected?(key)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard articleImage != nil else { return }
        addGradient(to: articleImage, theme: nil)
    }

    func getExtraWideFrameForGradient() -> CGRect {
        return CGRect(x: articleImage.bounds.origin.x,
                      y: articleImage.bounds.origin.y,
                      width: UIScreen.main.bounds.width * 2,
                      height: 230)
    }
}
