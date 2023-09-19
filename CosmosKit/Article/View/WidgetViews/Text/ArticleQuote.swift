import Foundation

public enum QuoteStyle {
    case normal
    case accented(color: UIColor)
}

class ArticleQuote: UIView {

    @IBOutlet var quote: QuoteTextLabel!
    @IBOutlet var author: QuoteAuthorLabel!
    @IBOutlet var accentView: UIView?
    @IBOutlet var topLine: QuoteTopLine?
    @IBOutlet var bottomLine: QuoteBottomLine?

    init(_ viewModel: QuoteViewModel, theme: QuoteTheme) {
        super.init(frame: CGRect.zero)
        let view: ArticleQuote? = fromNib(style: theme.quoteStyle)
        view?.configure(quote: viewModel.quote, author: viewModel.cite, theme: theme)
    }

    init(_ viewModel: InfoBlockViewModel, theme: QuoteTheme) {
        super.init(frame: CGRect.zero)
        let view: ArticleQuote? = fromNib(style: theme.quoteStyle)
        view?.configure(quote: viewModel.title, author: viewModel.description, theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configure(quote: String?, author: String?, theme: QuoteTheme) {
        self.quote.attributedText = String.attributedString(html: quote,
                                                            font: theme.quoteFont)?.trailingNewlineTrimmed
        self.author.attributedText = String.attributedString(html: author,
                                                             font: theme.authorFont)?.trailingNewlineTrimmed

        switch theme.quoteStyle {
        case .accented(let color):
            accentView?.backgroundColor = color
        default: break
        }
    }

    func fromNib(style: QuoteStyle) -> ArticleQuote? {
        var nibName: String
        if case .normal = style {
            nibName = "ArticleQuote"
        } else {
            nibName = "ArticleQuoteAccented"
        }

        guard let contentView = Bundle.cosmos.loadNibNamed(nibName,
                                                           owner: self,
                                                           options: nil)?.first as? ArticleQuote else {
                                                            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(to: self)
        return contentView
    }
}
