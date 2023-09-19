import Foundation

public struct ArticleListTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(featuredTitleColor: UIColor, featuredTitleFont: UIFont?, featuredSectionColor: UIColor, featuredSectionFont: UIFont?, titleColor: UIColor, titleFont: UIFont?, sectionColor: UIColor, sectionFont: UIFont?, videoIcon: UIImage, useCellSeparators: Bool = true, gradientColor: UIColor) {
        self.featuredTitleColor = featuredTitleColor
        self.featuredTitleFont = featuredTitleFont
        self.featuredSectionColor = featuredSectionColor
        self.featuredSectionFont = featuredSectionFont
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.sectionColor = sectionColor
        self.sectionFont = sectionFont
        self.videoIcon = videoIcon
        self.useCellSeparators = useCellSeparators
        self.gradientColor = gradientColor
    }

    let featuredTitleColor: UIColor
    let featuredTitleFont: UIFont?
    let featuredSectionColor: UIColor
    let featuredSectionFont: UIFont?
    let titleColor: UIColor
    let titleFont: UIFont?
    let sectionColor: UIColor
    let sectionFont: UIFont?
    let videoIcon: UIImage
    let useCellSeparators: Bool
    let gradientColor: UIColor

    func applyColors(parent: Theme) {
        ArticleListTitleLabel.appearance().textColor = titleColor
        ArticleListSectionLabel.appearance().textColor = sectionColor
        ArticleListFeaturedSectionLabel.appearance().textColor = featuredSectionColor
        ArticleListFeaturedTitleLabel.appearance().textColor = featuredTitleColor
    }

    func applyFonts(parent: Theme) {
        ArticleListTitleLabel.appearance().font = titleFont
        ArticleListSectionLabel.appearance().font = sectionFont
        ArticleListFeaturedSectionLabel.appearance().font = featuredSectionFont
        ArticleListFeaturedTitleLabel.appearance().font = featuredTitleFont
    }
}

extension ArticleListTheme {
    public init() {
        videoIcon = UIImage()
        useCellSeparators = true
        titleColor = .black
        sectionColor = .orange
        featuredTitleColor = .white
        featuredSectionColor = .white
        titleFont = UIFont(name: "HelveticaNeue", textStyle: .body)!
        sectionFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)!
        featuredSectionFont = UIFont(name: "HelveticaNeue", textStyle: .subheadline)!
        featuredTitleFont = UIFont(name: "HelveticaNeue", textStyle: .title3)!
        gradientColor = .black
    }
}
