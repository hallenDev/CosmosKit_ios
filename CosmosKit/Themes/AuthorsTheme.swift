import Foundation

public struct AuthorsTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(cellNameColor: UIColor, cellNameFont: UIFont?, cellTitleColor: UIColor, cellTitleFont: UIFont?, detailTitleColor: UIColor, detailTitleFont: UIFont?, detailNameColor: UIColor, detailNameFont: UIFont?, detailBioColor: UIColor, detailBioFont: UIFont?) {
        self.cellNameColor = cellNameColor
        self.cellNameFont = cellNameFont
        self.cellTitleColor = cellTitleColor
        self.cellTitleFont = cellTitleFont
        self.detailTitleColor = detailTitleColor
        self.detailTitleFont = detailTitleFont
        self.detailNameColor = detailNameColor
        self.detailNameFont = detailNameFont
        self.detailBioColor = detailBioColor
        self.detailBioFont = detailBioFont
    }

    let cellNameColor: UIColor
    let cellNameFont: UIFont?
    let cellTitleColor: UIColor
    let cellTitleFont: UIFont?
    let detailTitleColor: UIColor
    let detailTitleFont: UIFont?
    let detailNameColor: UIColor
    let detailNameFont: UIFont?
    let detailBioColor: UIColor
    let detailBioFont: UIFont?

    func applyColors(parent: Theme) {
        AuthorCellNameLabel.appearance().textColor = cellNameColor
        AuthorCellTitleLabel.appearance().textColor = cellTitleColor
        AuthorDetailNameLabel.appearance().textColor = detailNameColor
        AuthorDetailTitleLabel.appearance().textColor = detailTitleColor
        AuthorDetailBioLabel.appearance().textColor = detailBioColor
        AuthorHeaderView.appearance().backgroundColor = parent.backgroundColor
    }

    func applyFonts(parent: Theme) {
        AuthorCellNameLabel.appearance().font = cellNameFont!
        AuthorCellTitleLabel.appearance().font = cellTitleFont!
        AuthorDetailNameLabel.appearance().font = detailNameFont!
        AuthorDetailTitleLabel.appearance().font = detailTitleFont!
        AuthorDetailBioLabel.appearance().font = detailBioFont!
    }
}
extension AuthorsTheme {
    public init() {
        self.cellNameColor = .black
        self.cellNameFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)!
        self.cellTitleColor = .black
        self.cellTitleFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)!
        self.detailTitleColor = .black
        self.detailTitleFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)!
        self.detailNameColor = .black
        self.detailNameFont = UIFont(name: "HelveticaNeue", textStyle: .title2)!
        self.detailBioColor = .black
        self.detailBioFont = UIFont(name: "HelveticaNeue", textStyle: .footnote)!
    }
}
