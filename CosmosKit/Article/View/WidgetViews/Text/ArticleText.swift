import UIKit

class ArticleText: UIView {

    @IBOutlet var articleText: BodyText! {
        didSet {
            articleText.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            articleText.textContainer.lineFragmentPadding = 0
            articleText.delegate =  self
        }
    }
    var cosmos: Cosmos!
    var defaults: CosmosDefaults!
    var viewModel: TextViewModel!

    func configure(viewModel: TextViewModel, cosmos: Cosmos, defaults: CosmosDefaults? = nil) {
        self.cosmos = cosmos
        self.viewModel = viewModel
        self.defaults = defaults ?? CosmosDefaults()
        backgroundColor = cosmos.theme.backgroundColor
        articleText.backgroundColor = cosmos.theme.backgroundColor
        let refactoredHtml = viewModel.html?
            .replaceLast(of: "<p>", with: "<span>")
            .replaceLast(of: "</p>", with: "</span>")

        let font = UIFont(name: cosmos.articleTheme.bodyFontName, textStyle: self.defaults.getBodyFontSize())

        let string = String.attributedString(html: refactoredHtml,
                                             font: font,
                                             italicFont: cosmos.articleTheme.bodyItalicFontName,
                                             boldFont: cosmos.articleTheme.bodyBoldFontName)?.trailingNewlineTrimmed

        articleText.attributedText = string

        invalidateIntrinsicContentSize()
    }

    func refreshFont() {
        let font = UIFont(name: cosmos.articleTheme.bodyFontName, textStyle: defaults.getBodyFontSize())

        let string = String.attributedString(html: viewModel.html,
                                             font: font,
                                             italicFont: cosmos.articleTheme.bodyItalicFontName,
                                             boldFont: cosmos.articleTheme.bodyBoldFontName)?.trailingNewlineTrimmed

        let new = NSMutableAttributedString(attributedString: string!)
        new.addAttribute(.foregroundColor, value: cosmos.theme.textColor, range: NSRange(location: 0, length: string!.length))
        articleText.attributedText = new
        invalidateIntrinsicContentSize()
    }

    class func nib() -> UINib {
        return UINib(nibName: "ArticleText", bundle: Bundle.cosmos)
    }

    public class func instanceFromNib(viewModel: TextViewModel, cosmos: Cosmos) -> ArticleText {
        // swiftlint:disable:next force_cast
        let view = nib().instantiate(withOwner: self)[0] as! ArticleText
        view.configure(viewModel: viewModel, cosmos: cosmos)
        return view
    }
}

extension ArticleText: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let url = URL.absoluteString
        if url.isInternalArticleSlug,
            let slug = url.internalArticleSlug {
            self.showArticle(slug: slug)
            return false
        }
        return true
    }

    func showArticle(slug: String) {
        let renderType: ArticleRenderType = cosmos.isEdition ? .edition : .live
        let article = ArticleViewModel(slug: slug, as: renderType)
        let nav = cosmos.getSingleArticleView(for: article)
        nav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            let topVC = UIApplication.shared.topViewController()
            topVC?.present(nav, animated: true, completion: nil)
        }
    }
}

extension String {
    var isInternalArticleSlug: Bool {
        return self.starts(with: "../")
    }

    var internalArticleSlug: String? {
        let parts = self.split(separator: "/")
        if let last = parts.last {
            return String(last)
        }
        return nil
    }
}
