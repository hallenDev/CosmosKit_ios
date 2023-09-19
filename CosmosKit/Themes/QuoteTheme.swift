import Foundation

public struct QuoteTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(quoteStyle: QuoteStyle = .normal, backgroundColor: UIColor, quoteColor: UIColor, quoteFont: UIFont?, authorColor: UIColor, authorFont: UIFont?, topLineColor: UIColor, bottomLineColor: UIColor) {
        self.quoteStyle = quoteStyle
        self.backgroundColor = backgroundColor
        self.quoteColor = quoteColor
        self.quoteFont = quoteFont
        self.authorColor = authorColor
        self.authorFont = authorFont
        self.topLineColor = topLineColor
        self.bottomLineColor = bottomLineColor
    }

    let quoteStyle: QuoteStyle
    let backgroundColor: UIColor
    let quoteColor: UIColor
    let quoteFont: UIFont?
    let authorColor: UIColor
    let authorFont: UIFont?
    let topLineColor: UIColor
    let bottomLineColor: UIColor

    func applyColors(parent: Theme) {
        QuoteTextLabel.appearance().textColor = quoteColor
        QuoteAuthorLabel.appearance().textColor = authorColor
        ArticleQuote.appearance().backgroundColor = backgroundColor
        QuoteTopLine.appearance().backgroundColor = topLineColor
        QuoteBottomLine.appearance().backgroundColor = bottomLineColor
    }

    func applyFonts(parent: Theme) {
        QuoteTextLabel.appearance().font = quoteFont!
        QuoteAuthorLabel.appearance().font = authorFont!
    }
}

extension QuoteTheme {

    public init() {
        self.init(backgroundColor: .black,
                  quoteColor: .white,
                  quoteFont: UIFont(name: "HelveticaNeue", size: 14),
                  authorColor: .white,
                  authorFont: UIFont(name: "HelveticaNeue", size: 12),
                  topLineColor: .black,
                  bottomLineColor: .black)
    }
}
