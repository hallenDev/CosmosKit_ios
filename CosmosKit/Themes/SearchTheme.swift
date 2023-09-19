import Foundation

public struct SearchTheme: SubTheme {
    public init(textColor: UIColor, cursorColor: UIColor) {
        self.textColor = textColor
        self.cursorColor = cursorColor
    }

    let textColor: UIColor
    let cursorColor: UIColor

    func applyColors(parent: Theme) {
        SearchField.appearance().textColor = textColor
        SearchField.appearance().tintColor = cursorColor
    }

    func applyFonts(parent: Theme) {}
}

extension SearchTheme {
    public init() {
        textColor = .black
        cursorColor = .black
    }
}
