import Foundation

public struct EditionTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(headerTheme: EditionTheme.EditionHeaderTheme, editionSectionTheme: EditionTheme.EditionSectionTheme, articleCellTheme: EditionTheme.ArticleCellTheme, accordionTheme: EditionTheme.AccordionTheme, pastEditionTheme: EditionTheme.PastEditionsTheme) {
        self.headerTheme = headerTheme
        self.editionSectionTheme = editionSectionTheme
        self.articleCellTheme = articleCellTheme
        self.accordionTheme = accordionTheme
        self.pastEditionTheme = pastEditionTheme
    }

    public struct ArticleCellTheme: SubTheme {
        public init(synopsisFont: UIFont?, synopsisColor: UIColor, readTimeFont: UIFont?, readTimeColor: UIColor, separatorColor: UIColor) {
            self.synopsisFont = synopsisFont
            self.synopsisColor = synopsisColor
            self.readTimeFont = readTimeFont
            self.readTimeColor = readTimeColor
            self.separatorColor = separatorColor
        }

        let synopsisFont: UIFont?
        let synopsisColor: UIColor
        let readTimeFont: UIFont?
        let readTimeColor: UIColor
        let separatorColor: UIColor

        func applyColors(parent: Theme) {
            EditionFeaturedSectionLabel.appearance().textColor = parent.articleListTheme.featuredSectionColor
            EditionFeaturedTitleLabel.appearance().textColor = parent.articleListTheme.featuredTitleColor
            EditionListArticleSynopsisLabel.appearance().textColor = synopsisColor
            EditionCellTitleLabel.appearance().textColor = parent.textColor
            ReadTimeLabel.appearance().textColor = readTimeColor
        }

        func applyFonts(parent: Theme) {
            EditionFeaturedSectionLabel.appearance().font = parent.articleListTheme.featuredSectionFont
            EditionFeaturedTitleLabel.appearance().font = parent.articleListTheme.featuredTitleFont
            EditionListArticleSynopsisLabel.appearance().font = synopsisFont
            EditionCellTitleLabel.appearance().font = parent.articleListTheme.titleFont
            ReadTimeLabel.appearance().font = readTimeFont
        }
    }

    public struct EditionSectionTheme: SubTheme {
        public init(titleFont: UIFont?, titleColor: UIColor, subTitleFont: UIFont?, subTitleColor: UIColor, sectionShadowColor: UIColor) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.subTitleFont = subTitleFont
            self.subTitleColor = subTitleColor
            self.sectionShadowColor = sectionShadowColor
        }

        let titleFont: UIFont?
        let titleColor: UIColor
        let subTitleFont: UIFont?
        let subTitleColor: UIColor
        let sectionShadowColor: UIColor

        func applyColors(parent: Theme) {
            EditionListSectionLabel.appearance().textColor = titleColor
            EditionListSectionBylineLabel.appearance().textColor = subTitleColor
        }

        func applyFonts(parent: Theme) {
            EditionListSectionLabel.appearance().font = titleFont
            EditionListSectionBylineLabel.appearance().font = subTitleFont
        }
    }

    public struct EditionHeaderTheme: SubTheme {
        public init(titleFont: UIFont?, titleColor: UIColor, titleBackgroundColor: UIColor, titleStyle: HeaderStyle) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.titleBackgroundColor = titleBackgroundColor
            self.titleStyle = titleStyle
        }

        let titleFont: UIFont?
        let titleColor: UIColor
        let titleBackgroundColor: UIColor
        public let titleStyle: HeaderStyle

        func applyColors(parent: Theme) {
            EditionTitleView.appearance().backgroundColor = titleBackgroundColor
            EditionTitleLabel.appearance().textColor = titleColor
            EditionTitleLabel.appearance().backgroundColor = titleBackgroundColor
        }

        func applyFonts(parent: Theme) {
            EditionTitleLabel.appearance().font = titleFont!
        }
    }

    public struct AccordionTheme: SubTheme {
        public init(titleFont: UIFont?, headingFont: UIFont?, bodyFont: UIFont?) {
            self.titleFont = titleFont
            self.bodyFont = bodyFont
            self.headingFont = headingFont
        }

        let titleFont: UIFont?
        let headingFont: UIFont?
        let bodyFont: UIFont?

        func applyColors(parent: Theme) {
            AccordionTitleLabel.appearance().textColor = parent.accentColor
            AccordionHeaderLabel.appearance().textColor = parent.textColor
            AccordionBodyLabel.appearance().textColor = parent.textColor
        }

        func applyFonts(parent: Theme) {
            AccordionTitleLabel.appearance().font = titleFont
            AccordionHeaderLabel.appearance().font = headingFont
            AccordionBodyLabel.appearance().font = bodyFont
        }
    }

    public struct PastEditionsTheme: SubTheme {
        // swiftlint:disable:next line_length
        public init(titleFont: UIFont?, titleColor: UIColor, subTitleFont: UIFont?, subTitleColor: UIColor, featuredButtonTextColor: UIColor? = nil, featuredButtonBackgroundColor: UIColor? = nil, featuredButtonFont: UIFont? = nil, uppercasePastEditionText: Bool = true) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.subTitleFont = subTitleFont
            self.subTitleColor = subTitleColor
            self.featuredButtonTextColor = featuredButtonTextColor
            self.featuredButtonBackgroundColor = featuredButtonBackgroundColor
            self.featuredButtonFont = featuredButtonFont
            self.uppercasePastEditionText = uppercasePastEditionText
        }

        let titleFont: UIFont?
        let titleColor: UIColor
        let subTitleFont: UIFont?
        let subTitleColor: UIColor
        let featuredButtonTextColor: UIColor?
        let featuredButtonBackgroundColor: UIColor?
        let featuredButtonFont: UIFont?
        let uppercasePastEditionText: Bool

        func applyColors(parent: Theme) {
            PastEditionsDateLabel.appearance().textColor = titleColor
            PastEditionsArticleLabel.appearance().textColor = subTitleColor
            PastEditionFeaturedButton.appearance().tintColor = featuredButtonTextColor
            PastEditionFeaturedButton.appearance().backgroundColor = featuredButtonBackgroundColor
            PastEditionTriangle.appearance().backgroundColor = parent.accentColor
        }

        func applyFonts(parent: Theme) {
            PastEditionsDateLabel.appearance().font = titleFont
            PastEditionsArticleLabel.appearance().font = subTitleFont
        }
    }

    let headerTheme: EditionHeaderTheme
    let editionSectionTheme: EditionSectionTheme
    let articleCellTheme: ArticleCellTheme
    let accordionTheme: AccordionTheme
    let pastEditionTheme: PastEditionsTheme

    func applyColors(parent: Theme) {
        headerTheme.applyColors(parent: parent)
        editionSectionTheme.applyColors(parent: parent)
        articleCellTheme.applyColors(parent: parent)
        accordionTheme.applyColors(parent: parent)
        pastEditionTheme.applyColors(parent: parent)
    }

    func applyFonts(parent: Theme) {
        headerTheme.applyFonts(parent: parent)
        editionSectionTheme.applyFonts(parent: parent)
        articleCellTheme.applyFonts(parent: parent)
        accordionTheme.applyFonts(parent: parent)
        pastEditionTheme.applyFonts(parent: parent)
    }
}
