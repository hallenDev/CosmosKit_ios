import Foundation

public struct ArticleHeaderTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(coBrandHeight: CGFloat = 20, dateColor: UIColor, dateFont: UIFont?, titleColor: UIColor, titleFont: UIFont?, titleLineSpacing: CGFloat? = nil, underTitleColor: UIColor, underTitleFont: UIFont?, overTitleColor: UIColor, overTitleFont: UIFont?, sectionFont: UIFont?, sectionColor: UIColor, introFont: UIFont?, headerBylineFont: UIFont?, headerByline2Font: UIFont?, headerBylineColor: UIColor) {
        self.coBrandHeight = coBrandHeight
        self.dateColor = dateColor
        self.dateFont = dateFont
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.titleLineSpacing = titleLineSpacing
        self.underTitleColor = underTitleColor
        self.underTitleFont = underTitleFont
        self.overTitleColor = overTitleColor
        self.overTitleFont = overTitleFont
        self.sectionFont = sectionFont
        self.sectionColor = sectionColor
        self.introFont = introFont
        self.headerBylineFont = headerBylineFont
        self.headerByline2Font = headerByline2Font
        self.headerBylineColor = headerBylineColor
    }

    let coBrandHeight: CGFloat
    let dateColor: UIColor
    let dateFont: UIFont?
    let titleColor: UIColor
    let titleFont: UIFont?
    let titleLineSpacing: CGFloat?
    let underTitleColor: UIColor
    let underTitleFont: UIFont?
    let overTitleColor: UIColor
    let overTitleFont: UIFont?
    let sectionFont: UIFont?
    let sectionColor: UIColor
    let introFont: UIFont?
    let headerBylineFont: UIFont?
    let headerByline2Font: UIFont?
    let headerBylineColor: UIColor

    func applyColors(parent: Theme) {
        ArticleDateLabel.appearance().textColor = dateColor
        ArticleTitleLabel.appearance().textColor = titleColor
        ArticleSubTitleLabel.appearance().textColor = underTitleColor
        ArticleOverTitleLabel.appearance().textColor = overTitleColor
        HeaderBylineLabel.appearance().textColor = headerBylineColor
        HeaderByline2Label.appearance().textColor = headerBylineColor
        ArticleSectionLabel.appearance().textColor = sectionColor
    }

    func applyFonts(parent: Theme) {
        ArticleSectionLabel.appearance().font = sectionFont
        HeaderBylineLabel.appearance().font = headerBylineFont
        HeaderByline2Label.appearance().font = headerByline2Font
        ArticleDateLabel.appearance().font = dateFont
        ArticleTitleLabel.appearance().font = titleFont
        ArticleSubTitleLabel.appearance().font = underTitleFont
        ArticleOverTitleLabel.appearance().font = overTitleFont
        ArticleIntroLabel.appearance().font = introFont
    }
}

extension ArticleHeaderTheme {
    public init() {
        dateColor = .black
        dateFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)
        sectionColor = .black
        coBrandHeight = 20
        titleLineSpacing = nil
        overTitleColor = .black
        underTitleColor = .black
        underTitleFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)
        overTitleFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)
        titleColor = .black
        introFont = UIFont(name: "HelveticaNeue", textStyle: .body)
        sectionFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)
        titleFont = UIFont(name: "HelveticaNeue-Bold", textStyle: .title2)
        headerBylineFont = UIFont(name: "HelveticaNeue-Italic", textStyle: .caption1)
        headerByline2Font = UIFont(name: "HelveticaNeue-Italic", textStyle: .caption1)
        headerBylineColor = .gray
    }
}
