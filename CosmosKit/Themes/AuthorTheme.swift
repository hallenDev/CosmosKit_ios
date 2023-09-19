import Foundation

public struct AuthorTheme: SubTheme {
    public init(nameFont: UIFont?, nameColor: UIColor, categoryFont: UIFont?, categoryColor: UIColor) {
        self.nameFont = nameFont
        self.nameColor = nameColor
        self.categoryFont = categoryFont
        self.categoryColor = categoryColor
    }

    let nameFont: UIFont?
    let nameColor: UIColor
    let categoryFont: UIFont?
    let categoryColor: UIColor

    func applyColors(parent: Theme) {
        AuthorCategoryLabel.appearance().textColor = categoryColor
        AuthorNameLabel.appearance().textColor = nameColor
        AuthorView.appearance().backgroundColor = parent.backgroundColor
    }

    func applyFonts(parent: Theme) {
        AuthorNameLabel.appearance().font = nameFont!
        AuthorCategoryLabel.appearance().font = categoryFont!
    }
}
extension AuthorTheme {
    public init() {
        self.nameFont = UIFont(name: "HelveticaNeue", textStyle: .caption1)!
        self.categoryFont = UIFont(name: "HelveticaNeue", textStyle: .caption1)!
        self.categoryColor = .black
        self.nameColor = .black
    }
}
