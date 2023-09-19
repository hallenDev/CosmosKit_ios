import Foundation

public struct RelatedArticleTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(backgroundColor: UIColor, titleColor: UIColor, titleFont: UIFont?, sectionColor: UIColor, sectionFont: UIFont?, authorColor: UIColor, authorFont: UIFont?, readTimeColor: UIColor, readTimeFont: UIFont?, dateColor: UIColor, dateFont: UIFont?, summaryColor: UIColor, summaryFont: UIFont?, dividerColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.sectionColor = sectionColor
        self.sectionFont = sectionFont
        self.authorColor = authorColor
        self.authorFont = authorFont
        self.readTimeColor = readTimeColor
        self.readTimeFont = readTimeFont
        self.dateColor = dateColor
        self.dateFont = dateFont
        self.summaryColor = summaryColor
        self.summaryFont = summaryFont
        self.dividerColor = dividerColor
    }

    public let backgroundColor: UIColor
    let titleColor: UIColor
    let titleFont: UIFont?
    let sectionColor: UIColor
    let sectionFont: UIFont?
    let authorColor: UIColor
    let authorFont: UIFont?
    let readTimeColor: UIColor
    let readTimeFont: UIFont?
    let dateColor: UIColor
    let dateFont: UIFont?
    let summaryColor: UIColor
    let summaryFont: UIFont?
    let dividerColor: UIColor

    func applyColors(parent: Theme) {
        RelatedSpacer.appearance().backgroundColor = dividerColor
        ArticleRelated.appearance().backgroundColor = backgroundColor
        RelatedArticleTitle.appearance().textColor = titleColor
        RelatedArticleSection.appearance().textColor = sectionColor
        RelatedArticleAuthor.appearance().textColor = authorColor
        RelatedArticleReadTime.appearance().textColor = readTimeColor
        RelatedArticleDate.appearance().textColor = dateColor
        RelatedArticleSummary.appearance().textColor = summaryColor
    }

    func applyFonts(parent: Theme) {
        RelatedArticleTitle.appearance().font = titleFont!
        RelatedArticleSection.appearance().font = sectionFont!
        RelatedArticleAuthor.appearance().font = authorFont!
        RelatedArticleReadTime.appearance().font = readTimeFont!
        RelatedArticleDate.appearance().font = dateFont!
        RelatedArticleSummary.appearance().font = summaryFont!
    }
}

extension RelatedArticleTheme {
    public init() {
        titleColor = .black
        titleFont = UIFont(name: "HelveticaNeue", textStyle: .title3)
        sectionColor = .black
        sectionFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)
        authorColor = .black
        authorFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)
        readTimeColor = .black
        readTimeFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)
        dateColor = .black
        dateFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)
        backgroundColor = .white
        dividerColor = .lightGray
        summaryColor = .black
        summaryFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)
    }
}
